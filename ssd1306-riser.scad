$fs = 0.1;
$fa = 0.1;

ys = [-12, 11.5];
xs = [-11.5, 11.5];

panel_height = 10;
module_height = 3.5;
height = panel_height - module_height;
gap = 2.5;
joined_height = height - 2 * gap;
post_dia = 3.4;
screw_dia = 1;

module screw_holes() {
  for(y = ys) for(x = xs) {
    translate([x, y, -1]) cylinder(d = screw_dia, h = height + 2);
  }
}

module post(dy) {
  hull() {
    cylinder(d = post_dia, h = height);
    translate([0, dy, gap]) cylinder(d = post_dia, h = joined_height);
  }
}

module side_arm() {
  for(y = ys) {
    dy = y < 0 ? gap : -gap;
    translate([0, y]) post(dy);
  }
  hull() {
    for(y = ys) {
      translate([0, y, gap]) cylinder(d = post_dia, h = joined_height);
    }
  }
}

module struts() {
  for(x = xs) {
    translate([x, 0]) side_arm();
  }
  hull() for(x = xs) {
    translate([x, 0, gap]) cylinder(d = post_dia, h = joined_height);
  }
}

difference() {
  struts();
  screw_holes();
}
