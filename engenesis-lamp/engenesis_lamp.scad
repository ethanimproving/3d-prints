// Engenesis modular light-box logo, clipped onto a cubicle divider.
// Units: mm. Viewer looks along +Y (front face is -Y). Glyphs read along +X, up is +Z.
// Inter-letter wiring routes through Octolamp-style rear cable grooves (no visible front bridges).
//
// Export one part at a time: set PART, press F6, export STL.
// PART values: "assembly", "letter", "letter_diffuser", "letter_reflector", "glyphs"

include <letters/glyph_params.scad>
use <letters/E.scad>
use <letters/N.scad>
use <letters/g.scad>
use <letters/S.scad>
use <letters/I.scad>
use <letters/I/i_face_grooves.scad>
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
letter_gap = 18;                  // clear kerning gap between outer edges of neighbouring letters (6.3 mm printed)
// ---------- Octolamp-style controller bay & cable slot (measured from octolamp_black_outer_mini_sparkle_motion.stl) ----------
// Exact 1:1 physical dimensions from the Octolamp STL:
//   - Outer frame: 25.6 x 37.0 mm (R_outer = 4.0 mm), 9.75 mm tall above inner floor (0.5 mm chamfered top rim)
//   - Inner pocket: 22.4 x 33.8 mm (R_inner = 2.4 mm), 1.6 mm wall thickness
//   - 4 corner posts at X = +/-7.30 mm, Z = +12.70 / -12.70 mm (offset -1.0 mm from frame mid):
//     D = 5.0 mm PCB standoff base (1.35 mm tall) + D = 2.2 mm locating pin (4.60 mm tall, total 5.95 mm)
//   - Bottom USB-C opening: 12.0 mm wide (R = 1.0 mm) down to 2.95 mm above floor, 8.0 mm step at bottom
//   - Top terminal-block wire exit: 11.0 mm wide top notch + 8.0 mm lower arch down to 3.15 mm above floor
//   - Right side-wall component window: 16.8 mm tall (Z_rel -6.8 .. +10.0), 1.75..9.25 mm above floor
//   - Left & right inner lid-retention snap ribs: 20.0 mm long, 1.0 mm inward protrusion near top rim
//   - Underneath cable strain-relief & exit: two D = 5.0 mm zip-tie holes (10.0 mm spacing),
//     14.2 mm keyhole pass-through (4.0 mm retention neck), and 5.0 x 6.0 mm bottom-wall cable channel.
strip_w = 10;                     // WS2812B strip width, laid along Y against the wall
strip_t = 1.5;                    // groove depth into the wall, seats the strip flush
strip_y0 = -8.5;                  // strip runs behind the diffuser and in front of the reflector
board_l = 30;                     // Adafruit Sparkle Motion Mini footprint, 1.2" x 0.8"
board_w = 20;
tray_wall = 1.6;                  // octolamp board holder wall
tray_in_x = board_w + 2.4;        // holder pocket 22.4 (X) x 33.8 (Z), measured from the octolamp STL
tray_in_z = board_l + 3.8;
tray_out_x = tray_in_x + 2 * tray_wall; // 25.6 mm
tray_out_z = tray_in_z + 2 * tray_wall; // 37.0 mm
tray_r_out = 4.0;                 // Octolamp outer corner radius
tray_r_in = 2.4;                  // Octolamp inner corner radius
board_x = -14;                    // legacy FL holder X offset
board_dz = 35;                    // legacy FL holder Z offset
tray_h = 9.75;                    // Octolamp holder height from inner back floor (-11.0 -> -1.25 mm)
cable_notch_w = 8.6;              // legacy FL cable notch width
cable_d = 8;                      // legacy FL cable hole diameter
pin_base_d = 5.0;                 // Octolamp PCB standoff base diameter
pin_base_h = 1.35;                // Octolamp PCB standoff height (-11.0 -> -9.65 mm)
pin_d = 2.2;                      // Octolamp board locating pin diameter
pin_h = 5.95;                     // Octolamp locating pin total height above floor (-11.0 -> -5.05 mm)
pin_x = 7.3;                      // pins at +/-7.3 mm in X
pin_dz = 12.7;                    // pins at +/-12.7 mm in Z around PCB center (-1.0 mm below frame center)

// Snake "I" 1:1 physical placement (printed mm; unscaled inside controller_bay via 1 / model_scale):
i_chip_x = -9.8;                  // printed X center of chip slot & cable path (clears divider clip at +/-4.55 mm)
i_chip_z = 80.5;                  // printed Z center of chip slot (spans Z = 62.0 .. 99.0 mm in upper belly)
i_ziptie_z = 30.5;                // printed Z of the two D = 5.0 mm zip-tie holes (X = i_chip_x +/- 5.0 mm)
i_keyhole_z = 19.5;               // printed Z of the D = 14.2 mm keyhole head (narrows to 4.0 mm neck below)

