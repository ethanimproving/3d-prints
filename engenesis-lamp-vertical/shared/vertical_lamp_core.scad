// Parametric Octolamp-Engineered Vertical-Stack Lamp Core
// Units: true printed mm (1:1 scale — NO global X/Z shrinking that would distort hardware pockets).
// Orientation: Viewer looks along +Y (front diffuser face is -Y, flat rear wall is +Y, X is horizontal, +Z is up).
//
// Key Vertical-Display Engineering Changes vs. Horizontal Cubicle Version:
//   1. Bottom cubicle divider clip removed -> flat 0.00 mm baseline and 100% flush rear wall (Y = +12.50 mm).
//   2. Interlocking Hollow Double-Dovetail ("Bowtie") Sockets + 14.0 mm LED-Strip Conduit Channels
//      built into the 11.0 mm rear structural layer (Y = +0.50 .. +11.00 mm, behind the 2.0 mm white reflector):
//        - Top / Bottom sockets lock the 9-letter vertical column rigidly against gravity & shear.
//        - Left / Right side sockets on E_top, FL, and FR lock the flanking top flames via 15.70 mm hollow bridges.
//        - Front 13.0 mm bezel (Y = -12.50 .. +0.50 mm), snap V-grooves, and 15.0 mm hollow diffusers remain 100% unbroken & light-tight.
//   3. Reflector plates include aligned 15.0 x 7.0 mm (R = 2.0 mm) LED-strip pass-through pockets + 1.50 mm edge slits
//      so continuous uncut 10 mm / 12 mm LED strips (or 3-pin JST-SM plugs) transition smoothly from front wall -> hollow key -> next letter.
//   4. Print-in-place blind rear screw keyhole mount (45 deg self-supporting roof, 2.3 mm solid inner cap -> zero light leak)
//      aligned along X = 0.00 mm for hanging flush on a vertical column, post, or wall.

include <shape_pts.scad>

PART = "base";                    // "base", "reflector", "diffuser", or "assembly"

// ---------- 1. Exact Octolamp Two-Layer Wall Architecture ----------
back_wall      = 1.0;             // Rear floor thickness (mm)
bot_wall_h     = 11.0;            // Rear layer height from inner floor to reflector seat (mm)
top_wall_h     = 13.0;            // Front layer height from reflector seat to front lip (mm)
box_d          = back_wall + bot_wall_h + top_wall_h; // 25.0 mm total exterior depth
top_wall_t     = 3.0;             // Outer wall thickness (mm)
bot_ledge_w    = 3.0;             // Inward reflector ledge width -> 6.0 mm total rear perimeter wall
diff_clr       = 0.50;            // Radial clearance between base inner wall and diffuser skirt outer face (mm)
diff_wall      = 1.00;            // Hollow diffuser skirt & front face thickness (mm)
diff_skirt_len = 12.00;           // Skirt length from bevel base (-13.50 mm) back to reflector face (-1.50 mm)
diff_proud_sk  = 1.00;            // Skirt extends 1.00 mm proud of base front lip (-12.50 -> -13.50 mm)
diff_bevel     = 3.00;            // 45 deg front bevel height & radial inset (front face at -16.50 mm)
face_groove_d  = 0.45;            // Optional front-face relief groove depth (0.45 mm on Snake I, leaves 0.55 mm backing)
tab_w          = 13.20;           // Snap tab width (mm)
tab_y_span     = 3.00;            // 45 deg V-ridge length along Y
tab_protrude   = 1.50;            // Outward protrusion from skirt (+1.00 mm into 1.37 mm base groove)
reflector_t    = 2.0;             // White reflector plate thickness (mm)
reflector_clr  = 0.75;            // Perimeter clearance around reflector inside 3.0 mm wall

front_y        = -box_d / 2;                      // -12.50 mm
back_y         =  box_d / 2;                      // +12.50 mm (flush rear face)
back_in_y      =  back_y - back_wall;             // +11.50 mm
seat_y         =  back_in_y - bot_wall_h;         //  +0.50 mm (reflector rests here, trapping connector keys)
refl_y0        =  seat_y - reflector_t;           //  -1.50 mm

