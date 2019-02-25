$fn=64;

sphere_diam = 8.3;
sphere_outer_dist = 12.4;

sphere_scale = 0.8;

cylinder_diam = 2.6;
cylinder_outer_dist = 9.5;

cut_width = 0.8;

rotate([0, -90, 0]) {
	difference() {
		hull() {
			translate([0, 0, (sphere_outer_dist - sphere_diam*sphere_scale)/2])
				scale([1, 1, sphere_scale])
				sphere(r = sphere_diam/2);
			translate([0, 0, -(sphere_outer_dist - sphere_diam*sphere_scale)/2])
				scale([1, 1, sphere_scale])
				sphere(r = sphere_diam/2);
		}


		translate([0, -cut_width/2, -(sphere_outer_dist + 2)/2])
			cube([sphere_diam, cut_width, sphere_outer_dist + 2]);

		hull() {
			translate([0, (sphere_diam+2)/2, -(cylinder_outer_dist - cylinder_diam)/2])
				rotate([90, 0, 0])
				cylinder(r = cylinder_diam/2, h = sphere_diam+2);
			translate([0, (sphere_diam+2)/2, +(cylinder_outer_dist - cylinder_diam)/2])
				rotate([90, 0, 0])
				cylinder(r = cylinder_diam/2, h = sphere_diam+2);
		}

		hull() {
			translate([(sphere_diam+2)/2, 0, -(cylinder_outer_dist - cylinder_diam)/2])
				rotate([0, -90, 0])
				cylinder(r = cylinder_diam/2, h = sphere_diam+2);
			translate([(sphere_diam+2)/2, 0, +(cylinder_outer_dist - cylinder_diam)/2])
				rotate([0, -90, 0])
				cylinder(r = cylinder_diam/2, h = sphere_diam+2);
		}
	}
}

// vim: ft=c
