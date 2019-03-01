$fn=64;

/*
 * Part mode can be:
 *  0: whole object as one part
 *  1: split object, all parts present
 *  2: just one part specified by parameters part_x and part_y
 */
part_mode = 0;
part_x = 1;
part_y = 1;


/*
 * Model parameters
 */

bw = 240; // board width
bl = 330; // board length
bh = 0.6; // board depth

wall_width  = 4;
wall_height = 15;
end_fillet  = 0;
wall_fillet = 2;

hole_width  = 30;
hole_fillet = 6;
segment_count = 3; // number of wall segments (= hole_count + 1)

slot_count = 7;
slot_width = (bw - wall_width) / slot_count - wall_width;
echo("slot_width:", slot_width);

// options for print splits:
print_split_x = 3;
print_split_y = 2;
print_split_x_teeth_count = 12;
print_split_y_teeth_count = 11;

// how many slots should be split in half:
twin_mode = 2;

/*
 * Cube with fillets
 */
module cube_lower_outer_fillet(x, y, z, depth, f1, f2, f3, f4) {
	//
	//  +--------------------------------+
	//  |    |          f3          |    |
	//  |----+----------------------+----|
	//  |    |                      |    |
	//  |    |                      |    |
	//  | f4 |                      |    |  y
	//  |    |                      |    |
	//  |    |                      | f2 |
	//  |    |                      |    |
	//  |----+----------------------+----|
	//  |    |         f1           |    |
	//  +--------------------------------+
	//             f4 + x + f2
	total_x = f4 + x + f2;
	total_y = f1 + y + f3;


	translate([-f4, -f1, 0])
		difference(){
			translate([0, 0, -depth])
				cube([total_x, total_y, z+depth]);

			// f1
			translate([-1, -f1, f1])
				cube([total_x + 2, 2*f1, z]);
			translate([-1, 0, f1])
				rotate([0,90,0])
				cylinder(r = f1, h = total_x+2);

			// f3
			translate([-1, total_y - f3, f3])
				cube([total_x + 2, 2*f3, z]);
			translate([-1, total_y, f3])
				rotate([0,90,0])
				cylinder(r = f3, h = total_x+2);

			// f4
			translate([-f4, -1, f4])
				cube([2*f4, total_y + 2, z]);
			translate([0, -1, f4])
				rotate([-90,0,0])
				cylinder(r = f4, h = total_y+2);

			// f2
			translate([total_x-f2, -1, f2])
				cube([2*f2, total_y + 2, z]);
			translate([total_x, -1, f2])
				rotate([-90,0,0])
				cylinder(r = f2, h = total_y+2);
		}
}


/*
 * Separator between two slots, it consists of segment_count segments
 */
module separator(left_fillet, right_fillet, sc) {
	for (i = [0 : segment_count - 1]) {
		translate([
				bl / sc * i + hole_width/2 * sign(i),
				0,
				0
		])
			cube_lower_outer_fillet(
					bl / sc - hole_width/2 * sign(i) - hole_width/2 * sign(segment_count - 1 - i), // x
					wall_width, // y
					wall_height, // z
					bh/2, // depth
					wall_fillet, // f1
					hole_fillet * sign(segment_count - 1 - i), // f2
					wall_fillet, // f3
					hole_fillet * sign(i) // f4
					);
	}
}


module whole_model() {
	// base plane
	translate([0,0,-bh])
		cube([bl, bw, bh]);


	// Walls
	//	                        x            y  z            depth f1   f2   f3   f4
	// outer wall 4
	translate([0, 0, 0])
		cube_lower_outer_fillet(wall_width, bw, wall_height, bh/2, 0,end_fillet,0,0);

	// outer wall 2
	translate([bl-wall_width, 0, 0])
		cube_lower_outer_fillet(wall_width, bw, wall_height, bh/2, 0,0,0,end_fillet);

	// outer wall 1
	translate([0, 0, 0])
		cube_lower_outer_fillet(bl, wall_width, wall_height, bh/2, 0,0,wall_fillet,0);

	// outer wall 3
	translate([0, bw-wall_width, 0])
		cube_lower_outer_fillet(bl, wall_width, wall_height, bh/2, wall_fillet,0,0,0);

