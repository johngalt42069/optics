function picatinny_rail_version() = 2.1;

module picatinny_rail(
length = undef, l = undef,
number = undef, n = undef,
drop = undef, d = undef,
chamfer = undef, c = undef,
alignment = undef, a = undef,
screw_positions = undef, sp = undef,
screw_type = undef, st = undef,
screw_clearance = undef, sc = undef,
omit_slots_near_screws = undef, os = undef
) {

	//---------------------------------------------------------
	//
	//		Dimensions

	// from STANAG 4694

	inner_box_width = 19.05;
	inner_box_height = 2.74;

	bounding_box_width = 21.2;
	bounding_box_toprise = 4.17;
	bounding_box_height = 9.4;

	stem_width = 15.6;

	recoil_depth = 3;
	recoil_width = 5.35;
	recoil_spacing = 10;

	diamond_box_height = bounding_box_height - bounding_box_toprise + inner_box_height / 2;
	diamond_box_dimension = (inner_box_width + inner_box_height) / sqrt(2);

	// Chosen

	minimum_alignment = recoil_width / 2 + 4;
	default_alignment = 7.5;
	default_number = 7;
	default_screw_type = 4;

	//---------------------------------------------------------
	//
	//		Process specifications


	// Collate specifications. Everything except for length, number, and alignment can be set directly from specifications.

	function read(longname, shortname, default) =
		longname != undef ? longname : shortname != undef ? shortname : default;

	l1 = read(length, l, undef);
	n1 = read(number, n, undef);
	d0 = read(drop, d, 0);
	c0 = read(chamfer, c, 0);
	a1 = read(alignment, a, undef);
	sp0 = read(screw_positions, sp, []);
	st0 = read(screw_type, st, 4);
	sc0 = read(screw_clearance, sc, 0.25);
	os0 = read(omit_slots_near_screws, os, true);

	// Sanity-check

	if (is_num(n1) && is_num(l1))
	if ((n1 - 1) * recoil_spacing > l1) {
		echo(
		"Oops! Picatinny rail was called with a specified length and number of slots, but there's no way that many slots will fit in that length."
		);
	};

	if (is_string(a1))
	if (a1 != "slot" && a1 != "ridge" && a1 != "auto") {
		echo(
		"Oops! Picatinny rail was called with a specified alignment that's an unrecognized string. This may be a typo.")
			;
	};

	if (is_string(a1))
	if ((a1 == "slot" || a1 == "ridge") && len(sp0) == 0) {
		echo(
		"Oops! Picatinny rail was called with an alignment option which references screw port positions, but no screw port positions were defined."
		);
	};


	// Set alignment, based on ...
	a0 =

	// ... specification?
		is_num(a1) ? a1 :

			// ... slot alignment?
				a1 == "slot" && len(sp0) > 0 ? ((sp0[0] - minimum_alignment + recoil_spacing) % recoil_spacing) +
				minimum_alignment :

					// ... ridge alignment?
						a1 == "ridge" && len(sp0) > 0 ? ((sp0[0] - minimum_alignment + 1.5 * recoil_spacing) %
						recoil_spacing) + minimum_alignment :

							// ... length and number?
								is_num(l1) && is_num(n1) ? (l1 - recoil_spacing * (n1 - 1)) / 2 :

									// ... just length?
										is_num(l1) ? ((l1 - 2 * minimum_alignment) % recoil_spacing) / 2 +
										minimum_alignment :

											// ... default (which is the same as what "just number" would be).
											default_alignment;


	// Set number, based on ...
	n0 =

	// ... specification?
		is_num(n1) ? n1 :

			// ... length (and alignment, which we just found)?
				is_num(l1) ? floor((l1 - a0 - minimum_alignment) / recoil_spacing) + 1 :

					// ... default.
					default_number;


	// Set length, based on ...
	l0 =

	// ... specification?
		is_num(l1) ? l1 :

			// ... alignment and number.
					recoil_spacing * (n0 - 1) + 2 * a0;


	//---------------------------------------------------------
	//
	//		Screw plugs


	// Known values

	// https://boltsparts.github.io/en/parts/names/MetricHexSocketHeadCapScrew.html
	// https://boltsparts.github.io/en/parts/names/MetricHexSocketCountersunkHeadScrew.html

	known_sizes = [
		// Key name, head dia, head depth
		// Countersunk
			[-24, 39, 14],
			[-22, 36, 13.1],
			[-20, 36, 8.5],
			[-18, 33, 8],
			[-16, 30, 7.5],
			[-14, 27, 7],
			[-12, 24, 6.5],
			[-10, 20, 5.5],
			[-8, 16, 4.4],
			[-6, 12, 3.3],
			[-5, 10, 2.8],
			[-4, 8, 2.3],
			[-3, 6, 1.7],
			[-2.5, 5, 1.5],
			[-2, 4, 1.2],
		// Socket
			[2, 3.8, 2],
			[2.5, 4.5, 2.5],
			[3, 5.5, 3],
			[4, 7, 4],
			[5, 8.5, 5],
			[6, 10, 6],
			[8, 13, 8],
			[10, 16, 10],
			[12, 18, 12],
			[14, 21, 14],
			[16, 24, 16],
			[18, 27, 18],
			[20, 30, 20],
			[22, 33, 22],
			[24, 36, 24]
		];


	// Useful functions

	function linear_interpolate(start, end, valuestart, valueend, x) =
		start == end ?
		valuestart :
						(x - start) * (valueend - valuestart) / (end - start)
				+ valuestart;

	function lower_bound(m, k = len(known_sizes) - 1) =
		known_sizes[k][0] <= m ? k : lower_bound(m, k - 1);

	function upper_bound(m, k = 0) =
		known_sizes[k][0] >= m ? k : upper_bound(m, k + 1);

	function interpolating_read(key, paramiter) =
	linear_interpolate(
	start = known_sizes[lower_bound(key)][0],
	end = known_sizes[upper_bound(key)][0],
	valuestart = known_sizes[lower_bound(key)][paramiter],
	valueend = known_sizes[upper_bound(key)][paramiter],
	x = key
	);


	// Dimension-finding functions

	function hole_dia() =
	// Custom size?
		is_list(st0) ?
			st0[0] + 2 * sc0 :
			// Interpolated size?
				abs(is_num(st0) ? st0 : default_screw_type) + 2 * sc0;

	function head_dia() =
	// Custom size?
		is_list(st0) ?
			st0[1] + 2 * sc0 :
			// Interpolated size
				interpolating_read(is_num(st0) ? st0 : default_screw_type, 1) + 2 * sc0;

	function head_depth() =
	// Custom size?
		is_list(st0) && len(st0) > 2 ?
			st0[2] + sc0 :
			// Interpolated size
			interpolating_read(is_num(st0) ? st0 : default_screw_type, 2);


	//---------------------------------------------------------
	//
	//		Is this slot OK?

	removal_threshold =
		is_num(os0) ? os0 :
					head_dia() / 2 + recoil_width / 2;

	function too_close(slot, screw) =
	abs(a0 + slot * recoil_spacing - sp0[screw]) < removal_threshold;

	function is_OK(slot, screw = len(sp0) - 1) =
		os0 == false ? true :
				screw < 0 ? true :
						too_close(slot, screw) ? false :
							is_OK(slot, screw - 1);


	//---------------------------------------------------------
	//
	//		Parts


	// Basic shape

	module bounding_box() {
		translate([-bounding_box_width / 2, 0, -d0])
			cube([bounding_box_width, l0, bounding_box_height + d0]);
	};

	module chamfer_plugs() {

		translate([0, 0, bounding_box_height - c0])
			rotate([-45, 0, 0])
				translate([0, -bounding_box_width, 0])
					cube(bounding_box_width * 2, center = true);

		translate([0, l0, bounding_box_height - c0])
			rotate([45, 0, 0])
				translate([0, bounding_box_width, 0])
					cube(bounding_box_width * 2, center = true);

	};

	module stem() {
		translate([-stem_width / 2, 0, -d0])
			cube([stem_width, l0, diamond_box_height + d0]);
	};


	module diamond_box() {
		translate([0, 0, diamond_box_height])
			rotate([0, 45, 0])
				translate([-diamond_box_dimension / 2, 0, -diamond_box_dimension / 2])
					cube([diamond_box_dimension, l0, diamond_box_dimension]);
	};


	// Recoil slots

	module recoil() {
		translate([-bounding_box_width, -recoil_width / 2, bounding_box_height - recoil_depth])
			cube([2 * bounding_box_width, recoil_width, 2 * recoil_depth]);
	};

	module recoils() {
		if (n0 == 0) {}
		else if (n0 == 1) {
			translate([0, a0, 0])
				if (is_OK(0))
				recoil();
		}
		else {
			for (i = [0:n0 - 1]) {
				if (is_OK(i))
					translate([0, a0 + i * recoil_spacing, 0])
						recoil();
			};
		};
	};


	// Screw ports

	module screw_shaft_plug() {
		cylinder(
		h = 9999999,
		center = true,
		d = hole_dia(),
		$fn = 36
		);
	};

	module screw_socket_head_plug() {
		translate([0, 0, bounding_box_height - head_depth()])
			cylinder(
			h = 9999999,
			d = head_dia(),
			$fn = 36
			);
	};

	module screw_coundersunk_head_plug() {
		translate([0, 0, bounding_box_height - head_dia() / 2])
			cylinder(
			d1 = 0,
			d2 = 9999999,
			h = 9999999 / 2,
			$fn = 36
			);
	};

	module screw_plug()
	union() {
		screw_shaft_plug();
		if (st0 > 0) {
			screw_socket_head_plug();
		} else {
			screw_coundersunk_head_plug();
		};
	};

	module screws_plug() {
		if (len(sp0) > 0) {
			for (i = sp0) {
				translate([0, i, 0])
					screw_plug();
			};
		};
	};

	// Assembly

	intersection() {
		union() {
			stem();
			diamond_box();
		};
		difference() {
			bounding_box();
			union() {
				recoils();
				chamfer_plugs();
				screws_plug();
			};
		};
	};
};