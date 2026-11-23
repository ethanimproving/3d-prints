// Parametric storage box with a lid, made for OpenSCAD Viewer & 3D Preview by Zovo.
// Open the 3D preview from the editor title. With Zovo Pro, the Customizer turns the
// parameters below into sliders, drop-downs and checkboxes.

/* [Box] */
// Inside width in mm
width = 60; // [20:5:160]
// Inside depth in mm
depth = 40; // [20:5:120]
// Inside height in mm
height = 25; // [10:1:80]
// Wall thickness in mm
wall = 2; // [1.2:0.4:4]
// Corner style
corners = "round"; // [round:Rounded, square:Square]

/* [Compartments] */
// Number of compartments across the width
columns = 3; // [1:6]
// Divider height as a share of the box height
divider_share = 0.8; // [0.3:0.1:1]

/* [Lid] */
// Print the lid next to the box
show_lid = true;
// Gap between lid and box in mm
lid_gap = 0.3; // [0.1:0.05:0.6]
// Text on the lid (empty for none)
label = "PARTS"; // 12

/* [Hidden] */
radius = corners == "round" ? 4 : 0.01;
$fn = 40;

module rounded_block(size, r) {
  hull()
    for (x = [r, size[0] - r], y = [r, size[1] - r])
      translate([x, y, 0]) cylinder(r = r, h = size[2]);
}

module box() {
  outer = [width + 2 * wall, depth + 2 * wall, height + wall];
  color("SteelBlue") difference() {
    rounded_block(outer, radius + wall);
    translate([wall, wall, wall]) rounded_block([width, depth, height + 1], radius);
  }
  // dividers
  if (columns > 1)
    color("LightSteelBlue")
      for (i = [1 : columns - 1])
        translate([wall + i * width / columns - wall / 4, wall, wall])
          cube([wall / 2, depth, height * divider_share]);
}

module lid() {
  outer = [width + 2 * wall, depth + 2 * wall];
  color("Orange") difference() {
    union() {
      rounded_block([outer[0], outer[1], wall], radius + wall);
      translate([wall + lid_gap, wall + lid_gap, wall])
        rounded_block([width - 2 * lid_gap, depth - 2 * lid_gap, 4], max(radius - lid_gap, 0.01));
    }
    if (len(label) > 0)
      translate([outer[0] / 2, outer[1] / 2, -0.01])
        linear_extrude(0.6) mirror([1, 0, 0])
          text(label, size = min(width / max(len(label), 1), depth / 3), halign = "center", valign = "center");
  }
}

box();
if (show_lid) translate([0, depth + 2 * wall + 10, 0]) lid();
echo(str("Box outside: ", width + 2 * wall, " x ", depth + 2 * wall, " x ", height + wall, " mm"));
