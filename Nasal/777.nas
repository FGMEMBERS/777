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

setlistener("/sim/signals/fdm-initialized", func {
    # Checking if fuel tanks should be refilled (in case save state is off)
    fuel_save_state();
});