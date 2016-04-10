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

var pilot_switches1_mpp  = "sim/multiplay/generic/int[0]";
var pilot_TDM1_mpp       = "sim/multiplay/generic/string[1]";
var pilot_TDM2_mpp       = "sim/multiplay/generic/string[2]";
var pilot_TDM3_mpp       = "sim/multiplay/generic/string[3]";
var pilot_TDM4_mpp       = "sim/multiplay/generic/string[4]";

var l_display_mode       = "sim/multiplay/generic/string[5]";

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
var l_capt_flt_inst = "systems/electrical/CPT-FLT-INST";

var l_altitude_int = "instrumentation/altimeter/indicator-altitude-ft";
var l_altitude = "instrumentation/altimeter/indicated-altitude-ft";
#var l_src_baro = "instrumentation/altimeter/source-barometric";
var l_inhg = "instrumentation/altimeter/setting-inhg";

var l_ind_speed = "instrumentation/airspeed-indicator/indicator-speed-kt";
var l_vref = "instrumentation/weu/state/vref";
var l_stall_warning = "instrumentation/weu/state/stall-warning";
var l_flap_on = "instrumentation/weu/state/flap-on";
var l_fl1_on = "instrumentation/weu/state/fl1-on";
var l_fl5_on = "instrumentation/weu/state/fl5-on";
var l_fl15_on = "instrumentation/weu/state/fl15-on";
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
var l_ap = "instrumentation/afds/inputs/AP";
var l_ias_mach = "instrumentation/afds/inputs/ias-mach-selected";
var l_intervention = "instrumentation/afds/settings/manual-intervention";
#var l_ap_pich_mode = "instrumentation/afds/ap-modes/pitch-mode";
var l_referance_deg = "instrumentation/afds/inputs/reference-deg";
#var l_mode_annunciator = "instrumentation/afds/ap-modes/mode-annunciator";

var l_target_altitude = "autopilot/settings/counter-set-altitude-ft";
var l_set_altitude_FL = "autopilot/settings/counter-set-altitude-FL";
var l_set_altitude_100 = "autopilot/settings/counter-set-altitude-100";
var l_set_radio_altitude = "autopilot/settings/radio-altimeter-indication";
var l_target_speed = "autopilot/settings/target-speed-kt";
var l_target_heading = "autopilot/settings/heading-bug-deg";
var l_transition_alt = "autopilot/settings/transition-altitude";
var l_pfd_mach_ind = "autopilot/settings/pfd-mach-indication";
var l_pfd_mach_target_ind = "autopilot/settings/pfd-mach-target-indication";
var l_alt_alert = "autopilot/internal/alt-alert";
var l_autopilot_transition = "autopilot/internal/autopilot-transition";
var l_pitch_transition = "autopilot/internal/pitch-transition";
var l_roll_transition = "autopilot/internal/roll-transition";
var l_speed_transition = "autopilot/internal/speed-transition";
var l_heading = "autopilot/internal/crab-angle-hdg";
var l_heading_bug = "autopilot/internal/heading-bug-error-deg";
var l_track = "autopilot/internal/crab-angle-trk";
var l_rwy_elevation = "instrumentation/pfd/runway-elevation-diff";
var l_target_altitude_diff = "instrumentation/pfd/target-altitude-diff";
var l_minimum_diff = "instrumentation/pfd/minimum-diff";
var l_target_speed_diff = "instrumentation/pfd/target-speed-diff";
var l_stall_speed_diff = "instrumentation/pfd/stallspeed-diff";
var l_over_speed_diff = "instrumentation/pfd/overspeed-diff";
var l_speed_trend_up = "instrumentation/pfd/speed-trend-up";
var l_speed_trend_down = "instrumentation/pfd/speed-trend-down";
var l_baro_std = "instrumentation/efis/inputs/setting-std";

