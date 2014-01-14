####    jet engine hydraulics system    ####
####    Hyde Yamakawa    ####

var HYDR = {
	new : func(prop1){
		var m = { parents : [HYDR]};
		m.hydr = props.globals.initNode(prop1);
		m.LEDP = m.hydr.initNode("LEDP", 0, "BOOL");
		m.REDP = m.hydr.initNode("REDP", 0, "BOOL");
		m.C1ACMP = m.hydr.initNode("C1ACMP", 0, "BOOL");
		m.C2ACMP = m.hydr.initNode("C2ACMP", 0, "BOOL");
		m.LACMP = m.hydr.initNode("LACMP", 0, "BOOL");
		m.RACMP = m.hydr.initNode("RACMP", 0, "BOOL");
		m.C1ADP = m.hydr.initNode("C1ADP", 0, "BOOL");
		m.C2ADP = m.hydr.initNode("C2ADP", 0, "BOOL");
		m.LEDP_fine = m.hydr.initNode("LEDP-NORMAL", 0, "BOOL");
		m.REDP_fine = m.hydr.initNode("REDP-NORMAL", 0, "BOOL");
		m.C1ACMP_fine = m.hydr.initNode("C1ACMP-NORMAL", 0, "BOOL");
		m.C2ACMP_fine = m.hydr.initNode("C2ACMP-NORMAL", 0, "BOOL");
		m.LACMP_fine = m.hydr.initNode("LACMP-NORMAL", 0, "BOOL");
		m.RACMP_fine = m.hydr.initNode("RACMP-NORMAL", 0, "BOOL");
		m.C1ADP_fine = m.hydr.initNode("C1ADP-NORMAL", 0, "BOOL");
		m.C2ADP_fine = m.hydr.initNode("C2ADP-NORMAL", 0, "BOOL");
		m.leng_running = props.globals.getNode("engines/engine/run", 1);
		m.leng_primary_switch = props.globals.initNode("controls/hydraulics/system/LENG_switch", 1, "BOOL");
		m.reng_running = props.globals.getNode("engines/engine[1]/run", 1);
		m.reng_primary_switch = props.globals.initNode("controls/hydraulics/system[2]/RENG_switch", 1, "BOOL");
		m.c1elec_switch = props.globals.initNode("controls/hydraulics/system[1]/C1ELEC-switch", 0, "BOOL");
		m.c2elec_switch = props.globals.initNode("controls/hydraulics/system[1]/C2ELEC-switch", 0, "BOOL");
		m.lacmp_switch = props.globals.initNode("controls/hydraulics/system/LACMP-switch", 0, "INT");
		m.racmp_switch = props.globals.initNode("controls/hydraulics/system[2]/RACMP-switch", 0, "INT");
		m.c1adp_switch = props.globals.initNode("controls/hydraulics/system[1]/C1ADP-switch", 0, "INT");
		m.c2adp_switch = props.globals.initNode("controls/hydraulics/system[1]/C2ADP-switch", 0, "INT");
		return m;
	},
	update : func{
		if(me.leng_running.getValue() and me.leng_primary_switch.getValue()
				or (cpt_flt_inst.getValue() < 24))
		{
			me.LEDP.setValue(1);
			me.LEDP_fine.setValue(1);
		}
		else
		{
			me.LEDP.setValue(0);
			me.LEDP_fine.setValue(0);
		}
		if(me.reng_running.getValue() and me.reng_primary_switch.getValue()
				or (cpt_flt_inst.getValue() < 24))
		{
			me.REDP.setValue(1);
			me.REDP_fine.setValue(1);
		}
		else
		{
			me.REDP.setValue(0);
			me.REDP_fine.setValue(0);
		}
		if((lidg.get_output_volts() > 80) and me.c1elec_switch.getValue()
				or (cpt_flt_inst.getValue() < 24))
		{
			me.C1ACMP.setValue(1);
			me.C1ACMP_fine.setValue(1);
		}
		else
		{
			me.C1ACMP.setValue(0);
			me.C1ACMP_fine.setValue(0);
		}
		if((lidg.get_output_volts() > 80) and me.c2elec_switch.getValue()
				or (cpt_flt_inst.getValue() < 24))
		{
			me.C2ACMP.setValue(1);
			me.C2ACMP_fine.setValue(1);
		}
		else
		{
			me.C2ACMP.setValue(0);
			me.C2ACMP_fine.setValue(0);
		}
		if(((lidg.get_output_volts() > 80) and me.lacmp_switch.getValue() > 0)
				or (cpt_flt_inst.getValue() < 24))
		{
			me.LACMP.setValue(1);
			me.LACMP_fine.setValue(1);
		}
		else
		{
			me.LACMP.setValue(0);
			me.LACMP_fine.setValue(0);
		}
		if(((lidg.get_output_volts() > 80) and me.racmp_switch.getValue() > 0)
				or (cpt_flt_inst.getValue() < 24))
		{
			me.RACMP.setValue(1);
			me.RACMP_fine.setValue(1);
		}
		else
		{
			me.RACMP.setValue(0);
			me.RACMP_fine.setValue(0);
		}
		if(((lidg.get_output_volts() > 80) and me.c1adp_switch.getValue() > 0)
				or (cpt_flt_inst.getValue() < 24))
		{
			me.C1ADP.setValue(1);
			me.C1ADP_fine.setValue(1);
		}
		else
		{
			me.C1ADP.setValue(0);
			me.C1ADP_fine.setValue(0);
		}
		if(((lidg.get_output_volts() > 80) and me.c2adp_switch.getValue() > 0)
				or (cpt_flt_inst.getValue() < 24))
		{
			me.C2ADP.setValue(1);
			me.C2ADP_fine.setValue(1);
		}
		else
		{
			me.C2ADP.setValue(0);
			me.C2ADP_fine.setValue(0);
		}
	}
};

var Hydr = HYDR.new("systems/hydraulics");

var update_hyderaulics = func {
	Hydr.update();
    settimer(update_hyderaulics, 0.2);
}

#####################################
	setlistener("sim/signals/fdm-initialized", func {
	Hydr.leng_primary_switch.setValue(1);
	Hydr.reng_primary_switch.setValue(1);
    settimer(update_hyderaulics,5);
});

