// vim: ft=c

$fn=100;

module ring(r_outer, r_inner, height) {
	difference() {
		cylinder(h = height, r=r_outer);
		translate([0, 0, -1])
			cylinder(h = height+2, r=r_inner);
	}
}

module rewinder() {
	ring(13/2, 11/2, 26);
	for (i = [0:8]) {
		rotate([0,0,40*i])
			translate([13/2-0.5,-1,0])
				cube([2.5, 2, 26]);
	}
}

rewinder();