// ---------- Reflector seat & Octolamp wall dimensions (measured from octolamp_black_outer_mini_sparkle_motion.stl) ----------
// Exact Octolamp two-layer wall geometry (applied to the Snake "I" base):
//   - Total exterior depth: 25.0 mm (1.0 mm back floor + 11.0 mm bottom ridge + 13.0 mm top wall)
//   - Top wall (in front of reflector seat): 13.0 mm tall, 3.0 mm thick printed
//   - Bottom ridge (behind reflector seat):  11.0 mm tall, 6.0 mm total printed thickness (3.0 mm outer + 3.0 mm inward ledge)
//   - Inner cat-head snap V-groove: 14.41 mm span, starts 2.22 mm behind front lip, 2.88 mm along depth, 1.37 mm peak depth
i_back_wall = 1.0;                // Octolamp back floor thickness (mm along Y)
i_bot_wall_h = 11.0;              // Octolamp bottom ridge height from floor to reflector seat (mm along Y)
i_top_wall_h = 13.0;              // Octolamp top wall height from reflector seat to front lip (mm along Y)
i_box_d = i_back_wall + i_bot_wall_h + i_top_wall_h; // 25.0 mm total exterior depth along Y
i_side_wall = 3.0 / model_scale;  // 3.0 mm printed top-layer wall thickness (unscaled X/Z)
i_ridge_w = 3.0 / model_scale;    // 3.0 mm printed inward ledge -> 6.0 mm total bottom-layer wall thickness

snap_w = 14.41 / model_scale;     // snap groove span along X (14.41 mm printed, from octolamp cat-head snap)
snap_top_x = -2.5 / model_scale;  // centred on the flat crown of the I head
snap_bot_x = -5.0 / model_scale;  // centred on the flat foot of the I base (-34.7 .. +25.0 mm printed)
snap_y_inset = 2.22;              // starts 2.22 mm behind the front lip (exact octolamp cat-head measurement)
snap_y_span = 2.88;               // 2.88 mm total V-groove length along Y (exact octolamp cat-head measurement)
snap_depth = 1.37 / model_scale;  // 1.37 mm printed peak depth into the 3.0 mm wall (exact octolamp cat-head measurement)

// ---------- Octolamp white_inner diffuser shell & snap tabs (measured from octolamp_white_inner.stl) ----------
// Exact measurements from octolamp_white_inner.stl (15.00 mm total depth, hollow 1.00 mm wall/face):
//   - Skirt radial clearance: -0.50 mm inset from base inner cavity wall (1.00 mm thick skirt -> inner at -1.50 mm)
//   - Skirt depth: 12.00 mm (runs from front_y - 1.00 = -13.50 mm back to -1.50 mm, resting against reflector front face)
//   - Front 45 deg beveled dome: protrudes 3.00 mm further forward (front face at -16.50 mm, 4.00 mm proud of base lip,
//     1.00 mm thick front face, tapering inward 3.00 mm at 45 deg)
//   - Snap tabs (cat-head spec): 13.20 mm wide (0.60 mm side clearance inside 14.41 mm base groove),
//     3.00 mm Y-span (45 deg V-ridge centered at Y = -8.84 mm), protruding 1.50 mm outward from skirt (+1.00 mm past
//     cavity wall into the 1.37 mm base groove -> 0.37 mm bottoming clearance, matching Octolamp's 0.36 mm).
i_diff_clr_mm = 0.50;             // radial clearance between base inner wall and diffuser skirt outer face (mm)
i_diff_wall_mm = 1.00;            // diffuser skirt & front face wall thickness (mm)
i_diff_skirt_len = 12.00;         // skirt length from bevel base (-13.50 mm) back to reflector face (-1.50 mm)
i_diff_proud_skirt = 1.00;        // skirt extends 1.00 mm proud of base front lip (-12.50 -> -13.50 mm)
i_diff_bevel_mm = 3.00;           // 45 deg front bevel height & radial inset (front face at -16.50 mm)
i_tab_w = 13.20 / model_scale;    // snap tab width along X (13.20 mm printed, from octolamp_white_inner cat-head tab)
i_tab_y_span = 3.00;              // 45 deg V-ridge length along Y (centred on base snap groove apex)
i_tab_protrude_mm = 1.50;         // outward protrusion from skirt face (reaches +1.00 mm into 1.37 mm base groove)
i_face_groove_depth = 0.45;       // subtle 0.45 mm relief indentation into the 1.00 mm front diffuser face (leaves 0.55 mm solid skin)

