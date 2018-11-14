var XpdrTimer = maketimer(0.2, func(){
    var IndicatedAltFt = getprop("instrumentation/altimeter/indicated-altitude-ft");
    setprop("instrumentation/transponder/inputs/mode-s-alt-ft", math.round(IndicatedAltFt, 10));
});

var XpdrStartup = func(){
    XpdrTimer.start();
};

setlistener("/sim/fdm-initialized", XpdrStartup);