# FG // Project Boeing 777 Seattle
# EFB - Main Program
#
# Version 01, Jun 2014
# I-NEMO
#
#__________________________________________________________________________________________
# Here we include the EFB Pages' DataBase
io.include("EFB_Pages.db");
# Here we include the EFB Applications' DataBase
io.include("EFB_Applications.db");    
# Here we include the EFB Chart's DataBase
io.include("EFB_Charts.db");
# Here we include the EFB Conversion Factor's DataBase
io.include("EFB_CNV_Factors.db");
#

var Text_Line_L = [];
var Text_Line_R = [];
var PAGE = "EFB_INIT";
var SUB_PAGE = "";
var GOTO = "";

var l0 = "";
var l1 = "";
var l2 = "";
var l3 = "";
var l4 = "";
var l5 = "";
var l6 = "";
var l7 = "";
var l8 = "";
var l9 = "";
var l10 = "";
var l11 = "";
var l12 = "";
var l13 = "";
var l14 = "";
var l15 = "";
var l16 = "";
var l17 = "";
var l18 = "";
var l19 = "";
var l20 = "";

var r1 = "";
var r2 = "";
var r3 = "";
var r4 = "";
var r5 = "";
var r6 = "";
var r7 = "";
var r8 = "";
var r9 = "";
var r10 = "";
var r11 = "";
var r12 = "";
var r13 = "";
var r14 = "";
var r15 = "";
var r16 = "";
var r17 = "";
var r18 = "";
var r19 = "";
var r20 = "";

var KCl0_0 = "";
var KCl0_1 = "";
var KCl0 = "";
var KCl1 = "";
var KCl2 = "";
var KCl3 = "";
var KCl4 = "";

var KCr1 = "";
var KCr2 = "";
var KCr3 = "";
var KCr4 = "";
var KCr5 = "";
var KCr6 = "";

var helper = "";
var keypress = "";
var lastlog = "";
var lastn = 0;
var hist1 = "";
var hist2 = "";
var hist3 = "";
var hist4 = "";
var hist5 = "";
var hist6 = "";
var Chart_Searchable = 1;
var ZoomFact = 0;
var PanHFact = 0;
var PanVFact = 0;

var ChartSelection = [];
var ChartName = [];
var ChartDisp = [];

var AptIcao = "Unknown";
var AptIcao_Searched = "Unknown";
var FlightStatus = 0;
var OriginApt = "NOT Set";
var DestinationApt = "NOT Set";
var OriginStatusFlag = 0;
var DestinationStatusFlag = 0;
var ClosingFlightFlag = 0;

var ClosestName = "";
var lenght = 0;
var Temp_String = "";
var Cnv_Fact = 0;
var VK_Key = "";
var VK_Input_Mem = 0;
var VK_Output_Mem = 0;
var TMZ_Input_Lenght = 0;
var TMZ_Converted_ID = "";
var TMZ_Converted_Name = "";
var TMZ_Converted_OffSet = "";
var TMZ_zulu_HH = "";
var TMZ_Index = 0;
var TMZ_DB_Size = 0;
var TMZ_Index_Direction = 0;
var Output_TMZ_Line = "";
var TMZ_DATE = "";
var TMZ_TIME = "";
var Output_HH = 0;
var Output_MM = 0;
var Keyboard_Helper = "";
var Keyboard_Message = "";

var CUT = ["NULL", "NULL", "NULL"];
var Initial_FL = 0;
var Target_FL = 0;
var Initial_GS = 0;
var Target_GS = 0;
var DRC_Distance = 0;
var DRC_l3 = "";
var DRC_r3 = "";
var DRC_l5 = "";
var DRC_r5 = "";
var DRC_l7 = "";
var DRC_r8 = "";
var DRC_r9 = "";
var DRC_r10 ="";
DRC_String = "";
DRC_Input_Lenght = 0;

var Index_Max = 0;
var Index_Offset = 0;
var Chart_Pages = 1;
var PageList = 0;
var Page_Memory = 0;
var PageShow = "0/0";
var Chart_Selected ="";
var AptIcao_Searched = "Unknown";
var Chart_Type = "APT";
var TestChart = 0;


var fuelrequired = 0;
var fuelrecommended = 0;

#__________________________________________
#  Initialize CANVAS |
#__________________________________________|

var EFB_canvas = canvas.new({
		"name": "EFB",  		# The name is optional but allow for easier identification
		"size": [1024, 1024], 	# Size of the underlying texture (should be a power of 2, required) [Resolution]
		"view": [511, 695],  	# Virtual resolution (Defines the coordinate system of the canvas [Dimensions]
								# which will be stretched the size of the texture, required)
		"mipmapping": 1,       	# Enable mipmapping (optional)
	});

EFB_canvas.addPlacement({"node": "Display"});

# Creates the Text-Matrix Canvas Group element and set some values
var EFB_group = EFB_canvas.createGroup();
# Creates the Text-Matrix Canvas Elements
# Creates Text Rows 
var Text_Line_Size = 16; 								# Number of EFB's rows
setsize(Text_Line_L, Text_Line_Size);
setsize(Text_Line_R, Text_Line_Size);
var xpos_L = 22.0;
var xpos_R = 487.0;
var ypos = 87.5;
for(var i = 0; i < (Text_Line_Size - 1); i += 1)
{
	Text_Line_ID = "L_" ~ i;
	Text_Line_L[i] = EFB_group.createChild("text", Text_Line_ID)
					.setTranslation(xpos_L,ypos)     	# x-left-position, y-position
					.setAlignment("left-center") 	
					.setFont("Helvetica.txf") 		
					.setFontSize(32,1)    	    	
					.setColor(1,1,1)            	
					.set("z-index",10)
					.setText("TEST");
	Text_Line_ID = "R_" ~ i;
	Text_Line_R[i] = EFB_group.createChild("text", Text_Line_ID)
					.setTranslation(xpos_R,ypos)     	# x-right-position, y-position
					.setAlignment("right-center") 	
					.setFont("Helvetica.txf") 		
					.setFontSize(32,1)    	    	
					.setColor(1,1,1)            	
					.set("z-index",10)
					.setText("TEST");					
	Text_Line_L[i].hide();
	Text_Line_R[i].hide();
	ypos = ypos + 40.5;
}
# Creates Title
var Title = EFB_group.createChild("text", "Title")
					.setTranslation(255.5,27.1)     	# x-left-position, y-position
					.setAlignment("center-center") 	
					.setFont("Helvetica.txf") 		
					.setFontSize(32,1)    	    	
					.setColor(1,1,1)            	
					.set("z-index",10)
					.setText("TITLE TEST");
Title.hide();
# Creates Helper
var Helper = EFB_group.createChild("text", "Helper")
					.setTranslation(255.5,654.5)     	# x-left-position, y-position
					.setAlignment("center-center") 	
					.setFont("Helvetica.txf") 		
					.setFontSize(32,1)    	    	
					.setColor(0,1,0)            	
					.set("z-index",10)
					.setText("HELPER TEST");
Helper.hide();
# Creates Screen					
var screen = EFB_group.createChild("image")
				.setFile("Models/Instruments/EFB/Displays/Initialize_0.jpg")
				.setSize(511,695)
				.setTranslation(0,0);

# canvas.parsesvg(EFB_group, "Models/Instruments/EFB/Displays/Main_Menu.svg");
				
#________________________________
#  Initialize some Chart vectors |
#________________________________|

var ChartSelection_Size = 30;
setsize(ChartSelection, ChartSelection_Size);

    forindex(var i; ChartSelection) 
		ChartSelection[i] = "NULL";
				
var ChartName_Size = 30;
setsize(ChartName, ChartName_Size);

    forindex(var i; ChartName) 
		ChartName[i] = "NULL";
		
var ChartDisp_Size = 3;
setsize(ChartDisp, ChartDisp_Size);

    forindex(var i; ChartDisp) 
		ChartDisp[i] = "NULL";
#___________________
#  Chart Properties |
#___________________|

setprop("/instrumentation/gps/scratch/ident", getprop("/sim/airport/closest-airport-id"));

# AptIcao = sprintf("%s", getprop("/instrumentation/efb/chart/icao"));

if (getprop("/instrumentation/gps/scratch/ident") != nil) { setprop("/instrumentation/efb/chart/icao", sprintf("%s", getprop("/instrumentation/gps/scratch/ident")));
setprop("instrumentation/efb/chart/DEP_icao", sprintf("%s", getprop("/instrumentation/efb/chart/icao")));
} else setprop("/instrumentation/efb/chart/icao", "");

setprop("/instrumentation/efb/chart/type", "APT");
setprop("/instrumentation/efb/chart/newairport", 0);
setprop("/instrumentation/efb/FlightStatus", 0);        # INACTIVE

Chart_Searchable = 0;
setprop("/instrumentation/efb/page", "EFB_INIT");		#
setprop("/instrumentation/efb/keypress", "l8"); 		# <--- This is just to start from EFB Initialization Screen
PAGE = "EFB_INIT";										#