// ---------- Octolamp white_reflector cable pocket & slit (measured from octolamp_white_reflector.stl & .dxf) ----------
// Exact CAD measurements from octolamp_white_reflector_laser.dxf:
//   - Reflector plate thickness: 2.00 mm (sits at Y = -1.50 .. +0.50 mm, -0.75 mm perimeter clearance)
//   - Rounded rectangular cable pocket: 16.00 mm wide (X) x 9.00 mm tall (Z), corner radius R = 2.00 mm
//   - Entry slit from outer perimeter: 1.50 mm wide horizontal slit centered on the 9.00 mm pocket,
//     opening right through the nearest side edge so the pre-wired LED cable slides in sideways during assembly!
i_refl_pocket_w_mm = 16.00;       // Octolamp reflector cable pocket width (mm)
i_refl_pocket_h_mm = 9.00;        // Octolamp reflector cable pocket height (mm)
i_refl_pocket_r_mm = 2.00;        // Octolamp reflector cable pocket corner radius (mm)
i_refl_slit_h_mm   = 1.50;        // Octolamp reflector side-entry wire slit height (mm)
pillar_d = 6;                     // octolamp corner pillar diameter
pillar_h = 10.5;                  // standard letter pillar height: reflector standoff from the back wall
ridge_w = 3;                      // standard letter ledge ridge width around the glyph
pillar_pitch = 40;                // pillar grid spacing; pillars are clipped to the glyph interior

// ---------- Rear cable grooves (measured from octolamp_black_outer_mini_sparkle_motion.stl) ----------
// Octolamp rear horizontal cable groove: 4.00 mm tall x 6.00 mm deep into the back (4.01 mm straight + 45 deg roof bevel),
// running right across the bottom rim so inter-letter wires tuck flush into the back face with no external bridges.
groove_h_mm = 4.0;                // Octolamp horizontal rear groove height (mm printed)
groove_d_mm = 6.0;                // Octolamp horizontal rear groove total depth from back face (mm)
groove_flat_d_mm = 4.01;          // straight side-wall portion before the 45 deg bevel roof (mm)
i_groove_z_mm = 7.0;              // printed Z center of the horizontal rear groove across the Snake "I" bottom foot (Z = 5.0..9.0 mm)
std_groove_d = 2.2;               // rear groove depth into the 3.0 mm back wall on standard letters (leaves 0.8 mm skin)
wire_pass_d_mm = 4.5;             // wire pass-through hole diameter from rear groove into standard letter cavities

glyphs = ["FL", "E", "N", "g", "E", "N", "E", "S", "I", "S", "FR"];   // FL/FR: flame ends; "I" is the traced helix snake

// ---------- Derived values ----------
base_top = clip_roof_t + base_t;
zc = base_top + side_wall + letter_h / 2;           // glyph mid-height
back_in_y = letter_d / 2 - back_wall;               // inner face of the back wall
seat_y = back_in_y - pillar_h;                      // pillar tops: reflector rests here
refl_y0 = seat_y - reflector_t;                     // reflector front face

// Per-glyph shell geometry helpers (Snake "I" uses exact Octolamp 25 mm two-layer walls; other glyphs keep 20 mm letter_d)
function box_d_of(g) = g == "I" ? i_box_d : letter_d;
function side_wall_of(g) = g == "I" ? i_side_wall : side_wall;
function back_wall_of(g) = g == "I" ? i_back_wall : back_wall;
function pillar_h_of(g) = g == "I" ? i_bot_wall_h : pillar_h;
function ridge_w_of(g) = g == "I" ? i_ridge_w : ridge_w;
function front_y_of(g) = -box_d_of(g) / 2;
function back_in_y_of(g) = box_d_of(g) / 2 - back_wall_of(g);
function seat_y_of(g) = back_in_y_of(g) - pillar_h_of(g);
function refl_y0_of(g) = seat_y_of(g) - reflector_t;

function outer_w(g) = glyph_w(g) + 2 * side_wall_of(g);
function left_edge(i) = i == 0 ? 0 : left_edge(i - 1) + outer_w(glyphs[i - 1]) + letter_gap;
function center_x(i) = left_edge(i) + outer_w(glyphs[i]) / 2;
total_w = left_edge(len(glyphs) - 1) + outer_w(glyphs[len(glyphs) - 1]);

// ---------- Glyph helpers ----------
// These profiles deliberately match the supplied wordmark rather than relying on
// an installed font. The I is the traced helix snake.
module rounded_rect(w, h, r) {
    offset(r=r) offset(delta=-r) square([w, h]);
}

// Outline points of the polygon glyphs. Each part binds them once with let($glyph_pts = glyph_points(g))
// so the ~10 glyph2d calls per letter reuse one list; re-evaluating the traced outlines on every
// call pushes the full assembly past the VS Code OpenSCAD.js preview's 100k evaluation-step limit.
function glyph_points(g) =
    (g == "FL" || g == "FR") ? flame_points(glyph_w(g), flame_h) :
    g == "g" ? logo_g_points() :
    g == "I" ? logo_i_points() : [];

