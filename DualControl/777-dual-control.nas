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

var l_yoke = "sim/yokes-visible";
var l_aileron = "controls/flight/aileron";
var l_elevator = "controls/flight/elevator";
var l_rudder = "controls/flight/rudder";
var l_flaps = "controls/flight/flaps";
var l_spoiler = "controls/flight/speedbrake-lever";
var l_throttle = ["controls/engines/engine[0]/throttle-lever",
     "controls/engines/engine[1]/throttle-lever"];

var l_efis = "systems/electrical/outputs/efis";
var l_avionics = "systems/electrical/outputs/avionics";

#var l_altitude_int = "instrumentation/altimeter/indicator-altitude-ft";
#var l_altitude = "instrumentation/altimeter/indicated-altitude-ft";
var l_target_speed = "autopilot/settings/target-speed-kt";
var l_ias_mach = "instrumentation/afds/inputs/ias-mach-selected";
var l_intervention = "instrumentation/afds/settings/manual-intervention";
var l_ap_pich_mode = "instrumentation/afds/ap-modes/pitch-mode";

var l_target_altitude = "autopilot/settings/counter-set-altitude-ft";
var l_target_heading = "autopilot/settings/heading-bug-deg";


var pilot_connect_copilot = func (copilot) {

    return
        [
            ##################################################
            # Set up TDM transmission of slow state properties.
            DCT.TDMEncoder.new
            ([
                props.globals.getNode(l_yoke),
                props.globals.getNode(l_aileron),
                props.globals.getNode(l_elevator),
                props.globals.getNode(l_rudder),
                props.globals.getNode(l_flaps),
                props.globals.getNode(l_spoiler),
                props.globals.getNode(l_throttle[0]),
                props.globals.getNode(l_throttle[1]),

                props.globals.getNode(l_efis),
                props.globals.getNode(l_avionics),

#               props.globals.getNode(l_altitude_int),
#               props.globals.getNode(l_altitude),
                props.globals.getNode(l_target_speed),
#               props.globals.getNode(l_ias_mach),
#               props.globals.getNode(l_intervention),
#               props.globals.getNode(l_ap_pich_mode),

                props.globals.getNode(l_target_altitude),
                props.globals.getNode(l_target_heading),
            ],
            props.globals.getNode(pilot_TDM1_mpp),
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
#           func (v) {
#               pilot.getNode(l_altitude_int, 1).setValue(v);
#               props.globals.getNode(l_altitude_int).setValue(v);
#           },
#           func (v) {
#               pilot.getNode(l_altitude, 1).setValue(v);
#               props.globals.getNode(l_altitude).setValue(v);
#           },
            func (v) {
                pilot.getNode(l_target_speed, 1).setValue(v);
                props.globals.getNode(l_target_speed).setValue(v);
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
                pilot.getNode(l_target_altitude, 1).setValue(v);
                props.globals.getNode(l_target_altitude).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_heading, 1).setValue(v);
                props.globals.getNode(l_target_heading).setValue(v);
            },
            ]),
        ];
}

var copilot_disconnect_pilot = func {
}

######################################################################
# Copilot Nasal wrappers

var set_copilot_wrappers = func (pilot) {
    pilot.getNode("instrumentation/altimeter/indicated-altitude-ft").
        alias(props.globals.getNode("instrumentation/altimeter/indicated-altitude-ft"));
}
