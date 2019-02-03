$fn=80;
con = 30;
svg = 0;

board_x = 126;
board_y = 120;
board_z = 2.1;

hole_x_spacing = 2;

inner_diam_enlarge = 0.3;


module holes(start_i, step_i, end_i, x, y, dir_x, dir_y) {
	for (i = [start_i : step_i: end_i]) {
		sum_i = (i + start_i) * (i - start_i + 1) / 2;
		off_x = x + (sum_i + hole_x_spacing * (i - start_i)) * dir_x;
		off_y = y + (i - start_i)/2 * dir_y;
		translate([off_x, off_y, -1])
			cylinder(r = (i+inner_diam_enlarge)/2, h = board_z + 2);

	}
}

module hole_text(start_i, step_i, end_i, x, y, dir_x, dir_y) {
	for (i = [start_i : step_i: end_i]) {
		sum_i = (i + start_i) * (i - start_i + 1) / 2;
		off_x = x + (sum_i + hole_x_spacing * (i - start_i)) * dir_x;
		off_y = y + (i - start_i)/2 * dir_y;
		translate([off_x, off_y, 0.5])
			text(text = str(i), size = i/2, halign = "center", valign = "center");
	}
}

module board() {
	difference() {
		cube([board_x, board_y, board_z]);
		holes(3, 1, 13, 5, 4, 1, 1);
		holes(14, 1, 19, 125, 25, -1, -2);

		holes(16, 2, 24, 116, 42, -0.5, 0.5);
		holes(20, 1, 20, 17, 69, 0, 0);
		holes(26, 2, 30, 31, 70, 0.5, -1.5);
		holes(32, 2, 36, 113, 100, -0.5, -0.5);
	}
}



if (svg == 1) {
	scale(96/25.4) {
	projection()
		board();
	hole_text(3, 1, 13, 5, 4, 1, 1);
	hole_text(14, 1, 19, 125, 25, -1, -2);

	hole_text(16, 2, 24, 116, 42, -0.5, 0.5);
	hole_text(20, 1, 20, 17, 69, 0, 0);
	hole_text(26, 2, 30, 31, 70, 0.5, -1.5);
	hole_text(32, 2, 36, 113, 100, -0.5, -0.5);
	}
}
else {
	board();
}



// vim: ft=c
