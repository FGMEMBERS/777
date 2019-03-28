#Ground Services added by Isaak Dieleman, based on Boeing 787 systems.

var ground_services = {
	init : func {
		me.UPDATE_INTERVAL = 0.1;
	me.loopid = 0;
	
	me.ice_time = 0;
	
	# Fuel Truck
	
	setprop("/services/fuel-truck/enable", 0);
	setprop("/services/fuel-truck/connect", 0);
	setprop("/services/fuel-truck/transfer", 0);
	setprop("/services/fuel-truck/clean", 0);
	setprop("/services/fuel-truck/request-kg", 0);	
	
	# Set them all to 0 if the aircraft is not stationary
	
	if (getprop("/velocities/groundspeed-kt") > 10) {
		setprop("/services/fuel-truck/enable", 0);
	}

	me.reset();
	},
	update : func {
	
		# Fuel Truck Controls
		# Fuel Transfer Rate is based on a 1000 US Gal flow per minute, which is at the fast side of real life operations, but not unrealistic.
		
		if (getprop("/services/fuel-truck/enable") and getprop("/services/fuel-truck/connect")) {
		
			if (getprop("/services/fuel-truck/transfer")) {
			
				if (getprop("/consumables/fuel/total-fuel-lbs") < getprop("/services/fuel-truck/request-lbs")) {
				    if (getprop("/consumables/fuel/tank/level-gal_us") < getprop("/consumables/fuel/tank[2]/capacity-gal_us")) {
					    if (getprop("/consumables/fuel/tank/level-lbs") + 10 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank[2]/level-lbs") - getprop("/consumables/fuel/tank[1]/level-lbs")) {
						    setprop("/consumables/fuel/tank/level-lbs", getprop("/consumables/fuel/tank/level-lbs") + 2.7);
						} else {
						    setprop("/consumables/fuel/tank/level-lbs", getprop("/consumables/fuel/tank/level-lbs") + 5.55);
						}
					}
					if (getprop("/consumables/fuel/tank[2]/level-gal_us") < getprop("/consumables/fuel/tank[2]/capacity-gal_us")) {
					    if (getprop("/consumables/fuel/tank[2]/level-lbs") + 10 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank/level-lbs") - getprop("/consumables/fuel/tank[1]/level-lbs")) {
						    setprop("/consumables/fuel/tank[2]/level-lbs", getprop("/consumables/fuel/tank[2]/level-lbs") + 2.7);
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
						if (getprop("/consumables/fuel/tank[1]/level-lbs") + 20 > getprop("/services/fuel-truck/request-lbs") - getprop("/consumables/fuel/tank/level-lbs") - getprop("/consumables/fuel/tank[2]/level-lbs")) {
						    setprop("/consumables/fuel/tank[1]/level-lbs", getprop("/consumables/fuel/tank[1]/level-lbs") + 5.3);
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

	me.ice_time += 1;

	},
	reset : func {
		me.loopid += 1;
		me._loop_(me.loopid);
	},
	_loop_ : func(id) {
		id == me.loopid or return;
		me.update();
		settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
	}
};

setlistener("sim/signals/fdm-initialized", func {
	ground_services.init();
	print("Ground Services ..... Initialized");
});