var l_signal_quality = "instrumentation/nav/signal-quality-norm";
var l_heading_def = "instrumentation/nav/heading-needle-deflection-ptr";
var l_in_range = "instrumentation/nav/in-range";
var l_nav_loc = "instrumentation/nav/nav-loc";
var l_presision_loc = "autopilot/internal/presision-loc";
var l_has_gs = "instrumentation/nav/has-gs";
var l_gs_in_range = "instrumentation/nav/gs-in-range";
var l_gs_def = "instrumentation/nav/gs-needle-deflection-norm";

var l_track_deg = "orientation/track-deg";
var l_track_mag_deg = "orientation/track-magnetic-deg";

var l_range_nm = "instrumentation/efis/inputs/range-nm";
var l_wxr = "instrumentation/efis/inputs/wxr";
var l_arpt = "instrumentation/efis/inputs/arpt";
var l_sta = "instrumentation/efis/inputs/sta";
var l_wpt = "instrumentation/efis/inputs/wpt";
var l_pos = "instrumentation/efis/inputs/pos";
var l_data = "instrumentation/efis/inputs/data";
var l_terr = "instrumentation/efis/inputs/terr";
var l_tfc = "instrumentation/efis/inputs/tfc";
var l_nd_centered = "instrumentation/efis/inputs/nd-centered";
var l_lh_vor_adf = "instrumentation/efis/inputs/lh-vor-adf";
var l_rh_vor_adf = "instrumentation/efis/inputs/rh-vor-adf";
var l_mode_num = "instrumentation/efis/mfd/mode-num";
var l_true_north = "instrumentation/efis/mfd/true-north";
var l_rangearc = "instrumentation/efis/mfd/rangearc";
var l_hdg_trk_selected = "instrumentation/efis/hdg-trk-selected";
var l_hdg_bug_only = "instrumentation/efis/hdg-bug-only";

var l_range_nm1 = "instrumentation/efis[1]/inputs/range-nm";
var l_wxr1 = "instrumentation/efis[1]/inputs/wxr";
var l_arpt1 = "instrumentation/efis[1]/inputs/arpt";
var l_sta1 = "instrumentation/efis[1]/inputs/sta";
var l_wpt1 = "instrumentation/efis[1]/inputs/wpt";
var l_pos1 = "instrumentation/efis[1]/inputs/pos";
var l_data1 = "instrumentation/efis[1]/inputs/data";
var l_terr1 = "instrumentation/efis[1]/inputs/terr";
var l_tfc1 = "instrumentation/efis[1]/inputs/tfc";
var l_nd_centered1 = "instrumentation/efis[1]/inputs/nd-centered";
var l_lh_vor_adf1 = "instrumentation/efis[1]/inputs/lh-vor-adf";
var l_rh_vor_adf1 = "instrumentation/efis[1]/inputs/rh-vor-adf";
var l_mode_num1 = "instrumentation/efis[1]/mfd/mode-num";
var l_true_north1 = "instrumentation/efis[1]/mfd/true-north";
var l_rangearc1 = "instrumentation/efis[1]/mfd/rangearc";
var l_hdg_trk_selected1 = "instrumentation/efis[1]/hdg-trk-selected";
var l_hdg_bug_only1 = "instrumentation/efis[1]/hdg-bug-only";

var l_wind_speed = "environment/wind-speed-kt";
var l_wind_heading = "environment/wind-from-heading-deg";