z0             = top_wall_t;                      //   3.00 mm (exterior bottom rests cleanly at Z = 0.00 mm)
ext_h          = shape_h + 2 * top_wall_t;        // Exact exterior height (150.00, 200.00, or 225.00 mm)

// ---------- 2. Interlocking Hollow Double-Dovetail ("Bowtie") Channel Spec ----------
conn_waist_w   = 21.00;           // Female dovetail mortise width at outer seam plane (mm)
conn_head_w    = 26.00;           // Female dovetail mortise width at 10.00 mm inward depth (~14 deg dovetail)
conn_depth     = 10.00;           // Mortise depth from outer seam plane to solid stop shoulder (mm)
conn_bore_w    = 14.00;           // Center LED-strip conduit slot width (clears 10/12 mm strips & JST-SM plugs)
conn_boss_w    = 31.00;           // Structural boss outer width surrounding the 26.0 mm mortise (mm)
conn_boss_d    = 13.00;           // Structural boss inward depth (provides 3.0 mm stop wall behind dovetail cheeks)
conn_through_d = 18.50;           // Center conduit cut reach past boss & 3.0 mm ledge into open rear cavity (mm)
conn_floor_t   = 1.50;            // Reinforced solid rear skin behind dovetail socket (Y = +11.00 .. +12.50 mm)
conn_pocket_in = 15.50;           // Inward offset from interior edge to reflector strip pass-through pocket center
conn_pocket_w  = 15.00;           // Reflector strip pass-through pocket width (mm)
conn_pocket_h  = 7.00;            // Reflector strip pass-through pocket height (mm)
conn_pocket_r  = 2.00;            // Reflector pocket corner radius (mm)
conn_slit_w    = 1.50;            // Side-entry wire slit width from reflector pocket out nearest edge (mm)

top_conn_enable   = rec_top_conn_enable;
top_conn_x        = rec_top_conn_x;
bot_conn_enable   = rec_bot_conn_enable;
bot_conn_x        = rec_bot_conn_x;
left_conn_enable  = rec_left_conn_enable;
left_conn_z       = z0 + rec_left_conn_z;
left_conn_face_x  = rec_left_conn_face_x;
left_conn_pock_x  = rec_left_conn_pocket_x;
right_conn_enable = rec_right_conn_enable;
right_conn_z      = z0 + rec_right_conn_z;
right_conn_face_x = rec_right_conn_face_x;
right_conn_pock_x = rec_right_conn_pocket_x;

// ---------- 3. Diffuser Snap V-Grooves ----------
snap_w         = 14.41;
snap_y_inset   = 2.22;
snap_y_span    = 2.88;
snap_depth     = 1.37;
snap_top_x     = rec_snap_top_x;
snap_top_z     = z0 + rec_snap_top_z;
snap_bot_x     = rec_snap_bot_x;

// ---------- 4. Blind Print-In-Place Rear Wall/Post Keyhole Mount ----------
enable_wall_mount = rec_wall_mount_enable;
wall_mount_x      = rec_wall_mount_x;
wall_mount_z      = z0 + rec_wall_mount_z;

// ---------- 4b. Internal Snap-Fit Magnet Bay (LOVIMAG 110 lb 32 x 6 mm Round Cup Magnet) ----------
// Places the magnet behind an exact 0.50 mm outer rear skin (Y = +12.00 .. +12.50 mm) inside a reinforced
// 12.00 mm-thick rear boss, capped from the inside by `magnet_snap_cover.scad` (sits flush behind the reflector).
enable_magnet     = rec_magnet_enable;
mag_x             = rec_magnet_x;
mag_z             = z0 + rec_magnet_z;
mag_dia_x         = 32.00;        // LOVIMAG 110 lb round magnet X span (mm)
mag_dia_z         = 32.00;        // LOVIMAG 110 lb round magnet Z span (mm; set to 30.00 if using a 32x30 oval magnet)
mag_thick         = 6.00;         // Magnet thickness (mm)
mag_clr_xy        = 0.40;         // Diametral slip-fit clearance around magnet (+0.20 mm per side -> 32.40 mm pocket)
mag_clr_y         = 0.20;         // Axial thickness clearance above 6.00 mm magnet (6.20 mm pocket height)
mag_outer_skin    = 0.50;         // Solid plastic skin on the outside rear face covering the magnet (mm)
mag_throat_extra  = 0.20;         // Entry throat clearance above magnet seat (32.60 mm throat so magnet drops straight in)
mag_snap_undercut = 0.70;         // Radial depth of internal 45 deg snap-cover V-groove (34.00 mm peak, zero supports)
mag_snap_span_y   = 1.60;         // Total Y height of 45 deg snap V-groove (+/-0.80 mm around apex)
mag_boss_wall     = 3.10;         // Radial wall around magnet bore (38.60 mm OD boss, clipped cleanly inside outer silhouette)

