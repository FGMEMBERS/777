###############################################################################
##
##  Nasal for dual control of the 777 over the multiplayer network.
##
##  Copyright (C) 2009  Anders Gidenstam  (anders(at)gidenstam.org)
##  Edited for 777 by Gijs de Rooy
##  This file is licensed under the GPL license version 2 or later.
##
###############################################################################

# Renaming (almost :)
var DCT = dual_control_tools;

######################################################################
# Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/777/Models/"~getprop("sim/aero")~".xml";
var copilot_type = "Aircraft/777/Models/777-fo.xml";

props.globals.initNode("/sim/remote/pilot-callsign", "", "STRING");
props.globals.initNode("/sim/remote/copilot-callsign", "", "STRING");

######################################################################
# MP enabled properties.
# NOTE: These must exist very early during startup - put them
#       in the -set.xml file.

var pilot_TDM1_mpp       = "sim/multiplay/generic/string[1]";
var pilot_TDM2_mpp       = "sim/multiplay/generic/string[2]";

var l_yoke = "sim/yokes-visible";
var l_groundspeed = "velocities/groundspeed-kt";
var l_aileron = "controls/flight/aileron";
var l_elevator = "controls/flight/elevator";
var l_rudder = "controls/flight/rudder";
var l_flaps = "controls/flight/flaps";
var l_spoiler = "controls/flight/speedbrake-lever";
var l_throttle = ["controls/engines/engine[0]/throttle-lever",
     "controls/engines/engine[1]/throttle-lever"];

var l_efis = "systems/electrical/outputs/efis";
var l_avionics = "systems/electrical/outputs/avionics";

var l_altitude_int = "instrumentation/altimeter/indicator-altitude-ft";
var l_altitude = "instrumentation/altimeter/indicated-altitude-ft";
#var l_src_baro = "instrumentation/altimeter/source-barometric";
var l_inhg = "instrumentation/altimeter/setting-inhg";

var l_ind_speed = "instrumentation/airspeed-indicator/indicator-speed-kt";
var l_vref = "instrumentation/weu/state/vref";
var l_vref_diff = "instrumentation/pfd/vref-diff";
var l_vref_text_diff = "instrumentation/pfd/vref-text-diff";
var l_v1_diff = "instrumentation/pfd/v1-diff";
var l_vr_diff = "instrumentation/pfd/vr-diff";
var l_v2_diff = "instrumentation/pfd/v2-diff";
var l_flap_diff = "instrumentation/pfd/flap-diff";
var l_fl1_diff = "instrumentation/pfd/fl1-diff";
var l_fl5_diff = "instrumentation/pfd/fl5-diff";
var l_fl15_diff = "instrumentation/pfd/fl15-diff";



var l_ind_vs = "instrumentation/afds/inputs/indicated-vs-fpm";
#var l_ias_mach = "instrumentation/afds/inputs/ias-mach-selected";
#var l_intervention = "instrumentation/afds/settings/manual-intervention";
#var l_ap_pich_mode = "instrumentation/afds/ap-modes/pitch-mode";
var l_referance_deg = "instrumentation/afds/inputs/reference-deg";

var l_target_altitude = "autopilot/settings/counter-set-altitude-ft";
var l_set_altitude_FL = "autopilot/settings/counter-set-altitude-FL";
var l_set_altitude_100 = "autopilot/settings/counter-set-altitude-100";
var l_set_radio_altitude = "autopilot/settings/radio-altimeter-indication";
var l_transition_alt = "autopilot/settings/transition-altitude";
var l_pfd_mach_ind = "autopilot/settings/pfd-mach-indication";
var l_alt_alert = "autopilot/internal/alt-alert";
var l_autopilot_transition = "autopilot/internal/autopilot-transition";
var l_pitch_transition = "autopilot/internal/pitch-transition";
var l_roll_transition = "autopilot/internal/roll-transition";
var l_speed_transition = "autopilot/internal/speed-transition";
var l_heading = "autopilot/internal/crab-angle-hdg";
var l_track = "autopilot/internal/crab-angle-trk";
var l_precision_loc = "autopilot/internal/presision-loc";
var l_rwy_elevation = "instrumentation/pfd/runway-elevation-diff";
var l_target_altitude_diff = "instrumentation/pfd/target-altitude-diff";
var l_minimum_diff = "instrumentation/pfd/minimum-diff";
var l_target_speed_diff = "instrumentation/pfd/target-speed-diff";
var l_stall_speed_diff = "instrumentation/pfd/stallspeed-diff";
var l_over_speed_diff = "instrumentation/pfd/overspeed-diff";
var l_speed_trend_up = "instrumentation/pfd/speed-trend-up";
var l_speed_trend_down = "instrumentation/pfd/speed-trend-down";


var pilot_connect_copilot = func (copilot) {

return
    [
        ##################################################
        # Set up TDM transmission of slow state properties.
        DCT.TDMEncoder.new
        ([
            props.globals.getNode(l_yoke),
                props.globals.getNode(l_groundspeed),
            props.globals.getNode(l_aileron),
            props.globals.getNode(l_elevator),
            props.globals.getNode(l_rudder),
            props.globals.getNode(l_flaps),
            props.globals.getNode(l_spoiler),
            props.globals.getNode(l_throttle[0]),
            props.globals.getNode(l_throttle[1]),

            props.globals.getNode(l_efis),
            props.globals.getNode(l_avionics),

            props.globals.getNode(l_altitude_int),
            props.globals.getNode(l_altitude),
            props.globals.getNode(l_ind_speed),
#               props.globals.getNode(l_ias_mach),
#               props.globals.getNode(l_intervention),
#               props.globals.getNode(l_ap_pich_mode),
                props.globals.getNode(l_referance_deg),

                props.globals.getNode(l_target_altitude),
#               props.globals.getNode(l_target_speed),
#               props.globals.getNode(l_target_heading),
            ],
            props.globals.getNode(pilot_TDM1_mpp),
            ),
        DCT.TDMEncoder.new
        ([
                props.globals.getNode(l_heading),
                props.globals.getNode(l_track),
                props.globals.getNode(l_precision_loc),
                props.globals.getNode(l_rwy_elevation),
                props.globals.getNode(l_target_altitude_diff),
                props.globals.getNode(l_minimum_diff),
                props.globals.getNode(l_target_speed_diff),
                props.globals.getNode(l_stall_speed_diff),
                props.globals.getNode(l_over_speed_diff),
                props.globals.getNode(l_speed_trend_up),
                props.globals.getNode(l_speed_trend_down),
            ],
            props.globals.getNode(pilot_TDM2_mpp),
        ),
        ];
}

