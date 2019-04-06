#Ground Services added by Isaak Dieleman.

var payload_boarding = {
	init : func {
	
	# pax
	
	props.globals.initNode("/services/payload/first-request-nr", 0);
	props.globals.initNode("/services/payload/first-onboard-nr", 0);
	props.globals.initNode("/services/payload/first-onboard-lbs", 0);
	props.globals.initNode("/services/payload/business-request-nr", 0);
	props.globals.initNode("/services/payload/business-onboard-nr", 0);
	props.globals.initNode("/services/payload/business-onboard-lbs", 0);
	props.globals.initNode("/services/payload/economy-request-nr", 0);
	props.globals.initNode("/services/payload/economy-onboard-nr", 0);
	props.globals.initNode("/services/payload/economy-onboard-lbs", 0);
	props.globals.initNode("/services/payload/pax-request-nr", 0);
	props.globals.initNode("/services/payload/pax-onboard-nr", 0);
	props.globals.initNode("/services/payload/pax-onboard-lbs", 0);
	props.globals.initNode("/services/payload/pax-random-nr", 0);
	props.globals.initNode("/services/payload/pax-boarding", 0);
	props.globals.initNode("/services/stairs/stairs1_enable", 0);
	props.globals.initNode("/services/stairs/stairs2_enable", 0);
	props.globals.initNode("/services/stairs/stairs3_enable", 0);
	props.globals.initNode("/services/stairs/paint-end", "blue-shade.png");
	props.globals.initNode("/services/stairs/cover", 1);
	props.globals.initNode("/services/payload/passenger-added", 0);
	props.globals.initNode("/services/payload/passenger-removed", 0);
	props.globals.initNode("/services/payload/speed", 6.0); #This defines the loading/boarding cycle speed. 6.0 equals 1 cycle every 6 seconds.
	props.globals.initNode("/services/payload/pax-force-deboard", 0);
	
	# Baggage
	
	props.globals.initNode("/services/payload/belly-request-lbs", 0);
	props.globals.initNode("/services/payload/belly-onboard-lbs", 0);
	props.globals.initNode("/services/payload/baggage-loading", 0);
	props.globals.initNode("/services/payload/baggage-truck1-enable", 0);
	props.globals.initNode("/services/payload/baggage-truck2-enable", 0);
	props.globals.initNode("/services/payload/baggage-speed", 0);
	
	# Crew
	
	props.globals.initNode("/services/payload/crew-request-nr", 2.0);
	props.globals.initNode("/services/payload/crew-onboard-nr", 2.0);
	props.globals.initNode("/services/payload/crew-onboard-lbs", 300.0);

	_startstop();

	},
	
	update : func {
		
		#Keep the dialog up to date and prepare some values for calculations
		
		setprop("/services/payload/pax-request-nr", getprop("/services/payload/first-request-nr") + getprop("/services/payload/business-request-nr") + getprop("/services/payload/economy-request-nr"));
				
		#Passenger boarding
		#First: each passenger weighs between 85 and 189 Lbs (random for each passenger) and has 110 Lbs of luggage
		#Business: each passenger weighs between 85 and 189 Lbs (random for each passenger) and has 88 Lbs of luggage
		#Economy: each passenger weighs between 85 and 189 Lbs (random for each passenger) and has 33 Lbs of luggage
		#Passengers are boarding quite randomly (classwise) and the same amount of passengers will weigh a different amount with each flight. The average should be around the worldwide average weight of 137 Lbs pp.
		
		if (getprop("/services/payload/pax-boarding") == 1) {
		
			if (getprop("/services/payload/pax-onboard-nr") < getprop("/services/payload/pax-request-nr")) {
				
				#This random number defines which type of passenger (first/business/economy) is boarding in this cycle.
				setprop("/services/payload/pax-random-nr", math.round(rand() * getprop("/services/payload/pax-request-nr")));
			
				if (getprop("/services/payload/first-onboard-nr") < getprop("/services/payload/first-request-nr")) {			    
					if ((getprop("/services/payload/pax-request-nr") - getprop("/services/payload/pax-onboard-nr")) > (getprop("/services/payload/first-request-nr"))) {
						if (getprop("/services/payload/pax-random-nr") <= getprop("/services/payload/first-request-nr")) {
							setprop("/services/payload/first-onboard-nr", getprop("/services/payload/first-onboard-nr") + 1.0);
							setprop("/services/payload/first-onboard-lbs", math.round(getprop("/services/payload/first-onboard-lbs") + 195 + math.round(rand() * 104)));
							setprop("/services/payload/passenger-added", 1);
						}
					} else {
						setprop("/services/payload/first-onboard-nr", getprop("/services/payload/first-onboard-nr") + 1.0);
						setprop("/services/payload/first-onboard-lbs", math.round(getprop("/services/payload/first-onboard-lbs") + 195 + math.round(rand() * 104)));
						setprop("/services/payload/passenger-added", 1);
					}
				}
				
				if ((getprop("/services/payload/passenger-added") != 1) and (getprop("/services/payload/economy-onboard-nr") < getprop("/services/payload/economy-request-nr"))) {			    
					if ((getprop("/services/payload/pax-request-nr") - getprop("/services/payload/pax-onboard-nr")) > (getprop("/services/payload/economy-request-nr"))) {
						if (getprop("/services/payload/pax-random-nr") >= (getprop("/services/payload/pax-request-nr") - getprop("/services/payload/economy-request-nr"))) {
							setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") + 1.0);
							setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-onboard-lbs") + 118 + rand() * 104));
							setprop("/services/payload/passenger-added", 1);
						}
					} else {
						setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") + 1.0);
						setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-onboard-lbs") + 118 + rand() * 104));
						setprop("/services/payload/passenger-added", 1);
					}
				}
				
				if (getprop("/services/payload/passenger-added") != 1) {
					if (getprop("/services/payload/business-onboard-nr") < getprop("/services/payload/business-request-nr")) {
						setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-onboard-nr") + 1.0);
						setprop("/services/payload/business-onboard-lbs", math.round(getprop("/services/payload/business-onboard-lbs") + 173 + rand() * 104));
					}
				}
				
				setprop("/services/payload/passenger-added", 0);
				
				#if the middle stairs are enabled, an extra business or economy passenger is added every cycle because they can board faster.
				#if the rear stairs are enabled, an extra economy passenger is added every cycle because they can board faster.
				#I should try to find out if I can make this work for the jetway system too.
				
				setprop("/services/payload/pax-random-nr", math.round(rand() * getprop("/services/payload/pax-request-nr")));
				
				if (getprop("/services/stairs/stairs2_enable") == 1) {
				    if (getprop("/services/payload/economy-onboard-nr") < getprop("/services/payload/economy-request-nr")) {
					    if (getprop("/services/payload/pax-random-nr") >= (getprop("/services/payload/pax-request-nr") - getprop("/services/payload/economy-request-nr"))) {
					        setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") + 1);
						    setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-onboard-lbs") + 118 + rand() * 104));
						    setprop("/services/payload/passenger-added", 1);
						}
					}
					
					if ((getprop("/services/payload/business-onboard-nr") < getprop("/services/payload/business-request-nr")) and (getprop("/services/payload/passenger-added") != 1)) {
					    setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-onboard-nr") + 1);
						setprop("/services/payload/business-onboard-lbs", math.round(getprop("/services/payload/business-onboard-lbs") + 173 + rand() * 104));
					}
				}
				
				if (getprop("/services/stairs/stairs3_enable") == 1) {
				    if (getprop("/services/payload/economy-onboard-nr") < getprop("/services/payload/economy-request-nr")) {
					    setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") + 1);
						setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-onboard-lbs") + 118 + rand() * 104));
					}
				}
				
				setprop("/services/payload/passenger-added", 0);
				setprop("/services/payload/pax-onboard-nr", (getprop("/services/payload/first-onboard-nr") + getprop("/services/payload/business-onboard-nr") + getprop("/services/payload/economy-onboard-nr")));
				setprop("/services/payload/pax-onboard-lbs", (getprop("/services/payload/first-onboard-lbs") + getprop("/services/payload/business-onboard-lbs") + getprop("/services/payload/economy-onboard-lbs")));
				
				
			} else {
				setprop("/services/payload/pax-boarding", 0);
				screen.log.write("Boarding complete. " ~ getprop("/services/payload/pax-onboard-nr") ~ " pax on board, weighing " ~ getprop("/services/payload/pax-onboard-lbs") ~ " Lbs.", 0, 0.584, 1);
			}
			
		#Deboarding
		} elsif (getprop("/services/payload/pax-boarding") == 2) {
		    setprop("/services/payload/weight-total-lbs", getprop("/services/payload/pax-onboard-lbs") + getprop("/services/payload/belly-onboard-lbs"));
		    if ((getprop("/services/payload/weight-total-lbs") <= getprop("/sim/weight[1]/max-lb")) or (getprop("/services/payload/pax-force-deboard") == 1))  {
				if (getprop("/services/payload/first-onboard-nr") > 0) {
					setprop("/services/payload/first-onboard-lbs", math.round((getprop("/services/payload/first-onboard-lbs") - (getprop("/services/payload/first-onboard-lbs") / getprop("/services/payload/first-onboard-nr")))));
					setprop("/services/payload/first-onboard-nr", getprop("/services/payload/first-onboard-nr") - 1.0);
					setprop("/services/payload/passenger-removed", 1);
				} elsif ((getprop("/services/payload/business-onboard-nr") > 0) and (getprop("/services/payload/passenger-removed") != 1)) {
					setprop("/services/payload/business-onboard-lbs", math.round((getprop("/services/payload/business-onboard-lbs") - (getprop("/services/payload/business-onboard-lbs") / getprop("/services/payload/business-onboard-nr")))));
					setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-onboard-nr") - 1.0);
					setprop("/services/payload/passenger-removed", 1);
				} elsif ((getprop("/services/payload/economy-onboard-nr") > 0) and (getprop("/services/payload/passenger-removed") != 1)) {
					setprop("/services/payload/economy-onboard-lbs", math.round((getprop("/services/payload/economy-onboard-lbs") - (getprop("/services/payload/economy-onboard-lbs") / getprop("/services/payload/economy-onboard-nr")))));
					setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") - 1.0);
				} else {
					setprop("/services/payload/pax-boarding", 0);
					setprop("/services/payload/pax-force-deboard", 0);
					screen.log.write("Deboarding complete.", 0, 0.584, 1);
				}
				
				#if the middle stairs are enabled, an extra business or economy passenger is removed every cycle because they can deboard faster.
				#if the rear stairs are enabled, an extra economy passenger is removed every cycle because they can deboard faster.
				#I should try to find out if I can make this work for the jetway system too.
				
				if (getprop("/services/stairs/stairs2_enable") == 1) {
				    if (getprop("/services/payload/business-onboard-nr") > 0) {
						setprop("/services/payload/business-onboard-lbs", math.round((getprop("/services/payload/business-onboard-lbs") - (getprop("/services/payload/business-onboard-lbs") / getprop("/services/payload/business-onboard-nr")))));
						setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-onboard-nr") - 1.0);
					} elsif (getprop("/services/payload/economy-onboard-nr") > 0) {
					    setprop("/services/payload/economy-onboard-lbs", math.round((getprop("/services/payload/economy-onboard-lbs") - (getprop("/services/payload/economy-onboard-lbs") / getprop("/services/payload/economy-onboard-nr")))));
					    setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") - 1.0);
					}
				}
				
				if (getprop("/services/stairs/stairs3_enable") == 1) {
				    if (getprop("/services/payload/economy-onboard-nr") > 0) {
					    setprop("/services/payload/economy-onboard-lbs", math.round((getprop("/services/payload/economy-onboard-lbs") - (getprop("/services/payload/economy-onboard-lbs") / getprop("/services/payload/economy-onboard-nr")))));
					    setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") - 1.0);
					}
				}
			} else {
				setprop("/services/payload/pax-boarding", 3);
			}
		    setprop("/services/payload/passenger-removed", 0);
			setprop("/services/payload/pax-onboard-nr", (getprop("/services/payload/first-onboard-nr") + getprop("/services/payload/business-onboard-nr") + getprop("/services/payload/economy-onboard-nr")));
			setprop("/services/payload/pax-onboard-lbs", (getprop("/services/payload/first-onboard-lbs") + getprop("/services/payload/business-onboard-lbs") + getprop("/services/payload/economy-onboard-lbs")));
		
		#Deboarding a few passengers when over the maximum loading weight. This enables the user to choose which passengers he wants to remove.
		
		} elsif (getprop("/services/payload/pax-boarding") == 3) {
			if (getprop("/services/payload/first-request-nr") < getprop("/services/payload/first-onboard-nr")) {
				setprop("/services/payload/first-onboard-lbs", math.round(getprop("/services/payload/first-onboard-lbs") - getprop("/services/payload/first-onboard-lbs") / getprop("/services/payload/first-onboard-nr")));
				setprop("/services/payload/first-onboard-nr", getprop("/services/payload/first-onboard-nr") - 1.0);
			} elsif (getprop("/services/payload/business-request-nr") < getprop("/services/payload/business-onboard-nr")) {
				setprop("/services/payload/business-onboard-lbs", math.round(getprop("/services/payload/business-onboard-lbs") - getprop("/services/payload/business-onboard-lbs") / getprop("/services/payload/business-onboard-nr")));
				setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-onboard-nr") - 1.0);
			} elsif (getprop("/services/payload/economy-request-nr") < getprop("/services/payload/economy-onboard-nr")) {
				setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-onboard-lbs") - getprop("/services/payload/economy-onboard-lbs") / getprop("/services/payload/economy-onboard-nr")));
				setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-onboard-nr") - 1.0);
			} else {
			    if (getprop("/services/payload/weight-total-lbs") < getprop("/sim/weight[1]/max-lb")) {
				    setprop("/services/payload/pax-boarding", 0);
					screen.log.write("Captain, a few passengers have deboarded. We can safely travel now.", 0, 0.584, 1);
				} else {
				    setprop("/services/payload/pax-boarding", 2);
					setprop("/services/payload/pax-force-deboard", 1);
				}
			}
			
			setprop("/services/payload/passenger-removed", 0);
			setprop("/services/payload/pax-onboard-nr", (getprop("/services/payload/first-onboard-nr") + getprop("/services/payload/business-onboard-nr") + getprop("/services/payload/economy-onboard-nr")));
			setprop("/services/payload/pax-onboard-lbs", (getprop("/services/payload/first-onboard-lbs") + getprop("/services/payload/business-onboard-lbs") + getprop("/services/payload/economy-onboard-lbs")));
		}
		
		#Baggage Loading
		
		#This works easier than boarding passengers. Between 50 and 250 Lbs is loaded/unloaded per baggage truck per cycle, averaging around 150 Lbs per cycle.
		
		if (getprop("/services/payload/baggage-loading") == 1) {
		    #Define loading speed based on the number of baggage trucks connected.
		    setprop("/services/payload/baggage-speed", math.round((getprop("/services/payload/baggage-truck1-enable") + getprop("/services/payload/baggage-truck2-enable")) * (50 + rand() * 200)));
			if (getprop("/services/payload/belly-onboard-lbs") < getprop("/services/payload/belly-request-lbs")) {
				setprop("/services/payload/belly-onboard-lbs", getprop("/services/payload/belly-onboard-lbs") + getprop("/services/payload/baggage-speed"));
				if (getprop("/services/payload/belly-onboard-lbs") >= getprop("/services/payload/belly-request-lbs")) {
					setprop("/services/payload/belly-onboard-lbs", getprop("/services/payload/belly-request-lbs"));
					setprop("/services/payload/baggage-loading", 0);
					screen.log.write("Baggage loading complete.", 0, 0.584, 1);
				}
			}
		} elsif (getprop("/services/payload/baggage-loading") == 2) {
		    #Define unloading speed based on the number of baggage trucks connected.
		    setprop("/services/payload/baggage-speed", math.round((getprop("/services/payload/baggage-truck1-enable") + getprop("/services/payload/baggage-truck2-enable")) * (50 + rand() * 200)));
			
			#unload
			if (getprop("/services/payload/belly-onboard-lbs") > 0) {
				if (getprop("/services/payload/belly-onboard-lbs") <= getprop("/services/payload/baggage-speed")) {
					setprop("/services/payload/belly-onboard-lbs", 0);
					setprop("/services/payload/baggage-loading", 0);
					screen.log.write("Baggage unloading complete.", 0, 0.584, 1);
				} else {
					setprop("/services/payload/belly-onboard-lbs", getprop("/services/payload/belly-onboard-lbs") - getprop("/services/payload/baggage-speed"))
				}
			}
		}
		
		#Crew
		
		#We're assuming an average crew member weighs 137 Lbs, as does the average human, and has 13 lbs of luggage with him/her.
		#Changes are applied immediatly because doing this via a procedure is overkill.
		
		if (getprop("/services/payload/crew-onboard-nr") != getprop("/services/payload/crew-request-nr")) {
			setprop("/services/payload/crew-onboard-nr", getprop("/services/payload/crew-request-nr"));
			setprop("/services/payload/crew-onboard-lbs", getprop("/services/payload/crew-onboard-nr") * 150);
		}
		
		# Write to weight properties, but check if we are not overloading first.
		
		setprop("/services/payload/weight-total-lbs", getprop("/services/payload/pax-onboard-lbs") + getprop("/services/payload/belly-onboard-lbs") + getprop("/services/payload/crew-onboard-lbs"));
		if (((getprop("/services/payload/weight-total-lbs") - getprop("/services/payload/crew-onboard-lbs")) >= getprop("/sim/weight[1]/max-lb")) and ((getprop("/services/payload/baggage-loading") == 1) or (getprop("/services/payload/pax-boarding") == 1))) {
			setprop("/services/payload/baggage-loading", 0);
			setprop("/services/payload/pax-boarding", 0);
			screen.log.write("Captain, we are overloading the aircraft. Please reduce the number of passengers or cargo on board. Boarding & loading stopped.", 1, 0, 0);
		}
		
		setprop("/services/payload/expected-weight-lbs", getprop("/services/payload/belly-request-lbs") + getprop("/services/payload/first-request-nr") * 247 + getprop("/services/payload/business-request-nr") * 225 + getprop("/services/payload/economy-request-nr") * 170 + getprop("/services/payload/crew-request-nr") * 150);
		setprop("/sim/weight[1]/weight-lb", getprop("/services/payload/pax-onboard-lbs") + getprop("/services/payload/belly-onboard-lbs"));
		setprop("/sim/weight/weight-lb", getprop("/services/payload/crew-onboard-lbs"));

	},
};

