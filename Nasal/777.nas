##########################################
# Fuel State
##########################################

var fuel_save_state = func {
    if (getprop("/aircraft/settings/fuel_persistent")) {
        setprop("/aircraft/settings/fuel/tank_level-lbs", getprop("/consumables/fuel/tank/level-lbs"));
        setprop("/aircraft/settings/fuel/tank1_level-lbs", getprop("/consumables/fuel/tank[1]/level-lbs"));
        setprop("/aircraft/settings/fuel/tank2_level-lbs", getprop("/consumables/fuel/tank[2]/level-lbs"));
        io.write_properties(getprop("/sim/fg-home") ~ "/Export/" ~ getprop("/sim/aero") ~ "-specific_config.xml", "/aircraft/settings/fuel");
    };
};

var fuel_load_state = func {
    if (getprop("/aircraft/settings/fuel_persistent")) {
        io.read_properties(getprop("/sim/fg-home") ~ "/Export/" ~ getprop("/sim/aero") ~ "-specific_config.xml", "/aircraft/settings/fuel");
        #Make sure we don't pass a nil (first run with this model)
        if ((getprop("/aircraft/settings/fuel/tank_level-lbs") == nil) or (getprop("/aircraft/settings/fuel/tank1_level-lbs") == nil) or (getprop("/aircraft/settings/fuel/tank2_level-lbs") == nil)) {
            setprop("/consumables/fuel/tank/level-norm", 0.25);
            setprop("/consumables/fuel/tank[1]/level-norm", 0.0);
            setprop("/consumables/fuel/tank[2]/level-norm", 0.25);
        } else {
            setprop("consumables/fuel/tank/level-lbs", getprop("/aircraft/settings/fuel/tank_level-lbs"));
            setprop("consumables/fuel/tank[1]/level-lbs", getprop("/aircraft/settings/fuel/tank1_level-lbs"));
            setprop("consumables/fuel/tank[2]/level-lbs", getprop("/aircraft/settings/fuel/tank2_level-lbs"));
        };
    } else {
        setprop("/consumables/fuel/tank[0]/level-norm", 0.25);
        setprop("/consumables/fuel/tank[1]/level-norm", 0.0);
        setprop("/consumables/fuel/tank[2]/level-norm", 0.25);
        setprop("/aircraft/settings/fuel/tank_level-lbs", 0.25);
        setprop("/aircraft/settings/fuel/tank1_level-lbs", 0.0);
        setprop("/aircraft/settings/fuel/tank2_level-lbs", 0.25);
    };
};

##########################################
# Radio Save State
##########################################

var radio_save_state = func {
    if (!getprop("/aircraft/settings/radio_persistent")) {
        setprop("/instrumentation/comm/frequencies/selected-mhz", 119.10);
        setprop("/instrumentation/comm/frequencies/standby-mhz", 125.00);
        setprop("/instrumentation/comm[1]/frequencies/selected-mhz", 119.30);
        setprop("/instrumentation/comm[1]/frequencies/standby-mhz", 118.70);
        setprop("/instrumentation/comm[2]/frequencies/selected-mhz", 119.50);
        setprop("/instrumentation/comm[2]/frequencies/standby-mhz", 135.705);
        setprop("/instrumentation/nav/frequencies/selected-mhz", 109.50);
        setprop("/instrumentation/nav/frequencies/standby-mhz", 109.55);
        setprop("/instrumentation/nav[1]/frequencies/selected-mhz", 110.10);
        setprop("/instrumentation/nav[1]/frequencies/standby-mhz", 111.70);
    } else {
        setprop("/instrumentation/rmu/unit/selected-mhz", getprop("/instrumentation/comm/frequencies/selected-mhz"));
        setprop("/instrumentation/rmu/unit/standby-mhz", getprop("/instrumentation/comm/frequencies/standby-mhz"));
        setprop("/instrumentation/rmu/unit[1]/selected-mhz", getprop("/instrumentation/comm[1]/frequencies/selected-mhz"));
        setprop("/instrumentation/rmu/unit[1]/standby-mhz", getprop("/instrumentation/comm[1]/frequencies/standby-mhz"));
        setprop("/instrumentation/rmu/unit[2]/selected-mhz", getprop("/instrumentation/comm[2]/frequencies/selected-mhz"));
        setprop("/instrumentation/rmu/unit[2]/standby-mhz", getprop("/instrumentation/comm[2]/frequencies/standby-mhz"));
    };
};

setlistener("/sim/signals/fdm-initialized", func {
    fuel_load_state();
    radio_save_state();
});

setlistener("/sim/signals/exit", func {
    fuel_save_state();
});

setlistener("/sim/signals/reinit", func {
    fuel_save_state();
});