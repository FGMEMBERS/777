# ==============================================================================
# UEICAS
# ==============================================================================
var leicas = {
  new: func()
  {
    debug.dump("Creating new canvas UEICAS");

    var m = { parents: [leicas] };
    
    # create a new canvas...
    m.canvas = canvas.new({
      "name": "UEICAS",
      "size": [1024, 1024],
      "view": [1024, 1024],
      "mipmapping": 1
    });
    
    m.dt = props.globals.getNode("sim/time/delta-sec");
    # ... and place it on the object called UEICAS.Screen
    m.canvas.addPlacement({"node": "UEICAS.screen"});
    m.canvas.setColorBackground(0,0,0);
    
    var g = m.canvas.createGroup();
    
#	g.createChild("image")
#		.setFile("Aircraft/777/Models/Instruments/LEICAS/leicas.png")
#		.setSize(512,512)
#		.setTranslation(512,100);
    m.text_title =
	g.createChild("text", "line-title")
#		.setText(getprop("instrumentation/efis/eicas/msg/info"))
		.setFont("Helvetica.txf")
		.setFontSize(26)
#		.setColor(0.8,0.8,0.8)
		.setAlignment("center-left")
		.setTranslation(536,162);
#    m.tf = m.text_title.createTransform();
#    m.tf.setTranslation(536, 200);

#    m.rot = 0;
#    m.pos = 200;
#    m.move = 50;
    
    return m;
  },
  update: func()
  {
#    var dt = me.dt.getValue();
#    me.pos += me.move * dt;
#    if( me.pos > 900 )
#    {
#      me.pos = 900;
#      me.move *= -1;
#    }
#    else if( me.pos < 150 )
#    {
#      me.pos = 150;
#      me.move *= -1;
#   }
#    me.tf.setTranslation(512, 150);
	me.text_title.setColor(0.9,0,0);
	me.text_title.setText(getprop("instrumentation/efis/eicas/msg/alert"));
	me.text_title.setColor(0.8,0.4,0);
	me.text_title.setText(getprop("instrumentation/efis/eicas/msg/caution"));
	me.text_title.setColor(0.8,0.8,0.8);
	me.text_title.setText(getprop("instrumentation/efis/eicas/msg/info"));
	settimer(func me.update(), 0);
  },
};

setlistener("/nasal/canvas/loaded", func {
  var ind = leicas.new();
  ind.update();
}, 1);
