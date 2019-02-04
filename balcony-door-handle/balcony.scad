$fn=64;
con = 30;

part_mode = 0;

s_fillet  = 1.5;
l_fillet  = 3;
lb_fillet = 3.5;

height   = 70;
b_height = 71;

depth = 8;
width = 12.5;
extra_width = 4;

i_height = 66.5;
i_depth = 6;
i_hole_depth = 2;
i_hole_height = 1.8;
i_cut = 1;


module upper_toroid() {
	rotate_extrude(convexity = con)
		translate([l_fillet - s_fillet, 0, 0])
		circle(r = s_fillet);
}

module lower_toroid() {
	rotate_extrude(convexity = con)
		translate([lb_fillet - s_fillet, 0, 0])
		circle(r = s_fillet);
}

module corner_tower() {
	hull() {
		translate([0,0,depth-s_fillet])
			upper_toroid();
		intersection() {
			lower_toroid();
			translate([-lb_fillet, -lb_fillet,0])
				cube([2*lb_fillet, 2*lb_fillet, s_fillet]);
		}
	}
}


module base_block() {
translate([0,-height/2+l_fillet,0])
	hull() {
		corner_tower();
		translate([width+extra_width,0,0])
			corner_tower();
		translate([width+extra_width,height-2*l_fillet,0])
			corner_tower();
		translate([0,height-2*l_fillet,0])
			corner_tower();
	}
}

module cover() {


rotate([90,0,90])
/*
 * 13                                                                 12
 *
 *
 *        5                                                   6
 *     4                                                         7
 *
 *     3     2                                           9       8
 *
 * 0         1                                           10           11
 *
 */
linear_extrude(height = width)

polygon(points=[
    [-b_height/2-1, -1], [-i_height/2 + i_hole_height, -1], [-i_height/2 + i_hole_height, i_hole_depth], // 0, 1, 2
     [-i_height/2, i_hole_depth], [-i_height/2, i_depth - i_cut], [-i_height/2 + i_cut, i_depth], // 3, 4, 5

     [+i_height/2 - i_cut, i_depth], [+i_height/2, i_depth - i_cut], [+i_height/2, i_hole_depth],  // 6, 7, 8
    [+i_height/2 - i_hole_height, i_hole_depth], [+i_height/2 - i_hole_height, -1], [+b_height/2+1, -1], // 9 10, 11
    [+b_height/2+1, depth + 1], [-b_height/2-1, depth + 1], // 12, 13
]);
}

hole_diam = 4.5;
hole_head_diam = 8;
hole_depth_head = 1;
hole_depth_head_end=3;
epsilon = 0.002;
hole_distance = 42.5;
module hole() {
    translate([0,0,-1])
    cylinder(r=hole_diam/2, h = i_depth+2);
    
    translate([0,0,i_depth-hole_depth_head])
    cylinder(r=hole_head_diam/2, h = hole_depth_head+1);
    
    translate([0,0,i_depth-hole_depth_head_end])
    cylinder(r1=hole_diam/2, r2=hole_head_diam/2, h = hole_depth_head_end - hole_depth_head + epsilon);
}


module full_base() {
difference() {
    base_block();
    cover();
    translate([width/2, hole_distance/2,0])
    hole();
    translate([width/2, -hole_distance/2,0])
    hole();
    translate([width+extra_width,-b_height,-1])
        cube([lb_fillet+1,2*b_height,depth+2]);
}
}

handle_hold_width = 1;

handle_offset = width + extra_width - handle_hold_width;
module handle_holder() {
    translate([-handle_offset,0,0])
difference() {
    base_block();
    cover();

    translate([width+extra_width,-b_height,-1])
        cube([lb_fillet+1,2*b_height,depth+2]);
    translate([-100,-b_height,-1])
        cube([width + extra_width - handle_hold_width + 100, 2*b_height,depth+2]);
}
}

handle_tower_pos = 18;

handle_fillet = 9;
handle_angle = -10;
handle_xs_fillet = 0.4;
module handle() {
translate([handle_offset,0,0])
    difference() {
    hull () {
        handle_holder();
        
        rotate([0,handle_angle,0])
        translate([handle_tower_pos, height/2 -handle_fillet,0])
            handle_tower();     
        rotate([0,handle_angle,0])   
        translate([handle_tower_pos, -height/2 +handle_fillet,0])
            handle_tower();
    }
    
    

for (i = [-1 : 1]) {
translate([16,i*15,2])
rotate([0,-6,0])
scale([1.5, 2, 0.5])
  sphere(r = 10);
}
}
}

module handle_upper_toroid() {
	rotate_extrude(convexity = con)
		translate([handle_fillet - s_fillet, 0, 0])
		circle(r = s_fillet);
}
module handle_lower_toroid() {
	rotate_extrude(convexity = con)
		translate([handle_fillet - handle_xs_fillet, 0, 0])
		circle(r = handle_xs_fillet);
}
module handle_tower() {
translate([0,0,depth-s_fillet])
  hull() {
handle_upper_toroid();
translate([0,0,-3])
handle_lower_toroid();
}  
}


module full() {
union () {
full_base();
handle();
}
}

module enforced_part() {
intersection() {
full();
    
translate([3,-50,-2])
rotate([0,65,0])
cube([100,100, 201]);

}
}

module light_part() {
difference() {
full();
    
translate([3,-50,-2])
rotate([0,65,0])
cube([100,100, 201]);

}
}

if (part_mode == 0) {
	rotate([0,0,-90])
	full();
}
if (part_mode == 1) {
	rotate([0,0,-90])
	light_part();
}
if (part_mode == 2) {
	rotate([0,0,-90])
	enforced_part();
}


// vim: ft=c
