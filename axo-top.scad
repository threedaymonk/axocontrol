include <rounded.scad>
include <constants.scad>

margin = gap_x + 7;
frame_th = top_th + 2;
frame_sx = size_x - 2 * wall_th;
frame_sy = size_y - 2 * wall_th;


pot_d = 8;
button_d = 10;
led_d = 3.0;
x_off = 14 + wall_th + gap_x;
y_off = wall_th + gap_y;
h_pitch = 22;

module panel() {
  linear_extrude(height = top_th) {
    rounded_square([size_x, size_y], r = corner_r);
  }
  linear_extrude(height = frame_th) {
    translate([wall_th, wall_th]) {
      difference() {
        rounded_square([frame_sx, frame_sy], r = corner_r - wall_th);
        translate([2, 2])
          rounded_square([frame_sx - 4, frame_sy - 4], r = corner_r - wall_th - 2);
      }
    }
  }
}

module panel_cutouts(height) {
  linear_extrude(height = height) {
    // Top row pots and encoder
    for(i = [2 : 6])
      translate([x_off + i * h_pitch, y_off + 32])
        circle(d = pot_d);

    // Bottom row pots
    for(i = [3 : 6])
      translate([x_off + i * h_pitch, y_off + 57])
        circle(d = pot_d);

    // Buttons
    for(i = [0 : 2])
      translate([x_off + i * h_pitch, y_off + 57])
        circle(d = button_d);

    // LEDs
    for(i = [0 : 2])
      translate([x_off + i * h_pitch, y_off + 68.5])
        circle(d = led_d);

    // Screen
    translate([x_off + 11, y_off + 31])
      rounded_square([25.5, 13.5], center=true, r=1);
  }
}

module frame_insets(height) {
  linear_extrude(height = height) {
    difference() {
      translate([wall_th + margin, wall_th + margin]) {
        rounded_square([frame_sx - 2*margin, frame_sy - 2*margin], r = corner_r - wall_th);
      }
      for(i = [1 : 5]) {
        translate([x_off + (i + 0.5) * h_pitch, size_y / 2])
          square([2, size_y], center=true);
      }
    }

    // MIDI connector
    translate([wall_th + gap_x + 6, wall_th + gap_y - 1])
      square([43, 4 + gap_y]);
  }
}

difference() {
  panel();
  translate([0, 0, -$e]) panel_cutouts(frame_th);
  translate([0, 0, panel_th]) frame_insets(frame_th);
}

// Bosses for M3 screws
translate([wall_th + gap_x, wall_th + gap_y])
  for(xyh = bosses)
    translate([xyh[0], xyh[1], top_th])
      screw_boss(
        height = 10 + panel_th - top_th,
        chamfer = [0.5, 3],
        inner_dia = 2.8,
        outer_dia = 6,
        pos = true
      );

// Bosses for support
for (y = [wall_th + margin / 2, size_y - wall_th - margin / 2])
  for (x = [wall_th + gap_x + 60, wall_th + gap_x + 100])
    translate([x, y, top_th])
      screw_boss(
        height = 10 + panel_th - top_th,
        chamfer = [3, 0.5],
        pos = true
      );
