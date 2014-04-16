
##############################################################################

load_nasal(narcissedir~"mockproputil.nas");
load_nasal(narcissedir~"mockprops.nas","props");
load_nasal(narcissedir~"mocksvg.nas","canvas");
load_nasal("../mfd.nas","b777");
load_nasal("../fctl.nas","b777");
load_nasal(narcissedir~"nasmine.nas","nsm");

var mock_canvas_group = {
        createChild : func(type,name){ 
            var child = {
                    hide : func(){},
                    getElementById : func(id) {
                        var elt = {
                             updateCenter : func() {return me;},
                             getCenter : func() {return [0, 0];},
                             createTransform : func(){return me;},
                             setTranslation : func(){return me;}
                        };
                        return elt;
                    }
            };
            return child;
        },
        
};

nsm.describe("a fctl panel",func() {
    nsm.it("should be able to be created",func(){
        var fctl_panel = b777.FctlPanel.new(mock_canvas_group);
        
        nsm.expect(1).toBe(1);
    });
});

nsm.describe("an Aileron",func(){
   nsm.it("should move to the right position",func(){
       setprop("surface-positions/flap-pos-norm",1);
       var mockelt = {
               pos : 0,
               setTranslation: func(start,end) {
                   me.pos = end;
               }
       };      
       var ail = b777.Aileron.new(mockelt);
       ail.update(1);
       nsm.expect(mockelt.pos).toBe(62);
   });
   nsm.it("should not move if no flaps",func(){
       setprop("surface-positions/flap-pos-norm",0);
       var mockelt = {
               pos : 0,
               setTranslation: func(start,end) {
                   me.pos = end;
               }
       };      
       var ail = b777.Aileron.new(mockelt);
       ail.update(1);
       nsm.expect(mockelt.pos).toBe(0);
   });
});
print("\n-------done-----------\n");