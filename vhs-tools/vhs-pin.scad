// vim: ft=c

$fn=100;

module pin() {
	union () {
		translate([-10,-10,0])
			cube([20,20,1.5]);
		translate([-2.5/2,-10,0.5])
			cube([2.5,20,2]);
		translate([0,0,0.5])
			cylinder(h=10.5, r=5.5/2);
	}
}

pin();