var efb = {
    init : func {
        me.UPDATE_INTERVAL = 0.05;
        me.loopid = 0;

#_____________
# INITIALIZE  |
#_____________|


# Chart Section Stuff

setprop("/instrumentation/efb/chart/type", "APT");
setprop("/instrumentation/efb/chart/selected", "APT_0");
setprop("/instrumentation/efb/VK_keypress", "");
setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", "");
setprop("/instrumentation/efb/chart/rotation", 0);
setprop("/instrumentation/efb/diagram/rotation", 0);


AptIcao = sprintf("%s", getprop("/instrumentation/efb/chart/icao"));
AptIcao = ChartsList[AptIcao];

# Various Stuff

setprop("/instrumentation/efb/manual-page", 0);

setprop("/instrumentation/efb/vnav_autogen/first", 0);
setprop("/instrumentation/efb/vnav_autogen/gen", 0);
TMZ_DB_Size = getprop("/instrumentation/efb/TimeZonesDB/TMZ_DB_Size") - 1;
setprop("/instrumentation/efb/chart/PageList", 1);


        me.reset();
},
    searchairport : func(query) {

    setprop("/instrumentation/gps/scratch/query", query);
    setprop("/instrumentation/gps/scratch/type", "airport");

    setprop("/instrumentation/gps/command", "search");

setprop("/instrumentation/efb/selected-rwy/id", "");

},
    searchcomms : func(query) {

    setprop("/sim/gui/dialogs/scratch/airports/selected-airport/id", query);
#   setprop("/sim/gui/dialogs/airports/scratch/type", "airport");

    setprop("/sim/gui/dialogs/scratch/airports/mode", "search");

# setprop("/instrumentation/efb/selected-rwy/id", "");

},
    searchcharts : func(chart) { setprop("/sim/model/efb/chart", "Charts/" ~ chart ~ ".jpg");
},

	Page_Set : func (keypress, PAGE) {
	
		page.Reset_Text_Matrix();
		GOTO = pages[PAGE][keypress].action;
		SUB_PAGE = pages[PAGE][keypress].subpage_label;
		setprop("/instrumentation/efb/page", SUB_PAGE);
		printf("Test> GOTO = %s", GOTO);
		printf("Test> SUB_PAGE = %s", SUB_PAGE);
		screen.setFile(GOTO).show();
		if (pages[PAGE][keypress].launch != "NULL") {
			printf("Test> Function Detected = %s", pages[PAGE][keypress].launch);
			Page_Functions[pages[PAGE][keypress].launch]();
		};		
		printf("Test> PAGE = %s", SUB_PAGE);
		PAGE = SUB_PAGE;
		if (PAGE == "NULL") {setprop("sim/sound/click10", 1)} else {setprop("sim/sound/click10", 0)}; # Plays Warning sound
		keypress ="";
		return PAGE;
	},
	
    Page_Update : func { # MAIN Section

var keypress = getprop("/instrumentation/efb/keypress");


if (getprop("/instrumentation/efb/page") != "") {

# Make sure we know the APT's ICAO

    setprop("/instrumentation/gps/scratch/ident", getprop("/sim/airport/closest-airport-id"));

    if (getprop("/instrumentation/gps/scratch/ident") != nil) setprop("/instrumentation/efb/chart/icao", sprintf("%s", getprop("/instrumentation/gps/scratch/ident")));
    else setprop("/instrumentation/efb/chart/icao", "");
    AptIcao = sprintf("%s", getprop("/instrumentation/efb/chart/icao"));

    page.clearpage();
    page.index();

# Canvas Display's Test
# screen.show();
# Title.show();
# for(var i = 0; i < (Text_Line_Size - 1); i += 1)
#	{
#		Text_Line_L[i].setText("Hello World!").show();	
#		Text_Line_R[i].setText("Hello World!").show();	
#	}
# Helper.show();

#__________________________________________________________________________________________
# MAIN MENU Section Parser ----------------------------------------------------------------|
#__________________________________________________________________________________________|


if ((keypress != "") and (keypress != "l1")) 
	{ 	
		printf("Test> PAGE_LAUNCH = %s", PAGE);	
		efb.Page_Set(keypress, PAGE);
		PAGE = getprop("/instrumentation/efb/page");
		printf("Test> PAGE_RETURNED = %s", PAGE);			
#		GOTO = pages[PAGE][keypress].action;
#		SUB_PAGE = pages[PAGE][keypress].subpage_label;
#		setprop("/instrumentation/efb/page", SUB_PAGE);
#		printf("TestGOTO = %s", GOTO);
#		screen.setFile(GOTO).show();
#		PAGE = SUB_PAGE;
#		keypress = "";
	}
# if (keypress == "MENU") { GOTO = pages["Main_Menu"]["MENU"].action;
# setprop("/sim/model/efb/page", "Displays/Main_Menu.jpg");
# keypress = "";

if (keypress == "l1") { setprop("/instrumentation/efb/page", "CHARTS");
setprop("/instrumentation/efb/chart/chartmenu", 0);
setprop("/instrumentation/efb/chart/zoom-in", 0);
ZoomFact = 0;
PanHFact = 0;
PanVFact = 0;
keypress = "";
}

#__________________________________________________________________________________________
# CHART SECTION Parser --------------------------------------------------------------------|
#__________________________________________________________________________________________|

} elsif (getprop("/instrumentation/efb/page") == "CHARTS") {

    page.clearpage();

# setprop("/sim/model/efb/chart", "Displays/Help_1.jpg");
setprop("/instrumentation/efb/diagram/rotation", 0);
setprop("/instrumentation/efb/diagram/chartmenu", 0);
setprop("/instrumentation/efb/chartsDB", "Charts/");

#   helper = "";

# NOTE: this gives the Airport's name to be used on the bottom line of the Chart Display) has still to be checked: if RouteManager is not selected from the upper MENU, the property is not active...

# AptIcao = sprintf("%s", getprop("/instrumentation/efb/chart/icao"));
# AptIcao = ChartsList[AptIcao].ICAO;

             #_____________________________
############## Chart Selection at Airport  |
             #_____________________________|


# Checks existence of Charts in the DB

if(ChartsList[AptIcao] == nil) { setprop("/instrumentation/efb/chart_Found", "NOT_FOUND");
Chart_Searchable = 0;
} else { setprop("/instrumentation/efb/chart_Found", "FOUND");
Chart_Searchable = 1;
}

if (Chart_Searchable == 1) { 

#				foreach(var Testindex; ChartsList[AptIcao][Chart_Type])
#						 {
#							 printf("Test foreach = %s", Testindex);
#							 if (Testindex == getprop("/instrumentation/efb/chart/selected")) { TestChart == 1;
#							 } else TestChart == 0;
#						 }

				page.update();

				if (getprop("/instrumentation/efb/chart/type") == "APT") { l0 = "AIRPORT MAP";
				} else l0 = "";
					
				l20 = AptIcao;

				efb.searchcharts(AptIcao ~ "/" ~ getprop("/instrumentation/efb/chart/type") ~ "/" ~ getprop("/instrumentation/efb/chart/selected"));

				setprop("/sim/model/efb/chart", getprop("/sim/model/efb/chart"));
				setprop("/sim/model/efb/chart_BKUP", getprop("/sim/model/efb/chart"));
				setprop("/sim/model/efb/Chart_2", getprop("/sim/model/efb/chart_BKUP"));
				setprop("/sim/model/efb/Chart_4", getprop("/sim/model/efb/chart_BKUP"));

				setprop("/sim/model/efb/Ovlay_1", "Displays/drawing.png");
				if (getprop("/instrumentation/efb/chart/chartmenu") == 0) setprop("/sim/model/efb/Ovlay_1", "Displays/drawing.png");
				if (getprop("/instrumentation/efb/chart/chartmenu") == 1) setprop("/sim/model/efb/Ovlay_1", "Displays/drawing2.png");
				} else { setprop("/sim/model/efb/chart", "Displays/NoCharts.jpg"); # Chart_Searchable == 0, then displays "Chart Not Found for Apt XYWZ"
					setprop("/sim/model/efb/Ovlay_1", "Displays/drawingNULL.png");
					helper = "Airport:    " ~ AptIcao;
				}

# Handles the Zoom-In and Zoom-Out EFB buttons on Charts Display; available ZoomFact is 2x and 4x only.

if ((ZoomFact >= 0) and (ZoomFact <= 4)) {
        if ((keypress == "Zin") and (Chart_Searchable == 1)) { ZoomFact = ZoomFact + 2;
        setprop("/instrumentation/efb/chart/zoom-in", ZoomFact);
        keypress = "";
        }
        if ((keypress == "Zout") and (Chart_Searchable == 1) and (ZoomFact > 0)) { ZoomFact = ZoomFact - 2;
        setprop("/instrumentation/efb/chart/zoom-in", ZoomFact);
        keypress = "";
        }
}

if (ZoomFact == 0) setprop("/instrumentation/efb/chart/zoom-in", 0);

# Handles the Pan-Right, Pan_Left, ScrollUP and ScrollDN EFB buttons on Charts Display; Pan Horizontal Factor is 100; Pan Vertical Factor is 100.

if ((ZoomFact == 2) or (ZoomFact == 4)) {
        if ((keypress == "Move_R") and (Chart_Searchable == 1)) { PanHFact = PanHFact + 100;
        setprop("/instrumentation/efb/chart/panH", PanHFact);
        keypress = "";
        }
        if ((keypress == "Move_L") and (Chart_Searchable == 1)) { PanHFact = PanHFact - 100;
        setprop("/instrumentation/efb/chart/panH", PanHFact);
        keypress = "";
        }
        if ((keypress == "ScrollUP") and (Chart_Searchable == 1)) { PanVFact = PanVFact + 100;
        setprop("/instrumentation/efb/chart/panV", PanVFact);
        keypress = "";
        }
        if ((keypress == "ScrollDN") and (Chart_Searchable == 1)) { PanVFact = PanVFact - 100;
        setprop("/instrumentation/efb/chart/panV", PanVFact);
        keypress = "";
        }
} elsif (ZoomFact == 0) { setprop("/instrumentation/efb/chart/panH", -PanHFact);
setprop("/instrumentation/efb/chart/panV", -PanVFact);
}

# Handles Chart Rotation counter-clockwise

if ((keypress == "l2") and (Chart_Searchable == 1) and (getprop("/instrumentation/efb/chart/chartmenu")) == 0) toggle("/instrumentation/efb/chart/rotation");

# Toggles Overlay Menu On/OFF

if ((keypress == "r8")  and (Chart_Searchable == 1)) toggle("/instrumentation/efb/chart/chartmenu");

# Calls Virtual Keyboard for Chart DB Selection by the Pilot

if (keypress == "l5") { setprop("/instrumentation/efb/page", "CHARTS_KEYBOARD");
    setprop("/instrumentation/efb/chart/zoom-in", 0);
    setprop("/instrumentation/efb/VKDRC_keypress", "");
    setprop("/instrumentation/efb/VK_Keyboard/Input_String", "");
    setprop("/instrumentation/efb/chart/Searchable", 0);
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/Main_Menu.jpg");
setprop("/instrumentation/efb/chart/zoom-in", 0);
ZoomFact = 0;
PanHFact = -PanHFact;
PanVFact = -PanVFact;
setprop("/instrumentation/efb/page", "MENU");
keypress = "";
}
#__________________________________________________________________________________________
#  CHART SECTION Parser -------------------------------------------------------------------|
#__________________________________________________________________________________________|

} elsif (getprop("/instrumentation/efb/page") == "CHARTS_KEYBOARD") {

    page.clearpage();
    page.update();
    page.charts_keyboard();

if (Chart_Searchable == 1) { setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", "Enter ICAO");
}

# Get the ICAO to be searched for; "Virtual Keyboard" Keys Parser

 if ((getprop("/instrumentation/efb/VKDRC_keypress") != "") and (getprop("/instrumentation/efb/VKDRC_keypress") != "SYMB") and (getprop("/instrumentation/efb/VKDRC_keypress") != "SHIFT")) {

        setprop("/instrumentation/efb/VK_Keyboard/Input_String", getprop("/instrumentation/efb/VK_Keyboard/Input_String") ~ getprop("/instrumentation/efb/VKDRC_keypress"));    # Build the Input String

        if (getprop("/instrumentation/efb/VKDRC_keypress") == "CLEAR") { setprop("/instrumentation/efb/VK_Keyboard/Input_String", "");                                          # CLEARs the whole Input Field and other stuff
        }
        if (getprop("/instrumentation/efb/VKDRC_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/VK_Keyboard/Input_String");                                 # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/VK_Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VKDRC_keypress", "");
        }
}
    setprop("/instrumentation/efb/VKDRC_keypress", "");

    TMZ_String = getprop("/instrumentation/efb/VK_Keyboard/Input_String");
    TMZ_Input_Lenght = size(TMZ_String);

        if (TMZ_Input_Lenght <= 3)  { setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", getprop("/instrumentation/efb/VK_Keyboard/Input_String"));                      # Print it to the Keyboard Input Field

        } else { setprop("/instrumentation/efb/chart/Searchable", 1);
                setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", "Press [Search IDENT] to search for: " ~ getprop("/instrumentation/efb/VK_Keyboard/Input_String"));
        }
        if ((getprop("/instrumentation/efb/chart/Searchable") == 1) and (keypress == "l3")) { # do SEARCH CHART
			AptIcao = getprop("/instrumentation/efb/VK_Keyboard/Input_String");
			page.charts_keyboard();
			AptIcao = AptIcao_Searched;
			setprop("/instrumentation/efb/VKDRC_keypress", "");
			setprop("/instrumentation/efb/chart/Searchable", 0);
			setprop("/instrumentation/efb/VK_Keyboard/Input_String", "");
        }
    if ((keypress == "PGDN") and (getprop("/instrumentation/efb/chart/PageList") < Chart_Pages)) {
    setprop("/instrumentation/efb/chart/SetPage", "INCREASE");
    setprop("/instrumentation/efb/chart/PageList", getprop("/instrumentation/efb/chart/PageList") + 1);
    }
    if ((keypress == "PGUP") and (getprop("/instrumentation/efb/chart/PageList") > 1)) {
    setprop("/instrumentation/efb/chart/SetPage", "DECREASE");
    setprop("/instrumentation/efb/chart/PageList", getprop("/instrumentation/efb/chart/PageList") - 1);
    }

# Chart Selection - redirection to CHARTS...___________________________________________________________________________________

    if (keypress == "r1") { setprop("/instrumentation/efb/chart/selected", getprop("/instrumentation/efb/chart/Selection_0"));
	setprop("/instrumentation/efb/chart/PageList", 1);
	setprop("/sim/model/efb/chart", "Displays/Loading.jpg");	
    keypress = "MENU";
    }
    if (keypress == "r2") { setprop("/instrumentation/efb/chart/selected", getprop("/instrumentation/efb/chart/Selection_1"));
	setprop("/instrumentation/efb/chart/PageList", 1);
	setprop("/sim/model/efb/chart", "Displays/Loading.jpg");	
    keypress = "MENU";
    }
    if (keypress == "r3") { setprop("/instrumentation/efb/chart/selected", getprop("/instrumentation/efb/chart/Selection_2"));
	setprop("/instrumentation/efb/chart/PageList", 1);
	setprop("/sim/model/efb/chart", "Displays/Loading.jpg");	
    keypress = "MENU";
    }
# _____________________________________________________________________________________________________________________________

    if (keypress == "MENU") { # setprop("/sim/model/efb/page", "Displays/Blank_Test.jpg");
    setprop("/instrumentation/efb/chart/Status", "OFF");
    setprop("/instrumentation/efb/VK_Chart_Type", "APT"); # This starts and re-starts the Chart_Keyboard with active ICAO/APT Chart displayed ! (see B777 EFB Manual)
    Page_Memory = 1;
    setprop("/instrumentation/efb/VK_Keyboard/Input_String", "");
	setprop("/instrumentation/efb/chart/PageList", 1);
    setprop("/instrumentation/efb/page", "CHARTS");
        page.KCclearpage();
        page.KCupdate();
    keypress = "";
}
#__________________________________________________________________________________________
#  INITIALIZE SECTION Parser --------------------------------------------------------------|
#__________________________________________________________________________________________|

} elsif (getprop("/instrumentation/efb/page") == "INITIALIZE") {

    page.clearpage();

    if (getprop("/instrumentation/efb/FlightStatus") == 0) {
    if (getprop("/autopilot/route-manager/departure/airport") != "") {
        OriginApt = getprop("/autopilot/route-manager/departure/airport");
    } else {
        OriginApt = "NOT Set";
    }
    if (getprop("/autopilot/route-manager/destination/airport") != "") {
        DestinationApt= getprop("/autopilot/route-manager/destination/airport");
    } else {
        DestinationApt = "NOT Set";
    }

    if ((OriginApt != "NOT Set") and (DestinationApt != "NOT Set")) {
        OriginApt = getprop("/autopilot/route-manager/departure/airport");
        DestinationApt = getprop("/autopilot/route-manager/destination/airport");
        setprop("/sim/model/efb/page", "Displays/Initialize_1.jpg");
        ClosingFlightFlag = 1; # Flight INITIABLE

    } else {
            setprop("/sim/model/efb/page", "Displays/Initialize_2.jpg");
            setprop("/instrumentation/efb/FlightStatus", 0);
            ClosingFlightFlag = 0; # Flight NOT INITIABLE
    }

    } elsif ((getprop("/instrumentation/efb/FlightStatus") == 1) and (ClosingFlightFlag == 2)) {
            setprop("/instrumentation/efb/FlightStatus", 1); # Flight ACTIVE and CLOSABLE
            FlightStatus = 1;
            setprop("/sim/model/efb/page", "Displays/Initialize_3.jpg");
    }
            INITl4 = OriginApt;
            INITl5 = DestinationApt;
            setprop("/instrumentation/efb/display/INITline4-l", INITl4);
            setprop("/instrumentation/efb/display/INITline5-l", INITl5);
if ((keypress == "r8") and (ClosingFlightFlag == 1)) { setprop("/instrumentation/efb/FlightStatus", 1); # Flight INITIATED
ClosingFlightFlag = 2; # Flight CLOSABLE
keypress = "";
}
if ((keypress == "r8") and (FlightStatus == 1)) { setprop("/instrumentation/efb/FlightStatus", 0); # Flight NOT ACTIVE
setprop("/sim/model/efb/page", "Displays/Initialize_5.jpg");
FlightStatus = 0;
ClosingFlightFlag = 0; # Flight CLOSED
keypress = "";
}
if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/Main_Menu.jpg");
setprop("/instrumentation/efb/page", "MENU");
keypress = "";

INITl4 = "";
INITl5 = "";
        setprop("/instrumentation/efb/display/INITline4-l", INITl4);
        setprop("/instrumentation/efb/display/INITline5-l", INITl5);
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES SECTION Parser ----------------------------------------------------------|
#__________________________________________________________________________________________|

} elsif (getprop("/instrumentation/efb/page") == "UTILITIES") {

    page.clearpage();
    setprop("/instrumentation/efb/Keyboard/Input_String", "");
    setprop("/instrumentation/efb/Keyboard/Input_Line", "");
    setprop("/instrumentation/efb/Keyboard/Input_Line2", "");
    setprop("/instrumentation/efb/Keyboard/Input_Line3", "");
    setprop("/instrumentation/efb/VK_keypress", "");

    if (keypress == "l3") {
    setprop("/instrumentation/efb/page", "UTILITIES_DESC_RATE");
    setprop("/sim/model/efb/page", "Displays/PU_DRC.jpg");
    setprop("/instrumentation/efb/Keyboard/Input_String", "");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/Input_Unit", "NO_INPUT");
    setprop("/instrumentation/efb/DRC_Initial_FL", "300");
    setprop("/instrumentation/efb/DRC_Target_FL", "30");
    setprop("/instrumentation/efb/DRC_Initial_GS", "250");
    setprop("/instrumentation/efb/DRC_Target_GS", "200");
    setprop("/instrumentation/efb/DRC_Distance", "50");
    setprop("/instrumentation/efb/DRC_Initial_FL_MEM", getprop("/instrumentation/efb/DRC_Initial_FL"));
    setprop("/instrumentation/efb/DRC_Target_FL_MEM", getprop("/instrumentation/efb/DRC_Target_FL"));
    setprop("/instrumentation/efb/DRC_Initial_GS_MEM", getprop("/instrumentation/efb/DRC_Initial_GS"));
    setprop("/instrumentation/efb/DRC_Target_GS_MEM", getprop("/instrumentation/efb/DRC_Target_GS"));
    setprop("/instrumentation/efb/DRC_Distance_MEM", getprop("/instrumentation/efb/DRC_Distance"));
    VK_Key = "";
#   setprop("/instrumentation/efb/VK_DRC_MarkerL", 1);
    Initial_FL = 300;
    Target_FL = 30;
    Initial_GS = 250;
    Target_GS = 200;
    DRC_Distance = 50;
    keypress = "";
    }
    if (keypress == "l4") {
    setprop("/instrumentation/efb/page", "GPS POSITION");
    }
    if (keypress == "r1") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_SPD");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Spd.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    VK_Input_Mem = 0;
    VK_Output_Mem = 0;
    }
    if (keypress == "r2") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_LNG");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Lng.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    VK_Input_Mem = 0;
    VK_Output_Mem = 0;
    }
    if (keypress == "r3") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_WGT");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Wgt.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    VK_Input_Mem = 0;
    VK_Output_Mem = 0;
    }
    if (keypress == "r4") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_TMP");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Tmp.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    VK_Input_Mem = 0;
    VK_Output_Mem = 0;
    }
    if (keypress == "r5") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_VLM");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Vlm.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    VK_Input_Mem = 0;
    VK_Output_Mem = 0;
    }
    if (keypress == "r6") {
    setprop("/instrumentation/efb/page", "UTILITIES_CNV_TMZ");
    setprop("/sim/model/efb/page", "Displays/PU_Cnv_Tmz.jpg");
    setprop("/instrumentation/efb/VK_keypress", "");
    setprop("/instrumentation/efb/VK_IN_Marker", 1);
    setprop("/instrumentation/efb/VK_OUT_Marker", 1);
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/Keyboard/Input_HH", "--");
    setprop("/instrumentation/efb/Keyboard/Input_MM", "--");
    setprop("/instrumentation/efb/Keyboard/Output_HH", "");
    setprop("/instrumentation/efb/Keyboard/Output_MM", "");
    setprop("/instrumentation/efb/page/Cnv_Fact", "0");
    TMZ_String = "";
    TMZ_Index = 0;

#   Parsing for Month's names

    TMZ_DATE = substr(getprop("environment/metar/data"), 5, 5);

    if (substr(TMZ_DATE, 0, 2) == "01") { TMZ_DATE = "JAN" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "02") { TMZ_DATE = "FEB" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "03") { TMZ_DATE = "MAR" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "04") { TMZ_DATE = "APR" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "05") { TMZ_DATE = "MAY" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "06") { TMZ_DATE = "JUN" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "07") { TMZ_DATE = "JUL" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "08") { TMZ_DATE = "AUG" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "09") { TMZ_DATE = "SEP" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "10") { TMZ_DATE = "OCT" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "11") { TMZ_DATE = "NOV" ~ substr(TMZ_DATE, 2, 3);
    }
    if (substr(TMZ_DATE, 0, 2) == "12") { TMZ_DATE = "DEC" ~ substr(TMZ_DATE, 2, 3);
    }

    }
