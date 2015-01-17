# Copyright (C) 2014  onox
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

var copilot_say = func (message) {
    setprop("/sim/messages/copilot", message);
};

var make_notification_cb = func (format, action=nil) {
    return func (data=nil) {
        if (format != nil) {
            if (data != nil) {
                var message = sprintf(format, data.getValue());
            }
            else {
                var message = format;
            }

            copilot_say(message);
#            logger.info(sprintf("Announcing '%s'", message));
        }

        if (typeof(action) == "func") {
            action();
        }
    };
};

var make_distance_cb = func (format) {
    return func (data=nil) {
        if (format != nil) {
            var message = sprintf(format, data.getValue(), landing_config.distances_unit);
            copilot_say(message);
#            logger.info(sprintf("Announcing '%s'", message));
        }
    };
};

var stop_announcer = func {
    landing_announcer.stop();
#    logger.warn("Stopping landing announce");

    takeoff_announcer.set_mode("taxi-and-takeoff");
#    logger.warn(sprintf("Takeoff mode: %s", takeoff_announcer.mode));
};

var switch_to_takeoff = func {
    if (takeoff_announcer.mode == "taxi-and-takeoff") {
        takeoff_announcer.set_mode("takeoff");
#        logger.warn(sprintf("Takeoff mode: %s", takeoff_announcer.mode));
    }
};

var takeoff_config = { parents: [runway.TakeoffRunwayAnnounceConfig] };

# Will cause the announcer to emit the "on-runway" signal if the
# aircraft is within 600 meters of the beginning of the runway and
# at most 15 meters from the center line of the runway
takeoff_config.distance_center_line_m = 15;
takeoff_config.distance_start_m = 600;

# Let the announcer emit the "approaching-runway" signal if the
# aircraft comes within 200 meters of the runway
takeoff_config.distance_edge_max_m = 200;

var takeoff_announcer = runway.TakeoffRunwayAnnounceClass.new(takeoff_config);
takeoff_announcer.connect("on-runway", make_notification_cb("On runway %s", switch_to_takeoff));
takeoff_announcer.connect("approaching-runway", make_notification_cb("Approaching runway %s"));

var landing_config = { parents: [runway.LandingRunwayAnnounceConfig] };
landing_config.distances_unit = "meter";
landing_config.distance_center_nose_m = 25;

var landing_announcer = runway.LandingRunwayAnnounceClass.new(landing_config);
landing_announcer.connect("remaining-distance", make_distance_cb("%d %s remaining"));
landing_announcer.connect("vacated-runway", make_notification_cb("Vacated runway %s", stop_announcer));
landing_announcer.connect("landed-runway", make_notification_cb("Touchdown on runway %s"));
landing_announcer.connect("landed-outside-runway", make_notification_cb(nil, stop_announcer));

var make_switch_mode_cb = func (wow_mode, no_wow_mode) {
    return func (node) {
        if (node.getBoolValue()) {
            if (getprop("/gear/gear[1]/wow") and getprop("/gear/gear[2]/wow")) {
                takeoff_announcer.set_mode(wow_mode);
            }
            else {
                takeoff_announcer.set_mode(no_wow_mode);
            }
        }
        else {
            takeoff_announcer.set_mode("");
        }
#        logger.warn(sprintf("Takeoff mode: %s", takeoff_announcer.mode));
    };
};

setlistener("/controls/lighting/nav-lights",
  make_switch_mode_cb("taxi-and-takeoff", "taxi"),
  startup=1, runtime=0);

var have_been_in_air = 0;

var test_on_ground = func (on_ground) {
    if (on_ground) {
        takeoff_announcer.start();
#        logger.warn("Starting takeoff announce");

        if (have_been_in_air == 1) {
            have_been_in_air = 0;

            takeoff_announcer.set_mode("");

            landing_announcer.start();
            landing_announcer.set_mode("landing");
#            logger.warn("Starting landing announce");
        }
    }
    else {
        takeoff_announcer.stop();
#        logger.warn("Stopping takeoff announce");

        landing_announcer.stop();
#        logger.warn("Stopping landing announce");

        if (have_been_in_air == 0) {
            have_been_in_air = 1;
        }
    }
};

var init_announcers = func {
    setlistener("/gear/gear[1]/wow", func (n) {
        test_on_ground(getprop("/gear/gear[1]/wow") and getprop("/gear/gear[2]/wow"));
    }, startup=1, runtime=0);

    setlistener("/gear/gear[2]/wow", func (n) {
        test_on_ground(getprop("/gear/gear[1]/wow") and getprop("/gear/gear[2]/wow"));
    }, startup=1, runtime=0);
};

setlistener("/sim/signals/fdm-initialized", func {
#    logger.warn("FDM initialized");

    var timer = maketimer(5.0, func init_announcers());
    timer.singleShot = 1;
    timer.start();
});
