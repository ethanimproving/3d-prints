// Engenesis interlocking light-box logo, clipped onto a cubicle divider.
// Units: mm. Viewer looks along +Y (front face is -Y). Glyphs read along +X, up is +Z.
//
// Export one part at a time: set PART, press F6, export STL.
// PART values: "assembly", "letter", "letter_diffuser", "letter_reflector", "bridge", "bridge_diffuser"

include <letters/glyph_params.scad>
use <letters/E.scad>
use <letters/N.scad>
use <letters/g.scad>
use <letters/S.scad>
use <letters/I.scad>
use <letters/flame.scad>

PART = "assembly";
GLYPH = "E";                      // used when PART = "letter" or "letter_diffuser"
model_scale = 0.35;               // scales height and width only; thickness (Y) stays full size

// ---------- Divider clip ----------
divider_t = 22.41;                // measured cubicle divider width the clip slides onto
clip_clear = 0;                   // extra clearance on top of divider_t
clip_gap = divider_t + clip_clear;
clip_leg_t = 3;
clip_leg_len = 22;
clip_roof_t = 4;
clip_w = 26;

// ---------- Letter light box ----------
letter_d = 20;                     // depth along Y (LED to diffuser path)
side_wall = 3;
back_wall = 3;
diffuser_t = 1.2;
reflector_t = 2;                  // white reflector behind the LED strip
base_t = 4;
letter_gap = 50;                  // clear distance between outer edges of neighbouring letters
// ---------- Octolamp-style base features ----------
strip_w = 10;                     // WS2812B strip width, laid along Y against the wall
strip_t = 1.5;                    // groove depth into the wall, seats the strip flush
strip_y0 = -8.5;                  // strip runs behind the diffuser and in front of the reflector
board_l = 30;                     // Adafruit Sparkle Motion Mini footprint, 1.2" x 0.8"
board_w = 20;
tray_wall = 1.6;                  // octolamp board holder wall
tray_in_x = board_w + 2.4;        // holder pocket 22.4 (X) x 33.8 (Z), measured from the octolamp STL
tray_in_z = board_l + 3.8;
board_x = -14;                         // holder X offset from the glyph centre (I base)
board_dz = 35;                         // holder Z offset above the glyph centre (I base)
tray_h = 6;                       // holder wall depth from the back wall's inner face
cable_notch_w = 8.6;              // cable notch in the holder's bottom wall, measured from octolamp STL
cable_d = 8;                      // cable hole through the back wall, below the notch
pin_d = 2.2;                      // octolamp board locating pins
pin_h = 3;
pin_x = 7.3;                      // pins at +/-7.3 in X and +/-12.7 in Z from the pocket centre
pin_dz = 12.7;

// ---------- Reflector seat (measured from octolamp_black_outer_mini_sparkle_motion.stl) ----------
pillar_d = 6;                     // octolamp corner pillar diameter
pillar_h = 10.5;                  // octolamp pillar height: reflector standoff from the back wall
ridge_w = 3;                      // ledge ridge width around the glyph, holds the reflector edge
pillar_pitch = 40;                // pillar grid spacing; pillars are clipped to the glyph interior

// ---------- Bridge and ports ----------
bridge_h = 18;                    // 10 mm WS2812B strip plus margin
flange_t = 2;
hub_len = 10;                     // port protrudes beyond the letter edge
hub_in = 6;                       // port overlaps into the letter
hub_h = bridge_h + 5;
socket_d = 10;                    // keyed bridge engagement inside each hub
key_extra_h = 3;                  // T-key captures bridge vertically
port_clear = 0.25;                // total clearance on bridge-to-port fit

glyphs = ["FL", "E", "N", "g", "E", "N", "E", "S", "I", "S", "FR"];   // FL/FR: flame ends; "I" is the traced helix snake

