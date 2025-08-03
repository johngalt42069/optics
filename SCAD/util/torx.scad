$fn = 32;

module torx_cutout() {
    union() {
        rotate_extrude(angle = 360) polygon(points = [[0, -1], [2.2, -1], [4.2, 1],[4.2, 2], [4.2, 100], [0, 100]]);
        translate([0, 0, -6]) cylinder(6, 2.2, 2.2);
    }
}

