var mfd = {};
var mfdDisplay = {};

var mfdCreated = 0;

setlistener("sim/signals/fdm-initialized", func {
	if (mfdCreated == 1)
		mfd.del();
	mfd = canvas.new({
		"name": "MFD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	mfd.addPlacement({"node": "MFD.screen"});
	
	var group = mfd.createGroup();
	mfdDisplay = canvas_fctl.new(group);
	mfdDisplay.update();
	mfdCreated = 1;
});

var showMfd = func() {
	var dlg = canvas.Window.new([400, 400], "MFD");
	dlg.setCanvas(mfd);
}