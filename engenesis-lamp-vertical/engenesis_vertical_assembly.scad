// Engenesis Vertical-Display Modular Light-Box Assembly Preview
// Total assembled dimensions: 341.5 mm wide (across top flames) x 29.0 mm deep x 1,475.6 mm (4.84 ft / 58.1 in) tall.
//
// Modes (`SHOW`):
//   - "assembled" : Full 11-module illuminated vertical tower + 10 interlocking bowtie keys
//   - "cutaway"   : Hides diffusers & reflectors so you can inspect the internal LED-strip channels & bowtie keys!
//   - "exploded"  : Vertically & horizontally exploded view showing how the 10 hollow bowtie keys lock the bases together

SHOW = "assembled";               // "assembled", "cutaway", or "exploded"

expl = (SHOW == "exploded") ? 28.0 : 0.0;
show_optics = (SHOW != "cutaway");

seat_y = 0.50;

module place_module(folder, pref, x, z, diff_rgb = [0.42, 0.78, 1.0, 0.90], base_hex = "#111827") {
    translate([x, 0, z]) {
        color(base_hex)
            import(str("letters/", folder, "/", pref, "_base.stl"));
        if (show_optics) {
            translate([0, -0.35 * expl, 0])
                color("white")
                    import(str("letters/", folder, "/", pref, "_reflector.stl"));
            translate([0, -0.85 * expl, 0])
                color(diff_rgb)
                    import(str("letters/", folder, "/", pref, "_diffuser.stl"));
        }
    }
}

back_y = 12.50;

module place_vert_key(x, z) {
    // Rear-entry key inserts straight into the flat back face (+Y -> -Y): sits dead-flush at Y = +12.40 mm!
    translate([x, back_y - 0.10 + 0.6 * expl, z])
        rotate([90, 0, 0])
            color("#2563eb")
                import("connectors/connector_key_vertical.stl");
}

module place_flame_key(x, z) {
    translate([x, back_y - 0.10 + 0.6 * expl, z])
        rotate([0, 90, 0]) rotate([90, 0, 0])
            color("#1e293b")
                import("connectors/connector_key_flame.stl");
}

// ---------- 9-Letter Vertical Spine (Bottom to Top: S - I - S - E - n - E - g - n - E) ----------
// joint_gap: clear seam between letter edges. Must match bridge_gap in connectors/connector_key_vertical.scad.
joint_gap = 12.70;
z_s2   = 0;
z_i    = z_s2   + 150 + joint_gap + expl;
z_s1   = z_i    + 200 + joint_gap + expl;
z_elow = z_s1   + 150 + joint_gap + expl;
z_n2   = z_elow + 150 + joint_gap + expl;
z_emid = z_n2   + 150 + joint_gap + expl;
z_g    = z_emid + 150 + joint_gap + expl;
z_n1   = z_g    + 150 + joint_gap + expl;
z_etop = z_n1   + 150 + joint_gap + expl;

place_module("S_bottom", "s_bottom", 0, z_s2);
place_vert_key(0, z_s2 + 150 + joint_gap / 2 + 0.5 * expl);

place_module("I", "i", 0, z_i, diff_rgb = [0.22, 0.88, 0.46, 0.92]);
place_vert_key(0, z_i + 200 + joint_gap / 2 + 0.5 * expl);

place_module("S_upper", "s_upper", 0, z_s1);
place_vert_key(0, z_s1 + 150 + joint_gap / 2 + 0.5 * expl);

place_module("E_low", "e_low", 0, z_elow);
place_vert_key(28.0, z_elow + 150 + joint_gap / 2 + 0.5 * expl);

place_module("n", "n", 0, z_n2);
place_vert_key(0, z_n2 + 150 + joint_gap / 2 + 0.5 * expl);

place_module("E_mid", "e_mid", 0, z_emid);
place_vert_key(-8.0, z_emid + 150 + joint_gap / 2 + 0.5 * expl);

place_module("g", "g", 0, z_g);
place_vert_key(28.0, z_g + 150 + joint_gap / 2 + 0.5 * expl);

place_module("n", "n", 0, z_n1);
place_vert_key(0, z_n1 + 150 + joint_gap / 2 + 0.5 * expl);

place_module("E_top", "e_top", 0, z_etop);

// ---------- Flanking Left & Right Flames on Top E ----------
place_module("FL", "fl", -110.50 - expl, z_etop);
place_flame_key(-57.85 - 0.5 * expl, z_etop + 75.30);

place_module("FR", "fr",  108.76 + expl, z_etop);
place_flame_key( 56.11 + 0.5 * expl, z_etop + 75.30);
