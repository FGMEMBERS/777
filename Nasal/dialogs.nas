var Radio = gui.Dialog.new("/sim/gui/dialogs/radios/dialog",
        "Aircraft/777/Systems/tranceivers.xml");
var ap_settings = gui.Dialog.new("/sim/gui/dialogs/autopilot/dialog",
        "Aircraft/777/Systems/autopilot-dlg.xml");
var tiller_steering = gui.Dialog.new("/sim/gui/dialogs/tiller-steering/dialog",
		"Aircraft/777/Systems/tiller-steering.xml");

gui.menuBind("radio", "dialogs.Radio.open()");
gui.menuBind("autopilot-settings", "dialogs.ap_settings.open()");