var pilot_connect_copilot = func (copilot) {

return
    [
        ######################################################################
        # Process properties to send.
        ######################################################################
        ##################################################
        # Encoding of on/off switches.
        DCT.SwitchEncoder.new
        (
            [
                props.globals.getNode("systems/electrical/outputs/strobe"),
            ],
        props.globals.getNode(pilot_switches1_mpp)
        ),
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
                props.globals.getNode(l_capt_flt_inst),

                props.globals.getNode(l_altitude_int),
                props.globals.getNode(l_altitude),
#               props.globals.getNode(l_src_baro),
                props.globals.getNode(l_inhg),
                props.globals.getNode(l_ind_speed),
                props.globals.getNode(l_vref),
                props.globals.getNode(l_stall_warning),
                props.globals.getNode(l_flap_on),
                props.globals.getNode(l_fl1_on),
                props.globals.getNode(l_fl5_on),
                props.globals.getNode(l_fl15_on),
                props.globals.getNode(l_vref_diff),
                props.globals.getNode(l_vref_text_diff),
                props.globals.getNode(l_v1_diff),
                props.globals.getNode(l_vr_diff),
                props.globals.getNode(l_v2_diff),
                props.globals.getNode(l_flap_diff),
                props.globals.getNode(l_fl1_diff),
                props.globals.getNode(l_fl5_diff),
                props.globals.getNode(l_fl15_diff),
                props.globals.getNode(l_ind_vs),
                props.globals.getNode(l_ap),
                props.globals.getNode(l_ias_mach),
                props.globals.getNode(l_intervention),
#               props.globals.getNode(l_ap_pich_mode),
                props.globals.getNode(l_referance_deg),
#               props.globals.getNode(l_mode_annunciator),
                props.globals.getNode(l_track_deg),
                props.globals.getNode(l_track_mag_deg),

            ],
            props.globals.getNode(pilot_TDM1_mpp),
        ),
        DCT.TDMEncoder.new
        ([
                props.globals.getNode(l_target_altitude),
                props.globals.getNode(l_set_altitude_FL),
                props.globals.getNode(l_set_altitude_100),
                props.globals.getNode(l_set_radio_altitude),
                props.globals.getNode(l_target_speed),
                props.globals.getNode(l_target_heading),
                props.globals.getNode(l_transition_alt),
                props.globals.getNode(l_pfd_mach_ind),
                props.globals.getNode(l_pfd_mach_target_ind),
                props.globals.getNode(l_alt_alert),
                props.globals.getNode(l_autopilot_transition),
                props.globals.getNode(l_pitch_transition),
                props.globals.getNode(l_roll_transition),
                props.globals.getNode(l_speed_transition),
                props.globals.getNode(l_heading),
                props.globals.getNode(l_heading_bug),
                props.globals.getNode(l_track),
                props.globals.getNode(l_rwy_elevation),
                props.globals.getNode(l_target_altitude_diff),
                props.globals.getNode(l_minimum_diff),
                props.globals.getNode(l_target_speed_diff),
                props.globals.getNode(l_stall_speed_diff),
                props.globals.getNode(l_over_speed_diff),
                props.globals.getNode(l_speed_trend_up),
                props.globals.getNode(l_speed_trend_down),
                props.globals.getNode(l_baro_std),
                props.globals.getNode(l_signal_quality),
                props.globals.getNode(l_heading_def),
                props.globals.getNode(l_in_range),
                props.globals.getNode(l_nav_loc),
                props.globals.getNode(l_presision_loc),
                props.globals.getNode(l_has_gs),
                props.globals.getNode(l_gs_in_range),
                props.globals.getNode(l_gs_def),
            ],
            props.globals.getNode(pilot_TDM2_mpp),
        ),
        DCT.TDMEncoder.new
        ([
                props.globals.getNode(l_range_nm),
                props.globals.getNode(l_wxr),
                props.globals.getNode(l_arpt),
                props.globals.getNode(l_sta),
                props.globals.getNode(l_wpt),
                props.globals.getNode(l_pos),
                props.globals.getNode(l_data),
                props.globals.getNode(l_terr),
                props.globals.getNode(l_tfc),
                props.globals.getNode(l_nd_centered),
                props.globals.getNode(l_lh_vor_adf),
                props.globals.getNode(l_rh_vor_adf),
                props.globals.getNode(l_mode_num),
                props.globals.getNode(l_true_north),
                props.globals.getNode(l_rangearc),
                props.globals.getNode(l_hdg_trk_selected),
                props.globals.getNode(l_hdg_bug_only),
                props.globals.getNode(l_range_nm1),
                props.globals.getNode(l_wxr1),
                props.globals.getNode(l_arpt1),
                props.globals.getNode(l_sta1),
                props.globals.getNode(l_wpt1),
                props.globals.getNode(l_pos1),
                props.globals.getNode(l_data1),
                props.globals.getNode(l_terr1),
                props.globals.getNode(l_tfc1),
                props.globals.getNode(l_nd_centered1),
                props.globals.getNode(l_lh_vor_adf1),
                props.globals.getNode(l_rh_vor_adf1),
                props.globals.getNode(l_mode_num1),
                props.globals.getNode(l_true_north1),
                props.globals.getNode(l_rangearc1),
                props.globals.getNode(l_hdg_trk_selected1),
                props.globals.getNode(l_hdg_bug_only1),
            ],
            props.globals.getNode(pilot_TDM3_mpp),
        ),
        DCT.TDMEncoder.new
        ([
                props.globals.getNode(l_wind_speed),
                props.globals.getNode(l_wind_heading),
            ],
            props.globals.getNode(pilot_TDM4_mpp),
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
         # Decode pilot cockpit switch states.
         #   NOTE: Actions are only triggered on change.
         DCT.SwitchDecoder.new
         (pilot.getNode(pilot_switches1_mpp),
         [
            func {
#               var l_strobe = props.globals.getNode("systems/electrical/outputs/strobe");
#               var b = l_strobe.getValue();
#               b = !b;
#               l_strobe.setValue(b);
            },
         ]
         ),
         ##################################################
        ##################################################
         # Set up TDM reception of slow state properties.
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM1_mpp),
            [
            func (v) {
                pilot.getNode(l_yoke, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_groundspeed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_aileron, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_elevator, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rudder, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_flaps, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_spoiler, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_throttle[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_throttle[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_efis, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_avionics, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_capt_flt_inst, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_altitude_int, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_altitude, 1).setValue(v);
            },
#           func (v) {
#               pilot.getNode(l_src_baro, 1).setValue(v);
#           },
            func (v) {
                pilot.getNode(l_inhg, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ind_speed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vref, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_stall_warning, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_flap_on, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl1_on, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl5_on, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl15_on, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vref_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vref_text_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_v1_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vr_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_v2_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_flap_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl1_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl5_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fl15_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ind_vs, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ap, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ias_mach, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_intervention, 1).setValue(v);
            },
#           func (v) {
#               pilot.getNode(l_ap_pich_mode, 1).setValue(v);
#           },
            func (v) {
                pilot.getNode(l_referance_deg, 1).setValue(v);
            },
#           func (v) {
#               pilot.getNode(l_mode_annunciator, 1).setValue(v);
#           },
            func (v) {
                pilot.getNode(l_track_deg, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_track_mag_deg, 1).setValue(v);
            },
            ]),
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM2_mpp),
            [
            func (v) {
                pilot.getNode(l_target_altitude, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_set_altitude_FL, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_set_altitude_100, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_set_radio_altitude, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_speed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_heading, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_transition_alt, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pfd_mach_ind, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pfd_mach_target_ind, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_alt_alert, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_autopilot_transition, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pitch_transition, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_roll_transition, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_speed_transition, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_heading, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_heading_bug, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_track, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rwy_elevation, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_altitude_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_minimum_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_speed_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_stall_speed_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_over_speed_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_speed_trend_up, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_speed_trend_down, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_baro_std, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_signal_quality, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_heading_def, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_in_range, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_nav_loc, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_presision_loc, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_has_gs, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_gs_in_range, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_gs_def, 1).setValue(v);
            },
            ]),
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM3_mpp),
            [
            func (v) {
                pilot.getNode(l_range_nm, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wxr, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_arpt, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_sta, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wpt, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pos, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_data, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_terr, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_tfc, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_nd_centered, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_lh_vor_adf, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rh_vor_adf, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_mode_num, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_true_north, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rangearc, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_trk_selected, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_bug_only, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_range_nm1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wxr1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_arpt1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_sta1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wpt1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pos1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_data1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_terr1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_tfc1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_nd_centered1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_lh_vor_adf1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rh_vor_adf1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_mode_num1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_true_north1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rangearc1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_trk_selected1, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_bug_only1, 1).setValue(v);
            },
            ]),
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM4_mpp),
            [
            func (v) {
                pilot.getNode(l_wind_speed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wind_heading, 1).setValue(v);
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
