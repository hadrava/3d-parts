spindle_diameter = 14;
support_diameter = 32;
stand_diameter = 60;


module ring(r_outer, r_inner, height) {
  difference() {
    cylinder(h = height, r=r_outer, $fn=64);
    translate([0, 0, -1])
      cylinder(h = height+2, r=r_inner, $fn=64);
  }
}

module stand() {
  for (i=[0:2]) {
    rotate(60*i)
      translate([-(stand_diameter-2)/2, -1,0])
      cube(size=[stand_diameter-2,2,2]);
  }
}

module support() {
  ring(support_diameter/2, (support_diameter/2)-1.5, 8);
}
module spindle() {
  ring(spindle_diameter/2, (spindle_diameter/2)-1.5, 20);
}

difference() {
  union() {
    stand();
    support();
    spindle();
  }
  translate([0, 0, -1])
    cylinder(h = 2+2, r=(spindle_diameter/2)-1.5, $fn=64);
}
