var fctl_canvas = {};

var aileronPosLeft = {};
var flaperonPosLeft = {};
var aileronPosRight = {};
var flaperonPosRight = {};
var rudderPos = {};
var elevPosLeft = {};
var elevPosRight = {};
var elevatorTrim = {};
var rudderTrim = {};
var rudderTrimDirection = {};
var spoilers = {};
var spoilers_scale = {};
var fctlMode = {};
var fctlModeBox = {};

var canvas_fctl = {
    new : func(canvas_group)
    {
        var m = { parents: [canvas_fctl, MfDPanel.new("fctl",canvas_group,"Aircraft/777/Models/Instruments/MFD/fctl.svg",canvas_fctl.update)] };
        m.context = m;
        m.initSvgIds(m.group);
        return m;
    },
    initSvgIds: func(group)
    {
        aileronPosLeft = group.getElementById("aileronPosLeft");
        flaperonPosLeft = group.getElementById("flaperonPosLeft");
        aileronPosRight = group.getElementById("aileronPosRight");
        flaperonPosRight = group.getElementById("flaperonPosRight");
        rudderPos = group.getElementById("rudderPos");
        elevPosLeft = group.getElementById("elevPosLeft");
        elevPosRight = group.getElementById("elevPosRight");
        elevatorTrim = group.getElementById("elevatorTrim");
        rudderTrim = group.getElementById("rudderTrim");
        rudderTrimDirection = group.getElementById("rudderTrimDirection");
        spoilers = group.getElementById("spoilers").updateCenter();
        fctlMode = group.getElementById("fctlMode");
        fctlModeBox = group.getElementById("fctlModeBox");

        var c1 = spoilers.getCenter();
        spoilers.createTransform().setTranslation(-c1[0], -c1[1]);
        spoilers_scale = spoilers.createTransform();
        spoilers.createTransform().setTranslation(c1[0], c1[1]);
    },
    updateRudderTrim: func()
    {
        var rdTrim = getprop("controls/flight/rudder-trim");
        var rdTrimDir = "L";
        if (rdTrim > 0) rdTrimDir = "R";
        rdTrim = math.abs(rdTrim * 17);
        rudderTrim.setText(sprintf("%2.1f",math.round(rdTrim,0.1)));
        rudderTrimDirection.setText(rdTrimDir);
    },
    updateSpoilers: func()
    {
        var spoilerTotalHeight = 77.5;
        var spbangle = getprop("surface-positions/speedbrake-pos-norm") or 0.00;
        var spoilerCurrentHeight = spbangle*spoilerTotalHeight;
        spoilers_scale.setScale(1,spbangle);
        spoilers_scale.setTranslation(0,(spoilerTotalHeight-spoilerCurrentHeight)/2);
    },
    updateFctlMode: func()
    {
        if (getprop("/fcs/pfc-enable") == 1) {
            fctlMode.setText("NORMAL");
            fctlMode.setColor(0,1,0);
            fctlModeBox.setColor(0,1,0);
        } else {
            fctlMode.setText("DIRECT");
            fctlMode.setColor(1,0.76,0);
            fctlModeBox.setColor(1,0.76,0);
        }
    },
    update: func()
    {
        aileronPosLeft.setTranslation(0,2.2*getprop("/fcs/left-out-aileron/final-deg"));
        aileronPosRight.setTranslation(0,2.2*getprop("/fcs/right-out-aileron/final-deg"));
        elevPosLeft.setTranslation(0,2.2*getprop("/fcs/left-elevator/final-deg"));
        elevPosRight.setTranslation(0,2.2*getprop("/fcs/right-elevator/final-deg"));
        elevatorTrim.setText(sprintf("%3.2f",math.round(getprop("/fcs/stabilizer/final-deg-ind"),0.1)));
        flaperonPosLeft.setTranslation(0,2*getprop("/fcs/left-in-aileron/final-deg"));
        flaperonPosRight.setTranslation(0,2*getprop("/fcs/right-in-aileron/final-deg"));
        rudderPos.setTranslation(4.7*getprop("/fcs/rudder/final-deg"),0);

        me.updateRudderTrim();
        me.updateSpoilers();
        me.updateFctlMode();
    },
};
