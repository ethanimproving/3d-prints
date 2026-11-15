include <glyph_params.scad>

// n: rounded-top arch with two open-bottomed legs.
module logo_n_2d() {
    w = glyph_w("N");
    r = 0.38 * w;
    ri = r - stroke;
    difference() {
        hull() {
            square([w, 1]);
            translate([r, letter_h - r]) circle(r);
            translate([w - r, letter_h - r]) circle(r);
        }
        hull() {
            translate([stroke, -1]) square([w - 2 * stroke, 2]);
            translate([stroke + ri, letter_h - stroke - ri]) circle(ri);
            translate([w - stroke - ri, letter_h - stroke - ri]) circle(ri);
        }
    }
}

logo_n_2d();  // preview when opened directly; ignored by `use`