// Requires $glyph_pts, bound by let($glyph_pts = glyph_points(g)).
module glyph2d(g) {
    if (g == "FL") translate([-glyph_w(g) / 2, -flame_h / 2]) flame_2d(glyph_w(g), flame_h, $glyph_pts);
    else if (g == "FR") translate([-glyph_w(g) / 2, -flame_h / 2])
        translate([glyph_w(g), 0]) mirror([1, 0]) flame_2d(glyph_w(g), flame_h, $glyph_pts);
    else if (g == "g") translate([-glyph_w(g) / 2, -letter_h / 2]) logo_g_2d($glyph_pts);
    else if (g == "I") translate([-glyph_w(g) / 2, -letter_h / 2]) logo_i_2d($glyph_pts);
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

// Octolamp-style rear cable grooves (indented into the back face, replacing external inter-letter bridges):
//   - On Snake "I": exact 4.00 mm tall x 6.00 mm deep 45 deg roof-beveled horizontal groove across the back
//     of the 6.00 mm bottom rim (intersecting the keyhole neck + vertical exit groove in a clean cross,
//     matching octolamp_black_outer_mini_sparkle_motion.stl).
//   - On standard letters: matching horizontal rear cable groove across the bottom back face + wire entry holes
//     into the letter cavity so 3-wire LED jumpers route cleanly behind the letters.
module rear_cable_grooves(g) {
    ex = glyph_w(g) / 2 + side_wall_of(g);
    back_y = front_y_of(g) + box_d_of(g);
    if (g == "I") {
        scale([1 / model_scale, 1, 1 / model_scale]) {
            w_mm = 2 * ex * model_scale + 4;
            hull() {
                translate([-w_mm / 2, back_y - groove_flat_d_mm, i_groove_z_mm - groove_h_mm / 2])
                    cube([w_mm, groove_flat_d_mm + 0.5, groove_h_mm]);
                translate([-w_mm / 2, back_y - groove_d_mm, i_groove_z_mm - 0.02])
                    cube([w_mm, groove_d_mm + 0.5, 0.04]);
            }
        }
    } else {
        // Horizontal groove indented into the 3.0 mm back wall + wire pass-through hole(s) into the cavity
        scale([1 / model_scale, 1, 1 / model_scale]) {
            w_mm = 2 * ex * model_scale + 4;
            gz = i_groove_z_mm;
            hull() {
                translate([-w_mm / 2, back_y - (std_groove_d - 0.8), gz - groove_h_mm / 2])
                    cube([w_mm, std_groove_d, groove_h_mm]);
                translate([-w_mm / 2, back_y - std_groove_d, gz - 0.8])
                    cube([w_mm, std_groove_d + 0.5, 1.6]);
            }
            // Through-holes from the rear groove into the letter cavity (two on arch "N", one on others)
            xs_mm = g == "N" ? [-18.2, 18.2] : (g == "g" ? [-5.5] : [0]);
            for (xh = xs_mm)
                translate([xh, back_y - back_wall - 1.0, gz])
                    rotate([-90, 0, 0]) cylinder(h = back_wall + 1.5, d = wire_pass_d_mm, $fn = 24);
        }
    }
}

// Exact 1:1 Octolamp Sparkle Motion Mini chip slot (built in true mm, then counter-scaled by 1/model_scale in X/Z
// on Snake "I" so the final printed holder has the exact 25.6 x 37.0 x 9.75 mm Octolamp geometry).
module octolamp_chip_holder_mm() {
    // Local origin: (0, 0, 0) at frame X/Z center on the inner face of the back floor; cavity projects along -Y (0.2 mm embed into floor).
    difference() {
        union() {
            // Rounded outer frame (25.6 x 37.0 mm, R = 4.0 mm) with 0.5 mm chamfered top rim (9.75 mm above floor)
            hull() {
                translate([0, 0.2, 0]) rotate([90, 0, 0]) linear_extrude(height = tray_h - 0.5 + 0.2)
                    offset(r = tray_r_out) square([tray_out_x - 2 * tray_r_out, tray_out_z - 2 * tray_r_out], center = true);
                translate([0, -(tray_h - 0.5), 0]) rotate([90, 0, 0]) linear_extrude(height = 0.5)
                    offset(r = tray_r_out - 0.5) square([tray_out_x - 2 * tray_r_out, tray_out_z - 2 * tray_r_out], center = true);
            }
        }
        // Rounded inner pocket (22.4 x 33.8 mm, R = 2.4 mm) stopping flush at floor (Y_rel = 0)
        translate([0, 0.01, 0]) rotate([90, 0, 0]) linear_extrude(height = tray_h + 1)
            offset(r = tray_r_in) square([tray_in_x - 2 * tray_r_in, tray_in_z - 2 * tray_r_in], center = true);

        // Bottom USB-C enclosed window (matching Octolamp South wall: 10.4 x 5.0 mm rounded window,
        // 1.95..6.95 mm above floor, leaving a 2.80 mm enclosed bridge across the top rim!)
        translate([0, -(2.45 + 2.50), -tray_out_z / 2])
            rotate([90, 0, 0]) linear_extrude(height = 6.0, center = true)
                offset(r = 1.0) square([10.4 - 2.0, 5.0 - 2.0], center = true);

        // Top 3-pin terminal-block wire exit: 11.0 mm upper notch + 8.0 mm lower slot (down to 3.15 mm above floor)
        translate([0, -(tray_h + 1) / 2 - 3.15, tray_out_z / 2]) {
            cube([8.0, tray_h + 1, 6.0], center = true);
            translate([0, -3.2, 0]) cube([11.0, tray_h - 5, 6.0], center = true);
        }

        // Right-wall side component window (Z_rel = -6.8 .. +10.0 mm, Y_rel = -9.25 .. -1.75 mm)
        translate([tray_out_x / 2, -5.5, 1.6])
            cube([6.0, 7.5, 16.8], center = true);
    }

