include <glyph_params.scad>

// S: bold five-bar S with squared terminals.
module logo_s_2d() {
    w = glyph_w("S");
    mid = letter_h / 2;
    union() {
        translate([0, letter_h - stroke]) square([w, stroke]);
        translate([0, mid]) square([stroke, mid]);
        translate([0, mid - stroke / 2]) square([w, stroke]);
        translate([w - stroke, 0]) square([stroke, mid]);
        square([w, stroke]);
    }
}

logo_s_2d();  // preview when opened directly; ignored by `use`
