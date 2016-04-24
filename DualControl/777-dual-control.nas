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
var pilot_TDM3_mpp       = "sim/multiplay/generic/string[3]";

var l_yoke = "sim/yokes-visible";
var l_groundspeed = "velocities/groundspeed-kt";
var l_flaps = "controls/flight/flaps";
var l_spoiler = "controls/flight/speedbrake-lever";
var l_throttle = ["controls/engines/engine[0]/throttle-lever",
     "controls/engines/engine[1]/throttle-lever"];

var l_efis = "systems/electrical/outputs/efis";
var l_avionics = "systems/electrical/outputs/avionics";
var l_capt_flt_inst = "systems/electrical/CPT-FLT-INST";

var l_target_speed_diff = "instrumentation/pfd/target-speed-diff";
var l_stall_speed_diff = "instrumentation/pfd/stallspeed-diff";
var l_over_speed_diff = "instrumentation/pfd/overspeed-diff";
var l_speed_trend_up = "instrumentation/pfd/speed-trend-up";
var l_speed_trend_down = "instrumentation/pfd/speed-trend-down";
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

var l_target_speed = "autopilot/settings/target-speed-kt";
var l_pfd_mach_ind = "autopilot/settings/pfd-mach-indication";
var l_pfd_mach_target_ind = "autopilot/settings/pfd-mach-target-indication";
var l_ias_mach = "instrumentation/afds/inputs/ias-mach-selected";
var l_intervention = "instrumentation/afds/settings/manual-intervention";

var l_target_altitude = "autopilot/settings/counter-set-altitude-ft";
var l_set_altitude_FL = "autopilot/settings/counter-set-altitude-FL";
var l_set_altitude_100 = "autopilot/settings/counter-set-altitude-100";
var l_rwy_elevation = "instrumentation/pfd/runway-elevation-diff";
var l_target_altitude_diff = "instrumentation/pfd/target-altitude-diff";
var l_set_radio_altitude = "autopilot/settings/radio-altimeter-indication";
var l_minimum_diff = "instrumentation/pfd/minimum-diff";
var l_alt_alert = "autopilot/internal/alt-alert";

var l_signal_quality = "instrumentation/nav/signal-quality-norm";
var l_heading_def = "instrumentation/nav/heading-needle-deflection-ptr";
var l_in_range = "instrumentation/nav/in-range";
var l_nav_loc = "instrumentation/nav/nav-loc";
var l_presision_loc = "autopilot/internal/presision-loc";
var l_has_gs = "instrumentation/nav/has-gs";
var l_gs_in_range = "instrumentation/nav/gs-in-range";
var l_gs_def = "instrumentation/nav/gs-needle-deflection-norm";
var l_loc_armed = "instrumentation/afds/inputs/loc-armed";
var l_gs_armed = "instrumentation/afds/inputs/gs-armed";

var l_inhg = "instrumentation/altimeter/setting-inhg";
var l_inhg_kpa = "instrumentation/efis/inhg-kpa";
var l_baro_std = "instrumentation/efis/inputs/setting-std";
var l_transition_alt = "autopilot/settings/transition-altitude";
var l_kpa_mode = "instrumentation/efis/inputs/kpa-mode";

var l_target_heading = "autopilot/settings/heading-bug-deg";
var l_heading = "autopilot/internal/crab-angle-hdg";
var l_heading_bug = "autopilot/internal/heading-bug-error-deg";
var l_track = "autopilot/internal/crab-angle-trk";

var l_target_pitch = "autopilot/internal/target-pitch-deg";
var l_target_roll = "autopilot/internal/target-roll-deg";
var l_autopilot_transition = "autopilot/internal/autopilot-transition";
var l_pitch_transition = "autopilot/internal/pitch-transition";
var l_roll_transition = "autopilot/internal/roll-transition";
var l_speed_transition = "autopilot/internal/speed-transition";

