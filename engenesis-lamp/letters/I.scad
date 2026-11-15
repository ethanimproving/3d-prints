include <glyph_params.scad>
include <I_trace_pts.scad>

// I: the snake silhouette traced from images/snake-trace-sheet (1).svg (I_trace_pts).
// Scaled to the logo's snake height (263px over the 145px letter height), centred on x,
// base on the baseline (y = 0) and head above the cap line.
module logo_i_2d() {
    s = letter_h * 263 / 145 / 456;           // 456 = traced snake height in SVG units
    translate([glyph_w("I") / 2, 0]) scale([s, -s]) translate([-(101.0 + 378.2) / 2, -591.2]) polygon(I_trace_pts);
}

// Preview in the lamp's orientation: glyph in XZ, thickness along Y. Ignored by `use`.
rotate([90, 0, 0]) linear_extrude(height = 10, center = true)
    translate([-glyph_w("I") / 2, -letter_h / 2]) logo_i_2d();