    // Inner lid-retention snap ribs along left & right walls (left: 20 mm intact; right: split outside the side window)
    translate([-(tray_in_x / 2 - 0.5), -(tray_h - 1.0), 0])
        hull() {
            translate([0.45, 0, 0]) cube([0.1, 0.5, 19.0], center = true);
            translate([-0.55, 0, 0]) cube([0.3, 1.9, 20.0], center = true);
        }
    for (seg = [[-8.4, 3.2], [10.5, 1.0]])
        translate([tray_in_x / 2 - 0.5, -(tray_h - 1.0), seg[0]])
            hull() {
                translate([-0.45, 0, 0]) cube([0.1, 0.5, seg[1]], center = true);
                translate([0.55, 0, 0]) cube([0.3, 1.9, seg[1] + 0.4], center = true);
            }

    // 4 stepped PCB standoffs (D = 5.0 x 1.35 mm) + locating pins (D = 2.2 x 5.95 mm) at X = +/-7.3, Z = -1.0 +/- 12.7
    for (sx = [-1, 1]) for (sz = [-1, 1])
        translate([sx * pin_x, 0.2, -1.0 + sz * pin_dz]) rotate([90, 0, 0]) {
            cylinder(h = pin_base_h + 0.2, d = pin_base_d, $fn = 28);
            cylinder(h = pin_h + 0.2, d = pin_d, $fn = 24);
        }
}

// Exact 1:1 Octolamp cable exit & strain-relief cuts (built in true mm, subtracted on Snake "I"):
//   1. Two D = 5.0 mm zip-tie holes (10.0 mm apart) through the 1.0 mm back floor
//   2. Keyhole cable pass-through (D = 14.2 mm plug hole + 4.0 mm retention neck, 45 deg floor chamfer)
//   3. 5.0 mm wide x 6.0 mm deep rear cable channel through the bottom foot wall & base plate
module octolamp_cable_cuts_mm(bin_y, bw) {
    // 1. Two D = 5.0 mm zip-tie holes at Z = i_ziptie_z, X = i_chip_x +/- 5.0 mm
    for (sx = [-1, 1])
        translate([i_chip_x + sx * 5.0, bin_y - 0.5, i_ziptie_z])
            rotate([-90, 0, 0]) cylinder(h = bw + 1.5, d = 5.0, $fn = 28);

    // 2. Keyhole cable pass-through through the 1.0 mm back floor (with inner 45 deg chamfer matching Octolamp)
    for (pass = [[0, -0.2, bw + 0.6], [0.8, -0.05, 0.65]]) {
        grow = pass[0];
        y0 = bin_y + pass[1];
        th = pass[2];
        translate([i_chip_x, y0 + th / 2, 0]) rotate([90, 0, 0])
            linear_extrude(height = th, center = true) offset(delta = grow) union() {
                // Upper D = 14.2 mm plug head
                translate([0, i_keyhole_z]) circle(d = 14.2, $fn = 40);
                // 4.0 mm retention neck running straight down into the bottom-wall cable channel
                translate([-2.0, 6.85]) square([4.0, i_keyhole_z - 6.85]);
            }
    }

