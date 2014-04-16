var flaperonPosLeft = {};
var flaperonPosRight = {};
var rudderPos = {};
var elevPosLeft = {};
var elevPosRight = {};
var elevatorTrim = {};

var RudderTrim = {
        new : func(eltvalue,eltdirection) {
            var m = { parents: [RudderTrim]};
            m.value = eltvalue;
            m.direction = eltdirection;
            return m;
        },
        update : func(rdTrim) {
            var rdTrimDir = "L";
            if (rdTrim > 0) rdTrimDir = "R";
            rdTrim = math.abs(rdTrim * 15);
            me.value.setText(sprintf("%2.1f",rdTrim));
            me.direction.setText(rdTrimDir);
        }
};

var Aileron = {
        linearFactor : 62,
        new : func(elt) {
            var m = { parents: [Aileron]};
            m.elt = elt;
            return m;
        },
        update : func(position) {
            if(getprop("surface-positions/flap-pos-norm") > 0)
            {
                me.elt.setTranslation(0,me.linearFactor*position);
            }
        }
};

var Spoilers = {
        spoilerTotalHeight : 77.5,
        new : func(elt) {
            var m = { parents: [Spoilers]};
            m.elt = elt;
            var c1 = m.elt.getCenter();
            m.elt.createTransform().setTranslation(-c1[0], -c1[1]);
            m.elt_scale = m.elt.createTransform();
            m.elt.createTransform().setTranslation(c1[0], c1[1]);
            return m;
        },
        update : func(spbangle) {
            var spoilerCurrentHeight = spbangle * me.spoilerTotalHeight;
            me.elt_scale.setScale(1,spbangle);
            me.elt_scale.setTranslation(0,(me.spoilerTotalHeight-spoilerCurrentHeight)/2);
        }
};

var FctlPanel = {
    new : func(canvas_group)
    {
        var m = { parents: [FctlPanel, MfDPanel.new("fctl",canvas_group,"Aircraft/777/Models/Instruments/MFD/fctl.svg",FctlPanel.update)] };
        m.context = m;
        m.initSvgIds(m.group);
        return m;
    },
    initSvgIds: func(group)
    {
        var aileronLeft = Aileron.new(group.getElementById("aileronPosLeft"));
        me.registry.add("surface-positions/left-aileron-pos-norm",aileronLeft);
        var aileronRight = Aileron.new(group.getElementById("aileronPosRight"));
        me.registry.add("surface-positions/right-aileron-pos-norm",aileronRight);

        flaperonPosLeft = group.getElementById("flaperonPosLeft");
        flaperonPosRight = group.getElementById("flaperonPosRight");
        rudderPos = group.getElementById("rudderPos");
        elevPosLeft = group.getElementById("elevPosLeft");
        elevPosRight = group.getElementById("elevPosRight");
        elevatorTrim = group.getElementById("elevatorTrim");

        var spoilers = Spoilers.new(group.getElementById("spoilers").updateCenter());
        me.registry.add("controls/flight/speedbrake-angle",spoilers);

        var rudderTrim = RudderTrim.new(group.getElementById("rudderTrim"),group.getElementById("rudderTrimDirection"));
        me.registry.add("controls/flight/rudder-trim",rudderTrim);

    },
    updateFlaperons: func()
    {
        var pos = getprop("controls/flight/aileron");
        if (pos > 0) {
            flaperonPosLeft.setTranslation(0,62*getprop("surface-positions/left-aileron-pos-norm"));
            flaperonPosRight.setTranslation(0,22*getprop("surface-positions/right-aileron-pos-norm"));
        }
        else {
            flaperonPosRight.setTranslation(0,62*getprop("surface-positions/right-aileron-pos-norm"));
            flaperonPosLeft.setTranslation(0,22*getprop("surface-positions/left-aileron-pos-norm"));
        }
    },
    update: func()
    {
        rudderPos.setTranslation(130*getprop("surface-positions/rudder-pos-norm"),0);
        elevPosLeft.setTranslation(0,62*getprop("surface-positions/elevator-pos-norm"));
        elevPosRight.setTranslation(0,62*getprop("surface-positions/elevator-pos-norm"));
        elevatorTrim.setText(sprintf("%3.2f",getprop("surface-positions/stabilizer-pos-norm")));

        me.updateFlaperons();
        me.updateAll();
    },
};
