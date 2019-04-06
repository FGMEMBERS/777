#Ground Services added by Isaak Dieleman - 20190405

var ground_services = {
	init : func {
	
	# Fuel Truck
	
	setprop("/services/fuel-truck/enable", 0);
	setprop("/services/fuel-truck/connect", 0);
	setprop("/services/fuel-truck/transfer", 0);
	setprop("/services/fuel-truck/clean", 0);
	setprop("/services/fuel-truck/request-lbs", getprop("/consumables/fuel/total-fuel-lbs"));
	setprop("/services/fuel-truck/extra-lbs", 0);
	if (getprop("/sim/aero") != "777-200F") {
	    # The 777-200F has its own payload dialog. For the other types, the max number of first/business/economy pax has to be defined, so we
		# overwrite the dialog with the values specified in their respective -set files.
		var payload = gui.Dialog.new("/sim/gui/dialogs/payload/dialog", "gui/dialogs/payload-dlg.xml");
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/slider/max", getprop("/services/payload/first-max-nr"));
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/slider[1]/max", getprop("/services/payload/business-max-nr"));
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/slider[2]/max", getprop("/services/payload/economy-max-nr"));
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/button[1]/binding/max", getprop("/services/payload/first-max-nr"));
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/button[3]/binding/max", getprop("/services/payload/business-max-nr"));
		setprop("/sim/gui/dialogs/payload/dialog/group[1]/button[5]/binding/max", getprop("/services/payload/economy-max-nr"));
    }
		
	# External Power
	
	setprop("/services/ext-pwr/enable", 0);
	setprop("/services/ext-pwr/was_enabled", 0);
	setprop("/services/ext-pwr/primary", 0);
	setprop("/services/ext-pwr/secondary", 0);
	
	# Chocks
	
	setprop("/services/chocks/nose", 0);
	setprop("/services/chocks/left", 0);
	setprop("/services/chocks/right", 0);
	
	# Catering Truck
	
	setprop("/services/catering/enable", 0);
	setprop("/services/catering/move", 0);	
	setprop("/services/catering/position", 0);
	setprop("/services/catering/angle-deg", 0);

    _startstop_gsv();
	
	},
	update : func {
	
		# Fuel Truck Controls
		# Fuel Transfer Rate is based on a 1000 US Gal flow per minute, which is at the fast side of real life operations, but not unrealistic.
		
		if (getprop("/services/fuel-truck/enable") and getprop("/services/fuel-truck/connect")) {
		
			if (getprop("/services/fuel-truck/transfer")) {
			
				if (getprop("/consumables/fuel/total-fuel-lbs") < getprop("/services/fuel-truck/request-lbs")) {
				    if (getprop("/consumables/fuel/tank/level-gal_us") < getprop("/consumables/fuel/tank[2]/capacity-gal_us")) {
					    if (getprop("/consumables/fuel/tank/level-lbs") + 6 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank[2]/level-lbs") - getprop("/consumables/fuel/tank[1]/level-lbs")) {
						    setprop("/consumables/fuel/tank/level-lbs", getprop("/consumables/fuel/tank/level-lbs") + 0.1);
						} else {
						    setprop("/consumables/fuel/tank/level-lbs", getprop("/consumables/fuel/tank/level-lbs") + 5.55);
						}
					}
					if (getprop("/consumables/fuel/tank[2]/level-gal_us") < getprop("/consumables/fuel/tank[2]/capacity-gal_us")) {
					    if (getprop("/consumables/fuel/tank[2]/level-lbs") + 6 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank/level-lbs") - getprop("/consumables/fuel/tank[1]/level-lbs")) {
						    setprop("/consumables/fuel/tank[2]/level-lbs", getprop("/consumables/fuel/tank[2]/level-lbs") + 0.1);
						} else {
						    setprop("/consumables/fuel/tank[2]/level-lbs", getprop("/consumables/fuel/tank[2]/level-lbs") + 5.55);
						}
					}
					if ((getprop("/consumables/fuel/tank/capacity-gal_us") <= getprop("/consumables/fuel/tank/level-gal_us")) and (getprop("/consumables/fuel/tank[2]/capacity-gal_us") <= getprop("/consumables/fuel/tank[2]/level-gal_us"))) {
	                    if (getprop("/consumables/fuel/tank/level-gal_us") > getprop("/consumables/fuel/tank/capacity-gal_us")) {
							setprop("/consumables/fuel/tank[1]/level-gal_us", (getprop("/consumables/fuel/tank[1]/level-gal_us") + getprop("/consumables/fuel/tank/level-gal_us") - getprop("/consumables/fuel/tank/capacity-gal_us")));
							setprop("/consumables/fuel/tank/level-gal_us", getprop("/consumables/fuel/tank/capacity-gal_us"));
						}
						if (getprop("/consumables/fuel/tank[2]/level-gal_us") > getprop("/consumables/fuel/tank[2]/capacity-gal_us")) {
							setprop("/consumables/fuel/tank[1]/level-gal_us", (getprop("/consumables/fuel/tank[1]/level-gal_us") + getprop("/consumables/fuel/tank[2]/level-gal_us") - getprop("/consumables/fuel/tank[2]/capacity-gal_us")));
							setprop("/consumables/fuel/tank[2]/level-gal_us", getprop("/consumables/fuel/tank[2]/capacity-gal_us"));
						}
						if (getprop("/consumables/fuel/tank[1]/level-lbs") + 12 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank/level-lbs") - getprop("/consumables/fuel/tank[2]/level-lbs")) {
						    setprop("/consumables/fuel/tank[1]/level-lbs", getprop("/consumables/fuel/tank[1]/level-lbs") + 0.1);
						} else {
						    setprop("/consumables/fuel/tank[1]/level-lbs", getprop("/consumables/fuel/tank[1]/level-lbs") + 11.1);
						}
					}
				} else {
					setprop("/services/fuel-truck/transfer", 0);
					screen.log.write("Refueling complete. " ~ math.round(getprop("/consumables/fuel/total-fuel-lbs")) ~" Lbs. of fuel loaded.", 0, 0.584, 1);
				}
			}
			
			if (getprop("/services/fuel-truck/clean")) {
			
				if (getprop("consumables/fuel/total-fuel-lbs") > 200) {
				
					setprop("/consumables/fuel/tank/level-lbs", getprop("/consumables/fuel/tank/level-lbs") - 11.1);
					setprop("/consumables/fuel/tank[1]/level-lbs", getprop("/consumables/fuel/tank[1]/level-lbs") - 11.1);
					setprop("/consumables/fuel/tank[2]/level-lbs", getprop("/consumables/fuel/tank[2]/level-lbs") - 11.1);
				} else {
					setprop("/services/fuel-truck/clean", 0);
					screen.log.write("Finished draining the fuel tanks...", 0, 0.584, 1);
				}	
			
			}
		}
		
		#External Ground Power controls
		
		if (getprop("/services/ext-pwr/enable") == 1) {
		    if (getprop("/services/ext-pwr/primary") == 1) {
			    setprop("/controls/electric/external-power", 1);
			} else {
			    setprop("/controls/electric/external-power", 0);
			}
			if (getprop("/services/ext-pwr/secondary") == 1) {
			    setprop("/controls/electric/external-power[1]", 1);
			} else {
			    setprop("/controls/electric/external-power[1]", 0);
			}
			setprop("/services/ext-pwr/was_enabled", 1);
		} else {
		    if (getprop("/services/ext-pwr/primary") == 1) {
			    if (getprop("/services/ext-pwr/was_enabled") != 1) {
				    screen.log.write("Can't connect primary ground power without a powerbox!", 1, 0 ,0);
				}
				setprop("/services/ext-pwr/primary", 0);
				setprop("/controls/electric/external-power", 0);
			}
			if (getprop("/services/ext-pwr/secondary") == 1) {
			    if (getprop("/services/ext-pwr/was_enabled") != 1) {
				    screen.log.write("Can't connect secondary ground power without a powerbox!", 1, 0 ,0);
				}
				setprop("/services/ext-pwr/secondary", 0);
				setprop("/controls/electric/external-power[1]", 0);
			}
			setprop("/services/ext-pwr/was_enabled", 0);
		}
		
		# Chocks
		# This uses the left and right brakes for the moment, to avoid the parking brake from being active.
		
		if ((getprop("/services/chocks/nose") == 1) or (getprop("/services/chocks/left") == 1)) {
			setprop("/controls/gear/brake-left", 1);
			setprop("/services/chocks/left-was-enabled", 1);
		} else {
			if (getprop("/services/chocks/left-was-enabled") == 1) {
			    setprop("/controls/gear/brake-left", 0);
				setprop("/services/chocks/left-was-enabled", 0);
			}
		}
		
		if ((getprop("/services/chocks/nose") == 1) or (getprop("/services/chocks/right") == 1)) {
			setprop("/controls/gear/brake-right", 1);
			setprop("/services/chocks/right-was-enabled", 1);
		} else {
			if (getprop("/services/chocks/right-was-enabled") == 1) {
			    setprop("/controls/gear/brake-right", 0);
				setprop("/services/chocks/right-was-enabled", 0);
			}
		}
		
		# Catering Truck Controls
		
		var cater_move = getprop("/services/catering/move");
		var cater_position = getprop("/services/catering/position");
		
		if (getprop("/services/catering/enable") != 0) {
			if (cater_position < cater_move) { #rise the catering truck 
				setprop("/services/catering/position", getprop("/services/catering/position") + 0.005);  
				if (cater_move - getprop("/services/catering/position") < 0.0001) {
					setprop("/services/catering/position", cater_move);
				}
			} elsif (cater_position > cater_move) { #lower the catering truck
				setprop("/services/catering/position", getprop("/services/catering/position") - 0.005);  
				if ((getprop("/services/catering/position") - cater_move) < 0.0001) {
					setprop("/services/catering/position", cater_move);
				}
			}
	    } else {
		    setprop("/services/catering/position", 0);
			setprop("/services/catering/move", 0);
		}

	}

};

var _timer_gsv = maketimer(0.1, func{ground_services.update()});

var _startstop_gsv = func() {
    if (getprop("/gear/gear[0]/wow") == 1) {
		_timer_gsv.start();
	} else {
	    _timer_gsv.stop();
	}
}

setlistener("sim/signals/fdm-initialized", func {
	ground_services.init();
	print("Ground Services ..... Initialized");
});

setlistener("/gear/gear[0]/wow", func {_startstop_gsv()});