    // 3. Rear cable channel (5.0 mm wide, 6.0 mm deep from outer back face, chamfered inner roof)
    //    running from the keyhole circle down through the thicker bottom ridge and out the bottom wall
    hull() {
        translate([i_chip_x - 2.5, bin_y + bw - 4.0, -1.0])
            cube([5.0, 4.5, 13.6]);
        translate([i_chip_x - 0.5, bin_y + bw - 6.0, -1.0])
            cube([1.0, 6.5, 13.6]);
    }
}

module controller_bay(g) {
    bin_y = back_in_y_of(g);
    if (g == "I") {
        translate([i_chip_x / model_scale, bin_y, i_chip_z / model_scale])
            scale([1 / model_scale, 1, 1 / model_scale])
                octolamp_chip_holder_mm();
    } else {
        yb = bin_y - 6;
        zcb = zc + board_dz;
        zb = zcb - tray_in_z / 2;
        translate([board_x, 0, 0]) {
            difference() {
                translate([-tray_in_x / 2 - tray_wall, yb, zb - tray_wall])
                    cube([tray_in_x + 2 * tray_wall, 6.5, tray_in_z + 2 * tray_wall]);
                translate([-tray_in_x / 2, yb - 1, zb])
                    cube([tray_in_x, 8, tray_in_z + 1]);
                translate([-cable_notch_w / 2, yb - 1, zb - tray_wall - 1])
                    cube([cable_notch_w, 8, tray_wall + 2]);
            }
            for (sx = [-1, 1]) for (sz = [-1, 1])
                translate([sx * pin_x, bin_y - 3, zcb + sz * pin_dz])
                    rotate([-90, 0, 0]) cylinder(h = 3.01, d = pin_d, $fn = 24);
        }
    }
}

module cable_cut(g) {
    bin_y = back_in_y_of(g);
    bw = back_wall_of(g);
    if (g == "I") {
        scale([1 / model_scale, 1, 1 / model_scale])
            octolamp_cable_cuts_mm(bin_y, bw);
    } else {
        translate([board_x, bin_y - 1, zc + board_dz - tray_in_z / 2 - tray_wall - cable_d / 2 - 1])
            rotate([-90, 0, 0]) cylinder(h = bw + 2, d = cable_d, $fn = 32);
    }
}

// ---------- Letter ----------
module cavity_cuts(g) {
    fy = front_y_of(g);
    // LED and diffuser cavity: the glyph outline, open to the front
    glyph_slab(g, fy - 1, back_in_y_of(g));
    // Standard letters use a flat diffuser rebate + shallow strip groove;
    // Snake "I" uses a flush 3.0 mm Octolamp top wall (diffuser skirt slides inside with 0.50 mm clearance and snaps into i_snap_grooves)
    if (g != "I") {
        glyph_slab(g, fy - 1, fy + diffuser_t, 0.6);
        glyph_slab(g, strip_y0, strip_y0 + strip_w, strip_t);
    }
}

// Diffuser snap grooves at the top and bottom of the I base, modelled on the octolamp's
// inner V-grooves: each groove follows the exact glyph inner wall (`offset(delta = d) glyph2d`),
// starting 2.22 mm behind the front lip and peaking at 1.37 mm printed depth inside the 3.0 mm top wall.
module i_snap_grooves() {
    y_start = front_y_of("I") + snap_y_inset;
    steps = 6;
    dy = snap_y_span / steps;
    intersection() {
        union() {
            for (k = [0 : steps - 1]) {
                u = (k + 0.5) / steps;
                d = snap_depth * (1 - abs(2 * u - 1));
                glyph_slab("I", y_start + k * dy - 0.02, y_start + (k + 1) * dy + 0.02, d);
            }
        }
        union() {
            // Top crown mask
            translate([snap_top_x - snap_w / 2, y_start - 1, zc + 180])
                cube([snap_w, snap_y_span + 2, 100]);
            // Bottom foot mask
            translate([snap_bot_x - snap_w / 2, y_start - 1, zc - 110])
                cube([snap_w, snap_y_span + 2, 40]);
        }
    }
}

// Reflector seat: octolamp-style pillars rise from the back wall to the seat plane,
// and an inward ledge runs around the glyph (for "I": 11 mm tall x 3 mm wide -> 6 mm bottom wall, flush at seat_y,
// plus a thicker bottom foot shelf up to Z = 12.6 mm printed around the keyhole neck just like on the Octolamp).
i_foot_ridge_top_mm = 12.6;       // printed Z top of the thicker bottom ridge shelf (top of keyhole neck, below D=14.2 circle)
module seat_supports(g) {
    w = glyph_w(g);
    bin_y = back_in_y_of(g);
    sy = seat_y_of(g);
    rw = ridge_w_of(g);
    ledge_front_y = g == "I" ? sy : refl_y0_of(g);
    yc = (sy + bin_y + 0.5) / 2;
    union() {
        translate([0, (ledge_front_y + bin_y + 0.5) / 2, zc]) rotate([90, 0, 0])
            linear_extrude(height = bin_y + 0.5 - ledge_front_y, center = true)
                difference() {
                    glyph2d(g);
                    offset(delta = -rw) glyph2d(g);
                }
        if (g == "I") {
            // Thicker bottom foot ridge filling the 11 mm bottom layer up to the top of the keyhole neck
            intersection() {
                glyph_slab("I", sy, bin_y + 0.5, 0);
                translate([-w, sy - 1, 0])
                    cube([2 * w, bin_y - sy + 2, i_foot_ridge_top_mm / model_scale]);
            }
        }
        intersection() {
            union() {
                if (g == "I") {
                    // Reflector standoff pillars (specified directly in printed mm: lower-left lobe, right belly lobe, upper head)
                    for (pm = [[-22.0, 21.0], [8.5, 53.0], [12.25, 105.35]])
                        translate([pm[0] / model_scale, yc, pm[1] / model_scale])
                            scale([1 / model_scale, 1, 1 / model_scale])
                                rotate([90, 0, 0])
                                    cylinder(h = bin_y + 0.5 - sy, d = pillar_d, center = true, $fn = 24);
                } else {
                    for (x = [-w / 2 + 15 : pillar_pitch : w / 2 - 15])
                        for (z = [-60, -30, 30, 60])
                            translate([x, yc, zc + z]) rotate([90, 0, 0])
                                cylinder(h = bin_y + 0.5 - sy, d = pillar_d, center = true, $fn = 24);
                }
            }
            glyph_slab(g, sy, bin_y + 0.5, -rw);
        }
    }
}

// ---------- Letter ----------
module letter_shell(g) {
    sw = side_wall_of(g);
    fy = front_y_of(g);
    bd = box_d_of(g);
    bin_y = back_in_y_of(g);
    ex = glyph_w(g) / 2 + sw;
    union() {
        difference() {
            union() {
                glyph_slab(g, fy, fy + bd, sw);
                if (g != "I")
                    translate([-ex, fy, clip_roof_t])
                        cube([2 * ex, bd, base_t]);
            }
            cavity_cuts(g);
            rear_cable_grooves(g);
            if (g == "I") i_snap_grooves();
            if (g == "FL" || g == "I") cable_cut(g);
        }
        if (g == "FL" || g == "I")
            intersection() {
                controller_bay(g);
                glyph_slab(g, bin_y - (g == "I" ? tray_h : 6) - 1, bin_y + 1);
            }
        difference() {
            seat_supports(g);
            rear_cable_grooves(g);
            if (g == "I") cable_cut(g);
        }
    }
}

// Octolamp-engineered hollow diffuser shell + snap tabs for Snake "I" (matching octolamp_white_inner.stl):
//   - 12.00 mm deep x 1.00 mm thick skirt (`Y = -13.50 .. -1.51 mm`, inset -0.50 mm from base cavity wall)
//   - 3.00 mm 45 deg beveled front dome (`Y = -16.50 .. -13.50 mm`, 1.00 mm front face thickness)
//   - Top & bottom 13.20 mm wide 45 deg V-ridge snap tabs engaging `i_snap_grooves` at `Y = -8.84 mm`
module i_octolamp_diffuser() {
    fy = front_y_of("I");                             // -12.50 mm
    y_bevel_base = fy - i_diff_proud_skirt;           // -13.50 mm
    y_front = y_bevel_base - i_diff_bevel_mm;         // -16.50 mm
    y_back = y_bevel_base + i_diff_skirt_len - 0.02;  // -1.52 mm (clears reflector at -1.50 mm)
    bevel_steps = 8;
    dy_bev = i_diff_bevel_mm / bevel_steps;

