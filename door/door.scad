$fn=64;

module half_sphered(d, r1, r2, h) {
	difference() {
		hull() {
			translate([-d/2, 0, 0])
				cylinder(r=r1, h=h);
			translate([d/2, 0, 0])
				cylinder(r=r2, h=h);
		}
		translate([-(r1 + r2 + d), 0, -h])
			cube([(r1 + r2 + d)*3, (r1 + r2 + d)*3, 3*h]);
	}
}

half_sphered(18, 3, 3, 75);

module side(sig) {
    translate([sig*18/2, 0, 0])
        rotate([0, 0, sig*96])
            translate([sig*10/2, 0, 0])
                half_sphered(10, 3.5 - 0.5*sig, 3.5 + 0.5*sig, 75);
}

side(1);
side(-1);

// vim: ft=c