var _timer = maketimer(6.0, func{payload_boarding.update()});

var _startstop = func() {
    if (getprop("/gear/gear[0]/wow") == 1) {
		_timer.start();
	} else {
	    _timer.stop();
	}
}

var _adjustspeed = func() {
    if (_timer.isRunning) {
	    if (getprop("/services/payload/speed") == 0) {
		    if (getprop("/services/payload/pax-boarding") == 1) {
				setprop("/services/payload/first-onboard-nr", getprop("/services/payload/first-request-nr"));
				setprop("/services/payload/first-onboard-lbs", math.round(getprop("/services/payload/first-request-nr") * 247));
				setprop("/services/payload/business-onboard-nr", getprop("/services/payload/business-request-nr"));
				setprop("/services/payload/business-onboard-lbs", math.round(getprop("/services/payload/business-request-nr") * 225));
				setprop("/services/payload/economy-onboard-nr", getprop("/services/payload/economy-request-nr"));
				setprop("/services/payload/economy-onboard-lbs", math.round(getprop("/services/payload/economy-request-nr") * 170));
			} elsif (getprop("/services/payload/pax-boarding") == 2) {
			    setprop("/services/payload/first-onboard-nr", 0);
				setprop("/services/payload/first-onboard-lbs", 0);
				setprop("/services/payload/business-onboard-nr", 0);
				setprop("/services/payload/business-onboard-lbs", 0);
				setprop("/services/payload/economy-onboard-nr", 0);
				setprop("/services/payload/economy-onboard-lbs", 0);
			}
			
			if (getprop("/services/payload/baggage-loading") == 1) {
				setprop("/services/payload/belly-onboard-lbs", getprop("/services/payload/belly-request-lbs") - 1.0);
			} elsif (getprop("/services/payload/baggage-loading") == 2) {
				setprop("/services/payload/belly-onboard-lbs", 0);
			}
		setprop("/services/payload/speed", 6.0); #Reset the speed to normal.
		} else {
		    _timer.restart(getprop("/services/payload/speed"));
		}
	}
}

setlistener("sim/signals/fdm-initialized", func {
	payload_boarding.init();
	print("Payload system ..... Initialized");
});

setlistener("/gear/gear[0]/wow", func {_startstop()});

setlistener("/services/payload/speed", func{_adjustspeed()});
