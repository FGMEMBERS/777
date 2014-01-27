var mfdi = nil;
var mfdListener = nil;

    var MfDPanel = {
        updateTimer: {},
        context : {},
        new : func(name,canvas_group,svgFile,updateFunc)
        {
            var m = { parents: [MfDPanel] };
            m.updateFunc = updateFunc;
            m.group = canvas_group.createChild("group",name);
            m.group.hide();
            var font_mapper = func(family, weight)
            {
                if( family == "Liberation Sans" and weight == "normal" )
                    return "LiberationFonts/LiberationSans-Regular.ttf";
            };
            canvas.parsesvg(m.group, svgFile, {'font-mapper': font_mapper});
            return m;
        },
        start : func()
        {
            me.group.show();
            me.updateTimer = maketimer(0,me.context,me.updateFunc);
            me.updateTimer.start();
            
        },
        stop : func()
        {
            me.group.hide();
            if (me.updateTimer != nil) {
                me.updateTimer.stop();
                me.updateTimer = nil;
            }
        }
    };

    var MFD = {
        defaultPanel : "eng",
        panel : "",
        popupWnd : {},
        popupId : -1,
        new : func(placement) 
        {
            var m = { parents: [MFD] };
            m.name = "MFD";
            m.screen = canvas.new({
                "name": m.name,
                "size": [1024, 1024],
                "view": [1024, 1024],
                "mipmapping": 1
            });
            m.screen.addPlacement({"node": placement});
            m.group = m.screen.createGroup();
            m.engDisplay = canvas_eng.new(m.group);
            m.fctlDisplay = canvas_fctl.new(m.group);
            m.displayPanel(m.defaultPanel);
            return m;
        },
        displayPanel: func(panel) 
        {
            if (me.panel != "") {
                me.display.stop();
            }
            if (me.panel != panel) {
                if (panel == "eng") 
                    me.display = me.engDisplay;
                elsif (panel == "fctl")
                    me.display = me.fctlDisplay;
                me.display.start();
                me.panel = panel;
            }
            else me.panel = "";
        },
        togglePopup : func()
        {
            if (me.popupId > 0) me.popupId = getprop("sim/gui/canvas/window["~me.popupId~"]/id") or -1;
            if (me.popupId < 0) {
                me.popupWnd = canvas.Window.new([400, 400],"MFD");
                me.popupWnd.setCanvas(me.screen);
                me.popupWnd.set("title","MFD");
                me.popupId  = me.popupWnd.get("id");
            }
            else {
                me.popupWnd.del();
            }
        },
        del : func() {
            if (me.popupId > 0) me.popupWnd.del();
            me.group.removeAllChildren();
            me.panel="";
            me.screen.del();
        }
    };
    
var mfdCreate = func() {
    if(mfdi == nil) {
        mfdi = MFD.new("MFD.screen");
    }
}
var mfdShow = func(panel)
{
    if(mfdi != nil) mfdi.displayPanel(panel);
}
var mfdRemove = func() {
    if(mfdi != nil) mfdi.del();
    mfdi = nil;
}

mfdListener = setlistener("sim/signals/fdm-initialized", mfdCreate);

var mfdTogglePopup = func() {
    if((mfdi != nil)
		and (getprop("sim/instrument-options/canvas-popup-enable")))
	{
		mfdi.togglePopup();
	}
}

var mfdDel = func() {
    removelistener(mfdListener);
    if(mfdiCreated) mfdi.del();
}
