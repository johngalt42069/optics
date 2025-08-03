include <../util/rounded_cube.scad>

$fn = 128;

difference() {
	union() {
		//main body
		translate([0, -2, 9.144 / 2]) cube([3, 11, 9.144], center = true);
		//slope on the side
		hull() {
			translate([0, -2, 0]) cube([5, 11, 0.01], center = true);
			translate([0, -2, 5]) cube([3, 11, 0.01], center = true);
		}
		//slide footprint
		translate([0, 0, -1.3 / 2]) rounded_cube(2.9, 4.8, 1.3, 1.45);
		translate([0, 0, -1.3]) cylinder(1.3, 3.15 / 2, 3.15 / 2);
	}
	//screw hole
	translate([0, 0, -1.3]) cylinder(6, 1.15, 1.15);
	//angle in the front
	translate([0, 4, 10]) rotate([45, 0, 0]) cube(8, center = true);
}