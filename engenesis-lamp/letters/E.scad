include <glyph_params.scad>

// E: solid left stem with three arms; the middle arm is slightly shorter.
module logo_e_2d() {
    w = glyph_w("E");
    union() {
        square([stroke, letter_h]);
        square([w, stroke]);
        translate([0, letter_h - stroke]) square([w, stroke]);
        translate([0, letter_h / 2 - stroke / 2]) square([w * 0.9, stroke]);
    }
}

logo_e_2d();  // preview when opened directly; ignored by `use`
