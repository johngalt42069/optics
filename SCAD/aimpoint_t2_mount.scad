include <util/picatinny-rail.scad>
include <util/rounded_cube.scad>
include <util/chamfer_cube.scad>
include <util/torx.scad>

$fn = 128;

length = 54;
width = 30;
height = 14;

difference() {
	//main body
	chamfer_cube(width, length, height, 3);
	//
	hull() {
		translate([0, 0, height / 2])cube([16, length, 0.01], center = true);
		translate([0, 0, height / 2 - 2])cube([15, length, 0.01], center = true);
	}
	//screw cuts
	translate([5, 17.5, 0])cylinder(height, 1.6, 1.6, center = true);
	translate([5, 17.5, 1.3])cylinder(4, 3, 3, center = true);
	translate([-5, -17.5, 0])cylinder(height, 1.6, 1.6, center = true);
	translate([-5, -17.5, 1.3])cylinder(4, 3, 3, center = true);
	translate([5, -17.5, 0])cylinder(height, 1.6, 1.6, center = true);
	translate([5, -17.5, 1.3])cylinder(4, 3, 3, center = true);
	translate([-5, 17.5, 0])cylinder(height, 1.6, 1.6, center = true);
	translate([-5, 17.5, 1.3])cylinder(4, 3, 3, center = true);
	//bottom pic cut out
	translate([0, -length / 2, -height / 2]) rotate([90, 0, 180])linear_extrude(length) for (m = [0:1]) mirror([m, 0, 0]
	)
		polygon(points = [[0, 0], [8.3, 0], [8.3, 0.5], [11.1, 3.2], [11.1, 3.9], [8.6, 6.4], [0, 6.4]]);
	translate([8, 0, 0]) rotate([90, 0, 0]) rounded_cube(2, 4, length, 1);
	translate([-8, 0, 0]) rotate([90, 0, 0]) rounded_cube(2, 4, length, 1);
	//pic screw
	translate([0, 0, -1]) rotate([0, 90, 0]) cylinder(width, 2.6, 2.6, center = true);
	translate([width / 2 - 1.25, 0, -1]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true, $fn = 6);
	translate([-width / 2 + 1.25, 0, -1]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true);
}
