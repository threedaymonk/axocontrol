include <rounded.scad>
include <constants.scad>

strut_sx = size_x - 2 * wall_th;
strut_sy = size_y - 2 * wall_th;
margin = gap_x + 7;
panel_th = 0.8;
strut_th = 3.2 - panel_th;

pot_d = 8;
button_d = 10;
led_d = 3.5;
x_off = 14 + wall_th + gap_x;
y_off = wall_th + gap_y;
h_pitch = 22;

module panel(height) {
  linear_extrude(height = height) {
    difference() {
      rounded_square([size_x, size_y], r = corner_r);

      translate([wall_th + gap_x, wall_th + gap_y])
        for(xyh = bosses)
          translate([xyh[0], xyh[1]])
            circle(d = 3.5);

      for(i = [2 : 6]) translate([x_off + i * h_pitch, y_off + 32]) circle(d = pot_d);
      for(i = [3 : 6]) translate([x_off + i * h_pitch, y_off + 57]) circle(d = pot_d);
      for(i = [0 : 2]) translate([x_off + i * h_pitch, y_off + 57]) circle(d = button_d);
      for(i = [0 : 2]) translate([x_off + i * h_pitch, y_off + 68.5]) circle(d = led_d);

      translate([x_off + 11, y_off + 31.5]) rounded_square([25, 13], center=true, r=1);
    }
  }
}

module each_screw() {
  translate([wall_th + gap_x, wall_th + gap_y])
    for(xyh = bosses)
      translate([xyh[0], xyh[1]])
        children();
}

module strut(height) {
  linear_extrude(height = height) {
    difference() {
      translate([wall_th, wall_th])
        rounded_square([strut_sx, strut_sy], r = corner_r - wall_th);

      for(i = [2 : 6]) translate([x_off + i * h_pitch, size_y / 2])
        rounded_square([14, strut_sy - 2 * margin], r = 2, center = true);

      translate([x_off + 0.5 * h_pitch, size_y / 2])
        rounded_square([14 + h_pitch, strut_sy - 2 * margin], r = 2, center = true);

      // MIDI connector
      translate([wall_th + gap_x + 6, wall_th + gap_y - 1])
        square([43, 4]);
    }
  }
}

difference() {
  union() {
    panel(height = panel_th);
    strut(height = strut_th + panel_th);
    translate([0, 0, strut_th + panel_th])
      each_screw()
        screw_boss(height = 10 - strut_th, chamfer = [0.5, 3], pos = true);
  }
  translate([0, 0, strut_th + panel_th])
    each_screw()
      screw_boss(height = 10 - strut_th, mount_thickness = 0.5, pos = false);
}

for (y = [wall_th + margin / 2, size_y - wall_th - margin / 2])
  for (x = [wall_th + gap_x + 60, wall_th + gap_x + 100])
    translate([x, y, strut_th + panel_th])
      screw_boss(height = 10 - strut_th, chamfer = [3, 0.5], pos = true);
