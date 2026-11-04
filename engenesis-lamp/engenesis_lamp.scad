// Engenesis interlocking light-box logo, clipped onto a cubicle divider.
// Units: mm. Viewer looks along +Y (front face is -Y). Glyphs read along +X, up is +Z.
//
// Export one part at a time: set PART, press F6, export STL.
// PART values: "assembly", "letter", "letter_diffuser", "bridge", "bridge_diffuser"

PART = "assembly";
GLYPH = "E";                      // used when PART = "letter" or "letter_diffuser"

// ---------- Divider clip ----------
divider_t = 22.0;                 // measured cubicle divider thickness
clip_clear = 0.4;                 // slide-on clearance; gap = divider_t + clip_clear
clip_gap = divider_t + clip_clear;
clip_leg_t = 3;
clip_leg_len = 22;
clip_roof_t = 4;
clip_w = 26;

// ---------- Letter light box ----------
letter_h = 180;                   // glyph height
letter_d = 20;                    // depth along Y (LED to diffuser path)
side_wall = 3;
back_wall = 3;
diffuser_t = 1.2;
base_t = 4;
letter_gap = 50;                  // clear distance between outer edges of neighbouring letters
stroke = 36;                      // bold stroke, matching the reference's heavy letterforms
round_r = 10;                     // small logo-style rounding on n, g and S

// ---------- Bridge and ports ----------
bridge_h = 18;                    // 10 mm WS2812B strip plus margin
flange_t = 2;
hub_len = 10;                     // port protrudes beyond the letter edge
hub_in = 6;                       // port overlaps into the letter
hub_h = bridge_h + 5;
socket_d = 10;                    // keyed bridge engagement inside each hub
key_extra_h = 3;                  // T-key captures bridge vertically
port_clear = 0.25;                // total clearance on bridge-to-port fit

glyphs = ["E", "N", "g", "E", "N", "E", "S", "I", "S"];   // "I" is a placeholder for the snake-I

// ---------- Derived values ----------
base_top = clip_roof_t + base_t;
zc = base_top + side_wall + letter_h / 2;           // glyph and bridge mid-height
bridge_L = letter_gap - 2 * hub_len;                // visible span between hub faces

function glyph_w(g) = g == "E" ? 130 : g == "N" ? 140 : g == "g" ? 135 : g == "S" ? 140 : 50;
function outer_w(g) = glyph_w(g) + 2 * side_wall;
function left_edge(i) = i == 0 ? 0 : left_edge(i - 1) + outer_w(glyphs[i - 1]) + letter_gap;
function center_x(i) = left_edge(i) + outer_w(glyphs[i]) / 2;
total_w = left_edge(len(glyphs) - 1) + outer_w(glyphs[len(glyphs) - 1]);

// ---------- Glyph helpers ----------
// These profiles deliberately match the supplied wordmark rather than relying on
// an installed font. The special I is reserved for the separately modelled snake.
module rounded_rect(w, h, r) {
    offset(r=r) offset(delta=-r) square([w, h]);
}

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

// Single-storey g in the glyph's local frame (0..letter_h): bowl above the
// x-height line, right stem down to a descender bar that curls up on the left.
module logo_g_2d() {
    w = glyph_w("g");
    xh = letter_h * 0.36;
    union() {
        difference() {
            translate([0, xh]) rounded_rect(w, letter_h - xh, round_r);
            translate([stroke, xh + stroke])
                rounded_rect(w - 2 * stroke, letter_h - xh - 2 * stroke, round_r / 2);
        }
        translate([w - stroke, 0]) square([stroke, letter_h]);
        rounded_rect(w, stroke, round_r / 2);
        square([stroke, letter_h * 0.3]);
    }
}

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

module glyph2d(g) {
    translate([-glyph_w(g) / 2, -letter_h / 2])
        offset(r=round_r) offset(delta=-round_r)
        if (g == "E") logo_e_2d();
        else if (g == "N") logo_n_2d();
        else if (g == "g") logo_g_2d();
        else if (g == "S") logo_s_2d();
        else rounded_rect(glyph_w(g), letter_h, round_r);
}

// Glyph outline extruded along Y from y0 to y1, centred on zc.
module glyph_slab(g, y0, y1, grow=0) {
    translate([0, (y0 + y1) / 2, zc]) rotate([90, 0, 0])
        linear_extrude(height=y1 - y0, center=true)
            offset(delta=grow) glyph2d(g);
}