var l_ind_vs = "instrumentation/afds/inputs/indicated-vs-fpm";
var l_ap = "instrumentation/afds/inputs/AP";
var l_hdg_trk_selected = "instrumentation/efis/hdg-trk-selected";

var l_egt = ["engines/engine[1]/egt",
     "engines/engine[0]/egt"];
var l_minimums = "instrumentation/efis/minimums";
var l_at_armed = ["instrumentation/afds/inputs/at-armed[0]",
     "instrumentation/afds/inputs/at-armed[1]"];
var l_FD = "instrumentation/afds/inputs/FD";
var l_vertical_speed = "autopilot/settings/vertical-speed-fpm";
var l_flight_path = "autopilot/settings/flight-path-angle";
var l_vs_fpa = "instrumentation/afds/inputs/vs-fpa-selected";
var l_vs_disp = "instrumentation/afds/settings/vs-display";
var l_fpa_disp = "instrumentation/afds/settings/fpa-display";

var l_intencity = "controls/lighting/panel-flood-intencity";

var l_cdu_serviceable = "instrumentation/cdu/serviceable";

var l_range_nm = ["instrumentation/efis[0]/inputs/range-nm",
        "instrumentation/efis[1]/inputs/range-nm"];
var l_wxr = ["instrumentation/efis[0]/inputs/wxr",
        "instrumentation/efis[1]/inputs/wxr"];
var l_arpt = ["instrumentation/efis[0]/inputs/arpt",
        "instrumentation/efis[1]/inputs/arpt"];
var l_sta = ["instrumentation/efis[0]/inputs/sta",
        "instrumentation/efis[1]/inputs/sta"];
var l_wpt = ["instrumentation/efis[0]/inputs/wpt",
        "instrumentation/efis[1]/inputs/wpt"];
var l_pos = ["instrumentation/efis[0]/inputs/pos",
        "instrumentation/efis[1]/inputs/pos"];
var l_data = ["instrumentation/efis[0]/inputs/data",
        "instrumentation/efis[1]/inputs/data"];
var l_terr = ["instrumentation/efis[0]/inputs/terr",
        "instrumentation/efis[1]/inputs/terr"];
var l_tfc = ["instrumentation/efis[0]/inputs/tfc",
        "instrumentation/efis[1]/inputs/tfc"];
var l_nd_centered = ["instrumentation/efis[0]/inputs/nd-centered",
        "instrumentation/efis[1]/inputs/nd-centered"];
var l_lh_vor_adf = ["instrumentation/efis[0]/inputs/lh-vor-adf",
        "instrumentation/efis[1]/inputs/lh-vor-adf"];
var l_rh_vor_adf = ["instrumentation/efis[0]/inputs/rh-vor-adf",
        "instrumentation/efis[1]/inputs/rh-vor-adf"];
var l_true_north = ["instrumentation/efis[0]/mfd/true-north",
        "instrumentation/efis[1]/mfd/true-north"];
var l_rangearc = ["instrumentation/efis[0]/mfd/rangearc",
        "instrumentation/efis[1]/mfd/rangearc"];
var l_hdg_bug_only = ["instrumentation/efis[0]/hdg-bug-only",
        "instrumentation/efis[1]/hdg-bug-only"];

