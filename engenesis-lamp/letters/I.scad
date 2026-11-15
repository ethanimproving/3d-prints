include <glyph_params.scad>
use <../snake_i.scad>

// I: the helix snake from the Snake-I drawing (geometry in snake_i.scad), open jaws and fangs.
// Taller than the letter band: base on the baseline, head above the cap line.
// Height ratio is the logo's snake height (263px) over its letter height (145px).
module logo_i_2d() {
    snake_i_2d(glyph_w("I"), letter_h * 263 / 145);
}

// Preview in the lamp's orientation: glyph in XZ, thickness along Y. Ignored by `use`.
rotate([90, 0, 0]) linear_extrude(height = 10, center = true)
    translate([-glyph_w("I") / 2, -letter_h / 2]) logo_i_2d();
