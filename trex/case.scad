$fn=64;

display_electronics = false;
//display_electronics = true;
bottom_part = true;
//bottom_part = false;
pinheader_present = false;
//pinheader_present = true;
hook_present = false;
//hook_present = true;
render_text = true;
//render_text = false;
cable_hole_present = true;
//cable_hole_present = false;

arduino_width  = 17.7;
arduino_length = 43.4;
arduino_height = 1.6;

arduino_usb_width  = 8;
arduino_usb_length = 9;
arduino_usb_height = 4;
arduino_usb_offset = -1.5;

arduino_button_width  = 3;
arduino_button_length = 1.5;
arduino_button_height = 3;
arduino_button_offset = 25.5;

arduino_button_support = 5;
arduino_button_hat = 3;

arduino_corner = 2.5;

antenna_length = 32;
antenna_diameter = 5.8;
antenna_offset = -4;
antenna_side_offset = 1.1;

transmitter_width = 12;
transmitter_length = 15.5;
transmitter_height = 1;

receiver_width = 33.2;
receiver_length = 9.3;
receiver_height = 1;

support_height = 4;
box_thickness = 1.5;
box_width = 39;
box_length = 64;
box_cut = arduino_usb_height / 2 + arduino_height;
box_height_without_pinheader = 6;
box_height_with_pinheader = 12;
box_side_offset = -8.8;

mechanism_clearance = 0.1;

hook_hole_inner_r = 2.5;
hook_hole_outer_r = 3.25;
hook_hole_offset = 2;

cable_hole_height = 4.3;
cable_hole_width = 1;
cable_hole_offset = 2;
cable_hole_angle = 60;

cable_holder_diameter = 3;

box_height = pinheader_present ? box_height_with_pinheader : box_height_without_pinheader;

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

module side_holder(pcb_height, width, depth = 1, lock_size = 1.3, extra_height = 0) {
	translate([0, 0, -support_height])
		cube([width, depth, pcb_height + support_height + lock_size + extra_height]);
	translate([0, 0, pcb_height])
		rotate([45, 0, 0])
			cube([width, sqrt(2) * lock_size/2, sqrt(2) * lock_size/2]);
}

module arduino(mark_mounting_area = false) {
	// PCB
	cube([arduino_width, arduino_length, arduino_height]);
	// USB
	translate([(arduino_width - arduino_usb_width) / 2, arduino_usb_offset, arduino_height])
		cube([arduino_usb_width, arduino_usb_length, arduino_usb_height]);
	// Button
	translate([(arduino_width - arduino_button_width) / 2, arduino_button_offset, arduino_height])
		cube([arduino_button_width, arduino_button_length, arduino_button_height]);

	if (mark_mounting_area) {
		translate([0, 0, 0])
			#cube([arduino_corner, arduino_corner, arduino_height]);
		translate([0, arduino_length - arduino_corner, 0])
			#cube([arduino_corner, arduino_corner, arduino_height]);
		translate([arduino_width - arduino_corner, 0, 0])
			#cube([arduino_corner, arduino_corner, arduino_height]);
		translate([arduino_width - arduino_corner, arduino_length - arduino_corner, 0])
			#cube([arduino_corner, arduino_corner, arduino_height]);
	}
}

module arduino_support() {
	translate([0, 0, 0]) {
		translate([arduino_corner, 0, 0]) rotate([0, 0, 180])
			side_holder(arduino_height, arduino_corner, 1.5);
		rotate([0, 0, 90])
			side_holder(arduino_height, arduino_corner, 1.5);
		translate([0, 0, -support_height])
			cube([arduino_corner, arduino_corner, support_height]);
	}

	translate([0, arduino_length - arduino_corner, 0]) {
		translate([2, arduino_corner, 0])
			side_holder(arduino_height, arduino_width - 4, 1.5, 0, arduino_height);
		rotate([0, 0, 90])
			side_holder(arduino_height, arduino_corner, 1.5, 0.7);
		translate([0, 0, -support_height])
			cube([arduino_corner, arduino_corner, support_height]);
	}

	translate([arduino_width - arduino_corner, 0, 0]) {
		translate([arduino_corner, 0, 0]) rotate([0, 0, 180])
			side_holder(arduino_height, arduino_corner, 1.5);
		translate([arduino_corner, arduino_corner, 0]) rotate([0, 0, -90])
			side_holder(arduino_height, arduino_corner, 1.5);
		translate([0, 0, -support_height])
			cube([arduino_corner, arduino_corner, support_height]);
	}

	translate([arduino_width - arduino_corner, arduino_length - arduino_corner, 0]) {
		translate([arduino_corner, arduino_corner, 0]) rotate([0, 0, -90])
			side_holder(arduino_height, arduino_corner, 1.5, 0.7);
		translate([0, 0, -support_height])
			cube([arduino_corner, arduino_corner, support_height]);
	}

	// Button support
	translate([arduino_width / 2, arduino_button_offset + arduino_button_length / 2, -support_height])
		cylinder(r = arduino_button_support / 2, h = support_height);
}

