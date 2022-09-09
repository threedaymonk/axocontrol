include <rounded.scad>
include <constants.scad>

module rrect(size = [1, 1], r = 0.5, center = false) {
	size = (size[0] == undef) ? [size, size] : size;
  sx = size[0]; sy = size[1];

	shift = (center == false) ? [r, r] : [r - sx/2, r - sy/2];

	translate(shift) minkowski() {
    square([sx - r*2, sy - r*2]);
    circle(r = r);
  }
}

module shell() {
  difference() {
    rounded_bottom_cube(
      [size_x, size_y, size_z],
      r = corner_r,
      square_off = 1
    );
    translate([wall_th, wall_th, base_th])
      rounded_bottom_cube(
        [size_x - 2 * wall_th,
         size_y - 2 * wall_th,
         size_z],
        r = corner_r - wall_th
      );
  }
}

module boss(h, pos = true) {
  hole_d = 3.5;
  inner_d = 4;
  outer_d = 6;
  head_d = 6.5;
  head_depth = 2.6;
  chamfer = min(h, 1.4);

  if (pos) {
    difference() {
      union() {
        cylinder(d = outer_d, h = base_th + h);
        translate([0, 0, base_th - $e])
          cylinder(d1 = outer_d + 2 * chamfer, d2 = outer_d, h = chamfer + $e);
      }
      translate([0, 0, -$e])
        cylinder(d = inner_d, h = base_th + h + 2 * $e);
    }
  } else {
    translate([0, 0, -$e]) {
      cylinder(d = head_d, h = head_depth + $e);
      cylinder(d = hole_d, h = base_th + h + 2 * $e);
    }
  }
}

module bosses(pos = true) {
  translate([wall_th + gap_x, wall_th + gap_y, 0])
    for(xyh = bosses)
      translate([xyh[0], xyh[1], 0])
        boss(h = xyh[2], pos = pos);
}

module cutouts() {
  translate([0, 0, base_th + gap_z + pcb_th]) {
    translate([size_x - wall_th - 10, wall_th + gap_y + 15, -1])
      cube([20, 11, 13]);
    translate([wall_th + gap_x, wall_th + 2, 0]) {
      rotate([90, 0, 0]) linear_extrude(height = 10) {
        // Audio
        translate([17.5, 8, 0]) circle(d=12.5);
        translate([37, 8, 0]) circle(d=12.5);
        // Micro USB
        translate([63, 1.5, 0]) rrect([12, 8], center=true);
        // USB A
        translate([87, 7.2, 0]) rrect([8, 16], r=1, center=true);
        // LEDs
        translate([93.5, 0.4, 0]) circle(d=2);
        translate([97, 0.4, 0]) circle(d=2);
        // Switches
        translate([101.5, 0.5, 0]) square(3, center=true);
        translate([107, 0.5, 0]) square(3, center=true);
        // MIDI
        translate([121.5, 10, 0]) circle(d=15);
        translate([142, 10, 0]) circle(d=15);

        // Merge Micro USB, Micro SD, and USB A
        translate([69.5, 2, 0]) rrect([43, 9], r=1, center=true);
      }
    }
    // Bottom access for Micro SD
    translate([wall_th + gap_x + 76 - 14/2, -10, -20])
      rounded_cube([14, 16.5, 20 + 2.2], r = 1);
  }
}

module feet() {
  // Feet
  foot_d = 10.5;
  foot_x = 17;
  foot_y = 12;
  foot_depth = 1.2;
  feet = [
    [foot_x, foot_y],
    [size_x - foot_x, foot_y],
    [foot_x, size_y - foot_y],
    [size_x - foot_x, size_y - foot_y],
  ];
  for (foot = feet)
    translate([foot[0], foot[1], -1])
      cylinder(d = foot_d, h = foot_depth + 1);
}


difference() {
  union() {
    shell();
    bosses(pos = true);
  }
  bosses(pos = false);
  cutouts();
  feet();
}

if ($preview) {
  translate([module_sx + wall_th + gap_x, wall_th + gap_y, pcb_th + base_th + gap_z])
    rotate([90, 0, 180])
      import("axoloti.stl");
}