var pilot_connect_copilot = func (copilot) {

    return
        [
            ##################################################
            # Set up TDM transmission of slow state properties.
            DCT.TDMEncoder.new
            ([
                props.globals.getNode(l_groundspeed),
                props.globals.getNode(l_yoke),
                props.globals.getNode(l_flaps),
                props.globals.getNode(l_spoiler),
                props.globals.getNode(l_throttle[0]),
                props.globals.getNode(l_throttle[1]),

                props.globals.getNode(l_efis),
                props.globals.getNode(l_avionics),
                props.globals.getNode(l_capt_flt_inst),

                props.globals.getNode(l_target_speed_diff),
                props.globals.getNode(l_stall_speed_diff),
                props.globals.getNode(l_over_speed_diff),
                props.globals.getNode(l_speed_trend_up),
                props.globals.getNode(l_speed_trend_down),
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

                props.globals.getNode(l_target_speed),
                props.globals.getNode(l_pfd_mach_ind),
                props.globals.getNode(l_pfd_mach_target_ind),
                props.globals.getNode(l_ias_mach),
                props.globals.getNode(l_intervention),

                props.globals.getNode(l_target_altitude),
                props.globals.getNode(l_set_altitude_FL),
                props.globals.getNode(l_set_altitude_100),
                props.globals.getNode(l_rwy_elevation),
                props.globals.getNode(l_target_altitude_diff),
                props.globals.getNode(l_set_radio_altitude),
                props.globals.getNode(l_minimum_diff),
                props.globals.getNode(l_alt_alert),

                props.globals.getNode(l_signal_quality),
                props.globals.getNode(l_heading_def),
                props.globals.getNode(l_in_range),
                props.globals.getNode(l_nav_loc),
                props.globals.getNode(l_presision_loc),
                props.globals.getNode(l_has_gs),
                props.globals.getNode(l_gs_in_range),
                props.globals.getNode(l_gs_def),
                props.globals.getNode(l_loc_armed),
                props.globals.getNode(l_gs_armed),

                props.globals.getNode(l_inhg),
                props.globals.getNode(l_inhg_kpa),
                props.globals.getNode(l_baro_std),
                props.globals.getNode(l_transition_alt),
                props.globals.getNode(l_kpa_mode),

                props.globals.getNode(l_target_heading),
                props.globals.getNode(l_heading),
                props.globals.getNode(l_heading_bug),
                props.globals.getNode(l_track),
            ],
            props.globals.getNode(pilot_TDM1_mpp),
            ),
            DCT.TDMEncoder.new
            ([
                props.globals.getNode(l_target_pitch),
                props.globals.getNode(l_target_roll),
                props.globals.getNode(l_autopilot_transition),
                props.globals.getNode(l_pitch_transition),
                props.globals.getNode(l_roll_transition),
                props.globals.getNode(l_speed_transition),

                props.globals.getNode(l_ind_vs),
                props.globals.getNode(l_ap),
                props.globals.getNode(l_hdg_trk_selected),

                props.globals.getNode(l_egt[0]),
                props.globals.getNode(l_egt[1]),
                props.globals.getNode(l_minimums),
                props.globals.getNode(l_at_armed[0]),
                props.globals.getNode(l_at_armed[1]),
                props.globals.getNode(l_FD),
                props.globals.getNode(l_vertical_speed),
                props.globals.getNode(l_flight_path),
                props.globals.getNode(l_vs_fpa),
                props.globals.getNode(l_vs_disp),
                props.globals.getNode(l_fpa_disp),

                props.globals.getNode(l_intencity),

                props.globals.getNode(l_cdu_serviceable),
                props.globals.getNode(l_range_nm[0]),
                props.globals.getNode(l_range_nm[1]),
                props.globals.getNode(l_wxr[0]),
                props.globals.getNode(l_wxr[1]),
                props.globals.getNode(l_arpt[0]),
                props.globals.getNode(l_arpt[1]),
                props.globals.getNode(l_sta[0]),
                props.globals.getNode(l_sta[1]),
                props.globals.getNode(l_wpt[0]),
                props.globals.getNode(l_wpt[1]),
                props.globals.getNode(l_pos[0]),
                props.globals.getNode(l_pos[1]),
                props.globals.getNode(l_data[0]),
                props.globals.getNode(l_data[1]),
                props.globals.getNode(l_terr[0]),
                props.globals.getNode(l_terr[1]),
                props.globals.getNode(l_tfc[0]),
                props.globals.getNode(l_tfc[1]),
                props.globals.getNode(l_nd_centered[0]),
                props.globals.getNode(l_nd_centered[1]),
                props.globals.getNode(l_lh_vor_adf[0]),
                props.globals.getNode(l_lh_vor_adf[1]),
                props.globals.getNode(l_rh_vor_adf[0]),
                props.globals.getNode(l_rh_vor_adf[1]),
                props.globals.getNode(l_true_north[0]),
                props.globals.getNode(l_true_north[1]),
                props.globals.getNode(l_rangearc[0]),
                props.globals.getNode(l_rangearc[1]),
                props.globals.getNode(l_hdg_bug_only[0]),
                props.globals.getNode(l_hdg_bug_only[1]),
            ],
            props.globals.getNode(pilot_TDM2_mpp),
            ),
        ];
}