// ---------- 5. Optional Sparkle Motion Mini Controller Bay (Bottom Anchor Module) ----------
include_controller = rec_include_controller;
chip_x         = rec_chip_x;
chip_z         = z0 + rec_chip_z;
cable_x        = rec_cable_x;
ziptie_z       = z0 + rec_ziptie_z;
keyhole_z      = z0 + rec_keyhole_z;
foot_ridge_top = keyhole_z - 7.1 + 0.2;
refl_slit_dir  = rec_slit_dir;
refl_pocket_w  = 16.00;
refl_pocket_h  = 9.00;
refl_pocket_r  = 2.00;
refl_slit_h    = 1.50;

tray_in_x      = 22.4;
tray_in_z      = 33.8;
tray_wall      = 1.6;
tray_out_x     = tray_in_x + 2 * tray_wall; // 25.6 mm
tray_out_z     = tray_in_z + 2 * tray_wall; // 37.0 mm
tray_r_out     = 4.0;
tray_r_in      = 2.4;
tray_h         = 9.75;
pin_base_d     = 5.0;
pin_base_h     = 1.35;
pin_d          = 2.2;
pin_h          = 5.95;
pin_x          = 7.30;
pin_dz         = 12.70;

// ---------- 6. Reflector Standoff Pillars ----------
pillar_d       = 6.0;
pillars_xz     = rec_pillars;
has_face_grooves = rec_has_face_grooves;

// ---------- Core Geometry Helpers ----------
module shape_slab(y0, y1, grow = 0) {
    translate([0, (y0 + y1) / 2, z0])
        rotate([90, 0, 0])
            linear_extrude(height = y1 - y0, center = true)
                offset(delta = grow) shape_2d($pts);
}

module diffuser_slab(y0, y1, grow = 0) {
    translate([0, (y0 + y1) / 2, z0])
        rotate([90, 0, 0])
            linear_extrude(height = y1 - y0, center = true)
                offset(delta = grow) diffuser_shape_2d($dpts);
}

module snap_grooves() {
    y_start = front_y + snap_y_inset;
    steps = 6;
    dy = snap_y_span / steps;
    intersection() {
        union() {
            for (k = [0 : steps - 1]) {
                u = (k + 0.5) / steps;
                d = snap_depth * (1 - abs(2 * u - 1));
                shape_slab(y_start + k * dy - 0.02, y_start + (k + 1) * dy + 0.02, d);
            }
        }
        union() {
            translate([snap_top_x - snap_w / 2, y_start - 1, snap_top_z - 6])
                cube([snap_w, snap_y_span + 2, 12]);
            translate([snap_bot_x - snap_w / 2, y_start - 1, z0 - 6])
                cube([snap_w, snap_y_span + 2, 12]);
        }
    }
}

// Local 2D socket boss + local 2D dovetail-and-conduit cut in (u, v), where v = 0 is the outer mating seam
// and +v points inward into the letter body.
module socket_boss_local() {
    yc = (seat_y + back_y) / 2;
    yh = back_y - seat_y;
    translate([0, yc, conn_boss_d / 2])
        cube([conn_boss_w, yh, conn_boss_d], center = true);
}

