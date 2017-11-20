function stick_r(x) = min((pow(abs(x-18)/14, 4)+2.5), 5);

module hanger(t) {
    translate(t)
    union() {

/*
        translate([0, stick_r(36)*2/5, 36])
        difference() {
            scale([1, 1, 0.4])
            sphere(r=stick_r(36), $fn=64);
            translate([-10,-10,-10])
            cube(size = [20,20,10]);
        }
*/      
        for (i = [0:36]) {
            q=stick_r(i)-stick_r(i-1);
            M = [ [ 1  , 0  , 0  , 0   ],
            [ 0  , 1  , q*2/5, 0   ],  // The "0.7" is the skew value; pushed along the y axis
            [ 0  , 0  , 1  , 0   ],
            [ 0  , 0  , 0  , 1   ] ] ;
            translate([0, stick_r(i-1)*2/5, i-1])
            multmatrix(M) {
                cylinder(h = 1, r1=stick_r(i-1), r2=stick_r(i), $fn=64);
            }
        }
    }
}

module hole(x) {
    translate([x,0,0])
    union() {
        translate([0,0,4.5])
        cylinder (r=5, h=10, $fn=64);
        cylinder(h = 5, r1=0.3, r2=3.2, $fn=64);
        translate([0,0,-2])
        cylinder (r=2.3, h=10, $fn=64);
    }
}

module everything() {
    for(i = [-3:3]) {
        sig = 1 - abs(i%2)*2;
        hanger([40*i, 13*sig, 6]);
    }
    
    
    color("white", 0.9) {
        // fillet() cube(size = [270, 60, 6]);
        difference() {
            minkowski() {
                translate([-125,-20, 0])
                cube(size = [250, 40, 1]);
                cylinder(h=2, r=7, $fn=64);
                union() {
                    sphere(r=3, $fn=64);
                    translate([0,0,-3])
                    cylinder(h=3, r=3, $fn=64);
                }
            }
            translate([-200,-50,-8])
            cube(size = [400, 100, 10]);
            hole(-88.75);
            hole(88.75);
        }
    }
}



module puzzle(offset_size, coat_x, coat_y, coat_z) {
    for(i = [-4:4]) {
        translate([5 -coat_x, 6*i + offset_size - coat_y, 2 - coat_z])
        cube(size = [10 + 2*coat_x, 3 + 2*coat_y, 2.6 + 2*coat_z]);
    }
}


module left() {
    difference() {
        union() {
            difference() {
                everything();
                translate([10,-50, -20])
                cube(size = [210, 100, 100]);
            }
            puzzle(0, 0, -0.15, 0);
        }
        puzzle(-3, 0.6, 0.15, 0.35);
    }
}

module right() {
    difference() {
        union() {
            difference() {
                everything();
                translate([-200,-50, -20])
                cube(size = [210, 100, 100]);
            }
            puzzle(-3, 0, -0.15, 0);
        }
        puzzle(0, 0.6, 0.15, 0.35);
    }
}

module test_connection_left() {
    difference() {
        left();
        union() {
            translate([-200,-50, -20])
            cube(size = [200, 100, 100]);
            translate([-50,-50, 7])
            cube(size = [200, 100, 100]);
        }
    }
}

module test_hanger_end() {
    difference() {
        left();
        union() {
            translate([-200,-50, -20])
            cube(size = [190, 100, 100]);
            translate([-50,-50, -100])
            cube(size = [200, 100, 140]);
        }
    }
}


//translate([-3,0,0])
//left();

//right();

//test_connection_left();
//test_hanger_end();
everything();
