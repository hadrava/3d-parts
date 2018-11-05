// vim: ft=c

$fn=100;

cable_count = 1;
width = 10;
height = 1.5;
base_height = 2.5;
spacing = 1;
epsilon = 0.1;
gap_angle = 52;

holder_count = 4;

hole_r_inner = 2;
hole_r_outer = 5;
hole_distance = 10;

// CAT 5e:
diameter = 5.1;

// CAT 6A:
//diameter = 6.73;
//diameter = 7.62;
//diameter = 9;


module ring(r_outer, r_inner, height) {
	difference() {
		cylinder(h = height, r=r_outer);
		translate([0, 0, -1])
			cylinder(h = height+2, r=r_inner);
	}
}

module holder() {
	difference() {
		ring(diameter/2+height, diameter/2, width);
		intersection() {
			rotate([0, 0, gap_angle])
				translate([0, -(diameter/2 + height + 1), -1])
				cube([diameter/2 + height + 1, diameter + 2*height + 2, width+2]);
			rotate([0, 0, 180 - gap_angle])
				translate([0, -(diameter/2 + height + 1), -1])
				cube([diameter/2 + height + 1, diameter + 2*height + 2, width+2]);
		}
	}
}

module holder_with_base() {
	translate([-diameter/2 - height - epsilon, 0, 0])
		cube([diameter + 2*height + spacing + epsilon, width, base_height]);
	translate([0, 0, diameter/2 + base_height + height/2])
		rotate([90, 0, 180])
			holder();
}

module base() {
	translate([-diameter/2 - height, 0, 0])
		cube([diameter + 2*height + spacing + epsilon, width, base_height]);
}

module base_with_hole(length) {
	difference() {
		union() {
			translate([-epsilon, 0, 0])
				cube([length + epsilon + hole_r_outer, width, base_height]);
			translate([length, width/2, 0])
				cylinder(h = base_height, r = hole_r_outer);
		}
		translate([length, width/2, -1])
			cylinder(h = base_height + 2, r = hole_r_inner);
	}
}


module everything() {
    union() {

shift = diameter + 2*height + spacing;
half_shift = diameter/2 + height + spacing;
for (i = [0:holder_count - 1]) {
	translate([-shift * i - half_shift, 0, 0])
	holder_with_base();
}

base_with_hole(hole_distance);
}
}
rotate([90,0,90])
everything();