module button_hat() {
	translate([arduino_width / 2, arduino_button_offset + arduino_button_length / 2, arduino_height + arduino_button_height])
		cylinder(r = arduino_button_hat / 2, h = box_height - (arduino_height + arduino_button_height));
}

module antenna() {
	translate([0, antenna_offset, 0])
		rotate([90, 0, 0])
		cylinder(r = antenna_diameter / 2, h = antenna_length);
}

module antenna_support(bottom_part = true) {
	difference() {
		z_offset = bottom_part ? -support_height : 0;
		z_height = bottom_part ? support_height : box_height;
		union() {
			translate([-antenna_diameter/2 - 1, antenna_offset - 1- antenna_length *4/5 , z_offset])
				cube([antenna_diameter + 2, 2, z_height]);
			translate([-antenna_diameter/2 - 1, antenna_offset - 1- antenna_length *1/5 , z_offset])
				cube([antenna_diameter + 2, 2, z_height]);
		}
		antenna();
	}
}

module transmitter(mark_mounting_area = false) {
	translate([antenna_side_offset-transmitter_width, 0, 0])
		cube([transmitter_width, transmitter_length, transmitter_height]);
	if (mark_mounting_area) {
		translate([-2+antenna_side_offset, transmitter_length - 2, 0])
			#cube([2, 2, receiver_height]);
		translate([-transmitter_width +antenna_side_offset, transmitter_length - 2, 0])
			#cube([2, 2, receiver_height]);
	}
}

module receiver(mark_mounting_area = false) {
	translate([antenna_side_offset-receiver_width, 0, 0])
		cube([receiver_width, receiver_length, receiver_height]);
	if (mark_mounting_area) {
		translate([-4+antenna_side_offset, 0, 0])
			#cube([2, 2, receiver_height]);
		translate([-transmitter_width -3 + antenna_side_offset, receiver_length - 1, 0])
			#cube([3, 1, receiver_height]);
		translate([-receiver_width + antenna_side_offset, 0, 0])
			#cube([1.5, 2, receiver_height]);
	}
}

module transciever_support() {
	translate([-2+antenna_side_offset, transmitter_length - 2, 0]) {
		translate([0, -8, 0]) translate([2, 2, 0]) rotate([0, 0, -90])
			side_holder(transmitter_height, 5, 1.5, 0, transmitter_height);
		translate([2, 2, 0]) rotate([0, 0, -90])
			side_holder(transmitter_height, 2, 1.5);
		translate([0, 0, -support_height])
			cube([2, 2, support_height]);
	}

	translate([-transmitter_width +antenna_side_offset, transmitter_length - 2, -0]) {
		rotate([0, 0, 90])
			side_holder(transmitter_height, 2, 1.5);
		translate([0, 0, -support_height])
			cube([2, 2, support_height]);
	}

	translate([-4+antenna_side_offset, 0, 0]) {
		translate([2, 0, 0]) rotate([0, 0, 180])
			side_holder(transmitter_height, 2, 1.5, 0.7);
		translate([0, 0, -support_height])
			cube([2, 2, support_height]);
	}

	translate([-transmitter_width + antenna_side_offset, 0, 0]) {
		translate([2, 0, 0]) rotate([0, 0, 180])
			side_holder(arduino_height, 3, 1.5, 0, transmitter_height);
	}

	translate([-transmitter_width -3 + antenna_side_offset, receiver_length - 1, 0]) {
		translate([0, 1, 0])
			side_holder(arduino_height, 3, 1.5, 0.7);
		translate([0, 0, -support_height])
			cube([3, 1, support_height]);
	}

	translate([-receiver_width - 1.5  + antenna_side_offset, receiver_length - 1, 0]) {
		translate([0, 1, 0])
			side_holder(arduino_height, 4, 1.5, 0, transmitter_height);
	}

	translate([-receiver_width + antenna_side_offset, 0, 0]) {
		rotate([0, 0, 90])
			side_holder(transmitter_height, 2, 1.5);
		translate([0, 0, -support_height])
			cube([1.5, 2, support_height]);
		translate([1.5, 0, 0]) rotate([0, 0, 180])
			side_holder(arduino_height, 1.5 + 1.5, 1.5, 0, transmitter_height);
	}
}

module trex_text() {
	font="Liberation Serif";
	scale([0.9, 0.9, 1])
		linear_extrude(box_thickness * 2)
			text("T.REX", font = font, halign="center");
}

module side_catcher(width, depth, lock_only = false, lock_size = 1.3) {
	z_off = -2;
	if (!lock_only) {
		translate([0, 0, z_off])
			cube([width, depth, box_height - z_off]);
	}
	translate([0, 0, z_off])
		rotate([45, 0, 0])
			cube([width, sqrt(2) * lock_size/2, sqrt(2) * lock_size/2]);
}

module box_mechanism(lock_only = true) {
	x_off = box_side_offset;
	z_off = box_cut - 2;
	cx = 1.5; // corner_size_x
	cy = 3; // corner_size_y
	clearance = lock_only ? 0 : mechanism_clearance;
	depth = 1.5;

