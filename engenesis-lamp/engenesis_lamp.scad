// Engenesis interlocking light-box logo, clipped onto a cubicle divider.
// Units: mm. Viewer looks along +Y (front face is -Y). Glyphs read along +X, up is +Z.
//
// Export one part at a time: set PART, press F6, export STL.
// PART values: "assembly", "letter", "letter_diffuser", "letter_reflector", "bridge", "bridge_diffuser"

use <snake_i.scad>

PART = "assembly";
GLYPH = "E";                      // used when PART = "letter" or "letter_diffuser"
model_scale = 0.35;               // proportional scale-down to fit a 300 mm bed and a 2-3 ft divider

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
reflector_t = 2;                  // white reflector behind the LED strip
base_t = 4;
letter_gap = 50;                  // clear distance between outer edges of neighbouring letters
stroke = 36;                      // bold stroke, matching the reference's heavy letterforms
round_r = 10;                     // small logo-style rounding on n, g and S

// ---------- Octolamp-style base features ----------
strip_w = 10;                     // WS2812B strip width, laid along Y against the wall
strip_t = 1.5;                    // groove depth into the wall, seats the strip flush
strip_y0 = -8.5;                  // strip runs behind the diffuser and in front of the reflector
cable_d = 8;                      // charging-cable hole through the flame's back wall
bay_wall = 3;
board_l = 52;                     // controller board footprint (assumed, Sparkle Motion Mini)
board_w = 28;
board_t = 8;

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

flame_h = 2 * letter_h;   // flames rise above and below the letters, as in the logo

function glyph_w(g) = g == "E" ? 130 : g == "N" ? 140 : g == "g" ? 80 : g == "S" ? 140 : g == "I" ? 210 : (g == "FL" || g == "FR") ? 170 : 50;
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

// Single-storey g traced from the logo's lowercase g (unit box, v up).
g_outer_pts = [
    [0.9692, 1.0000], [0.3077, 1.0000], [0.1077, 0.9658], [0.0462, 0.9247], [0.0000, 0.7671],
    [0.0000, 0.4863], [0.0462, 0.3630], [0.1538, 0.3082], [0.2615, 0.2945], [0.5846, 0.2877],
    [0.6615, 0.2534], [0.6154, 0.2055], [0.5077, 0.1575], [0.3538, 0.1370], [0.1692, 0.1301],
    [0.1692, 0.0068], [0.4154, 0.0068], [0.6154, 0.0274], [0.7846, 0.0753], [0.9385, 0.1644],
    [0.9846, 0.3356]
];
g_counter_pts = [
    [0.3846, 0.8630], [0.6154, 0.8630], [0.6462, 0.8493], [0.6462, 0.4384], [0.6154, 0.4247],
    [0.3846, 0.4247], [0.3231, 0.4726], [0.3231, 0.8151], [0.3385, 0.8425]
];

// I: the helix snake from the Snake-I drawing (geometry in snake_i.scad), open jaws and fangs.
// Taller than the letter band: base on the baseline, head above the cap line.
// Height ratio is the logo's snake height (263px) over its letter height (145px).
module logo_i_2d() {
    snake_i_2d(glyph_w("I"), letter_h * 263 / 145);
}

