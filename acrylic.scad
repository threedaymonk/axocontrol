include <rounded.scad>
include <constants.scad>

pot_d = 7.2;
button_d = 9.5;
led_d = 5;
x_off = 14 + wall_th + gap_x;
y_off = wall_th + gap_y;

difference() {
  rounded_square([size_x, size_y], r = corner_r);

  translate([wall_th + gap_x, wall_th + gap_y])
    for(xyh = bosses)
      translate([xyh[0], xyh[1]])
        circle(d = 3.5);

  for(i = [2 : 6]) translate([x_off + i * 22, y_off + 32]) circle(d = pot_d);
  for(i = [3 : 6]) translate([x_off + i * 22, y_off + 57]) circle(d = pot_d);
  for(i = [0 : 2]) translate([x_off + i * 22, y_off + 57]) circle(d = button_d);
  for(i = [0 : 2]) translate([x_off + i * 22, y_off + 68.5]) circle(d = led_d);
}
