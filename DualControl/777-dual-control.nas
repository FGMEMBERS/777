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

var l_aileron = "controls/flight/aileron";
var l_elevator = "controls/flight/elevator";
var l_flaps = "controls/flight/flaps";
var l_throttle = ["controls/engines/engine[0]/throttle",
     "controls/engines/engine[1]/throttle"];

var l_battery = "controls/electric/battery-switch";

var pilot_connect_copilot = func (copilot) {

    return
        [
            ##################################################
            # Set up TDM transmission of slow state properties.
            DCT.TDMEncoder.new
            ([
                props.globals.getNode(l_flaps),
                props.globals.getNode(l_aileron),
                props.globals.getNode(l_elevator),
                props.globals.getNode(l_throttle[0]),
                props.globals.getNode(l_throttle[1]),

                props.globals.getNode(l_battery),
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
                pilot.getNode(l_flaps, 1).setValue(v);
                props.globals.getNode(l_flaps).setValue(v);
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
                pilot.getNode(l_throttle[0], 1).setValue(v);
                props.globals.getNode(l_throttle[0]).setValue(v);
            },
            func (v) {
                pilot.getNode(l_throttle[1], 1).setValue(v);
                props.globals.getNode(l_throttle[1]).setValue(v);
            },
            func (v) {
                pilot.getNode(l_battery, 1).setValue(v);
                props.globals.getNode(l_battery).setValue(v);
            },
            ]),
        ];
}

var copilot_disconnect_pilot = func {
}

######################################################################
# Copilot Nasal wrappers

var set_copilot_wrappers = func (pilot) {
    pilot.getNode("controls/flight/flaps").
        alias(props.globals.getNode("controls/flight/flaps"));
    pilot.getNode("controls/flight/aileron").
        alias(props.globals.getNode("controls/flight/aileron"));
    pilot.getNode("controls/flight/elevator").
        alias(props.globals.getNode("controls/flight/elevator"));
    pilot.getNode("controls/engines/engine[0]/throttle").
        alias(props.globals.getNode("controls/engines/engine[0]/throttle"));
    pilot.getNode("controls/engines/engine[1]/throttle").
        alias(props.globals.getNode("controls/engines/engine[1]/throttle"));

    pilot.getNode("controls/electric/battery-switch").
        alias(props.globals.getNode("controls/electric/battery-switch"));
}
