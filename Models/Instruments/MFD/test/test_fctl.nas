
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

print("\n-------done-----------\n");