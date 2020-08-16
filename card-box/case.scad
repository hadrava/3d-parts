$fn=64;

part_mode = 0;

c_width = 67.5;
c_height = 95.5;
c_depth = 30;
c_wall1 = 1.25;
c_wall2 = 1.25;
c_bottom = 2.5;
top_clearance = 0.1;

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

module side_catcher(width, depth, lock_size = 4.3) {
	z_off = -c_bottom;
	box_height = 10;
    lock_move = 3;
	rotate([0,0,90]) {
		translate([-width/2, 0, z_off])
			cube([width, depth, box_height - z_off]);
		translate([-width/2, 0 , -c_bottom*0.75-lock_move])
			rotate([45, 0, 0])
			cube([width, sqrt(2) * lock_size/2, sqrt(2) * lock_size/2]);
	}
}

module base() {
	translate([-c_width/2, -c_height/2, -c_bottom])
		cube([c_width, c_height, c_bottom]);
}

module side_inner(length, shift, clearance) {
	sx = c_depth;
	sy = 1.5;
	my = length/2 / sy;
	rotate([0,-90,0])
		linear_extrude(height=c_wall1+clearance)
		polygon(
				[for (a=[-my:0.1:my]) [sx/(1+exp(shift-a)) + sx/(1+exp(a+shift)), sy*a], [-c_bottom,my*sy], [-c_bottom, -my*sy]]
		       );
}

module side_outer(length, shift) {
	sx = c_depth;
	sy = 1.5;
	my = length/2 / sy;
	translate([0,0,-c_bottom/2])
		rotate([0,-90,0])
		linear_extrude(height=c_wall1)
		polygon(
				[for (a=[-my:0.1:my]) [sx/(1+exp(shift-a)) + sx/(1+exp(a+shift)), sy*a], [-c_bottom/2,my*sy], [-c_bottom/2, -my*sy]]
		       );
}

module half_side(clearance) {
	difference() {
		union() {
			// inner
			translate([-c_width/2, 0, 0])
				side_inner(c_height+2*c_wall1, c_height/6-clearance, clearance);
			rotate([0,0,-90])
				translate([-c_height/2, 0, 0])
				side_inner(c_width+2*c_wall1, c_width/6-clearance, clearance);

			// outer
			translate([-c_width/2 - c_wall1, 0, 0])
				side_outer(c_height+2*(c_wall1 + c_wall2), c_height/6+c_bottom/2-clearance);
			rotate([0,0,-90])
				translate([-c_height/2 - c_wall1, 0, 0])
				side_outer(c_width+2*(c_wall1 + c_wall2), c_width/6 +c_bottom/2-clearance);
		}
		translate([-c_width/2 - c_wall1, 0, 0])
			side_catcher(c_height*0.35 - 2*clearance, c_wall2);
	}
}

module bottom(clearance = 0) {
	half_side(clearance);
	rotate([0,0,180])
		half_side(clearance);
	base();
}

module top() {
	wi = c_width + 2*c_wall1 + 2*c_wall2;
	he = c_height + 2*c_wall1 + 2*c_wall2;
	difference() {
		translate([-wi/2, -he/2, -c_bottom])
			cube([wi, he, c_bottom * 2 + c_depth]);
		translate([-c_width/2, -c_height/2, -2*c_bottom])
			cube([c_width, c_height, c_bottom * 2 + c_depth]);
		bottom(top_clearance);
	}
}


if (part_mode == 0) {
	bottom();
	translate([0, 0, 100])
		top();
}
if (part_mode == 1) {
	bottom();
}
if (part_mode == 2) {
	translate([100, 0, 0])
		rotate([180, 0, 0])
		top();
}if (part_mode == 99) {
    intersection() {
    translate([-200, 0, -200])
    cube([400,1,400]);
        union() {
	bottom();
	translate([0, 0, 10])
		top();
        }
    }
}

// vim: ft=c