	// Inner separators
	for (i = [1 : slot_count - 1]) {
		translate([
				0,
				(bw - wall_width)  * i / slot_count,
				0
		])
			separator(wall_fillet, wall_fillet, segment_count);
	}

	// twin mode middle separator
	translate([(bl-wall_width)/2, 0, 0])
		cube_lower_outer_fillet(wall_width, bw * twin_mode / slot_count, wall_height, bh/2, 0,end_fillet,0,end_fillet);
}


/*
 * reverse (v): reverse vector v
 */

function reverse (v, i = 0) =
	len(v) > i ?
		concat(reverse(v, i + 1), [v[i]]) :
		[]
;

/*
 * Helper module for cutting whole model
 */
module print_cut(part_x, part_y) {
	// Definition of cut points orthogonal to x axis
	function cut_x(cut_x_index, part_y) =
		(cut_x_index == 0 ) || (cut_x_index == print_split_x) ? [
			[bl/print_split_x * cut_x_index, bw/print_split_y * (part_y - 1)],
			[bl/print_split_x * cut_x_index, bw/print_split_y * part_y],
		]
		: [
			for (i = [1 : print_split_x_teeth_count])
				for  (pt = [
					[bl/print_split_x * cut_x_index,                                                    bw/print_split_y * (part_y - 1) + bw/print_split_y / print_split_x_teeth_count * (i - 1)],
					[bl/print_split_x * cut_x_index + bw/print_split_y / print_split_x_teeth_count / 4, bw/print_split_y * (part_y - 1) + bw/print_split_y / print_split_x_teeth_count * (i - 1) + bw/print_split_y / print_split_x_teeth_count * 0.25],
					[bl/print_split_x * cut_x_index - bw/print_split_y / print_split_x_teeth_count / 4, bw/print_split_y * (part_y - 1) + bw/print_split_y / print_split_x_teeth_count * (i - 1) + bw/print_split_y / print_split_x_teeth_count * 0.75],
					[bl/print_split_x * cut_x_index,                                                    bw/print_split_y * (part_y - 1) + bw/print_split_y / print_split_x_teeth_count * (i - 1) + bw/print_split_y / print_split_x_teeth_count],
				])
					pt
		]
	;

	// Definition of cut points orthogonal to y axis
	function cut_y(part_x, cut_y_index) =
		(cut_y_index == 0) || (cut_y_index == print_split_y) ? [
			[bl/print_split_x * (part_x - 1), bw/print_split_y * cut_y_index],
			[bl/print_split_x * part_x,       bw/print_split_y * cut_y_index],
		]
		: [
			for (i = [1 : print_split_y_teeth_count])
				for  (pt = [
					[bl/print_split_x * (part_x - 1) + bl/print_split_x / print_split_y_teeth_count  * (i - 1),                                                       bw/print_split_y * cut_y_index],
					[bl/print_split_x * (part_x - 1) + bl/print_split_x / print_split_y_teeth_count  * (i - 1) + bl/print_split_x / print_split_y_teeth_count * 0.25, bw/print_split_y * cut_y_index + bl/print_split_x / print_split_y_teeth_count / 4],
					[bl/print_split_x * (part_x - 1) + bl/print_split_x / print_split_y_teeth_count  * (i - 1) + bl/print_split_x / print_split_y_teeth_count * 0.75, bw/print_split_y * cut_y_index - bl/print_split_x / print_split_y_teeth_count / 4],
					[bl/print_split_x * (part_x - 1) + bl/print_split_x / print_split_y_teeth_count  * (i - 1) + bl/print_split_x / print_split_y_teeth_count,        bw/print_split_y * cut_y_index],
				])
					pt
		]
	;


	translate([0,0,-1])
		linear_extrude(height = bh + wall_height + 2)
		polygon(points = concat(
					cut_y(part_x, part_y - 1),
					cut_x(part_x, part_y),
					reverse(cut_y(part_x, part_y)),
					reverse(cut_x(part_x - 1, part_y))
				       ));
}


if (part_mode == 0) {
	whole_model();
}
if (part_mode == 1) {
	for (x = [1 : print_split_x]) {
		for (y = [1 : print_split_y]) {
			translate([x,y])
				intersection() {
					whole_model();
					print_cut(x, y);
				}
		}
	}
}
if (part_mode == 2) {
	intersection() {
		whole_model();
		print_cut(part_x, part_y);
	}
}





// vim: ft=c
