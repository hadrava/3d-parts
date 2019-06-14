$fn=64;

module gearbox() {
	cylinder(r = 37/2, h = 29);
	translate([7,0,-5])
		cylinder(r = 12/2, h = 6);
}

module gearbox_screws() {
	for (i = [0: 5]) {
		rotate([0,0,30 + 60*i])
			translate([31/2,0,-4])
				cylinder(r = 3/2, h = 10);
	}
}

module coupling_hole() {
	translate([7 + 12/2 - 24/2,0,-5])
		cylinder(r = 24/2, h = 6);
}

module motor_subtract() {
	gearbox();
	gearbox_screws();
	coupling_hole();
}

module motor_holder() {
	difference() {
		translate([0,0,-3])
			cylinder(r = 47/2, h = 6);
		motor_subtract();
	}
}

module grinder_subtract() {
	union() {
		hull() {
			cylinder(r = 46.6/2, h = 16);
			translate([-78+46.6, 0, 0])
				cylinder(r = 46.6/2, h = 16);
		}

		hull() {
			translate([0, 0, -8])
			cylinder(r = 49/2, h = 16);
			translate([-80.4+49, 0, -8])
				cylinder(r = 49/2, h = 16);
		}
	}
}

module grinder_holder() {
	difference() {
		union() {
			hull() {
				cylinder(r = 56.6/2, h = 19);
				translate([-88+56.6, 0, 0])
					cylinder(r = 56.6/2, h = 19);
			translate([-7,0,0])
				cylinder(r = 47/2, h = 16+50+ 3);
			}
		}
		grinder_subtract();
		translate([-7,0,0])
			cylinder(r = 37/2, h = 16+50+10);
		hull() {
			translate([-7,0,16-1])
				cylinder(r = 37/2, h = 1+50-3);

			translate([-7,0,16-1])
				cylinder(r = (37+6)/2, h = 1+50-3-3);

			cylinder(r = 40/2, h = 30+3);
			translate([-78+46.6, 0, 0])
				cylinder(r = 40/2, h = 30-3);
		}
	}
}


module everything() {
	translate([-7,0,50])
		motor_holder();
	translate([0,0,-16])
		grinder_holder();
}

rotate([180,0,0])
	everything();

/*
rotate([180,0,0])
	motor_holder();
*/

/*
rotate([180,0,0])
	difference() {
		union() {
			hull() {
				cylinder(r = 56.6/2, h = 19);
				translate([-88+56.6, 0, 0])
					cylinder(r = 56.6/2, h = 19);
			}
		}
		grinder_subtract();
		translate([-7,0,0])
			cylinder(r = 37/2, h = 16+50+10);
		hull() {
			translate([-7,0,16-1])
				cylinder(r = 37/2, h = 1+50-3);

			translate([-7,0,16-1])
				cylinder(r = (37+6)/2, h = 1+50-3-3);

			cylinder(r = 40/2, h = 30+3);
			translate([-78+46.6, 0, 0])
				cylinder(r = 40/2, h = 30-3);
		}
	}
*/



// vim: ft=c
