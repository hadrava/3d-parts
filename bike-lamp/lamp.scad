$fn=64;
eps=0.001;

part_mode = 0;
//part_mode = 99;
// normal sizes: 0, 1, 2, 3
// zejména 1 a 2 doporučuji
bar_mode = 1;

bar_radius = 15 - 1.5 * bar_mode;


open_angle = 10;
open_space = 1;

bar_width = 15;

bar_thickness = 2.5;
bar_screwholder_height = 6;
bar_screwholder_distance = 9;
bar_screwholder_corner_height = 12;


m4_head_hole = 9;
m4_nut_hole = 7.6;
m4_hole = 4.6;
m4_min_material_height = 4;


// Source: http://forum.openscad.org/not-valid-2-manifold-union-of-two-cubes-td21953.html
module rotate(angle) {           // built-in rotate is inaccurate for 90 degrees, etc
	a = len(angle) == undef ? [0, 0, angle] : angle;
	cx = cos(a[0]);
	cy = cos(a[1]);
	cz = cos(a[2]);
	sx = sin(a[0]);
	sy = sin(a[1]);
	sz = sin(a[2]);
	multmatrix([
			[ cy * cz, cz * sx * sy - cx * sz, cx * cz * sy + sx * sz, 0],
			[ cy * sz, cx * cz + sx * sy * sz,-cz * sx + cx * sy * sz, 0],
			[-sy,      cy * sx,                cx * cy,                0],
			[ 0,       0,                      0,                      1]
	]) children();
}

bridge_support_height = 0.2;

connector_count = 5;
connector_radius = 7.5;
connector_in_radius = bar_radius-1;
connector_pos = [-bar_radius - connector_radius - bar_thickness - 1,0,0];
connector_screw_inset = 1.5;
connector_clearance = 0.1;

module connector_bar(supports) {
	h = bar_width / connector_count;
	bridge_w = bar_radius + 7.5;
	bridge_l = -connector_pos[0] + connector_radius + 1;
	if (supports) {
		translate([-bridge_l-3+eps, -bridge_w/2, 0])
			cube([3, bridge_w, bar_width]);
		for (i = [0 : 2 : connector_count]) {
			clearance_height_begin = (i == 0) ? 0 : connector_clearance;
			clearance_height_end = (i == connector_count-1) ? 0 : connector_clearance;
			temp_h = h - clearance_height_begin - clearance_height_end;

			if (i != 0) {
				translate([0,0,h * i + clearance_height_begin])
					translate([-bridge_l, -bridge_w/2, 0])
					cube([bridge_l, bridge_w, bridge_support_height]);
			}
		}
		translate([0,0, connector_screw_inset-0.1])
			translate(connector_pos)
			cylinder(r=connector_radius, h=bridge_support_height);
	}
	difference() {
		union() {
			for (i = [0 : 2 : connector_count]) {
				clearance_height_begin = (i == 0) ? 0 : connector_clearance;
				clearance_height_end = (i == connector_count-1) ? 0 : connector_clearance;
				temp_h = h - clearance_height_begin - clearance_height_end;

				translate([0,0,h * i + clearance_height_begin]) {
					hull () {
						translate(connector_pos)
							cylinder(r=connector_radius, h=temp_h);
						cylinder(r=connector_in_radius, h=temp_h);
					}
				}
			}
		}

		translate(connector_pos) {
			translate([0,0,-1])
				cylinder(r=m4_hole/2, h=bar_width+2);
			translate([0,0,-connector_screw_inset])
				cylinder(r=m4_head_hole/2, h=2*connector_screw_inset);
			translate([0,0,bar_width-connector_screw_inset])
				cylinder(r=m4_nut_hole/2, h=2*connector_screw_inset, $fn=6);
		}
	}
}


inset = 3*connector_radius-4;
module connector_lamp() {
	difference() {
		union() {
			h = bar_width / connector_count;
			for (i = [1 : 2 : connector_count-1]) {
				temp_h = h - 2*connector_clearance;

				translate([0,0,h * i + connector_clearance])
					hull () {
						cylinder(r=connector_radius, h=temp_h);
						translate([-inset, -inset,0])
							cylinder(r=connector_radius, h=temp_h);
						translate([-inset, inset,0])
							cylinder(r=connector_radius, h=temp_h);
					}
			}
		}

		translate([0,0,-1])
			cylinder(r=m4_hole/2, h=bar_width+2);

		translate([-2*inset,-2*inset,-1])
			cube([inset*3/2,4*inset,bar_width +2]);
	}
}



module bar_screw_base(hole_d, hole_fn) {
	difference() {
		hull() {
			translate([-open_space, -bar_screwholder_distance - bar_radius, bar_width/2])
				rotate([0, -90, 0])
				cylinder(r=bar_width/2, h=bar_screwholder_height);

			intersection(){
				cylinder(r=bar_radius+bar_thickness, h=bar_width);
				translate([-open_space - bar_screwholder_corner_height, -(bar_thickness+bar_radius+1),  -1])
					cube([bar_screwholder_corner_height, bar_thickness+bar_radius+1, bar_width+2]);
			}
		}
		srew_hole_height = bar_screwholder_height + bar_screwholder_corner_height + 2;
		translate([0, -bar_screwholder_distance - bar_radius, bar_width/2])
			rotate([0, -90, 0]) {
				cylinder(r=m4_hole/2, h=srew_hole_height);
				translate([0, 0, open_space + m4_min_material_height])
					cylinder(r=hole_d/2, h=srew_hole_height, $fn=hole_fn);
			}
	}
}

module bar_left() {
	bar_screw_base(m4_nut_hole, 6);
}

module bar_right() {
	translate([0, 0, bar_width])
		rotate([0,180,0])
		bar_screw_base(m4_head_hole, $fn);
}

module bar(supports=0) {
	translate(-connector_pos)
		difference() {
			union() {
				cylinder(r=bar_radius+bar_thickness, h=bar_width);
				rotate([0,0,-open_angle/2])
					bar_left();
				rotate([0,0,open_angle/2])
					bar_right();
				connector_bar(supports);
			}
			translate([0,0,-1])
				cylinder(r=bar_radius, h=bar_width+2);

			hull() {
				temp_y = bar_radius + bar_thickness + bar_width/2 + bar_screwholder_distance;

				rotate([0,0,-open_angle/2])
					translate([-open_space, -temp_y, -1])
					cube([open_space, temp_y, bar_width+2]);
				rotate([0,0,open_angle/2])
					translate([0, -temp_y, -1])
					cube([open_space, temp_y, bar_width+2]);
			}
			for (a = [-1:2:1]) {
				rotate([0,0,a*open_angle/2])
					translate([0,-bar_radius/2,0])
					rotate([0,0,45])
					translate([-bar_radius/2,-bar_radius/2,-1])
					cube([bar_radius, bar_radius, bar_width+2]);
			}
		}
}



module lamp() {
	connector_lamp();
}


if (part_mode == 0) {
	bar();
	lamp();
}
if (part_mode == 1) {
	bar(1);
}
if (part_mode == 2) {
	lamp();
}
if (part_mode == 99) {
	intersection() {
		bar();
		translate([-50, -bar_screwholder_distance - bar_radius, -50])
			cube([100, 1, 100]);
	}
}

// vim: ft=c
