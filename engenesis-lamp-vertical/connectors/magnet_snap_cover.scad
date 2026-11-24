// Internal Snap-Fit Magnet Cover for LOVIMAG 110 lb Round Magnet (32 x 30/32 x 6 mm)
// Prints flat on its smooth outer cap face (Z = 0 .. 3.80 mm) with ZERO supports in ~4 minutes.
//
// Assembly:
//   1. Drop the 32 x 6 mm LOVIMAG magnet into the base's internal magnet slot (open magnetic pole face DOWN against the 0.50 mm outer rear skin).
//   2. Press this snap-fit cover straight down over the magnet until the 6 slotted flex-latch petals click into the internal 45 deg V-groove!
//   3. The cover sits at Y = +2.00 .. +5.80 mm inside the rear chamber (1.50 mm clear behind the white reflector) and clamps the magnet rattle-free.

mag_dia_x      = 32.00;           // Matches `mag_dia_x` in vertical_lamp_core.scad
mag_dia_z      = 32.00;           // Matches `mag_dia_z` in vertical_lamp_core.scad (set 30.00 if oval)
throat_d_x     = mag_dia_x + 0.60; // 32.60 mm base entry throat
cap_clr        = 0.22;            // Per-side radial clearance of cap body inside 32.60 mm throat (-> 32.16 mm OD)
cap_plate_t    = 1.60;            // Solid outer cap disc thickness (mm)
total_h        = 3.80;            // Total height from cap top (Y = +2.00 mm) to magnet face (Y = +5.80 mm)
snap_z         = 2.70;            // Exact Z height of snap bead apex (lands at Y = +2.00 + 2.70 = +4.70 mm groove apex!)
snap_protrude  = 0.62;            // Radial snap bead protrusion past cap rim (33.40 mm OD -> 0.40 mm engagement per side in 34.00 mm groove)
snap_span_z    = 1.24;            // 45 deg upper & lower ramps on snap bead (zero overhang, effortless click-in & pry-out)
petal_wall_t   = 1.85;            // Radial thickness of the 6 curved cantilevered flex-petals (mm)
num_petals     = 6;
slot_gap_w     = 2.80;            // Width of radial flex-relief slots separating the 6 snap petals (mm)

module cap_profile_2d(delta_r = 0) {
    rx = throat_d_x / 2 - cap_clr + delta_r;
    rz = (mag_dia_z + 0.60) / 2 - cap_clr + delta_r;
    scale([rx / 16.0, rz / 16.0]) circle(r = 16.0, $fn = 72);
}

module magnet_snap_cover() {
    difference() {
        union() {
            // 1. Solid outer cap disc (Z = 0 .. 1.60 mm, with slight 0.4 mm bottom edge chamfer)
            hull() {
                linear_extrude(height = 0.05) cap_profile_2d(-0.35);
                translate([0, 0, 0.40]) linear_extrude(height = cap_plate_t - 0.40) cap_profile_2d(0);
            }

            // 2. Slotted flex-latch crown + 45 deg outward snap bead (Z = 1.60 .. 3.80 mm)
            difference() {
                union() {
                    translate([0, 0, cap_plate_t - 0.05])
                        linear_extrude(height = total_h - cap_plate_t + 0.05)
                            cap_profile_2d(0);

                    // 45 deg outward snap V-bead centered at Z = snap_z (2.70 mm)
                    hull() {
                        translate([0, 0, snap_z - snap_span_z / 2])
                            linear_extrude(height = 0.04) cap_profile_2d(0);
                        translate([0, 0, snap_z])
                            linear_extrude(height = 0.04) cap_profile_2d(snap_protrude);
                    }
                    hull() {
                        translate([0, 0, snap_z])
                            linear_extrude(height = 0.04) cap_profile_2d(snap_protrude);
                        translate([0, 0, snap_z + snap_span_z / 2])
                            linear_extrude(height = 0.04) cap_profile_2d(-0.15); // tapered lead-in tip!
                    }
                }

                // Hollow flex-relief moat behind the 6 snap petals so they flex inward smoothly
                translate([0, 0, cap_plate_t])
                    linear_extrude(height = total_h + 1.0)
                        difference() {
                            cap_profile_2d(-petal_wall_t);
                            circle(d = 16.0, $fn = 48);
                        }

                // 6 radial flex slots splitting the skirt into 6 independent leaf-spring petals
                for (i = [0 : num_petals - 1])
                    rotate([0, 0, i * (360 / num_petals) + 30])
                        translate([-slot_gap_w / 2, 5.0, cap_plate_t])
                            cube([slot_gap_w, throat_d_x, total_h + 1.0]);
            }

            // 3. Center anti-rattle magnet snubber ring (Z = 1.60 .. 3.80 mm, presses flat on magnet cup back)
            translate([0, 0, cap_plate_t - 0.05])
                linear_extrude(height = total_h - cap_plate_t + 0.05)
                    difference() {
                        circle(d = 16.0, $fn = 48);
                        circle(d = 11.2, $fn = 40);
                    }
        }

        // Subtle screwdriver / fingernail pry notches at +/-Y on the top rim (align with base pry reliefs)
        for (sy = [-1, 1])
            translate([-2.4, sy * ((mag_dia_z + 0.60) / 2 - cap_clr - 0.9), -0.1])
                cube([4.8, 2.2, 0.95]);
    }
}

magnet_snap_cover();
