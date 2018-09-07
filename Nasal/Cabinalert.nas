var CabinalertTimer = maketimer(5, func(){
var SeatBeltknob = getprop("/controls/cabin/SeatBelt-knob");
var IndAltFt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
var NoSmokeknob = getprop("/controls/cabin/NoSmoking-knob");
var Flapstatus = getprop("/controls/flight/flaps");
var Gearstatus = getprop("/controls/gear/gear-down");
var SeatbeltStatus = getprop("/controls/cabin/SeatBelt-status");
var NoSmokeStatus = getprop("/controls/cabin/NoSmoking-status");

if(SeatBeltknob==0){
if((IndAltFt<10300) or (!Flapstatus==0) or (Gearstatus==1)){
SeatbeltStatus = 1;
}else{
SeatbeltStatus = -1;
}
}else{
SeatbeltStatus=SeatBeltknob;
}

if(NoSmokeknob==0){
if(Gearstatus==1){
NoSmokeStatus = 1;
}else{
NoSmokeStatus = -1;
}
}else{
NoSmokeStatus=NoSmokeknob;
}

setprop("/controls/cabin/SeatBelt-status", SeatbeltStatus);
setprop("/controls/cabin/NoSmoking-status", NoSmokeStatus);
CabinalertTimer.restart(5)
});

var CabinalertSystem = func{
CabinalertTimer.singleShot = 1;
CabinalertTimer.restart(0.01);
};

var CabinalertStartup = func{
CabinalertTimer.start();
};

setlistener("/sim/signals/fdm-initialized", CabinalertStartup);
setlistener("/controls/cabin/SeatBelt-knob", CabinalertSystem);
setlistener("/controls/cabin/NoSmoking-knob", CabinalertSystem);
setlistener("/controls/flight/flaps", CabinalertSystem);
setlistener("/controls/gear/gear-down", CabinalertSystem);