if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/Main_Menu.jpg");
setprop("/instrumentation/efb/page", "MENU");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - SPEED CONVERSION Parser -----------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_SPD") {

Input_Unit = getprop("/instrumentation/efb/VK_IN_Marker");
Output_Unit = getprop("/instrumentation/efb/VK_OUT_Marker");

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "" or (Input_Unit != VK_Input_Mem) or (Output_Unit != VK_Output_Mem)) {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                    # CLEARs the whole Input Field
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                           # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                          # CHANGEs SIGN to the Input Field
            if (substr(Temp_String, 0, 1) == "-") { lenght = size(Temp_String) - 1;
            Temp_String = substr(Temp_String, 1, lenght);
            } else { Temp_String = "-" ~ Temp_String;
            }
        setprop("/instrumentation/efb/Keyboard/Input_String", Temp_String);
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display

        setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress")); # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Input_Line", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                 # Print it to the Keyboard Input Field

# ---------------> Conversion Table Selection

		Input_Unit = "Input_Unit" ~ "_" ~ Input_Unit;
		Cnv_Fact = Speed_CNV_Factors[Input_Unit][Output_Unit-1];
		
        VK_Input_Mem = Input_Unit;
        VK_Output_Mem = Output_Unit;

# Output Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_Line") == "") or (getprop("/instrumentation/efb/Keyboard/Input_Line") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_Line") == "-")) { setprop("/instrumentation/efb/Keyboard/Output_Line", "");
        } else { Output_Line = getprop("/instrumentation/efb/Keyboard/Input_Line");
        Output_Line = Output_Line * Cnv_Fact;                                       # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Output_Line", Output_Line);          # Print it to the Keyboard Output Field
        }
        setprop("/instrumentation/efb/VK_keypress", "");
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Input_Line", "");
setprop("/instrumentation/efb/Keyboard/Output_Line", "");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - LENGHT CONVERSION Parser ----------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_LNG") {

