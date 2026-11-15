// Shared glyph sizing, included by engenesis_lamp.scad and every letters/*.scad file.

letter_h = 180;                   // glyph height
stroke = 36;                      // bold stroke, matching the reference's heavy letterforms
round_r = 10;                     // small logo-style rounding on n, g and S
flame_h = 2 * letter_h;           // flames rise above and below the letters, as in the logo

function glyph_w(g) = g == "E" ? 130 : g == "N" ? 140 : g == "g" ? 80 : g == "S" ? 140 : g == "I" ? 210 : (g == "FL" || g == "FR") ? 170 : 50;