// ---------- Derived values ----------
base_top = clip_roof_t + base_t;
zc = base_top + side_wall + letter_h / 2;           // glyph and bridge mid-height
bridge_L = letter_gap - 2 * hub_len;                // visible span between hub faces
back_in_y = letter_d / 2 - back_wall;               // inner face of the back wall
seat_y = back_in_y - pillar_h;                      // pillar tops: reflector rests here
refl_y0 = seat_y - reflector_t;                     // reflector front face

function outer_w(g) = glyph_w(g) + 2 * side_wall;
function left_edge(i) = i == 0 ? 0 : left_edge(i - 1) + outer_w(glyphs[i - 1]) + letter_gap;
function center_x(i) = left_edge(i) + outer_w(glyphs[i]) / 2;
total_w = left_edge(len(glyphs) - 1) + outer_w(glyphs[len(glyphs) - 1]);

// ---------- Glyph helpers ----------
// These profiles deliberately match the supplied wordmark rather than relying on
// an installed font. The I is the traced helix snake.
module rounded_rect(w, h, r) {
    offset(r=r) offset(delta=-r) square([w, h]);
}

module glyph2d(g) {
    if (g == "FL") translate([-glyph_w(g) / 2, -flame_h / 2]) flame_2d(glyph_w(g), flame_h);
    else if (g == "FR") translate([-glyph_w(g) / 2, -flame_h / 2])
        translate([glyph_w(g), 0]) mirror([1, 0]) flame_2d(glyph_w(g), flame_h);
    else if (g == "g") translate([-glyph_w(g) / 2, -letter_h / 2]) logo_g_2d();
    else if (g == "I") translate([-glyph_w(g) / 2, -letter_h / 2]) logo_i_2d();
    else translate([-glyph_w(g) / 2, -letter_h / 2])
        offset(r=round_r) offset(delta=-round_r)
        if (g == "E") logo_e_2d();
        else if (g == "N") logo_n_2d();
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

// Board holder, as in the octolamp: a wall frame and four locating pins stand off the
// inner face of the back wall, with the board lying flat inside (X 20, Z 30, USB end down).
// The bottom wall has a notch for the cable, and a hole through the back wall sits below it.
module controller_bay(g) {
    yb = back_in_y - tray_h;
    zcb = zc + board_dz;
    zb = zcb - tray_in_z / 2;
    translate([board_x, 0, 0]) {
    difference() {
        translate([-tray_in_x / 2 - tray_wall, yb, zb - tray_wall])
            cube([tray_in_x + 2 * tray_wall, tray_h + 0.5, tray_in_z + 2 * tray_wall]);
        translate([-tray_in_x / 2, yb - 1, zb])
            cube([tray_in_x, tray_h + 2, tray_in_z + 1]);
        translate([-cable_notch_w / 2, yb - 1, zb - tray_wall - 1])
            cube([cable_notch_w, tray_h + 2, tray_wall + 2]);
    }
    for (sx = [-1, 1]) for (sz = [-1, 1])
        translate([sx * pin_x, back_in_y - pin_h, zcb + sz * pin_dz])
            rotate([-90, 0, 0]) cylinder(h = pin_h + 0.01, d = pin_d, $fn = 24);
    }
}

module cable_cut(g) {
    translate([board_x, back_in_y - 1, zc + board_dz - tray_in_z / 2 - tray_wall - cable_d / 2 - 1])
        rotate([-90, 0, 0]) cylinder(h = back_wall + 2, d = cable_d, $fn = 32);
}

// ---------- Letter ----------
// Bridge sockets and the bridge channel, cut from the shell and from the seat supports.
module port_cuts(g) {
    ex = glyph_w(g) / 2 + side_wall;
    for (s = [-1, 1])
        scale([s, 1, 1])
            translate([ex + hub_len - socket_d, 0, zc])
                bridge_socket();
    translate([-(ex + hub_len), 0, zc])
        bridge_channel(2 * (ex + hub_len));
}

module cavity_cuts(g) {
    // LED and diffuser cavity: the glyph outline, open to the front
    glyph_slab(g, -letter_d / 2 - 1, back_in_y);
    // Diffuser rebate at the front
    glyph_slab(g, -letter_d / 2 - 1, -letter_d / 2 + diffuser_t, 0.6);
    // LED strip groove: follows the wall so the strip sits flush inside the cavity
    glyph_slab(g, strip_y0, strip_y0 + strip_w, strip_t);
}

// Reflector seat: octolamp-style pillars rise from the back wall to the seat plane,
// and a ridge lip runs around the glyph to hold the reflector edge. Pillar rows
// skip the bridge band so the bridge channel stays clear.
module seat_supports(g) {
    w = glyph_w(g);
    yc = (seat_y + back_in_y + 0.5) / 2;
    union() {
        translate([0, (refl_y0 + back_in_y + 0.5) / 2, zc]) rotate([90, 0, 0])
            linear_extrude(height = back_in_y + 0.5 - refl_y0, center = true)
                difference() {
                    glyph2d(g);
                    offset(delta = -ridge_w) glyph2d(g);
                }
        intersection() {
            union() {
                for (x = [-w / 2 + 15 : pillar_pitch : w / 2 - 15])
                    for (z = g == "I" ? [-60] : [-60, -30, 30, 60])
                        translate([x, yc, zc + z]) rotate([90, 0, 0])
                            cylinder(h = back_in_y + 0.5 - seat_y, d = pillar_d, center = true, $fn = 24);
            }
            glyph_slab(g, seat_y, back_in_y + 0.5, -ridge_w);
        }
    }
}

// ---------- Letter ----------
module letter_shell(g) {
    ex = glyph_w(g) / 2 + side_wall;
    union() {
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
            cavity_cuts(g);
            port_cuts(g);
            if (g == "FL" || g == "I") cable_cut(g);
        }
        if (g == "FL" || g == "I")
            intersection() {
                controller_bay(g);
                glyph_slab(g, back_in_y - tray_h - 1, back_in_y + 1);
            }
        difference() {
            seat_supports(g);
            port_cuts(g);
        }
    }
}