    y_snap_mid = fy + snap_y_inset + snap_y_span / 2; // -8.84 mm (exact apex of base snap groove)
    y_tab0 = y_snap_mid - i_tab_y_span / 2;
    tab_steps = 6;
    dy_tab = i_tab_y_span / tab_steps;

    union() {
        difference() {
            // Outer shell: 12 mm skirt + 3 mm 45 deg beveled front dome
            union() {
                glyph_slab("I", y_bevel_base, y_back, -i_diff_clr_mm / model_scale);
                for (k = [0 : bevel_steps - 1]) {
                    inset_mm = i_diff_clr_mm + i_diff_bevel_mm * ((k + 0.5) / bevel_steps);
                    glyph_slab("I", y_bevel_base - (k + 1) * dy_bev - 0.02, y_bevel_base - k * dy_bev + 0.02, -inset_mm / model_scale);
                }
            }
            // Inner hollow cavity: 1.00 mm uniform wall & front face, open at the rear (-1.52 mm)
            union() {
                glyph_slab("I", y_bevel_base + i_diff_wall_mm, y_back + 1.0, -(i_diff_clr_mm + i_diff_wall_mm) / model_scale);
                for (k = [0 : bevel_steps - 1]) {
                    inset_mm = i_diff_clr_mm + i_diff_wall_mm + i_diff_bevel_mm * ((k + 0.5) / bevel_steps);
                    glyph_slab("I", y_bevel_base + i_diff_wall_mm - (k + 1) * dy_bev - 0.02, y_bevel_base + i_diff_wall_mm - k * dy_bev + 0.02, -inset_mm / model_scale);
                }
            }
            // Subtle front-face indentations (0.45 mm deep into the 1.00 mm front face) for the snake body coils,
            // belly scales, head/eye details, vertical I-column rails, and DNA helix rungs
            if (i_face_groove_depth > 0)
                translate([0, y_front + i_face_groove_depth / 2, zc])
                    rotate([90, 0, 0])
                        linear_extrude(height = i_face_groove_depth + 0.2, center = true)
                            i_face_grooves_2d();
        }