var pilot_disconnect_copilot = func {
}

var copilot_connect_pilot = func (pilot) {
    # Initialize Nasal wrappers for copilot pick anaimations.
    return
        [
        ##################################################
         # Set up TDM reception of slow state properties.
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM1_mpp),
            [
            func (v) {
                pilot.getNode(l_yoke, 1).setValue(v);
                props.globals.getNode(l_yoke).setValue(v);
            },
            func (v) {
                pilot.getNode(l_groundspeed, 1).setValue(v);
                props.globals.getNode(l_groundspeed).setValue(v);
            },
            func (v) {
                pilot.getNode(l_aileron, 1).setValue(v);
                props.globals.getNode(l_aileron).setValue(v);
            },
            func (v) {
                pilot.getNode(l_elevator, 1).setValue(v);
                props.globals.getNode(l_elevator).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rudder, 1).setValue(v);
                props.globals.getNode(l_rudder).setValue(v);
            },
            func (v) {
                pilot.getNode(l_flaps, 1).setValue(v);
                props.globals.getNode(l_flaps).setValue(v);
            },
            func (v) {
                pilot.getNode(l_spoiler, 1).setValue(v);
                props.globals.getNode(l_spoiler).setValue(v);
            },
            func (v) {
            pilot.getNode(l_throttle[0], 1).setValue(v);
                props.globals.getNode(l_throttle[0]).setValue(v);
            },
            func (v) {
                pilot.getNode(l_throttle[1], 1).setValue(v);
                props.globals.getNode(l_throttle[1]).setValue(v);
            },
            func (v) {
                pilot.getNode(l_efis, 1).setValue(v);
                props.globals.getNode(l_efis).setValue(v);
            },
            func (v) {
                pilot.getNode(l_avionics, 1).setValue(v);
                props.globals.getNode(l_avionics).setValue(v);
            },
            func (v) {
                pilot.getNode(l_altitude_int, 1).setValue(v);
                props.globals.getNode(l_altitude_int).setValue(v);
            },
            func (v) {
                pilot.getNode(l_altitude, 1).setValue(v);
                props.globals.getNode(l_altitude).setValue(v);
            },
           func (v) {
                pilot.getNode(l_ind_speed, 1).setValue(v);
                props.globals.getNode(l_ind_speed).setValue(v);
            },
#           func (v) {
#               pilot.getNode(l_ias_mach, 1).setValue(v);
#               props.globals.getNode(l_ias_mach).setValue(v);
#           },
#           func (v) {
#               pilot.getNode(l_intervention, 1).setValue(v);
#               props.globals.getNode(l_intervention).setValue(v);
#           },
#           func (v) {
#               pilot.getNode(l_ap_pich_mode, 1).setValue(v);
#               props.globals.getNode(l_ap_pich_mode).setValue(v);
#           },
            func (v) {
                pilot.getNode(l_referance_deg, 1).setValue(v);
                props.globals.getNode(l_referance_deg).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_altitude, 1).setValue(v);
                props.globals.getNode(l_target_altitude).setValue(v);
            },
            ]),
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM2_mpp),
            [
            func (v) {
                pilot.getNode(l_heading, 1).setValue(v);
                props.globals.getNode(l_heading).setValue(v);
            },
            func (v) {
                pilot.getNode(l_track, 1).setValue(v);
                props.globals.getNode(l_track).setValue(v);
            },
            func (v) {
                pilot.getNode(l_precision_loc, 1).setValue(v);
                props.globals.getNode(l_precision_loc).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rwy_elevation, 1).setValue(v);
                props.globals.getNode(l_rwy_elevation).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_altitude_diff, 1).setValue(v);
                props.globals.getNode(l_target_altitude_diff).setValue(v);
            },
            func (v) {
                pilot.getNode(l_minimum_diff, 1).setValue(v);
                props.globals.getNode(l_minimum_diff).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_speed_diff, 1).setValue(v);
                props.globals.getNode(l_target_speed_diff).setValue(v);
            },
            func (v) {
                pilot.getNode(l_stall_speed_diff, 1).setValue(v);
                props.globals.getNode(l_stall_speed_diff).setValue(v);
            },
            func (v) {
                pilot.getNode(l_over_speed_diff, 1).setValue(v);
                props.globals.getNode(l_over_speed_diff).setValue(v);
            },
            func (v) {
                pilot.getNode(l_speed_trend_up, 1).setValue(v);
                props.globals.getNode(l_speed_trend_up).setValue(v);
            },
            func (v) {
                pilot.getNode(l_speed_trend_down, 1).setValue(v);
                props.globals.getNode(l_speed_trend_down).setValue(v);
            },
            ]),
        ];
}

var copilot_disconnect_pilot = func {
}

######################################################################
# Copilot Nasal wrappers

var set_copilot_wrappers = func (pilot) {
}
