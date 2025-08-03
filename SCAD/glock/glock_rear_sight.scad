difference() {
	union() {
		//main body
		translate([0, 0, 9.2 / 2]) cube([13, 7, 9.2], center = true);
		//slide footprint
		hull() {
			cube([18, 5.5, 0.01], center = true);
			translate([0, 0, -2]) cube([18, 6.6, 0.01], center = true);
		}
		//angle on the side
		hull() {
			cube([18, 7, 0.01], center = true);
			translate([0, 0, 4]) cube([13, 7, 0.01], center = true);
		}
	}
	//cut out for alignment
	translate([0, 0, 8.5]) cube([3.8, 8, 3.8], center = true);
}