module socket_cut_local() {
    // Rear-entry female dovetail mortise: opens directly through the flat back face (Y = +12.50 mm) so the wedged
    // bowtie key pushes straight in from the back (+Y -> -Y) without being blocked by the 3.0 mm front bezel lip!
    // At Y = +2.00 -> +0.50 mm, a 45 deg inward bevel forms a print-in-place positive depth stop (zero supports when printed on back).
    y_stop0 = seat_y - 0.05;   // +0.45 mm (positive stop bevel front)
    y_stop1 = seat_y + 1.50;   // +2.00 mm (full-width mortise floor; 10.50 mm deep from back_y = +12.50 mm)
    y_back  = back_y + 0.25;   // +12.75 mm (cuts cleanly out the +12.50 mm rear face!)
    w0 = conn_waist_w / 2;     // 10.50 mm (21.00 mm waist)
    w1 = conn_head_w / 2;      // 13.00 mm (26.00 mm head)
    b  = 1.50;                 // 1.50 mm x 45 deg depth-stop chamfer

    // 1. Full-width rear-entry dovetail mortise from Y = +12.50 mm down to Y = +2.00 mm
    translate([0, (y_stop1 + y_back) / 2, 0]) rotate([90, 0, 0])
        linear_extrude(height = y_back - y_stop1, center = true)
            polygon([
                [-w0 - 0.06, -0.20],
                [ w0 + 0.06, -0.20],
                [ w1,         conn_depth],
                [-w1,         conn_depth]
            ]);

    // 2. 45 deg self-supporting positive depth-stop seat from Y = +2.00 mm to Y = +0.45 mm
    hull() {
        translate([0, y_stop1 + 0.02, 0]) rotate([90, 0, 0])
            linear_extrude(height = 0.04, center = true)
                polygon([
                    [-w0 - 0.06, -0.20],
                    [ w0 + 0.06, -0.20],
                    [ w1,         conn_depth],
                    [-w1,         conn_depth]
                ]);
        translate([0, y_stop0, 0]) rotate([90, 0, 0])
            linear_extrude(height = 0.04, center = true)
                polygon([
                    [-(w0 - b), -0.20],
                    [  w0 - b,  -0.20],
                    [  w1 - b,   conn_depth - b],
                    [-(w1 - b),  conn_depth - b]
                ]);
    }

    // 3. Center 14.0 mm LED-strip conduit continuing into the rear letter cavity (Y = +0.45 .. +10.50 mm;
    //    when the bowtie key's 2.0 mm rear cap sits at Y = +10.40 .. +12.40 mm, the back of the joint is sealed!)
    y_cond1 = back_y - 2.00; // +10.50 mm (leaves 2.00 mm rear floor past the boss end at v = 13..18.5 mm, or 1.00 mm in cavity)
    translate([0, (y_stop0 + y_cond1) / 2, 0]) rotate([90, 0, 0])
        linear_extrude(height = y_cond1 - y_stop0, center = true)
            translate([-conn_bore_w / 2, -0.20])
                square([conn_bore_w, conn_through_d + 0.20]);
}

module socket_bosses() {
    if (bot_conn_enable)
        translate([bot_conn_x, 0, 0]) socket_boss_local();
    if (top_conn_enable)
        translate([top_conn_x, 0, ext_h]) mirror([0, 0, 1]) socket_boss_local();
    if (left_conn_enable)
        translate([left_conn_face_x, 0, left_conn_z]) rotate([0, 90, 0]) socket_boss_local();
    if (right_conn_enable)
        translate([right_conn_face_x, 0, right_conn_z]) rotate([0, -90, 0]) socket_boss_local();
}

module socket_cuts() {
    if (bot_conn_enable)
        translate([bot_conn_x, 0, 0]) socket_cut_local();
    if (top_conn_enable)
        translate([top_conn_x, 0, ext_h]) mirror([0, 0, 1]) socket_cut_local();
    if (left_conn_enable)
        translate([left_conn_face_x, 0, left_conn_z]) rotate([0, 90, 0]) socket_cut_local();
    if (right_conn_enable)
        translate([right_conn_face_x, 0, right_conn_z]) rotate([0, -90, 0]) socket_cut_local();
}

