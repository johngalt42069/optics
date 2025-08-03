include <util/picatinny-rail.scad>
include <util/rounded_cube.scad>
include <util/chamfer_cube.scad>
include <util/torx.scad>

$fn = 128;

length = 350;
width = 30;

difference() {
	union() {
		chamfer_cube(width, length, 40, 6);
		translate([0, -length / 2 + 28, 20]) difference() {
			picatinny_rail(length - 88);
			//angle front and rear
			translate([0, 0, 10]) rotate([45, 0, 0]) cube([22, 6, 6], center = true);
			translate([0, length - 88, 10]) rotate([45, 0, 0]) cube([22, 6, 6], center = true);
		}
	}
	//cut middle
	translate([0, 30, -20])rotate([0, 90, 0]) rounded_cube(60, length - 120, 40, 30);
	//angle front
	front_angle_radius = 80;
	y_offset = -front_angle_radius / 2 + 10;
	z_offset = -60;
	translate([0, length / 2 - 30, 0]) difference() {
		cube([width, 60, 40], center = true);
		translate([0, y_offset, z_offset])rotate([0, 90, 0]) cylinder(width - 8, front_angle_radius, front_angle_radius,
		center = true);
		translate([width / 2 - 2, y_offset, z_offset])rotate([0, 90, 0]) cylinder(4, front_angle_radius,
			front_angle_radius - 4, center = true);
		translate([-width / 2 + 2, y_offset, z_offset])rotate([0, 90, 0]) cylinder(4, front_angle_radius - 4,
		front_angle_radius, center = true);
	}
	//cut center of front legs
	translate([0, length / 2 - 30, 20]) rounded_cube(20, 60, 20, 2);
	//cut display space
	translate([0, 0, 4]) rotate([90, 0, 0])rounded_cube(20, 26, length, 2);
	//angle rear
	translate([0, -length / 2 - 10, 0]) rotate([-30, 0, 0]) cube([width, 40, 80], center = true);
	//bottom pic cut out
	translate([0, -length / 2, -20]) rotate([90, 0, 180])linear_extrude(length) for (m = [0:1]) mirror([m, 0, 0])
		polygon(points = [[0, 0], [8.3, 0], [8.3, 0.5], [11.1, 3.2], [11.1, 3.9], [8.6, 6.4], [0, 6.4]]);
	translate([8, 0, -13]) rotate([90, 0, 0]) rounded_cube(2, 4, length, 1);
	translate([-8, 0, -13]) rotate([90, 0, 0]) rounded_cube(2, 4, length, 1);
	//screw 1
	translate([0, -length / 2 + 20, -14]) rotate([0, 90, 0]) cylinder(width, 2.6, 2.6, center = true);
	translate([width / 2 - 1.25, -length / 2 + 20, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true, $fn = 6);
	translate([-width / 2 + 1.25, -length / 2 + 20, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true);
	//screw 2
	translate([0, -length / 2 + 80, -14]) rotate([0, 90, 0]) cylinder(width, 2.6, 2.6, center = true);
	translate([width / 2 - 1.25, -length / 2 + 80, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true, $fn = 6);
	translate([-width / 2 + 1.25, -length / 2 + 80, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true);
	//screw 3
	translate([0, length / 2 - 20, -14]) rotate([0, 90, 0]) cylinder(width, 2.6, 2.6, center = true);
	translate([width / 2 - 1.25, length / 2 - 20, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true, $fn = 6);
	translate([-width / 2 + 1.25, length / 2 - 20, -14]) rotate([0, 90, 0]) cylinder(2.5, 4.5, 4.5, center = true);
	//screw hole for display module
	translate([13, -length / 2 + 100, 10]) rotate([0, 90, 0]) torx_cutout();
	translate([-13, -length / 2 + 100, 10]) rotate([0, -90, 0]) torx_cutout();
}
