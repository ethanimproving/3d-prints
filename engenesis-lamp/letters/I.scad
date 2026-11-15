include <glyph_params.scad>
use <../snake_i.scad>

// I: the helix snake from the Snake-I drawing (geometry in snake_i.scad), open jaws and fangs.
// Taller than the letter band: base on the baseline, head above the cap line.
// Height ratio is the logo's snake height (263px) over its letter height (145px).
module logo_i_2d() {
    snake_i_2d(glyph_w("I"), letter_h * 263 / 145);
}

linear_extrude(height = 10) logo_i_2d();  // preview when opened directly; ignored by `use`
