include <rounded.scad>
include <constants.scad>

plate_sx = size_x - 2 * wall_th;
plate_sy = size_y - 2 * wall_th;
margin = gap_x + 7;
plate_th = 4;

module each_screw() {
  translate([wall_th + gap_x, wall_th + gap_y])
    for(xyh = bosses)
      translate([xyh[0], xyh[1]])
        children();
}

module plate() {
  linear_extrude(height = plate_th) {
    difference() {
      translate([wall_th, wall_th]) {
        difference() {
          rounded_square([plate_sx, plate_sy], r = corner_r - wall_th);
          translate([margin, margin])
            rounded_square([plate_sx - 2 * margin, plate_sy - 2 * margin], r = 2);
        }
      }
      translate([wall_th + gap_x + 7, wall_th + gap_y - 1])
        square([41, 4]);
    }
  }
}

difference() {
  union() {
    plate();
    translate([0, 0, plate_th])
      each_screw()
        screw_boss(height = 10 - plate_th, chamfer = [0.5, 3], pos = true);
  }
  translate([0, 0, plate_th])
    each_screw()
      screw_boss(height = 10 - plate_th, pos = false);
}

for (y = [wall_th + margin / 2, size_y - wall_th - margin / 2])
  for (x = [wall_th + gap_x + 60, wall_th + gap_x + 100])
    translate([x, y, plate_th])
      screw_boss(height = 10 - plate_th, chamfer = [3, 0.5], pos = true);