var pilot_disconnect_copilot = func {
}

var copilot_connect_pilot = func (pilot) {
    # Map (some) properties needed to (e.g.) animate the MP/AI model.
    copilot_alias_aimodel(pilot);

    # Initialize Nasal wrappers for copilot pick anaimations.
    return
        [
        ##################################################
         # Set up TDM reception of slow state properties.
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM1_mpp),
            [
            func (v) {
                pilot.getNode(l_groundspeed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_yoke, 1).setValue(v);
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
                pilot.getNode(l_target_speed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pfd_mach_ind, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pfd_mach_target_ind, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ias_mach, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_intervention, 1).setValue(v);
            },
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
                pilot.getNode(l_rwy_elevation, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_altitude_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_set_radio_altitude, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_minimum_diff, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_alt_alert, 1).setValue(v);
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
            func (v) {
                pilot.getNode(l_loc_armed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_gs_armed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_inhg, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_inhg_kpa, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_baro_std, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_transition_alt, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_kpa_mode, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_heading, 1).setValue(v);
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
            ]),
            DCT.TDMDecoder.new
            (pilot.getNode(pilot_TDM2_mpp),
            [
            func (v) {
                pilot.getNode(l_target_pitch, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_target_roll, 1).setValue(v);
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
                pilot.getNode(l_ind_vs, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_ap, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_trk_selected, 1).setValue(v);
            },

            func (v) {
                pilot.getNode(l_egt[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_egt[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_minimums, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_at_armed[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_at_armed[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_FD, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vertical_speed, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_flight_path, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vs_fpa, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_vs_disp, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_fpa_disp, 1).setValue(v);
            },

            func (v) {
                pilot.getNode(l_intencity, 1).setValue(v);
            },

            func (v) {
                pilot.getNode(l_cdu_serviceable, 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_range_nm[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_range_nm[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wxr[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wxr[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_arpt[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_arpt[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_sta[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_sta[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wpt[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_wpt[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pos[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_pos[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_data[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_data[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_terr[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_terr[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_tfc[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_tfc[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_nd_centered[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_nd_centered[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_lh_vor_adf[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_lh_vor_adf[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rh_vor_adf[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rh_vor_adf[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_true_north[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_true_north[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rangearc[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_rangearc[1], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_bug_only[0], 1).setValue(v);
            },
            func (v) {
                pilot.getNode(l_hdg_bug_only[1], 1).setValue(v);
            },
            ]),
        ];
}

var copilot_disconnect_pilot = func {
}

######################################################################
# More property aliases to animate the MP/AI model for the copilot.
#  Contains all 1:1 mappings that are not provided by other modules
#  (e.g. instruments).
var copilot_alias_aimodel = func(pilot) {
    var p = "/instrumentation/efis[0]/mfd/display-mode";
    props.globals.getNode(p, 1).alias(pilot.getNode(p));
    p = "/instrumentation/efis[1]/mfd/display-mode";
    props.globals.getNode(p, 1).alias(pilot.getNode(p));
    p = "/instrumentation/efis/mfd[1]/display-type";
    props.globals.getNode(p, 1).alias(pilot.getNode(p));
    p = "/instrumentation/efis/mfd[1]/display-type";
    props.globals.getNode(p, 1).alias(pilot.getNode(p));
    p = "/instrumentation/cdu/display";
    props.globals.getNode(p, 1).alias(pilot.getNode(p));
}


