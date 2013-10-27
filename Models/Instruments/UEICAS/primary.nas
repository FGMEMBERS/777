# ==============================================================================
# Boeing 777 EICAS by Hyde Yamakawa
# ==============================================================================

var msgInfo = {};
var msgAlert = {};
var msgCaution = {};

var canvas_primary = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_primary] };
		
		var eicasP = canvas_group;
		
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicasP, "Aircraft/777/Models/Instruments/UEICAS/primary.svg", {'font-mapper': font_mapper});
		
		msgInfo = eicasP.getElementById("msgInfo");
		msgAlert = eicasP.getElementById("msgAlert");
		msgCaution = eicasP.getElementById("msgCaution");

		return m;
	},
	update: func()
	{	
		msgAlert.setText(getprop("instrumentation/efis/eicas/msg/alert"));
		msgCaution.setText(getprop("instrumentation/efis/eicas/msg/caution"));
		msgInfo.setText(getprop("instrumentation/efis/eicas/msg/info"));

		settimer(func me.update(), 0);
	}
};

setlistener("/nasal/canvas/loaded", func {
	var my_canvas = canvas.new({
		"name": "EICASPrimary",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	my_canvas.addPlacement({"node": "EICAS.screen"});
	var group = my_canvas.createGroup();
	var demo = canvas_primary.new(group);
	demo.update();
}, 1);