Input_Unit = getprop("/instrumentation/efb/VK_IN_Marker");
Output_Unit = getprop("/instrumentation/efb/VK_OUT_Marker");

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "" or (Input_Unit != VK_Input_Mem) or (Output_Unit != VK_Output_Mem)) {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                    # CLEARs the whole Input Field
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                           # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                          # CHANGEs SIGN to the Input Field
            if (substr(Temp_String, 0, 1) == "-") { lenght = size(Temp_String) - 1;
            Temp_String = substr(Temp_String, 1, lenght);
            } else { Temp_String = "-" ~ Temp_String;
            }
        setprop("/instrumentation/efb/Keyboard/Input_String", Temp_String);
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display

        setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress")); # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Input_Line", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                 # Print it to the Keyboard Input Field

# ---------------> Conversion Table Selection

		Input_Unit = "Input_Unit" ~ "_" ~ Input_Unit;
		Cnv_Fact = Lenght_CNV_Factors[Input_Unit][Output_Unit-1];
		
        VK_Input_Mem = Input_Unit;
        VK_Output_Mem = Output_Unit;

# Output Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_Line") == "") or (getprop("/instrumentation/efb/Keyboard/Input_Line") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_Line") == "-")) { setprop("/instrumentation/efb/Keyboard/Output_Line", "");
        } else { Output_Line = getprop("/instrumentation/efb/Keyboard/Input_Line");
        Output_Line = Output_Line * Cnv_Fact;                                       # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Output_Line", Output_Line);          # Print it to the Keyboard Output Field
        }
        setprop("/instrumentation/efb/VK_keypress", "");
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Input_Line", "");
setprop("/instrumentation/efb/Keyboard/Output_Line", "");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - WEIGHT CONVERSION Parser ----------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_WGT") {

Input_Unit = getprop("/instrumentation/efb/VK_IN_Marker");
Output_Unit = getprop("/instrumentation/efb/VK_OUT_Marker");

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "" or (Input_Unit != VK_Input_Mem) or (Output_Unit != VK_Output_Mem)) {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                    # CLEARs the whole Input Field
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                           # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                          # CHANGEs SIGN to the Input Field
            if (substr(Temp_String, 0, 1) == "-") { lenght = size(Temp_String) - 1;
            Temp_String = substr(Temp_String, 1, lenght);
            } else { Temp_String = "-" ~ Temp_String;
            }
        setprop("/instrumentation/efb/Keyboard/Input_String", Temp_String);
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display
        setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress")); # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Input_Line2", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                # Print it to the Keyboard Input Field

# ---------------> Conversion Table Selection

		Input_Unit = "Input_Unit" ~ "_" ~ Input_Unit;
		Cnv_Fact = Lenght_CNV_Factors[Input_Unit][Output_Unit-1];

        VK_Input_Mem = Input_Unit;
        VK_Output_Mem = Output_Unit;

# Output Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_Line2") == "") or (getprop("/instrumentation/efb/Keyboard/Input_Line2") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_Line2") == "-")) { setprop("/instrumentation/efb/Keyboard/Output_Line2", "");
        } else { Output_Line2 = getprop("/instrumentation/efb/Keyboard/Input_Line2");
        Output_Line2 = Output_Line2 * Cnv_Fact;                                     # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Output_Line2", Output_Line2);        # Print it to the Keyboard Output Field
        }
        setprop("/instrumentation/efb/VK_keypress", "");
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Input_Line2", "");
setprop("/instrumentation/efb/Keyboard/Output_Line2", "");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - TEMPERATURE CONVERSION Parser -----------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_TMP") {

Input_Unit = getprop("/instrumentation/efb/VK_IN_Marker");
Output_Unit = getprop("/instrumentation/efb/VK_OUT_Marker");

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "" or (Input_Unit != VK_Input_Mem) or (Output_Unit != VK_Output_Mem)) {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                    # CLEARs the whole Input Field
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                           # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                          # CHANGEs SIGN to the Input Field
            if (substr(Temp_String, 0, 1) == "-") { lenght = size(Temp_String) - 1;
            Temp_String = substr(Temp_String, 1, lenght);
            } else { Temp_String = "-" ~ Temp_String;
            }
        setprop("/instrumentation/efb/Keyboard/Input_String", Temp_String);
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display
        setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress")); # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Input_Line2", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                # Print it to the Keyboard Input Field



# Output Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_Line2") == "") or (getprop("/instrumentation/efb/Keyboard/Input_Line2") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_Line2") == "-")) { setprop("/instrumentation/efb/Keyboard/Output_Line2", "");
        } else { Output_Line2 = getprop("/instrumentation/efb/Keyboard/Input_Line2");
# ---------------> Conversion Table Selection

# ---------------> Input Unit 1 () CELSIUS (°C) ---> Output Unit: CELSIUS (°C), FAHRENHEIT (°F)

        if (Input_Unit == 1) {
            if (Output_Unit == 1) { Cnv_Fact = Output_Line2;
            }
            if (Output_Unit == 2) { Cnv_Fact = (Output_Line2*1.8) + 32;
            }
        }
# ---------------> Input Unit 2 () FAHRENHEIT (°F) ---> Output Unit: CELSIUS (°C), FAHRENHEIT (°F)
        if (Input_Unit == 2) {
            if (Output_Unit == 1) { Cnv_Fact = (Output_Line2 - 32)/1.8;
            }
            if (Output_Unit == 2) { Cnv_Fact = Output_Line2;
            }
        }
        VK_Input_Mem = Input_Unit;
        VK_Output_Mem = Output_Unit;

        Output_Line2 = Cnv_Fact;                                                    # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Output_Line2", Output_Line2);        # Print it to the Keyboard Output Field
        }
        setprop("/instrumentation/efb/VK_keypress", "");
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Input_Line2", "");
setprop("/instrumentation/efb/Keyboard/Output_Line2", "");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - VOLUME CONVERSION Parser ----------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_VLM") {

Input_Unit = getprop("/instrumentation/efb/VK_IN_Marker");
Output_Unit = getprop("/instrumentation/efb/VK_OUT_Marker");

Output_TMZ_Line = "";

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "" or (Input_Unit != VK_Input_Mem) or (Output_Unit != VK_Output_Mem)) {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                    # CLEARs the whole Input Field
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                           # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                          # CHANGEs SIGN to the Input Field
            if (substr(Temp_String, 0, 1) == "-") { lenght = size(Temp_String) - 1;
            Temp_String = substr(Temp_String, 1, lenght);
            } else { Temp_String = "-" ~ Temp_String;
            }
        setprop("/instrumentation/efb/Keyboard/Input_String", Temp_String);
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display
        setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress")); # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Input_Line3", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                # Print it to the Keyboard Input Field

# ---------------> Conversion Table Selection

		Input_Unit = "Input_Unit" ~ "_" ~ Input_Unit;
		Cnv_Fact = Volume_CNV_Factors[Input_Unit][Output_Unit-1];

        VK_Input_Mem = Input_Unit;
        VK_Output_Mem = Output_Unit;

# Output Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_Line3") == "") or (getprop("/instrumentation/efb/Keyboard/Input_Line3") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_Line3") == "-")) { setprop("/instrumentation/efb/Keyboard/Output_Line3", "");
        } else { Output_Line2 = getprop("/instrumentation/efb/Keyboard/Input_Line3");
        Output_Line2 = Output_Line2 * Cnv_Fact;                                     # Build the Input String
        setprop("/instrumentation/efb/Keyboard/Output_Line3", Output_Line2);        # Print it to the Keyboard Output Field
        }
        setprop("/instrumentation/efb/VK_keypress", "");
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Input_Line3", "");
setprop("/instrumentation/efb/Keyboard/Output_Line3", "");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - TIME ZONE CONVERSION Parser -------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_CNV_TMZ") {

    TMZ_TIME = getprop("/instrumentation/clock/indicated-short-string") ~ "z";
    setprop("/instrumentation/efb/Keyboard/Current_DT_Line", TMZ_DATE ~ " " ~ TMZ_TIME);                                                                                                                # Print Current Date & Time
    setprop("/instrumentation/efb/Keyboard/Converted_Name_Line", "Use Keyboard to Input Time (HHMM)");

# Input keys Check