        // Top & bottom 45 deg V-ridge snap tabs on the outer face of the skirt (anchored 0.4 mm into skirt wall)
        intersection() {
            difference() {
                union() {
                    for (k = [0 : tab_steps - 1]) {
                        u = (k + 0.5) / tab_steps;
                        out_mm = -i_diff_clr_mm + i_tab_protrude_mm * (1 - abs(2 * u - 1));
                        glyph_slab("I", y_tab0 + k * dy_tab - 0.02, y_tab0 + (k + 1) * dy_tab + 0.02, out_mm / model_scale);
                    }
                }
                glyph_slab("I", y_tab0 - 0.5, y_tab0 + i_tab_y_span + 0.5, -(i_diff_clr_mm + 0.4) / model_scale);
            }
            union() {
                translate([snap_top_x - i_tab_w / 2, y_tab0 - 1, zc + 180])
                    cube([i_tab_w, i_tab_y_span + 2, 100]);
                translate([snap_bot_x - i_tab_w / 2, y_tab0 - 1, zc - 110])
                    cube([i_tab_w, i_tab_y_span + 2, 40]);
            }
        }
    }
}

module letter_diffuser(g) {
    if (g == "I") {
        i_octolamp_diffuser();
    } else {
        fy = front_y_of(g);
        glyph_slab(g, fy, fy + diffuser_t, 0.4);
    }
}

// White reflector slides in from the front and rests on the pillar tops / bottom-layer ledge.
// For "I", matches octolamp_white_reflector.stl & octolamp_white_reflector_laser.dxf:
//   - 2.00 mm thick (`Y = -1.50 .. +0.50 mm`), -0.75 mm perimeter clearance inside the 3.00 mm top wall
//   - 16.00 x 9.00 mm (`R = 2.00 mm`) rounded cable pocket centered at `(i_chip_x - 0.47, i_ziptie_z)`
//   - 1.50 mm wide horizontal entry slit opening out the right side edge (`+X`) so pre-attached LED wires slip in sideways!
module letter_reflector(g) {
    inset = g == "I" ? (-0.75 / model_scale) : (-ridge_w - 0.2);
    difference() {
        glyph_slab(g, refl_y0_of(g), seat_y_of(g), inset);
        if (g == "I") {
            px = i_chip_x - 0.47;
            pz = i_ziptie_z;
            scale([1 / model_scale, 1, 1 / model_scale])
                translate([0, (refl_y0_of(g) + seat_y_of(g)) / 2, 0])
                    rotate([90, 0, 0])
                        linear_extrude(height = reflector_t + 2, center = true) union() {
                            // 16.00 x 9.00 mm rounded rectangular cable pocket (R = 2.00 mm)
                            translate([px, pz])
                                offset(r = i_refl_pocket_r_mm, $fn = 28)
                                    square([i_refl_pocket_w_mm - 2 * i_refl_pocket_r_mm, i_refl_pocket_h_mm - 2 * i_refl_pocket_r_mm], center = true);
                            // 1.50 mm wide horizontal entry slit out to the right edge (+X)
                            translate([px, pz - i_refl_slit_h_mm / 2])
                                square([30.0, i_refl_slit_h_mm]);
                        }
        } else {
            xs_mm = g == "N" ? [-18.2, 18.2] : (g == "g" ? [-5.5] : [0]);
            scale([1 / model_scale, 1, 1 / model_scale])
                for (xh = xs_mm)
                    translate([xh - 3.5, refl_y0_of(g) - 1, 5.5])
                        cube([7.0, reflector_t + 2, 6.0]);
        }
    }
}

// ---------- Assembly preview ----------
module assembly() {
    for (i = [0 : len(glyphs) - 1]) {
        g = glyphs[i];
        translate([center_x(i), 0, 0]) let($glyph_pts = glyph_points(g)) {
            color("#111827") letter_shell(g);
            color([0.75, 0.9, 1, 0.85]) letter_diffuser(g);
            color("white") letter_reflector(g);
            color("#0b5c8a") divider_clip();
        }
    }
}

// ---------- Part selector ----------
// Scale only height (Z) and width (X); thickness (Y) stays full size so the 1.2 mm diffuser, 10 mm LED strip and divider clip keep their real dimensions.
module render_part(part = PART, glyph = GLYPH) {
    scale([model_scale, 1, model_scale]) if (part == "letter") let($glyph_pts = glyph_points(glyph)) {
        union() {
            letter_shell(glyph);
            divider_clip();
        }
    } else if (part == "letter_diffuser") let($glyph_pts = glyph_points(glyph)) letter_diffuser(glyph);
    else if (part == "letter_reflector") let($glyph_pts = glyph_points(glyph)) letter_reflector(glyph);
    else if (part == "glyphs") {
        linear_extrude(1) {
            translate([-260, 0]) let($glyph_pts = glyph_points("E")) glyph2d("E");
            translate([-80, 0]) let($glyph_pts = glyph_points("N")) glyph2d("N");
            translate([80, 0]) let($glyph_pts = glyph_points("g")) glyph2d("g");
            translate([250, 0]) let($glyph_pts = glyph_points("S")) glyph2d("S");
            translate([-400, 0]) let($glyph_pts = glyph_points("FL")) glyph2d("FL");
            translate([400, 0]) let($glyph_pts = glyph_points("FR")) glyph2d("FR");
            translate([560, 0]) let($glyph_pts = glyph_points("I")) glyph2d("I");
        }
    }
    else assembly();
}

render_part();
