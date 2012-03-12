##########################################################################
# Warning Electronic System
# 2010, Thorsten Brehm
#
# The Boeing 777's warning electronic system (WES) uses two redundant
# warning electronic units (WEUs).
#
# The WEUs control:
#   - Master warning light
#   - Aural alerts
#   - Landing/takeoff configuration warnings
#   - Speedbrake alert
#   - Altitude alerts
#   - Stall warning
#   - Stick shaker
#   - Speed tape parameter calculation
#
##########################################################################

# TODOs:
#  Check overspeed (EICAS message "OVERSPEED" + clicking sound)
#  Need more detailed flap/speed and flap/speed/stall envelopes

##############################################
# WEU specific class
# ie: var Weu = WEU.new("instrumentation/weu");
##############################################
var WEU =
{
    new : func(prop1)
    {
        m = { parents : [WEU]};
        m.weu = props.globals.getNode(prop1);

        # output lights
        m.master_warning = m.weu.initNode("light/master-warning", 0,"BOOL");
        m.master_caution = m.weu.initNode("light/master-caution", 0,"BOOL");
        m.serviceable    = m.weu.initNode("serviceable", 1,"BOOL");
        # output sounds
        m.siren        = m.weu.initNode("sound/config-warning",   0,"BOOL");
        m.stallhorn    = m.weu.initNode("sound/stall-horn", 0,"BOOL");
        m.apwarning    = m.weu.initNode("sound/autopilot-warning", 0,"BOOL");
        # actuators
        m.stickshaker  = m.weu.initNode("actuators/stick-shaker",0,"BOOL");
        # status information
        m.stallspeed   = m.weu.initNode("state/stall-speed",-100,"DOUBLE");
        m.targetspeed   = m.weu.initNode("state/target-speed",-100,"DOUBLE");
        # EICAS output 
        m.msgs_alert   = [];
        m.msgs_caution = [];
        m.msgs_info    = [];

        # inputs
        m.node_flap_override = props.globals.getNode("instrumentation/mk-viii/outputs/discretes/flap-override");
        m.node_radio_alt     = props.globals.getNode("position/gear-agl-ft");
        m.node_flaps         = props.globals.getNode("surface-positions/flap-pos-norm");
        m.node_speed         = props.globals.getNode("velocities/airspeed-kt");

        # input values
        m.enabled       = 0;
        m.throttle      = 0;
        m.radio_alt     = 0;
        m.flaps         = 0;
        m.speedbrake    = 0;
        m.spdbrk_armed  = 0;
        m.parkbrake     = 0;
        m.speed         = 0;
        m.reverser      = 0;
        m.apu_running   = 0;
        m.gear_down     = 0;
        m.gear_override = 0;
        m.flap_override = 0;
        m.ap_passive    = 1;
        m.ap_disengaged = 0;
        me.rudder_trim  = 0;
        me.elev_trim    = 0;
        
        # internal states
        m.active_warnings = 0;
        m.active_caution  = 0;
        m.warn_mute       = 0;

        # add some listeners
        setlistener("controls/gear/gear-down",          func { Weu.update_listener_inputs() } );
        setlistener("controls/flight/speedbrake",       func { Weu.update_listener_inputs() } );
        setlistener("controls/flight/speedbrake-lever", func { Weu.update_listener_inputs() } );
        setlistener("controls/gear/brake-parking",      func { Weu.update_listener_inputs() } );
        setlistener("controls/engines/engine/reverser", func { Weu.update_listener_inputs() } );
        setlistener("controls/electric/APU-generator",  func { Weu.update_listener_inputs() } );
        setlistener("/systems/electrical/outputs/avionics",func { Weu.update_listener_inputs() } );
        setlistener("controls/flight/rudder-trim",      func { Weu.update_listener_inputs() } );
        setlistener("controls/flight/elevator-trim",    func { Weu.update_listener_inputs() } );
        setlistener("sim/freeze/replay-state",          func { Weu.update_listener_inputs() } );
        setlistener(prop1 ~ "/serviceable",             func { Weu.update_listener_inputs() } );

        setlistener("instrumentation/mk-viii/inputs/discretes/gear-override", func { Weu.update_listener_inputs() } );
        setlistener("controls/engines/engine/throttle", func { Weu.update_throttle_input() } );
        setlistener("autopilot/locks/passive-mode",     func { Weu.update_ap_mode();});
        m.update_listener_inputs();
        
        # update inputs now and then...
        settimer(weu_update_feeder,0.5);

        print("Warning Electronic System ... ok");
        return m;
    },

#### mute ####
    mute_warnings : func
    {
       me.warn_mute = 1;
    },

#### takeoff config warnings ####
    takeoff_config_warnings : func
    {
        if (me.speed >= getprop("instrumentation/afds/max-airspeed-kts")+5)
            append(me.msgs_alert,">OVERSPEED");

        if (me.radio_alt<=30)
        {
           # T/O warnings

           # 777: T/O warnings trigger when either throttle is at least at 0.667
           # 777: T/O warnings disabled after rotation with at lease 5 degrees nose-up
           if ((me.throttle>=0.667)and
               (me.gear_down)and
               (!me.reverser)and
               (getprop("orientation/pitch-deg")<5))
           {
               # Take-off attempt!
               if ((!me.flap_override)and
                   ((me.flaps<0.16)or(me.flaps>0.7)))
                 append(me.msgs_alert,">CONFIG FLAPS");

               # 777 manual: The EICAS warning message CONFIG SPOILERS indicates
               # that the speedbrake lever is not in its down detent
               # when either the left or right engine thrust exceeds the
               # takeoff threshold and the airplane is on the ground.
               if (me.speedbrake>0.1)
                 append(me.msgs_alert,">CONFIG SPOILERS");

               # 777 manual: Rudder trim must be within 2 units from center at T/O.
               if (abs(me.rudder_trim)>0.04)
                 append(me.msgs_alert,">CONFIG RUDDER TRIM");

               if (abs(me.elev_trim)>0.04)
                 append(me.msgs_alert,">CONFIG ELEV TRIM");
           }
        }
    },

#### approach config warnings ####
    approach_config_warnings : func
    {
        # approach warnings below 800ft when thrust lever in idle...
        # ... and flaps in landing configuration
        if ((me.radio_alt<800)and
            (me.throttle<0.5)and
            (me.flaps>0.6))
        {
            if ((!me.gear_override)and
                (!me.gear_down))
            {
                append(me.msgs_alert,">CONFIG GEAR");
            }
         }
    },

#### caution messages ####
    caution_messages : func
    {
        if (me.ap_disengaged)
            append(me.msgs_caution,">AP DISCONNECT");
        if ((getprop("/gear/brake-thermal-energy") or 0)>1)
            append(me.msgs_caution,">L R BRAKE OVERHEAT");
        if (me.speedbrake)
        {
            # 777 manual: EICAS caution message SPEEDBRAKE EXTENDED indicates
            # that the speedbrake lever is more than the armed position with
            # the airplane above 15 feet of radio altitude and one of these conditions:
            # Airplane below 800 feet radio altitude, Flaps at landing position, thrust lever is more than 5 degrees above idle.
            if ((me.radio_alt>15)and
                (me.radio_alt<800)and
                (me.throttle>0.1)and
                (me.flaps>0.6))
                append(me.msgs_caution,">SPEEDBRAKE EXTENDED");
        }
        if (me.parkbrake)
            append(me.msgs_info,">PARK BRK SET");
        if (me.reverser)
            append(me.msgs_info,">L R THRUST REV SET");
        if (me.spdbrk_armed)
            append(me.msgs_info,">SPEEDBRAKE ARMED");
        if (me.apu_running)
            append(me.msgs_info,">APU RUNNING");
    },

#### stall warnings and other sounds ####
    update_sounds : func
    {
		var target_speed = 0;
        var horn   = 0;
        var shaker = 0;
        var siren  = (size(me.msgs_alert)!=0);
		vgrosswt = math.sqrt(getprop("/yasim/gross-weight-lbs")/661500);

        # calculate stall speed
        if (me.flaps<0.01)			# flap up
		{
            stallspeed = vgrosswt * 166 + 80;
		}
        elsif (me.flaps<0.034)		# flap 1
		{
            stallspeed = vgrosswt * 166 + 60;
			target_speed = vgrosswt * 166 + 80;
		}
        elsif (me.flaps<0.167)		# flap 5
		{
            stallspeed = vgrosswt * 166 + 40;
			target_speed = vgrosswt * 166 + 60;
		}
        elsif (me.flaps<0.501)		# flap 15
		{
            stallspeed = vgrosswt * 166 + 20;
			target_speed = vgrosswt * 166 + 40;
		}
        elsif (me.flaps<0.667)		# flap 20
		{
            stallspeed = vgrosswt * 180;
			target_speed = vgrosswt * 166 + 20;
		}
        elsif (me.flaps<0.834)		# flap 25
		{
            stallspeed = vgrosswt * 174;
			target_speed = vgrosswt * 180;
		}
        else						# flap 30
		{
            stallspeed = vgrosswt * 166;
			target_speed = vgrosswt * 174;
		}
		stallspeed /= 1.3;
        me.stallspeed.setValue(stallspeed);
        me.targetspeed.setValue(target_speed);

        if ((me.speed<=stallspeed)and
            (me.enabled)and
            ((!getprop("gear/gear[1]/wow"))or
             (!getprop("gear/gear[2]/wow"))))
        {
            horn=1;
            shaker=1;
            # disable autopilot when stalled
            setprop("autopilot/locks/passive-mode",1);
        }

        caution_state = (size(me.msgs_caution)>0);

        if ((me.active_warnings)or(me.active_caution)or(caution_state)or(siren)or(shaker)or(horn))
        {
            if (horn) siren=0;
            me.siren.setBoolValue(siren and (!me.warn_mute));
            me.stallhorn.setBoolValue(horn and (!me.warn_mute));
            me.stickshaker.setBoolValue(shaker);
            
            me.active_warnings = (siren or shaker or horn);
            me.active_caution = caution_state;
            
            if (!me.active_warnings) me.warn_mute = 0;
            
            me.master_warning.setBoolValue(me.active_warnings);
            me.master_caution.setBoolValue(me.active_caution);
        }
        else
            me.warn_mute = 0;
    },

#### update listener inputs ####
    update_listener_inputs : func()
    {
        # be nice to sim: some inputs rarely change. use listeners.
        me.enabled       = (getprop("/systems/electrical/outputs/avionics") and
                            (getprop("sim/freeze/replay-state")!=1) and
                            me.serviceable.getValue());
        me.speedbrake    = getprop("controls/flight/speedbrake");
        me.spdbrk_armed  = (getprop("controls/flight/speedbrake-lever")==1); #2=extended (not armed...)
        me.reverser      = getprop("controls/engines/engine/reverser");
        me.gear_down     = getprop("controls/gear/gear-down");
        me.parkbrake     = getprop("controls/gear/brake-parking");
        me.gear_override = getprop("instrumentation/mk-viii/inputs/discretes/gear-override");
        me.apu_running   = getprop("controls/electric/APU-generator");
        me.rudder_trim   = getprop("controls/flight/rudder-trim");
        me.elev_trim     = getprop("controls/flight/elevator-trim");
    },

#### update throttle input ####
    update_throttle_input : func()
    {
        me.throttle = getprop("controls/engines/engine/throttle");
    },

#### update autopilot mode ####
    update_ap_mode : func()
    {
       ap_passive = getprop("autopilot/locks/passive-mode");
       if ((ap_passive)and(!me.ap_passive))
       {
           # AP has disengaged
           me.ap_disengaged = 1;
           # display "AP DISCONNECT" for 5 seconds
           settimer(func { Weu.update_ap_mode() }, 5);
       }
       else
       {
           me.ap_disengaged = 0;
       }
       me.apwarning.setBoolValue(me.ap_disengaged);
       me.ap_passive = ap_passive;
    },

#### main WEU update ####
    update : func()
    {
        me.msgs_alert   = [];
        me.msgs_caution = [];
        me.msgs_info    = [];

        if (me.enabled)
        {
            me.radio_alt  = me.node_radio_alt.getValue();
            me.flaps      = me.node_flaps.getValue();
            me.speed      = me.node_speed.getValue();
            me.flap_override = me.node_flap_override.getBoolValue();
            
            me.takeoff_config_warnings();
            me.approach_config_warnings();
            me.caution_messages();

            if ((me.parkbrake>0.1)and((me.throttle>=0.667)or(me.radio_alt>30)))
                append(me.msgs_alert,">CONFIG PARK BRK");
        }

        me.update_sounds();

        # update EICAS message display
        Efis.update_eicas(me.msgs_alert,me.msgs_caution,me.msgs_info);

        # be nice: updates every 0.5 seconds is enough
        settimer(weu_update_feeder,0.5);
    },
};

##############################################
# timer callbacks
##############################################
weu_update_feeder = func
{
    Weu.update();
}

##############################################
# main
##############################################
Weu = WEU.new("instrumentation/weu");