if (getprop("/instrumentation/efb/VK_keypress") != "") {

# Input Field Parser

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                                                        # CLEARs the whole Input Field and other stuff
        setprop("/instrumentation/efb/Keyboard/Input_HH_Line", "--");
        setprop("/instrumentation/efb/Keyboard/Input_MM_Line", "--");
        setprop("/instrumentation/efb/Keyboard/Input_Zulu_Line", "--:--");
        setprop("/instrumentation/efb/Keyboard/Output_HH", "");
        setprop("/instrumentation/efb/Keyboard/Output_MM", "");
        setprop("/instrumentation/efb/Keyboard/Converted_ID_Line", "");
        setprop("/instrumentation/efb/Keyboard/Converted_Name_Line", "Use Keyboard to Input Time (HHMM)");
        setprop("/instrumentation/efb/Keyboard/Output_TMZ_Line", "--:--");
        setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "");
        TMZ_index = 0;
        Output_TMz_Line = "--:--";
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                                                               # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
        setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "CHNGS") { setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String"));                     # Bypasses CHANGEs SIGN
        setprop("/instrumentation/efb/VK_keypress", "");
        }

# Input Field Display

        TMZ_String = getprop("/instrumentation/efb/Keyboard/Input_String");
        TMZ_Input_Lenght = size(TMZ_String);

        if (TMZ_Input_Lenght <= 3)  {
            setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress"));                                 # Build the Input String

            if (TMZ_Input_Lenght > 1) { setprop("/instrumentation/efb/Keyboard/Input_HH_Line", substr(getprop("/instrumentation/efb/Keyboard/Input_String"), 0, 2));                                    # IF 3rd digit, Print HH to the Keyboard Input Field
            setprop("/instrumentation/efb/Keyboard/Output_HH", substr(getprop("/instrumentation/efb/Keyboard/Input_String"), 0, 2));                                                                    # Copy HH to Output_HH
            setprop("/instrumentation/efb/Keyboard/Input_MM_Line", substr(getprop("/instrumentation/efb/Keyboard/Input_String"), 2, TMZ_Input_Lenght));                                                 # IF 3rd digit, Print MM to the Keyboard Input Field
            setprop("/instrumentation/efb/Keyboard/Output_MM", substr(getprop("/instrumentation/efb/Keyboard/Input_String"), 2, TMZ_Input_Lenght));                                                     # Copy MM to Output_MM
            setprop("/instrumentation/efb/Keyboard/Input_Zulu_Line", (getprop("/instrumentation/efb/Keyboard/Input_HH_Line") ~ ":" ~ getprop("/instrumentation/efb/Keyboard/Input_MM_Line")));          # IF 3rd digit, Print "zulu Time" to the Keyboard Output "zulu to be converted" Field (see EFB Manual)
            } else { setprop("/instrumentation/efb/Keyboard/Input_HH_Line", getprop("/instrumentation/efb/Keyboard/Input_String"));                                                                                                                         # Print Blank HH to the Keyboard Input Field
                     setprop("/instrumentation/efb/Keyboard/Input_MM_Line", "--");                                                                                                                      # Print Blank HH to the Keyboard Input Field
                     setprop("/instrumentation/efb/Keyboard/Input_Zulu_Line", getprop("/instrumentation/efb/Keyboard/Input_HH_Line") ~ ":" ~ getprop("/instrumentation/efb/Keyboard/Input_MM_Line"));   # Print Blank "zulu Time" to the Keyboard Output "zulu to be converted" Field (see EFB Manual)                                                                                                                          # Print "" MM to the Keyboard Input Field
                     setprop("/instrumentation/efb/Keyboard/Output_HH", "");
                     setprop("/instrumentation/efb/Keyboard/Output_MM", "");
            }

        } # an 'else' clause should be set here, giving the Pilot an audible 'WARNING Beep', because we cannot accept more than 4 chars for Time Input!
        }
        setprop("/instrumentation/efb/VK_keypress", ""); # reset the VK keys to ""

# ---------------> Output Unit: Input Time Conversion --> TIME ZONES Time

        if (TMZ_Input_Lenght > 1) { # TMZ_Index = TMZ_Index;

            if ((keypress == "r3") and (TMZ_Index > 0)) { TMZ_Index = TMZ_Index - 1;
                keypress = "";
            } # an 'else' clause should be set here, giving the Pilot an audible 'WARNING Beep', because he reached Bottom End of DB File!
            if ((keypress == "r4") and (TMZ_Index < TMZ_DB_Size)) { TMZ_Index = TMZ_Index + 1;
                keypress = "";
            } # an 'else' clause should be set here, giving the Pilot an audible 'WARNING Beep', because he reached Top End of DB File!

#           setprop("/instrumentation/efb/Keyboard/Output_HH", "12");
#           setprop("/instrumentation/efb/Keyboard/Output_MM", "54");
            if (keypress == "r5") { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "0");                                 # RESET ALL
                setprop("/instrumentation/efb/Keyboard/Input_String", "");
                TMZ_String = "";
                TMZ_Index = 0;
                TMZ_Input_Lenght = 0;
                setprop("/instrumentation/efb/Keyboard/Current_DT_Line", "");
                setprop("/instrumentation/efb/Keyboard/Input_HH_Line", "");
                setprop("/instrumentation/efb/Keyboard/Input_MM_Line", "");
                setprop("/instrumentation/efb/Keyboard/Input_Zulu_Line", "");
                setprop("/instrumentation/efb/Keyboard/Output_HH", "0");
                setprop("/instrumentation/efb/Keyboard/Output_MM", "0");
                setprop("/instrumentation/efb/Keyboard/Converted_ID_Line", "");
                setprop("/instrumentation/efb/Keyboard/Converted_Name_Line", "Use Keyboard to Input Time (HHMM)");
                setprop("/instrumentation/efb/Keyboard/Output_TMZ_Line", "");
                setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "0");
                TMZ_index = 0;
                Output_TMz_Line = "--:--";
            }

            if (getprop("/instrumentation/efb/Keyboard/Output_HH") != "0") {
                    TMZ_Converted_ID = getprop("/instrumentation/efb/TimeZonesDB/IDX[" ~ TMZ_Index ~ "]/ID");
                    TMZ_Converted_Name = getprop("/instrumentation/efb/TimeZonesDB/IDX[" ~ TMZ_Index ~ "]/Name");
                    TMZ_zulu_HH = getprop("/instrumentation/efb/Keyboard/Output_HH");
                    TMZ_Converted_OffSet = getprop("/instrumentation/efb/TimeZonesDB/IDX[" ~ TMZ_Index ~ "]/OffSet");
                    setprop("/instrumentation/efb/Keyboard/Converted_ID_Line", TMZ_Converted_ID);                           # Print Time Zone ID to the Keyboard Converted Time Field
                    setprop("/instrumentation/efb/Keyboard/Converted_Name_Line", TMZ_Converted_Name);                       # Print Time Zone Name to the Keyboard Converted Time Field
                    setprop("/instrumentation/efb/Keyboard/Cnv_Fact", (TMZ_zulu_HH + TMZ_Converted_OffSet));
                } else { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", 0);
                        }

# HH Corrections for Time Zone's Conversion Factors

            if (getprop("/instrumentation/efb/Keyboard/Cnv_Fact") > 9) { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", getprop("/instrumentation/efb/Keyboard/Cnv_Fact"));                                                                              # Print HH Converted Time to the Keyboard Converted Time Field
            } elsif (((getprop("/instrumentation/efb/Keyboard/Cnv_Fact") >= 0) and (getprop("/instrumentation/efb/Keyboard/Cnv_Fact") <= 9))) { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "0" ~ getprop("/instrumentation/efb/Keyboard/Cnv_Fact")); # Print H Converted Time to the Keyboard Converted Time Field
            } elsif (getprop("/instrumentation/efb/Keyboard/Cnv_Fact") < 0) { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", (24 + getprop("/instrumentation/efb/Keyboard/Cnv_Fact")));                                                                  # Print (24 - HH) Converted Time to the Keyboard Converted Time Field
            }
        } else { setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "--");
                }

# Output Converted Time Field Display

        if ((getprop("/instrumentation/efb/Keyboard/Input_HH_Line") == "") or (getprop("/instrumentation/efb/Keyboard/Input_HH_Line") == ".") or (getprop("/instrumentation/efb/Keyboard/Input_HH_Line") == "--")) { setprop("/instrumentation/efb/Keyboard/Output_TMZ_Line", "");
        Output_TMz_Line = "--:--";
        } else { Output_TMZ_Line = getprop("/instrumentation/efb/Keyboard/Cnv_Fact");
                 Output_TMZ_Line = substr(Output_TMZ_Line, 0, 2) ~ ":" ~ getprop("/instrumentation/efb/Keyboard/Output_MM");# Build the Output String
        }
        setprop("/instrumentation/efb/Keyboard/Output_TMZ_Line", Output_TMZ_Line);                                          # Print it to the Keyboard Output Converted Time Field

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/page", "UTILITIES");
setprop("/instrumentation/efb/Keyboard/Current_DT_Line", "");
setprop("/instrumentation/efb/Keyboard/Input_HH_Line", "");
setprop("/instrumentation/efb/Keyboard/Input_MM_Line", "");
setprop("/instrumentation/efb/Keyboard/Input_Zulu_Line", "");
setprop("/instrumentation/efb/Keyboard/Cnv_Fact", "");
setprop("/instrumentation/efb/Keyboard/Output_HH", "");
setprop("/instrumentation/efb/Keyboard/Output_MM", "");
setprop("/instrumentation/efb/Keyboard/Converted_ID_Line", "");
setprop("/instrumentation/efb/Keyboard/Converted_Name_Line", "");
setprop("/instrumentation/efb/Keyboard/Output_TMZ_Line", "");
setprop("/instrumentation/efb/Keyboard/Input_String", "");

keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - DESCENT RATE Calculator ----------------------------------------------|
#_________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "UTILITIES_DESC_RATE") {

page.clearpage();