// ---------- Divider clip (origin at divider top centre) ----------
module divider_clip() {
    outer_half = clip_gap / 2 + clip_leg_t;
    translate([-clip_w / 2, -outer_half, 0])
        cube([clip_w, 2 * outer_half, clip_roof_t]);
    for (s = [-1, 1])
        translate([-clip_w / 2, s > 0 ? clip_gap / 2 : -outer_half, -clip_leg_len])
            cube([clip_w, clip_leg_t, clip_leg_len]);
}

// A T-key on each end prevents bridge sag and is only released by sliding the
// bridge horizontally out of both letter hubs. The matching shell channel keeps
// the LED strip and its diffuser continuous through the joint.
module bridge_key(engagement, clearance=0) {
    union() {
        translate([0, -letter_d / 2 - clearance / 2, -(bridge_h / 2 + clearance / 2)])
            cube([engagement, letter_d + clearance, bridge_h + clearance]);
        translate([0, -letter_d / 2 - clearance / 2, -(bridge_h / 2 + key_extra_h + clearance / 2)])
            cube([engagement, letter_d + clearance, bridge_h + 2 * key_extra_h + clearance]);
    }
}

module bridge_channel(length, clearance=0) {
    translate([-1, -letter_d / 2 - clearance / 2, -(bridge_h / 2 - flange_t)])
        cube([length + 2, letter_d - back_wall + 1 + clearance, bridge_h - 2 * flange_t]);
}

module bridge_socket() {
    bridge_key(socket_d + 1, port_clear);
    bridge_channel(socket_d + 1, port_clear);
}

// ---------- Letter ----------
module letter_shell(g) {
    ex = glyph_w(g) / 2 + side_wall;
    difference() {
        union() {
            glyph_slab(g, -letter_d / 2, letter_d / 2, side_wall);
            for (s = [-1, 1])
                scale([s, 1, 1])
                    translate([ex - hub_in, -letter_d / 2, zc - hub_h / 2])
                        cube([hub_len + hub_in, letter_d, hub_h]);
            translate([-ex, -letter_d / 2, clip_roof_t])
                cube([2 * ex, letter_d, base_t]);
        }
        // LED and diffuser cavity: the glyph outline, open to the front
        glyph_slab(g, -letter_d / 2 - 1, letter_d / 2 - back_wall);
        // Diffuser rebate at the front
        glyph_slab(g, -letter_d / 2 - 1, -letter_d / 2 + diffuser_t, 0.6);
        // Keyed bridge ports: every letter accepts a bridge at either side.
        for (s = [-1, 1])
            scale([s, 1, 1])
                translate([ex + hub_len - socket_d, 0, zc])
                    bridge_socket();
        translate([-(ex + hub_len), 0, zc])
            bridge_channel(2 * (ex + hub_len));
    }
}

module letter_diffuser(g) {
    glyph_slab(g, -letter_d / 2, -letter_d / 2 + diffuser_t, 0.4);
}

// ---------- Bridge ----------
module bridge_tube(L) {
    difference() {
        union() {
            translate([0, -letter_d / 2, -bridge_h / 2]) cube([L, letter_d, bridge_h]);
            translate([-socket_d, 0, 0]) bridge_key(socket_d);
            translate([L + socket_d, 0, 0]) mirror([1, 0, 0]) bridge_key(socket_d);
        }
        translate([-socket_d, 0, 0]) bridge_channel(L + 2 * socket_d);
    }
}

module bridge_diffuser(L) {
    translate([0, -letter_d / 2 - diffuser_t, -(bridge_h / 2 - flange_t)])
        cube([L, diffuser_t, bridge_h - 2 * flange_t]);
}

// ---------- Assembly preview ----------
module assembly() {
    for (i = [0 : len(glyphs) - 1]) {
        g = glyphs[i];
        translate([center_x(i), 0, 0]) {
            color("#111827") letter_shell(g);
            color([0.75, 0.9, 1, 0.85]) letter_diffuser(g);
            color("#0b5c8a") divider_clip();
        }
        if (i < len(glyphs) - 1)
            translate([center_x(i) + outer_w(g) / 2 + hub_len, 0, zc])
                color("#111827") bridge_tube(bridge_L);
    }
}

// ---------- Part selector ----------
if (PART == "letter") {
    union() {
        letter_shell(GLYPH);
        divider_clip();
    }
} else if (PART == "letter_diffuser") letter_diffuser(GLYPH);
else if (PART == "glyphs") {
    linear_extrude(1) {
        translate([-260, 0]) glyph2d("E");
        translate([-80, 0]) glyph2d("N");
        translate([80, 0]) glyph2d("g");
        translate([250, 0]) glyph2d("S");
    }
}
else if (PART == "bridge") bridge_tube(bridge_L);
else if (PART == "bridge_diffuser") bridge_diffuser(bridge_L);
else assembly();
