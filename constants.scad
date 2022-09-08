$fs = $preview ? 1 : 0.1;
$fa = $preview ? 3 : 2;
$e = 0.001;

module_sx = 160;
module_sy = 80;
module_sz = 24;

corner_r = 6;

wall_th = 2;
base_th = 3.2;

gap_z = 3;
pcb_th = 1.6;
gap_x = 2;
gap_y = 1;

size_x = module_sx + 2 * wall_th + 2 * gap_x;
size_y = module_sy + 2 * wall_th + 2 * gap_y;
size_z = module_sz + base_th + gap_z;

bosses = [
  // x, y, height
  [3.5, 10, gap_z],
  [3.5, module_sy - 10, gap_z + pcb_th],
  [module_sx - 3.5, 10, gap_z],
  [module_sx - 3.5, module_sy - 10, gap_z + pcb_th]
];