# Input keys Check

    if (keypress == "l2") { setprop("/instrumentation/efb/Input_Unit", "Initial_FL");
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/DRC_Initial_FL_MEM", getprop("/instrumentation/efb/DRC_Initial_FL"));
    setprop("/instrumentation/efb/VK_DRC_MarkerL", 1);
    setprop("/instrumentation/efb/VK_DRC_MarkerR", 0);
    }
    if (keypress == "r2") { setprop("/instrumentation/efb/Input_Unit", "Target_FL");
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/DRC_Target_FL_MEM", getprop("/instrumentation/efb/DRC_Target_FL"));
    setprop("/instrumentation/efb/VK_DRC_MarkerR", 1);
    setprop("/instrumentation/efb/VK_DRC_MarkerL", 0);
    }
    if (keypress == "l3") { setprop("/instrumentation/efb/Input_Unit", "Initial_GS");
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/DRC_Initial_GS_MEM", getprop("/instrumentation/efb/DRC_Initial_GS"));
    setprop("/instrumentation/efb/VK_DRC_MarkerL", 2);
    setprop("/instrumentation/efb/VK_DRC_MarkerR", 0);
    }
    if (keypress == "r3") { setprop("/instrumentation/efb/Input_Unit", "Target_GS");
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/DRC_Target_GS_MEM", getprop("/instrumentation/efb/DRC_Target_GS"));
    setprop("/instrumentation/efb/VK_DRC_MarkerR", 2);
    setprop("/instrumentation/efb/VK_DRC_MarkerL", 0);
    }
    if (keypress == "l4") { setprop("/instrumentation/efb/Input_Unit", "Distance");
    setprop("/instrumentation/efb/Keyboard/Input_String","");
    setprop("/instrumentation/efb/DRC_Distance_MEM", getprop("/instrumentation/efb/DRC_Distance"));
    setprop("/instrumentation/efb/VK_DRC_MarkerL", 3);
    setprop("/instrumentation/efb/VK_DRC_MarkerR", 0);
    }


# Input keys Parser

if ((getprop("/instrumentation/efb/VK_keypress") != "") and (getprop("/instrumentation/efb/VK_keypress") != ".") and (getprop("/instrumentation/efb/VK_keypress") != "CHNGS") and (getprop("/instrumentation/efb/Input_Unit") != "NO_INPUT")) {

        if (getprop("/instrumentation/efb/VK_keypress") == "CLEAR") { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                                            # CLEARs the whole Input Field
        VK_Key = "VOID";
        setprop("/instrumentation/efb/VK_keypress", "");
        }
        if (getprop("/instrumentation/efb/VK_keypress") == "BKSP") { Temp_String = getprop("/instrumentation/efb/Keyboard/Input_String");                                                   # BACKSPACEs the Input Field
        lenght = size(Temp_String) - 1;
            if (lenght >= 1) {
                    setprop("/instrumentation/efb/Keyboard/Input_String", substr(Temp_String, 0, lenght));
                    setprop("/instrumentation/efb/VK_keypress", "");
            } elsif (lenght <= 0) { setprop("/instrumentation/efb/Keyboard/Input_String", "");                                                                                                          # CLEARs the whole Input Field
                    VK_Key = "VOID";
                }
        }

    DRC_String = getprop("/instrumentation/efb/Keyboard/Input_String");
    DRC_Input_Lenght = size(DRC_String);

        if (DRC_Input_Lenght < 3) {

                if (VK_Key != "VOID") { setprop("/instrumentation/efb/Keyboard/Input_String", getprop("/instrumentation/efb/Keyboard/Input_String") ~ getprop("/instrumentation/efb/VK_keypress"));                 # Build the Input String...
                }
                if ((getprop("/instrumentation/efb/Input_Unit") == "Initial_FL") and (VK_Key != "VOID")) { setprop("/instrumentation/efb/DRC_Initial_FL", getprop("/instrumentation/efb/Keyboard/Input_String"));   # ...For Initial FL
                } elsif ((getprop("/instrumentation/efb/Input_Unit") == "Initial_FL") and (VK_Key == "VOID")) { setprop("/instrumentation/efb/display/DRC_l3", "CLEAR");
                    setprop("/instrumentation/efb/DRC_Initial_FL", getprop("/instrumentation/efb/DRC_Initial_FL_MEM"));
                }
                if ((getprop("/instrumentation/efb/Input_Unit") == "Target_FL") and (VK_Key != "VOID")) { setprop("/instrumentation/efb/DRC_Target_FL", getprop("/instrumentation/efb/Keyboard/Input_String"));     # ...For Target FL
                } elsif ((getprop("/instrumentation/efb/Input_Unit") == "Target_FL") and (VK_Key == "VOID")) { setprop("/instrumentation/efb/display/DRC_r3", "CLEAR");
                    setprop("/instrumentation/efb/DRC_Target_FL", getprop("/instrumentation/efb/DRC_Target_FL_MEM"));
                }
                if ((getprop("/instrumentation/efb/Input_Unit") == "Initial_GS") and (VK_Key != "VOID")) { setprop("/instrumentation/efb/DRC_Initial_GS", getprop("/instrumentation/efb/Keyboard/Input_String"));   # ...For Initial GS
                } elsif ((getprop("/instrumentation/efb/Input_Unit") == "Initial_GS") and (VK_Key == "VOID")) { setprop("/instrumentation/efb/display/DRC_l5", "CLEAR");
                    setprop("/instrumentation/efb/DRC_Initial_GS", getprop("/instrumentation/efb/DRC_Initial_GS_MEM"));
                }
                if ((getprop("/instrumentation/efb/Input_Unit") == "Target_GS") and (VK_Key != "VOID")) { setprop("/instrumentation/efb/DRC_Target_GS", getprop("/instrumentation/efb/Keyboard/Input_String"));     # ...For Target GS
                } elsif ((getprop("/instrumentation/efb/Input_Unit") == "Target_GS") and (VK_Key == "VOID")) { setprop("/instrumentation/efb/display/DRC_r5", "CLEAR");
                setprop("/instrumentation/efb/DRC_Target_GS", getprop("/instrumentation/efb/DRC_Target_GS_MEM"));
                }
                if ((getprop("/instrumentation/efb/Input_Unit") == "Distance")  and (VK_Key != "VOID")) { setprop("/instrumentation/efb/DRC_Distance", getprop("/instrumentation/efb/Keyboard/Input_String"));      # ...For Distance
                } elsif ((getprop("/instrumentation/efb/Input_Unit") == "Distance")  and (VK_Key == "VOID")) { setprop("/instrumentation/efb/display/DRC_l7", "CLEAR");
                setprop("/instrumentation/efb/DRC_Distance", getprop("/instrumentation/efb/DRC_Distance_MEM"));
                }
        }
    }
    setprop("/instrumentation/efb/VK_keypress", ""); # reset the VK keys to ""
    VK_Key = "";
# Transfers Values to DRC variables as numbers

Initial_FL = num(getprop("/instrumentation/efb/DRC_Initial_FL"));
Target_FL = num(getprop("/instrumentation/efb/DRC_Target_FL"));
Initial_GS = num(getprop("/instrumentation/efb/DRC_Initial_GS"));
Target_GS = num(getprop("/instrumentation/efb/DRC_Target_GS"));
DRC_Distance = num(getprop("/instrumentation/efb/DRC_Distance"));

# Calculates Formulas
# Formula: [Angle of Descent (ft/NM) = ALT Gradient/Distance] |||| [SPD Factor (ft/min) = SPD Gradient/60] |||| [Target Descent Rate (Fpm) = Angle of Descent * SPD Factor]

var DRC_Angle = (Target_FL - Initial_FL)/DRC_Distance;
var DRC_AvgSpeed = (Initial_GS + Target_GS)/2;
var DRC_Fact = DRC_AvgSpeed/60;
var DRC_Output = DRC_Angle * DRC_Fact*100;
var DRC_Time = (Target_FL - Initial_FL)/(DRC_Output/100);

# Prepares Output Strings

DRC_l3 = substr(getprop("/instrumentation/efb/DRC_Initial_FL"), 0, 3);
CUT = split(".", DRC_l3);
DRC_l3 = CUT[0];

DRC_r3 = substr(getprop("/instrumentation/efb/DRC_Target_FL"), 0, 3);
CUT = split(".", DRC_r3);
DRC_r3 = CUT[0];

DRC_l5 = substr(getprop("/instrumentation/efb/DRC_Initial_GS"), 0, 3);
CUT = split(".", DRC_l5);
DRC_l5 = CUT[0];

DRC_r5 = substr(getprop("/instrumentation/efb/DRC_Target_GS"), 0, 3);
CUT = split(".", DRC_r5);
DRC_r5 = CUT[0];

DRC_l7 = substr(getprop("/instrumentation/efb/DRC_Distance"), 0, 3);
CUT = split(".", DRC_l7);
DRC_l7 = CUT[0];

setprop("/instrumentation/efb/DRC_Output", "100");
setprop("/instrumentation/efb/DRC_Output", DRC_Output);
DRC_r8 = substr(getprop("/instrumentation/efb/DRC_Output"), 0, 8);
CUT = split(".", DRC_r8);
DRC_r8 = CUT[0];

setprop("/instrumentation/efb/DRC_Angle", "100");
setprop("/instrumentation/efb/DRC_Angle", DRC_Angle);
DRC_r9 = substr(getprop("/instrumentation/efb/DRC_Angle"), 0, 5);
# CUT = split(".", DRC_r9);
# DRC_r9 = CUT[0];

setprop("/instrumentation/efb/DRC_Time", "100");
setprop("/instrumentation/efb/DRC_Time", DRC_Time);
DRC_r10 = substr(getprop("/instrumentation/efb/DRC_Time"), 0, 5);
#CUT = split(".", DRC_r10);
#DRC_r10 = CUT[0];


page.DRCupdate();   # Displays Output

if (keypress == "MENU") { page.DRCclearpage();
page.DRCupdate();
setprop("/sim/model/efb/page", "Displays/PU_1.jpg");
setprop("/instrumentation/efb/VK_DRC_MarkerR", 0);
setprop("/instrumentation/efb/VK_DRC_MarkerL", 0);
setprop("/instrumentation/efb/page", "UTILITIES");
keypress = "";
}
#__________________________________________________________________________________________
# PILOT UTILITIES - NORMAL PROCEDURES MANUAL ----------------------------------------------|
#__________________________________________________________________________________________|
} elsif (getprop("/instrumentation/efb/page") == "NORM PROC MANUAL") {

    page.clearpage();

if (keypress == "PGUP") { setprop("/instrumentation/efb/manual-page", getprop("/instrumentation/efb/manual-page") - 0.20);
keypress = "";
}
if (keypress == "ScrollUP") { setprop("/instrumentation/efb/manual-page", getprop("/instrumentation/efb/manual-page") - 0.02);
keypress = "";
}

if (keypress == "ScrollDN") { setprop("/instrumentation/efb/manual-page", getprop("/instrumentation/efb/manual-page") + 0.02);
keypress = "";
}

if (keypress == "PGDN") { setprop("/instrumentation/efb/manual-page", getprop("/instrumentation/efb/manual-page") + 0.20);
keypress = "";
}

if (keypress == "MENU") { setprop("/sim/model/efb/page", "Displays/Documents_1.jpg");
setprop("/instrumentation/efb/page", "DOCUMENTS");
keypress = "";
}

}
#___________________________________________________________________________________________
#_______________________________END of Parsers & SubParsers_________________________________|

    page.update();

