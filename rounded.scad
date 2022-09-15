module rounded_square(size = [1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size] : size;
  sx = size[0]; sy = size[1];

	shift = (center == false) ? [r, r] : [r - sx/2, r - sy/2];

	translate(shift) minkowski() {
    square([sx - r*2, sy - r*2]);
    circle(r = r);
  }
}

module rounded_cube(size = [1, 1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size, size] : size;
  sx = size[0]; sy = size[1]; sz = size[2];

	shift = (center == false) ? [r, r, r] : [r - sx/2, r - sy/2, r - sz/2];

	translate(shift) minkowski() {
    cube([sx - r*2, sy - r*2, sz - r*2]);
    if ($children == 0) sphere(r = r);
    else children();
  }
}

module rounded_bottom_cube(size, r = 1, center = false, square_off = 0) {
  rounded_cube(size, r, center) {
    hull() {
      intersection() {
        translate ([0, 0, -square_off]) sphere(r = r);
        cylinder(r = r, h = r * 2, center = true);
      }
      cylinder(r = r, h = r);
    }
  }
}

module screw_boss(height, hole_dia = 3.5, head_dia = 6.5, pos = true,
                  chamfer = 1, mount_thickness = 0.6, inner_dia, outer_dia) {

  inner_dia = (inner_dia == undef) ? hole_dia + 0.5 : inner_dia;
  outer_dia = (outer_dia == undef) ? inner_dia + 2 : outer_dia;

	chamfer = (chamfer[0] == undef) ? [chamfer, chamfer] : chamfer;
  chamfer_max = max(chamfer[0], chamfer[1]);
  csx = (outer_dia + 2 * chamfer[0]) / (outer_dia + 2 * chamfer_max);
  csy = (outer_dia + 2 * chamfer[1]) / (outer_dia + 2 * chamfer_max);

  if (pos) {
    difference() {
      translate([0, 0, -$e]) {
        cylinder(d = outer_dia, h = height + $e);
        scale([csx, csy, 1])
          cylinder(d1 = outer_dia + 2 * chamfer_max, d2 = outer_dia, h = chamfer_max + $e);
      }
      translate([0, 0, -2 * $e])
        cylinder(d = inner_dia, h = height + 3 * $e);
    }
  } else {
    translate([0, 0, -100]) {
      if (mount_thickness > 0)
        cylinder(d = head_dia, h = 100 - mount_thickness);
      cylinder(d = hole_dia, h = 100 + $e);
    }
  }
}
