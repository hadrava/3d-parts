$fn=64;

module mill() {
	cylinder(r = 6/2, h = 16);
}

module motor() {
	cylinder(r = 6/2, h = 12);
}

module washer_without_hole() {
        cylinder(r = 18/2, h = 1.5);
}

module washer_with_cutout() {
        cylinder(r = 18/2, h = 1.5);
        translate([-9+0.2,0,0])
        cube([18-2*0.2, 18, 1.5]);
}

module washer() {
    difference() {
        washer_without_hole();
        translate([0,0,-0.25])
        cylinder(r = 6/2, h = 2);
    }
}

module holes() {

mill();
translate([0, 0, 18+6])
	motor();

translate([0,-2,18/2])
rotate([-90,0,180])
washer_with_cutout();

translate([0,2,18/2])
rotate([-90,0,0])
washer_with_cutout();

translate([0,2,18/2+18])
rotate([-90,0,0])
washer_with_cutout();
}

rotate([180,0,0])
difference() {
    cylinder(r = 22/2, h = 18*2);
    holes();
}

// vim: ft=c
