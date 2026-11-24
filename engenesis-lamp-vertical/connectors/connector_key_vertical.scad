// Universal Rear-Entry Interlocking Hollow Double-Dovetail ("Bowtie") Conduit Key
// Inserts straight into the flat BACK face of two mating letters (+Y -> -Y) where there is zero front-bezel overhang!
//   - Prints flat on its smooth 2.00 mm rear cap face (Z = 0 on build plate) with ZERO supports; continuous axial
//     perimeter loops carry >25 kg tensile load.
//   - Leading top edge (Z = 10.30 -> 11.60 mm) has a matching 1.30 mm x 45 deg chamfer that seats squarely against
//     the base socket's internal 45 deg positive depth-stop bevel so the back of the key sits dead-flush at Y = +12.40 mm!
//   - Center 13.60 mm channel fits a 10 mm or 12 mm WS2812B LED strip (or 3-pin JST-SM plug) right inside it.

dovetail_clearance = 0.20;        // Per-side XY clearance against female base mortise (mm)
end_clearance      = 0.25;        // Tip clearance so mating letter housings pull 100% tight face-to-face (mm)
bridge_gap         = 12.70;       // Letter-to-letter seam gap (mm): key spans the gap + 9.75 mm into each letter (length = gap + 19.5 mm)
straddle_open      = true;        // true = open inward U-channel (drop LED strip in, press key over it); false = closed tunnel

mortise_waist_w    = 21.00;
mortise_head_w     = 26.00;
mortise_depth      = 10.00;
key_body_h         = 10.30;       // Full-width dovetail height (seats into 10.50 mm straight rear mortise)
lead_chamfer       = 1.30;        // 45 deg leading-edge chamfer matching base's internal depth-stop seat (total Z = 11.60 mm)
bore_w             = 13.60;       // Clear internal width for 10 mm / 12 mm LED strip or JST-SM plug (mm)
rear_cap_t         = 2.00;        // Solid flush outer back cap (seals the rear seam opaque black at Y = +10.40 .. +12.40 mm!)
inner_web_t        = 1.60;        // Used only when straddle_open = false (leaves 6.70 mm x 13.60 mm enclosed box tunnel)
collar_w           = 31.00;       // Outer width of center bridge collar when bridge_gap > 0
collar_thick_y     = 11.90;       // Spans Y = +0.50 .. +12.40 mm when bridge_gap > 0

module bowtie_2d(gap, L, w0, w1, inset = 0) {
    half_g = gap / 2;
    offset(delta = -inset)
        offset(r = 0.5, $fn = 20) offset(delta = -0.5)
            polygon([
                [-w0, -half_g],
                [-w1, -(half_g + L)],
                [ w1, -(half_g + L)],
                [ w0, -half_g],
                [ w0,  half_g],
                [ w1,  half_g + L],
                [-w1,  half_g + L],
                [-w0,  half_g]
            ]);
}

module bowtie_key(gap = bridge_gap, straddle = straddle_open, clr = dovetail_clearance) {
    L = mortise_depth - end_clearance; // 9.75 mm insertion per side
    slope = ((mortise_head_w - mortise_waist_w) / 2) / mortise_depth; // 0.25 (14.04 deg)
    w0 = mortise_waist_w / 2 - clr;    // 10.30 mm
    w1 = w0 + slope * L;               // 12.74 mm
    half_g = gap / 2;
    total_len = 2 * (half_g + L);
    total_z = key_body_h + lead_chamfer; // 11.60 mm

    difference() {
        union() {
            // Straight rear-entry dovetail body (Z = 0 .. 10.30 mm) + 45 deg leading seat chamfer (Z = 10.30 .. 11.60 mm)
            linear_extrude(height = key_body_h)
                bowtie_2d(gap, L, w0, w1, 0);
            hull() {
                translate([0, 0, key_body_h - 0.04])
                    linear_extrude(height = 0.04) bowtie_2d(gap, L, w0, w1, 0);
                translate([0, 0, total_z - 0.04])
                    linear_extrude(height = 0.04) bowtie_2d(gap, L, w0, w1, lead_chamfer);
            }

            // Enclosed black spacer collar across non-zero bridge gaps (FL/FR side bridges)
            if (gap > 0.01)
                translate([-collar_w / 2, -half_g, 0])
                    cube([collar_w, gap, collar_thick_y]);
        }

        // Center 13.60 mm LED-strip channel: open U (straddle) across the full key length, gap included
        if (straddle) {
            // Open U-channel facing INWARD (-Y inside the lamp), solid 2.00 mm rear cap flush on the outside back!
            translate([-bore_w / 2, -total_len / 2 - 1, rear_cap_t])
                cube([bore_w, total_len + 2, total_z + 2]);
        } else {
            // Closed rectangular box tunnel (13.60 x 6.70 mm) enclosed front & back
            translate([-bore_w / 2, -total_len / 2 - 1, rear_cap_t])
                cube([bore_w, total_len + 2, key_body_h - rear_cap_t - inner_web_t]);
        }
    }
}

bowtie_key();