// Blind print-in-place rear wall/column screw keyhole (zero supports, 45 deg internal roof, 2.3 mm inner light cap)
module wall_mount_boss() {
    if (enable_wall_mount) {
        yc = (seat_y + back_y) / 2;
        translate([wall_mount_x, yc, wall_mount_z])
            rotate([90, 0, 0])
                linear_extrude(height = back_y - seat_y, center = true)
                    offset(r = 5.0, $fn = 28)
                        square([10.0, 18.0], center = true);
    }
}

module wall_mount_cut() {
    if (enable_wall_mount) {
        translate([wall_mount_x, 0, wall_mount_z]) {
            // 1. Entry hole for #6/#8 screw head (D = 9.8 mm at z_rel = -4.5 mm) + 4.6 mm lock slot up to z_rel = +4.5 mm
            translate([0, (back_y - 2.2 + back_y + 0.4) / 2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = 2.6, center = true) union() {
                        translate([0, -4.5]) circle(d = 9.8, $fn = 32);
                        hull() {
                            translate([0, -4.5]) circle(d = 4.6, $fn = 24);
                            translate([0,  4.5]) circle(d = 4.6, $fn = 24);
                        }
                    }
            // 2. Internal screw-head undercut chamber (10.0 mm wide) + 45 deg self-supporting conical roof (stops at Y = +2.8 mm)
            hull() {
                translate([0, (back_y - 4.7 + back_y - 2.15) / 2, 0])
                    rotate([90, 0, 0])
                        linear_extrude(height = 2.55, center = true)
                            hull() {
                                translate([0, -4.5]) circle(d = 10.0, $fn = 32);
                                translate([0,  4.5]) circle(d = 10.0, $fn = 32);
                            }
                translate([0, seat_y + 2.30, 0])
                    rotate([90, 0, 0])
                        linear_extrude(height = 0.10, center = true)
                            hull() {
                                translate([0, -4.5]) circle(d = 0.6, $fn = 16);
                                translate([0,  4.5]) circle(d = 0.6, $fn = 16);
                            }
            }
        }
    }
}

// Reinforced 12.00 mm rear boss + indented 0.50 mm-skin magnet pocket + internal 45 deg snap-cover groove
module magnet_slot_2d(extra_r = 0) {
    scale([(mag_dia_x + 2 * extra_r) / mag_dia_x, (mag_dia_z + 2 * extra_r) / mag_dia_x])
        circle(d = mag_dia_x, $fn = 72);
}

module magnet_bay_boss() {
    if (enable_magnet) {
        yc = (seat_y + back_y) / 2;
        intersection() {
            translate([mag_x, yc, mag_z])
                rotate([90, 0, 0])
                    linear_extrude(height = back_y - seat_y, center = true)
                        magnet_slot_2d(mag_clr_xy / 2 + mag_boss_wall);
            shape_slab(seat_y, back_y, top_wall_t);
        }
    }
}

module magnet_bay_cut() {
    if (enable_magnet) {
        y_mag_back  = back_y - mag_outer_skin;             // +12.00 mm (leaves 0.50 mm solid outer plastic skin!)
        y_mag_front = y_mag_back - (mag_thick + mag_clr_y); // +5.80 mm (6.20 mm magnet pocket height)
        y_snap_apex = y_mag_front - 1.10;                  //  +4.70 mm (internal 45 deg snap-groove apex)
        r_seat      = mag_clr_xy / 2;                      // +0.20 mm radial -> 32.40 mm magnet seat
        r_throat    = r_seat + mag_throat_extra / 2;       // +0.30 mm radial -> 32.60 mm entry throat
        r_groove    = r_throat + mag_snap_undercut;        // +1.00 mm radial -> 34.00 mm snap V-groove peak

        translate([mag_x, 0, mag_z]) {
            // 1. Lower 6.20 mm magnet seat pocket (stops at Y = +12.00 mm -> exact 0.50 mm outer rear skin)
            translate([0, (y_mag_front - 0.05 + y_mag_back) / 2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = y_mag_back - (y_mag_front - 0.05), center = true)
                        magnet_slot_2d(r_seat);

            // 2. Upper entry throat from reflector seat (Y = +0.50 mm) down to magnet top (Y = +5.80 mm)
            translate([0, (seat_y - 0.20 + y_mag_front + 0.05) / 2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = (y_mag_front + 0.05) - (seat_y - 0.20), center = true)
                        magnet_slot_2d(r_throat);

            // 3. Print-in-place 45 deg annular snap-fit V-groove for `magnet_snap_cover.scad` (zero supports)
            hull() {
                translate([0, y_snap_apex - mag_snap_span_y / 2, 0])
                    rotate([90, 0, 0]) linear_extrude(height = 0.04, center = true) magnet_slot_2d(r_throat);
                translate([0, y_snap_apex, 0])
                    rotate([90, 0, 0]) linear_extrude(height = 0.04, center = true) magnet_slot_2d(r_groove);
            }
            hull() {
                translate([0, y_snap_apex, 0])
                    rotate([90, 0, 0]) linear_extrude(height = 0.04, center = true) magnet_slot_2d(r_groove);
                translate([0, y_snap_apex + mag_snap_span_y / 2, 0])
                    rotate([90, 0, 0]) linear_extrude(height = 0.04, center = true) magnet_slot_2d(r_throat);
            }

            // 4. Two screwdriver/fingernail pry reliefs at +/-Z inside the upper rim (Y = +0.30 .. +2.80 mm)
            for (sz = [-1, 1])
                translate([0, (seat_y - 0.20 + 2.80) / 2, sz * (mag_dia_z / 2 + r_throat)])
                    cube([5.2, 2.80 - (seat_y - 0.20), 1.80], center = true);
        }
    }
}

module octolamp_chip_holder() {
    difference() {
        hull() {
            translate([0, 0.2, 0]) rotate([90, 0, 0]) linear_extrude(height = tray_h - 0.5 + 0.2)
                offset(r = tray_r_out) square([tray_out_x - 2 * tray_r_out, tray_out_z - 2 * tray_r_out], center = true);
            translate([0, -(tray_h - 0.5), 0]) rotate([90, 0, 0]) linear_extrude(height = 0.5)
                offset(r = tray_r_out - 0.5) square([tray_out_x - 2 * tray_r_out, tray_out_z - 2 * tray_r_out], center = true);
        }
        translate([0, 0.01, 0]) rotate([90, 0, 0]) linear_extrude(height = tray_h + 1)
            offset(r = tray_r_in) square([tray_in_x - 2 * tray_r_in, tray_in_z - 2 * tray_r_in], center = true);
        translate([0, -(2.45 + 2.50), -tray_out_z / 2])
            rotate([90, 0, 0]) linear_extrude(height = 6.0, center = true)
                offset(r = 1.0) square([10.4 - 2.0, 5.0 - 2.0], center = true);
        translate([0, -(tray_h + 1) / 2 - 3.15, tray_out_z / 2]) {
            cube([8.0, tray_h + 1, 6.0], center = true);
            translate([0, -3.2, 0]) cube([11.0, tray_h - 5, 6.0], center = true);
        }
        translate([tray_out_x / 2, -5.5, 1.6])
            cube([6.0, 7.5, 16.8], center = true);
    }
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
    for (sx = [-1, 1]) for (sz = [-1, 1])
        translate([sx * pin_x, 0.2, -1.0 + sz * pin_dz]) rotate([90, 0, 0]) {
            cylinder(h = pin_base_h + 0.2, d = pin_base_d, $fn = 28);
            cylinder(h = pin_h + 0.2, d = pin_d, $fn = 24);
        }
}

module controller_cable_cuts() {
    for (sx = [-1, 1])
        translate([cable_x + sx * 5.0, back_in_y - 0.5, ziptie_z])
            rotate([-90, 0, 0]) cylinder(h = back_wall + 1.5, d = 5.0, $fn = 28);

    for (pass = [[0, -0.2, back_wall + 0.6], [0.8, -0.05, 0.65]]) {
        grow = pass[0];
        y0 = back_in_y + pass[1];
        th = pass[2];
        translate([cable_x, y0 + th / 2, 0]) rotate([90, 0, 0])
            linear_extrude(height = th, center = true) offset(delta = grow) union() {
                translate([0, keyhole_z]) circle(d = 14.2, $fn = 40);
                translate([-2.0, z0 + bot_ledge_w]) square([4.0, keyhole_z - (z0 + bot_ledge_w)]);
            }
    }

    hull() {
        translate([cable_x - 2.5, back_y - 4.0, -1.0])
            cube([5.0, 4.5, foot_ridge_top + 1.5]);
        translate([cable_x - 0.5, back_y - 6.0, -1.0])
            cube([1.0, 6.5, foot_ridge_top + 1.5]);
    }
}

module reflector_seat_and_pillars() {
    yc = (seat_y + back_in_y + 0.5) / 2;
    union() {
        translate([0, yc, z0]) rotate([90, 0, 0])
            linear_extrude(height = back_in_y + 0.5 - seat_y, center = true)
                difference() {
                    shape_2d($pts);
                    offset(delta = -bot_ledge_w) shape_2d($pts);
                }

        if (include_controller)
            intersection() {
                shape_slab(seat_y, back_in_y + 0.5, 0);
                translate([-shape_w, seat_y - 1, 0])
                    cube([2 * shape_w, back_in_y - seat_y + 2, foot_ridge_top]);
            }

        if (len(pillars_xz) > 0)
            intersection() {
                union() {
                    for (p = pillars_xz)
                        translate([p[0], yc, z0 + p[1]])
                            rotate([90, 0, 0])
                                cylinder(h = back_in_y + 0.5 - seat_y, d = pillar_d, center = true, $fn = 24);
                }
                shape_slab(seat_y, back_in_y + 0.5, -bot_ledge_w);
            }
    }
}

module lamp_base() {
    difference() {
        union() {
            difference() {
                shape_slab(front_y, back_y, top_wall_t);
                shape_slab(front_y - 1, back_in_y, 0);
                snap_grooves();
            }
            reflector_seat_and_pillars();
            socket_bosses();
            wall_mount_boss();
            magnet_bay_boss();
            if (include_controller)
                intersection() {
                    translate([chip_x, back_in_y, chip_z]) octolamp_chip_holder();
                    shape_slab(back_in_y - tray_h - 1, back_in_y + 1, 0);
                }
        }
        socket_cuts();
        wall_mount_cut();
        magnet_bay_cut();
        if (include_controller) controller_cable_cuts();
    }
}

module reflector_conduit_cuts_2d() {
    if (bot_conn_enable) {
        pz = z0 + conn_pocket_in;
        translate([bot_conn_x, pz])
            offset(r = conn_pocket_r, $fn = 24)
                square([conn_pocket_w - 2 * conn_pocket_r, conn_pocket_h - 2 * conn_pocket_r], center = true);
        translate([bot_conn_x - conn_slit_w / 2, -5])
            square([conn_slit_w, pz + 5]);
    }
    if (top_conn_enable) {
        pz = z0 + shape_h - conn_pocket_in;
        translate([top_conn_x, pz])
            offset(r = conn_pocket_r, $fn = 24)
                square([conn_pocket_w - 2 * conn_pocket_r, conn_pocket_h - 2 * conn_pocket_r], center = true);
        translate([top_conn_x - conn_slit_w / 2, pz])
            square([conn_slit_w, conn_pocket_in + top_wall_t + 5]);
    }
    if (left_conn_enable) {
        px = left_conn_pock_x;
        translate([px, left_conn_z])
            offset(r = conn_pocket_r, $fn = 24)
                square([conn_pocket_h - 2 * conn_pocket_r, conn_pocket_w - 2 * conn_pocket_r], center = true);
        translate([px - shape_w, left_conn_z - conn_slit_w / 2])
            square([shape_w, conn_slit_w]);
    }
    if (right_conn_enable) {
        px = right_conn_pock_x;
        translate([px, right_conn_z])
            offset(r = conn_pocket_r, $fn = 24)
                square([conn_pocket_h - 2 * conn_pocket_r, conn_pocket_w - 2 * conn_pocket_r], center = true);
        translate([px, right_conn_z - conn_slit_w / 2])
            square([shape_w, conn_slit_w]);
    }
    if (include_controller) {
        px = cable_x - 0.47 * refl_slit_dir;
        pz = ziptie_z;
        translate([px, pz])
            offset(r = refl_pocket_r, $fn = 28)
                square([refl_pocket_w - 2 * refl_pocket_r, refl_pocket_h - 2 * refl_pocket_r], center = true);
        translate([refl_slit_dir > 0 ? px : px - shape_w, pz - refl_slit_h / 2])
            square([shape_w, refl_slit_h]);
    }
}

module lamp_reflector() {
    difference() {
        shape_slab(refl_y0, seat_y, -reflector_clr);
        translate([0, (refl_y0 + seat_y) / 2, 0])
            rotate([90, 0, 0])
                linear_extrude(height = reflector_t + 2, center = true)
                    reflector_conduit_cuts_2d();
    }
}

module lamp_diffuser() {
    y_bevel_base = front_y - diff_proud_sk;           // -13.50 mm
    y_back       = y_bevel_base + diff_skirt_len - 0.02; // -1.52 mm
    bevel_steps  = 8;
    dy_bev       = diff_bevel / bevel_steps;
    y_front_face = y_bevel_base - diff_bevel - 0.02;  // -16.52 mm

    y_snap_mid   = front_y + snap_y_inset + snap_y_span / 2; // -8.84 mm
    y_tab0       = y_snap_mid - tab_y_span / 2;
    tab_steps    = 6;
    dy_tab       = tab_y_span / tab_steps;

    difference() {
        union() {
            difference() {
                union() {
                    diffuser_slab(y_bevel_base, y_back, -diff_clr);
                    for (k = [0 : bevel_steps - 1]) {
                        inset_mm = diff_clr + diff_bevel * ((k + 0.5) / bevel_steps);
                        diffuser_slab(y_bevel_base - (k + 1) * dy_bev - 0.02, y_bevel_base - k * dy_bev + 0.02, -inset_mm);
                    }
                }
                union() {
                    diffuser_slab(y_bevel_base + diff_wall, y_back + 1.0, -(diff_clr + diff_wall));
                    for (k = [0 : bevel_steps - 1]) {
                        inset_mm = diff_clr + diff_wall + diff_bevel * ((k + 0.5) / bevel_steps);
                        diffuser_slab(y_bevel_base + diff_wall - (k + 1) * dy_bev - 0.02, y_bevel_base + diff_wall - k * dy_bev + 0.02, -inset_mm);
                    }
                }
            }
            intersection() {
                difference() {
                    union() {
                        for (k = [0 : tab_steps - 1]) {
                            u = (k + 0.5) / tab_steps;
                            out_mm = -diff_clr + tab_protrude * (1 - abs(2 * u - 1));
                            diffuser_slab(y_tab0 + k * dy_tab - 0.02, y_tab0 + (k + 1) * dy_tab + 0.02, out_mm);
                        }
                    }
                    diffuser_slab(y_tab0 - 0.5, y_tab0 + tab_y_span + 0.5, -(diff_clr + 0.4));
                }
                union() {
                    translate([snap_top_x - tab_w / 2, y_tab0 - 1, snap_top_z - 6])
                        cube([tab_w, tab_y_span + 2, 12]);
                    translate([snap_bot_x - tab_w / 2, y_tab0 - 1, z0 - 6])
                        cube([tab_w, tab_y_span + 2, 12]);
                }
            }
        }
        if (has_face_grooves)
            intersection() {
                translate([0, y_front_face + face_groove_d / 2 - 0.05, z0])
                    rotate([90, 0, 0])
                        linear_extrude(height = face_groove_d + 0.20, center = true)
                            diffuser_face_grooves_2d();
                diffuser_slab(y_front_face - 0.25, y_front_face + face_groove_d + 0.20, -(diff_clr + diff_bevel + 0.35));
            }
    }
}

module render_lamp_part(part = PART) {
    let($pts = shape_pts, $dpts = diffuser_shape_pts) {
        if (part == "base") lamp_base();
        else if (part == "reflector") lamp_reflector();
        else if (part == "diffuser") lamp_diffuser();
        else {
            color("#111827") lamp_base();
            color("white") lamp_reflector();
            color([0.75, 0.9, 1, 0.85]) lamp_diffuser();
        }
    }
}

render_lamp_part();