module letter_diffuser(g) {
    glyph_slab(g, -letter_d / 2, -letter_d / 2 + diffuser_t, 0.4);
}

// White reflector slides in from the front and rests on the pillar tops, inside the
// ridge lip. The wire slot at the bottom lets the LED cable leave the cavity, as in the octolamp.
module letter_reflector(g) {
    difference() {
        glyph_slab(g, refl_y0, seat_y, -ridge_w - 0.2);
        if (g == "FL") translate([-4, refl_y0 - 1, zc - letter_h / 2 - 1])
            cube([8, reflector_t + 2, 9]);
    }
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
            color("white") letter_reflector(g);
            color("#0b5c8a") divider_clip();
        }
        if (i < len(glyphs) - 1)
            translate([center_x(i) + outer_w(g) / 2 + hub_len, 0, zc])
                color("#111827") bridge_tube(bridge_L);
    }
}

// ---------- Part selector ----------
// Scale only height (Z) and width (X); thickness (Y) stays full size so the 1.2 mm diffuser, 10 mm LED strip and divider clip keep their real dimensions.
scale([model_scale, 1, model_scale]) if (PART == "letter") {
    union() {
        letter_shell(GLYPH);
        divider_clip();
    }
} else if (PART == "letter_diffuser") letter_diffuser(GLYPH);
else if (PART == "letter_reflector") letter_reflector(GLYPH);
else if (PART == "glyphs") {
    linear_extrude(1) {
        translate([-260, 0]) glyph2d("E");
        translate([-80, 0]) glyph2d("N");
        translate([80, 0]) glyph2d("g");
        translate([250, 0]) glyph2d("S");
        translate([-400, 0]) glyph2d("FL");
        translate([400, 0]) glyph2d("FR");
        translate([560, 0]) glyph2d("I");
    }
}
else if (PART == "bridge") bridge_tube(bridge_L);
else if (PART == "bridge_diffuser") bridge_diffuser(bridge_L);
else assembly();
