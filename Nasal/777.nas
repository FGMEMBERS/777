##########################################
# Fuel Save State
##########################################
var fuel_save_state = func {
    if (!getprop("/aircraft/settings/fuel_persistent")) {
        setprop("/consumables/fuel/tank[0]/level-norm", 0.25);
        setprop("/consumables/fuel/tank[1]/level-norm", 0.0);
        setprop("/consumables/fuel/tank[2]/level-norm", 0.25);
    };
};

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
    # Checking if fuel tanks should be refilled (in case save state is off)
    fuel_save_state();
	radio_save_state();
});