module logo_g_2d() {
    w = glyph_w("g");
    n_out = len(g_outer_pts);
    n_in = len(g_counter_pts);
    polygon(
        points = [for (p = concat(g_outer_pts, g_counter_pts)) [p[0] * w, p[1] * letter_h]],
        paths = [[for (i = [0 : n_out - 1]) i], [for (i = [n_out : n_out + n_in - 1]) i]]
    );
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

// Flame end-piece from the logo: bulbous base, tongue rising to a tip on the left.
// FR is the same flame mirrored, so the word is bracketed symmetrically.
// Left flame outline in a unit box (x: 0..1 across, y: 0..1 up), traced from the logo.
flame_pts = [
    [0.6364, 1.0000], [0.5966, 0.9713], [0.5795, 0.9395], [0.5455, 0.9013], [0.4886, 0.8631],
    [0.4545, 0.8503], [0.4034, 0.8408], [0.2614, 0.8376], [0.1534, 0.8217], [0.1080, 0.8057],
    [0.0568, 0.7771], [0.0170, 0.7389], [0.0000, 0.6943], [0.0000, 0.6306], [0.0284, 0.5573],
    [0.0966, 0.4968], [0.1989, 0.4236], [0.2386, 0.3790], [0.2500, 0.3503], [0.2443, 0.3248],
    [0.2159, 0.2898], [0.0966, 0.2134], [0.0966, 0.2038], [0.1250, 0.1656], [0.1761, 0.1306],
    [0.2443, 0.0987], [0.3295, 0.0732], [0.3182, 0.0701], [0.3920, 0.0510], [0.5057, 0.0287],
    [0.6307, 0.0127], [0.7727, 0.0032], [0.9886, 0.0032], [0.9943, 0.0127], [0.8977, 0.0478],
    [0.7670, 0.1242], [0.6932, 0.1879], [0.6932, 0.2038], [0.6648, 0.2420], [0.6648, 0.3089],
    [0.6989, 0.3758], [0.7330, 0.4172], [0.7330, 0.4459], [0.6648, 0.5127], [0.6477, 0.5414],
    [0.6477, 0.5828], [0.6989, 0.6497], [0.7784, 0.7197], [0.7784, 0.7389], [0.7443, 0.7420],
    [0.7159, 0.7261], [0.6250, 0.6369], [0.5795, 0.6083], [0.5227, 0.5860], [0.4545, 0.5828],
    [0.4205, 0.5924], [0.3750, 0.6178], [0.3409, 0.6561], [0.4034, 0.7484], [0.4716, 0.8057],
    [0.5625, 0.8694], [0.6420, 0.9459], [0.6591, 0.9904], [0.6477, 1.0000]
];

module flame_2d(w, h) {
    polygon([for (p = flame_pts) [p[0] * w, p[1] * h]]);
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

// Controller bay on the back of the flame: the board drops in from below and the
// charging cable enters through the back wall above it.
module controller_bay(g) {
    ex = glyph_w(g) / 2 + side_wall;
    zb = zc - letter_h / 2;
    difference() {
        translate([-board_l / 2 - bay_wall, letter_d / 2, zb])
            cube([board_l + 2 * bay_wall, board_t + bay_wall, board_w + bay_wall]);
        translate([-board_l / 2, letter_d / 2 - 0.01, zb - 1])
            cube([board_l, board_t, board_w + 1]);
    }
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
    // Charging-cable hole through the flame's back wall into the controller bay
    if (g == "FL") translate([0, letter_d / 2 - back_wall - 1, zc - letter_h / 2 + 12])
        rotate([-90, 0, 0]) cylinder(h = back_wall + 2, d = cable_d, $fn = 32);
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
            union()
                for (x = [-w / 2 + 15 : pillar_pitch : w / 2 - 15])
                    for (z = [-60, -30, 30, 60])
                        translate([x, yc, zc + z]) rotate([90, 0, 0])
                            cylinder(h = back_in_y + 0.5 - seat_y, d = pillar_d, center = true, $fn = 24);
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
                if (g == "FL") controller_bay(g);
            }
            cavity_cuts(g);
            port_cuts(g);
        }
        difference() {
            seat_supports(g);
            port_cuts(g);
        }
    }
}

// Recesses cut into the front of the snake diffuser, mapped into glyph space.
// Depth is 0.5 mm of the 1.2 mm diffuser so the detail shows without blocking light.
recess_d = 0.5;

module snake_recess_slab(y0, y1) {
    H = letter_h * 263 / 145;
    translate([0, (y0 + y1) / 2, zc]) rotate([90, 0, 0])
        linear_extrude(height = y1 - y0, center = true)
            translate([-glyph_w("I") / 2, -letter_h / 2])
                scale([glyph_w("I") / 210, H / 340])
                    snake_detail_2d();
}

// The 3D snake stands proud of the diffuser front; its box coordinates map to the glyph.
module snake_3d_on_diffuser() {
    H = letter_h * 263 / 145;
    translate([-glyph_w("I") / 2, -letter_d / 2, zc - letter_h / 2])
        rotate([90, 0, 0])
            scale([glyph_w("I") / 210, H / 340, 1])
                snake_3d_body();
}

module letter_diffuser(g) {
    union() {
        difference() {
            glyph_slab(g, -letter_d / 2, -letter_d / 2 + diffuser_t, 0.4);
            if (g == "I") snake_recess_slab(-letter_d / 2 - 1, -letter_d / 2 + recess_d);
        }
        if (g == "I") snake_3d_on_diffuser();
    }
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
scale(model_scale) if (PART == "letter") {
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