if ((getprop("/instrumentation/efb/page") == "Airport Charts") or (getprop("/instrumentation/efb/page") == "Airport Diagram") or (getprop("/instrumentation/efb/page") == "NORM PROC MANUAL")) setprop("/instrumentation/efb/text-color", 0);
else setprop("/instrumentation/efb/text-color", 1);

},
    reset : func {
        me.loopid += 1;
        me._loop_(me.loopid);
    },
    _loop_ : func(id) {
        id == me.loopid or return;
        me.Page_Update();
        settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
    }

};

var page = {
    update : func {

        setprop("/instrumentation/efb/display/line0-l", l0);
        setprop("/instrumentation/efb/display/line1-l", l1);
        setprop("/instrumentation/efb/display/line2-l", l2);
        setprop("/instrumentation/efb/display/line3-l", l3);
        setprop("/instrumentation/efb/display/line4-l", l4);
        setprop("/instrumentation/efb/display/line5-l", l5);
        setprop("/instrumentation/efb/display/line6-l", l6);
        setprop("/instrumentation/efb/display/line7-l", l7);
        setprop("/instrumentation/efb/display/line8-l", l8);
        setprop("/instrumentation/efb/display/line9-l", l9);
        setprop("/instrumentation/efb/display/line10-l", l10);
        setprop("/instrumentation/efb/display/line11-l", l11);
        setprop("/instrumentation/efb/display/line12-l", l12);
        setprop("/instrumentation/efb/display/line13-l", l13);
        setprop("/instrumentation/efb/display/line14-l", l14);
        setprop("/instrumentation/efb/display/line15-l", l15);
        setprop("/instrumentation/efb/display/line16-l", l16);
        setprop("/instrumentation/efb/display/line17-l", l17);
        setprop("/instrumentation/efb/display/line18-l", l18);
        setprop("/instrumentation/efb/display/line19-l", l19);
        setprop("/instrumentation/efb/display/line20-l", l20);

        setprop("/instrumentation/efb/display/line1-r", r1);
        setprop("/instrumentation/efb/display/line2-r", r2);
        setprop("/instrumentation/efb/display/line3-r", r3);
        setprop("/instrumentation/efb/display/line4-r", r4);
        setprop("/instrumentation/efb/display/line5-r", r5);
        setprop("/instrumentation/efb/display/line6-r", r6);
        setprop("/instrumentation/efb/display/line7-r", r7);
        setprop("/instrumentation/efb/display/line8-r", r8);
        setprop("/instrumentation/efb/display/line9-r", r9);
        setprop("/instrumentation/efb/display/line10-r", r10);
        setprop("/instrumentation/efb/display/line11-r", r11);
        setprop("/instrumentation/efb/display/line12-r", r12);
        setprop("/instrumentation/efb/display/line13-r", r13);
        setprop("/instrumentation/efb/display/line14-r", r14);
        setprop("/instrumentation/efb/display/line15-r", r15);
        setprop("/instrumentation/efb/display/line16-r", r16);
        setprop("/instrumentation/efb/display/line17-r", r17);
        setprop("/instrumentation/efb/display/line18-r", r18);
        setprop("/instrumentation/efb/display/line19-r", r19);
        setprop("/instrumentation/efb/display/line20-r", r20);

        setprop("/instrumentation/efb/display/input-helper", helper);
        setprop("/instrumentation/efb/keypress", keypress);

},
    clearpage : func {

        l0 = "";
        l1 = "";
        l2 = "";
        l3 = "";
        l4 = "";
        l5 = "";
        l6 = "";
        l7 = "";
        l8 = "";
        l9 = "";
        l10 = "";
        l11 = "";
        l12 = "";
        l13 = "";
        l14 = "";
        l15 = "";
        l16 = "";
        l17 = "";
        l18 = "";
        l19 = "";
        l20 = "";

        r1 = "";
        r2 = "";
        r3 = "";
        r4 = "";
        r5 = "";
        r6 = "";
        r7 = "";
        r8 = "";
        r9 = "";
        r10 = "";
        r11 = "";
        r12 = "";
        r13 = "";
        r14 = "";
        r15 = "";
        r16 = "";
        r17 = "";
        r18 = "";
        r19 = "";
        r20 = "";

        helper = "";

},

    index : func {

l0 = "";
l1 = "";
l2 = "";
l3 = "";
l4 = "";
l5 = "";
l6 = "";
l7 = "";
l8 = "";
l9 = "";
l10 = "";
l11 = "";
l12 = "";
l13 = "";
l14 = "";
l15 = "";
l16 = "";
l17 = "";
l18 = "";
l19 = "";
l20 = "";


r1 = "";
r2 = "";
r3 = "";
r4 = "";
r5 = "";
r6 = "";
r7 = "";
r8 = "";
r9 = "";
r10 = "";
r11 = "";
r12 = "";
r13 = "";
r14 = "";
r15 = "";
r16 = "";
r17 = "";
r18 = "";
r19 = "";
r20 = "";


},
    Reset_Text_Matrix : func {

Title.setText("TITLE TEST");
Title.hide();
Helper.setText("HELPER TEST");
Helper.hide();
var Text_Line_Size = 16;
setsize(Text_Line_L, Text_Line_Size);
setsize(Text_Line_R, Text_Line_Size);
var xpos_L = 22.0;
var xpos_R = 487.0;
var ypos = 87.5;
for(var i = 0; i < (Text_Line_Size - 1); i += 1)
{
	Text_Line_L[i].setTranslation(xpos_L,ypos).setAlignment("left-center").setFont("Helvetica.txf").setFontSize(32,1).setColor(1,1,1).set("z-index",10).setText("TEST");
	Text_Line_L[i].setTranslation(xpos_L,ypos).setAlignment("left-center").setFont("Helvetica.txf").setFontSize(32,1).setColor(1,1,1).set("z-index",10).setText("TEST");
	Text_Line_L[i].hide();
	Text_Line_R[i].hide();
	ypos = ypos + 40.5;
}
},
   Clear_Text_Matrix : func {

var Text_Line_Size = 16;
for(var i = 0; i < (Text_Line_Size - 1); i += 1)
{
	Text_Line_L[i].setText("");
	Text_Line_L[i].setText("");
	Text_Line_L[i].hide();
	Text_Line_R[i].hide();
	ypos = ypos + 40.5;
}
},
    KCupdate : func {

        setprop("/instrumentation/efb/display/lineAPT_NAME", KCl0);
        setprop("/instrumentation/efb/display/lineAPT_LOCATION", KCl0_0);
        setprop("/instrumentation/efb/display/lineAPT_PAGESHOW", KCl0_1);
        setprop("/instrumentation/efb/display/lineSTAR", KCl1);
        setprop("/instrumentation/efb/display/lineIAP", KCl2);
        setprop("/instrumentation/efb/display/lineSID", KCl3);
        setprop("/instrumentation/efb/display/lineAPT", KCl4);

        setprop("/instrumentation/efb/display/lineCHART1-r", KCr1);
        setprop("/instrumentation/efb/display/lineCHART2-r", KCr2);
        setprop("/instrumentation/efb/display/lineCHART3-r", KCr3);

        setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", Keyboard_Helper);
        setprop("/instrumentation/efb/Keyboard/CHART_Output_Line", Keyboard_Message);

},
    KCclearpage : func {

        KCl0 = "";
        KCl0_0 = "";
        KCl0_1 = "";
        KCl1 = "";
        KCl2 = "";
        KCl3 = "";
        KCl4 = "";

        KCr1 = "";
        KCr2 = "";
        KCr3 = "";

        Keyboard_Helper = "";
        Keyboard_Message = "";
        helper = "";

},
    DRCupdate : func {

        setprop("/instrumentation/efb/display/DRC_l3", DRC_l3);
        setprop("/instrumentation/efb/display/DRC_l5", DRC_l5);
        setprop("/instrumentation/efb/display/DRC_r3", DRC_r3);
        setprop("/instrumentation/efb/display/DRC_r5", DRC_r5);
        setprop("/instrumentation/efb/display/DRC_l7", DRC_l7);
        setprop("/instrumentation/efb/display/DRC_r8", DRC_r8);
        setprop("/instrumentation/efb/display/DRC_r9", DRC_r9);
        setprop("/instrumentation/efb/display/DRC_r10", DRC_r10);

},
    DRCclearpage : func {

        DRC_l3 = "";
        DRC_l5 = "";
        DRC_r3 = "";
        DRC_r5 = "";
        DRC_l7 = "";
        DRC_r8 = "";
        DRC_r9 = "";
        DRC_r10 = "";

},
    FlightMonitor : func {

if (getprop("/instrumentation/efb/FlightStatus") == 1) {
var FStatus = "ACTIVE";
} else FStatus = "INACTIVE";
if (getprop("/autopilot/route-manager/active") == 1) {
if (getprop("/autopilot/route-manager/departure/takeoff-time") != nil) { var TOT = getprop("/autopilot/route-manager/departure/takeoff-time") ~ "z";
} else TOT = "Unknown";
if (getprop("/autopilot/route-manager/destination/touchdown-time") != nil) { var TDT = getprop("/autopilot/route-manager/destination/touchdown-time") ~ "z";
} else TDT = "Unknown";
var OAPT = getprop("/autopilot/route-manager/departure/airport") ~ " " ~ getprop("/autopilot/route-manager/departure/runway");
var DAPT = getprop("/autopilot/route-manager/destination/airport") ~ " " ~ getprop("/autopilot/route-manager/destination/runway");
} else { OAPT = "NOT Set";
DAPT = "NOT Set";
TOT = "Unknown";
TDT = "Unknown";
}


l2 = "Aircraft: " ~ getprop("/sim/description") ~ " Seattle";
l3 = "Operator: " ~ substr(getprop("/sim/aircraft-operator"),0,3);
r3 = "CallSign: " ~ substr(getprop("/sim/multiplay/callsign"), 0,6);
l4 = "Flight No: " ~ "NOT Set"; # This will be set through CDU (To be done)
r4 = "Flight Status: " ~ FStatus;
l5 = "Origin APT: " ~ OAPT;
r5 = "TO Time: " ~ TOT;
l6 = "Destination APT: " ~ DAPT;
r6 = "TD Time: " ~ TDT;
l7 = "Date: " ~ substr(getprop("environment/metar/data"),0,10);
r7 = "Time: " ~ getprop("/instrumentation/clock/indicated-short-string") ~ "z";
l9 = "Ind. ALT: " ~ sprintf("%3.2f", getprop("/Instrumentation/altimeter/indicated-altitude-ft")) ~ " ft";
r9 = "Press. ALT: " ~ sprintf("%3.2f", getprop("/Instrumentation/altimeter/pressure-alt-ft")) ~ " ft";
l10 = "Press. hPa: " ~ sprintf("%3.2f", getprop("/Instrumentation/altimeter/setting-hpa"));
r10 = "Press. inHg: " ~ sprintf("%3.2f", getprop("/Instrumentation/altimeter/setting-inhg"));
l11 = "Speed Knots: " ~ sprintf("%3.0f", getprop("/Instrumentation/airspeed/indicated-speed-kt"));
r11 = "Speed Mach: " ~ sprintf("%3.0f", getprop("/Instrumentation/airspeed/indicated-mach"));
l12 = "Temperature °C: " ~ sprintf("%3.2f", getprop("/environment/temperature-degc"));
r12 = "Temperature °F: " ~ sprintf("%3.2f", getprop("/environment/temperature-degf"));
l13 = "Wind Dir.: " ~ sprintf("%3.0f", getprop("/environment/metar/base-wind-dir-deg")) ~ " degs";
r13 = "Wind Speed: " ~ sprintf("%3.0f", getprop("/environment/base-wind-speed-kt")) ~ " kts";
l14 = "Total Fuel: " ~ sprintf("%3.2f", getprop("/consumables/fuel/total-fuel-gals")) ~ " gals";
l14 = "Gross Weight: " ~ sprintf("%3.2f", getprop("/yasim/gross-weight-lbs")) ~ " lbs";

},
    charts_keyboard : func {

setprop("/instrumentation/efb/chart/Status", "ON");
setprop("/instrumentation/efb/chart/type", "APT");
PageList = getprop("/instrumentation/efb/chart/PageList");

# Checks existence of Charts in the DB by chart's type ~ "-0"; example: "KSFO/type-0"

if(ChartsList[AptIcao] == nil)
{ setprop("/instrumentation/efb/chart_Found", "NOT_FOUND");
Chart_Searchable = 0;
} else { setprop("/instrumentation/efb/chart_Found", "FOUND");
Chart_Searchable = 1;
}
setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", "Charts for " ~ AptIcao ~ ": " ~ getprop("/instrumentation/efb/chart_Found"));

if (Chart_Searchable == 1) {

        # gets the APT's Name & Location

        setprop("/instrumentation/efb/chart/type", "NAME");
        KCl0 = sprintf("%s", ChartsList[AptIcao].NAME);
        setprop("/instrumentation/efb/chart/type", "LOCATION");
        KCl0_0 = sprintf("%s", ChartsList[AptIcao].LOCATION);

        setprop("/instrumentation/efb/chart/type", "APT");

        # Gets the number of charts (by Type) in the Charts DB

         STAR_Status = ChartsList[AptIcao].STARs;
         IAP_Status = ChartsList[AptIcao].IAPs;
         SID_Status = ChartsList[AptIcao].SIDs;
         APT_Status = ChartsList[AptIcao].APTs;

         AptIcao_Searched = sprintf("%s", ChartsList[AptIcao].ICAO);
         Chart_Type = getprop("/instrumentation/efb/chart/type");

# HYDE: this for hash access example - should be removed
#         printf("Test = %s", ChartsList[AptIcao]["NAME"]);
#         printf("Test STAR = %s", ChartsList[AptIcao].STAR[0]);
#         printf("Test STAR = %s", ChartsList[AptIcao]["STAR"][1]);
#        foreach(var sidindex; ChartsList[AptIcao]["APT"])
#        {
#             printf("Test for each = %s", sidindex);
#        }
# hash example

# this is just a control
setprop("/instrumentation/efb/chart/Apt_Searched", AptIcao_Searched);

        # Gets the Type of chart from Pilot's Selection

        if (getprop("/instrumentation/efb/VK_Chart_Type") != "") {

        if (getprop("/instrumentation/efb/VK_Chart_Type") == "STAR") { Chart_Type = "STAR";
        Keyboard_Message = ChartsList[AptIcao].STARs ~ " " ~ Chart_Type ~ " Charts for " ~ ChartsList[AptIcao].ICAO ~ " Apt - Select a Chart";
        lastn = ChartsList[AptIcao].STARs - 1;
#        STAR_Status = 1;
        }
        if (getprop("/instrumentation/efb/VK_Chart_Type") == "IAP") { Chart_Type = "IAP";
        Keyboard_Message = ChartsList[AptIcao].IAPs ~ " " ~ Chart_Type ~ " Charts for " ~ ChartsList[AptIcao].ICAO ~ " Apt - Select a Chart";
        lastn = ChartsList[AptIcao].IAPs - 1;
#        IAP_Status = 1;
        }
        if (getprop("/instrumentation/efb/VK_Chart_Type") == "SID") { Chart_Type = "SID";
        Keyboard_Message = ChartsList[AptIcao].SIDs ~ " " ~ Chart_Type ~ " Charts for " ~ ChartsList[AptIcao].ICAO ~ " Apt - Select a Chart";
        lastn = ChartsList[AptIcao].SIDs - 1;
#        SID_Status = 1;
        }
        if (getprop("/instrumentation/efb/VK_Chart_Type") == "APT") { Chart_Type = "APT";
        Keyboard_Message = ChartsList[AptIcao].APTs ~ " " ~ Chart_Type ~ " Charts for " ~ ChartsList[AptIcao].ICAO ~ " Apt - Select a Chart";
        lastn = ChartsList[AptIcao].APTs - 1;
#        APT_Status = 1;
        }

		setprop("/instrumentation/efb/chart/type", Chart_Type);
        setprop("/instrumentation/efb/VK_Chart_Type", Chart_Type);

        if (lastn <= 0) { lastn = 0;
        }
        setprop("/instrumentation/efb/chart/lastn", lastn);

        if ((STAR_Status == 0) and (IAP_Status == 0) and (SID_Status == 0) and (APT_Status == 0)) { setprop("/instrumentation/efb/chart/Status", 0);
        Keyboard_Message = "No Charts available for: " ~ sprintf("%s", getprop("/instrumentation/efb/chart/icao")) ~ " Apt";
        setprop("/instrumentation/efb/chart/Status", "OFF");
        }

        # Gets the available ICAO/Type charts in the Charts DB

        for (var index = 0; index <= 29; index += 1) {
        ChartName[index] = ""
        }
#		Chart_Type = sprintf("%s", getprop("/instrumentation/efb/chart/type"));
        
#		foreach(var SearchIndex; ChartsList[AptIcao]["APT"])
#        {
#             printf("Test for each = %s", SearchIndex);
#        }

        if (lastn > 0) {
                        for (var index = 0; index <= lastn; index += 1) {
                        setprop("/instrumentation/efb/chart/IDX", index);
						Chart_Type = sprintf("%s", getprop("/instrumentation/efb/chart/type"));
                        ChartName[index] = ChartsList[AptIcao_Searched][Chart_Type][index];
        }
        } else { setprop("/instrumentation/efb/chart/selected", (AptIcao_Searched ~ "." ~ getprop("/instrumentation/efb/chart/type") ~ "-0"));
                Chart_Type = sprintf("%s", getprop("/instrumentation/efb/chart/type"));
                ChartName[0] = ChartsList[AptIcao_Searched][Chart_Type][0];
        }

        Keyboard_Helper = "Enter Airport ICAO";
        setprop("/instrumentation/efb/Keyboard/CHART_Input_Line", Keyboard_Helper);
        setprop("/instrumentation/efb/Keyboard/CHART_Output_Line", Keyboard_Message);

        # Prints Charts values to Upper Input Display
        if (getprop("/instrumentation/efb/chart/Status") == "ON") {

        KCl1 = sprintf("%s", ChartsList[AptIcao].STARs);
        KCl2 = sprintf("%s", ChartsList[AptIcao].IAPs);
        KCl3 = sprintf("%s", ChartsList[AptIcao].SIDs);
        KCl4 = sprintf("%s", ChartsList[AptIcao].APTs);

        # Set Index Offset for proper Page Display (by 3 rows)

        if (lastn <=2) {
        Index_Max = 0;
        }
        if ((lastn > 2) and (lastn <=5)) {
        Index_Max = 3;
        }
        if ((lastn > 5) and (lastn <=8)) {
        Index_Max = 6;
        }
        if ((lastn > 8) and (lastn <=11)) {
        Index_Max = 9;
        }
        if ((lastn > 11) and (lastn <=14)) {
        Index_Max = 12;
        }
        if ((lastn > 14) and (lastn <=17)) {
        Index_Max = 15;
        }
        if ((lastn > 17) and (lastn <=20)) {
        Index_Max = 18;
        }
        if ((lastn > 20) and (lastn <=23)) {
        Index_Max = 21;
        }
        if ((lastn > 23) and (lastn <=26)) {
        Index_Max = 24;
        }
        if ((lastn > 26) and (lastn <=29)) {
        Index_Max = 27;
        }

        Chart_Pages = (Index_Max/3) + 1;

        # Displays Actual Chart Page/Total Pages

        Page_Show = "Page " ~ getprop("/instrumentation/efb/chart/PageList") ~ "/" ~ Chart_Pages;
        setprop("instrumentation/efb/chart/PageShow", Page_Show);
        KCl0_1 = getprop("/instrumentation/efb/chart/PageShow");

        # Build 3 rows of Chart Names

        for (var index = 0; index <= 2; index += 1) {
        Index_Offset = ((getprop("/instrumentation/efb/chart/PageList") - 1) * 3);
        Index_Offset = Index_Offset + index;
        ChartDisp[index] = ChartName[Index_Offset];
        }
        # Displays 3 Chart Names [MAX Lenght = 27 chars !], ready for Selection by the Pilot

        setprop("instrumentation/efb/chart/Selection_0", ChartDisp[0]);
        setprop("instrumentation/efb/chart/Selection_1", ChartDisp[1]);
        setprop("instrumentation/efb/chart/Selection_2", ChartDisp[2]);
        KCr1 = substr(getprop("instrumentation/efb/chart/Selection_0"), 0, 26);
        KCr2 = substr(getprop("instrumentation/efb/chart/Selection_1"), 0, 26);
        KCr3 = substr(getprop("instrumentation/efb/chart/Selection_2"), 0, 26);

        } else {

        KCl0 = "";
        KCl0_0 = "";
        KCl0_1 = "";
        KCl1 = "";
        KCl2 = "";
        KCl3 = "";
        KCl4 = "";

        KCr1 = "";
        KCr2 = "";
        KCr3 = "";
        setprop("instrumentation/efb/chart/Selection_0", "");
        setprop("instrumentation/efb/chart/Selection_1", "");
        setprop("instrumentation/efb/chart/Selection_2", "");
        }
        page.KCupdate();
        }
} # END of 'Chart_Searchable == 1' Brace

}

};
#__________________________________________________________________________________________
var toggle = func(property) {

if (getprop(property) == 1) setprop(property, 0);
else setprop(property, 1);

}

setlistener("sim/signals/fdm-initialized", func
 {
 efb.init();
 print("EFB Computer ........ Initialized");
 });
