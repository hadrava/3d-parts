difference() {
	union() {
		linear_extrude(height = 1)
			polygon(
				points=[ [0,3],[3,0],[15,0],[15,35],[3,35],[0,32] ],
				paths=[[0,1,2,3,4,5]]
			);

		linear_extrude(height = 2.5)
			polygon(
				points=[ [11.5,0],[15,0],[15,35],[11.5,35] ],
				paths=[[0,1,2,3]]
			);

		linear_extrude(height = 4)
			polygon(
				points=[
					[11.5,0],[15,0],[15,12.6],[11.5,12.6],
					[11.5,32.6],[15,32.6],[15,35],[11.5,35]
					],
				paths=[[0,1,2,3], [4,5,6,7]]
			);

		linear_extrude(height = 2)
			polygon(
				points=[
					[6.5,12.6],[8.5,12.6],[8.5,35],[6.5,35]
					],
				paths=[[0,1,2,3]]
			);

		linear_extrude(height = 4)
			polygon(
				points=[
					[6.5,22.6],[8.5,22.6],[8.5,35],[6.5,35]
					],
				paths=[[0,1,2,3]]
			);
	}

	translate([4.35, 5.95, -1])
		cylinder(h = 3, r=1.7, $fn=64);
}