	// A
	translate([x_off + clearance,                  clearance,                   0])
		side_catcher(6 - 2*clearance, depth, lock_only);
	// B
	translate([x_off + box_width - 10 + clearance, clearance,                   0])
		side_catcher(10 - 2*clearance, depth, lock_only);
	// D
	translate([x_off + 20 - clearance,             box_length - clearance,      0])
		rotate([0, 0, 180])
			side_catcher(20 - 2*clearance, depth, lock_only);

	if (!lock_only) {
		// C
		translate([x_off + box_width - cx - clearance, box_length - cy - clearance, z_off])
			cube([cx, cy, box_height - z_off]);

		// A
		translate([x_off,                              0,                           box_cut])
			cube([6 + clearance,                  depth + clearance,           box_height - box_cut]);
		// B
		translate([x_off + box_width - 10 - clearance, 0,                           box_cut])
			cube([10 + clearance,                 depth + clearance,           box_height - box_cut]);
		// D
		translate([x_off,                              box_length - depth - clearance, box_cut])
			cube([20 + clearance,                 depth + clearance,           box_height - box_cut]);
		// C
		translate([x_off + box_width - cx - clearance, box_length - cy - clearance, box_cut])
			cube([cx + clearance,                 cy + clearance,              box_height - box_cut]);
	}
}

module box(bottom_part = true) {
	holes = !bottom_part;
	difference() {
		if (bottom_part) {
			translate([box_side_offset - box_thickness, - box_thickness, -support_height - box_thickness])
				cube([box_width + 2 * box_thickness, box_length + 2 * box_thickness, support_height + box_cut + box_thickness]);
		}
		else {
			translate([box_side_offset - box_thickness, - box_thickness, box_cut])
				cube([box_width + 2 * box_thickness, box_length + 2 * box_thickness, box_height - box_cut + box_thickness]);
		}
		// Inner space
		translate([box_side_offset, 0, -support_height])
			cube([box_width, box_length, support_height + box_height]);
		// USB hole
		translate([(arduino_width - arduino_usb_width) / 2, arduino_usb_offset - box_thickness, arduino_height])
			cube([arduino_usb_width, arduino_usb_length, arduino_usb_height]);
		if (holes) {
			// Cover holes
			translate([box_side_offset, 0, -support_height - box_thickness * 2]) {
				l_steps = 10;
				j_start = render_text ? 2 : 0;
				for (j = [j_start: 2: l_steps - 1]) {
					eps = 0.01;
					for (i = [0,1,2,3,  6,7,8,9]) {
						translate([box_width / 11 * i + box_width / 11 / 2 - eps, box_length / l_steps * j + box_length / l_steps / 4, 0])
							cube([box_width / 11 + eps, 2.5, support_height + box_height + box_thickness * 4]);
					}
					for (i = [0,1,  3,4,5,6,  8,9]) {
						translate([box_width / 11 * i + box_width / 11 / 2 - eps, box_length / l_steps * (j + 1) + box_length / l_steps / 4, 0])
							cube([box_width / 11 + eps, 2.5, support_height + box_height + box_thickness * 4]);
					}
				}
			}
		}
		if (bottom_part) {
			box_mechanism(bottom_part);
			if (cable_hole_present) {
				translate([box_side_offset, cable_hole_offset, box_cut - cable_hole_height])
					rotate([0, 0, cable_hole_angle])
						translate([-10, 0, 0])
							cube([20, cable_hole_width, cable_hole_height + 1]);
			}
		}
		else {
			if (render_text) {
				translate([box_side_offset + box_width / 2, 2.2, box_height + box_thickness / 2])
					trex_text();
			}
		}
	}
}

module hook() {
	translate([box_side_offset - box_thickness, box_length, -support_height - box_thickness]) {
		difference() {
			hull() {
				cube([box_width + 2 * box_thickness, box_thickness, box_thickness]);
				translate([box_width / 2 + box_thickness, hook_hole_outer_r + hook_hole_offset])
					cylinder(r = hook_hole_outer_r, h = box_thickness);
			}
			translate([box_width / 2 + box_thickness, hook_hole_inner_r + hook_hole_offset])
				cylinder(r = hook_hole_inner_r, h = box_thickness);
		}
	}
}

module cable_holder() {
	for (i = [0: 3]) {
		translate([box_side_offset + cable_holder_diameter / 2 + cable_hole_width, 4 + i * (cable_holder_diameter + cable_hole_width), -support_height])
			cylinder(r = cable_holder_diameter / 2, h = support_height + box_cut);
	}
}

module everything() {
	if (display_electronics) {
		arduino(true);
	}

	if (bottom_part) {
		arduino_support();
		if (hook_present) {
			hook();
		}
		if (cable_hole_present) {
			cable_holder();
		}
	}
	else {
		button_hat();
		box_mechanism(false);
	}

	translate([arduino_width / 2 + receiver_width /2, arduino_length + 5, 0])
		union() {
			if (display_electronics) {
				transmitter(true);
				receiver(true);
				antenna();
			}
			antenna_support(bottom_part);
			if (bottom_part) {
				transciever_support();
			}
		};

	box(bottom_part);
}


if (bottom_part) {
	everything();
}
else {
	rotate([180, 0, 0])
		everything();
}


// vim: ft=c
