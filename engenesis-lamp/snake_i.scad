// Snake "I" traced from images/snake-trace-sheet.jpg (front view).
// The outline is the solid silhouette of the front view (cap, head, open jaw,
// neck, DNA column and base), flood-filled from the drawing's black linework
// and mapped into a 210 x 340 box (y up).

H_BOX = 340;

snake_outline = [
    [10.3, 336.6],
    [8.7, 335.0],
    [8.7, 322.0],
    [9.8, 320.7],
    [17.4, 320.4],
    [27.5, 318.6],
    [39.1, 313.9],
    [46.5, 306.8],
    [49.9, 298.4],
    [49.7, 296.6],
    [38.3, 288.8],
    [26.4, 277.8],
    [16.1, 264.5],
    [11.4, 256.4],
    [7.4, 246.7],
    [4.8, 236.5],
    [3.7, 228.1],
    [4.0, 216.9],
    [5.3, 209.1],
    [7.9, 200.7],
    [12.7, 191.0],
    [18.0, 183.5],
    [26.4, 174.6],
    [46.8, 159.2],
    [46.8, 101.9],
    [30.6, 90.2],
    [22.7, 81.5],
    [18.0, 73.7],
    [14.5, 63.0],
    [14.5, 49.7],
    [18.5, 37.9],
    [25.9, 27.2],
    [20.6, 22.2],
    [13.5, 18.3],
    [0.3, 15.2],
    [0.0, 1.0],
    [1.1, 0.0],
    [179.6, 0.0],
    [180.4, 1.0],
    [180.2, 14.9],
    [178.3, 15.9],
    [169.1, 16.5],
    [157.7, 19.1],
    [144.5, 25.6],
    [135.2, 33.7],
    [130.8, 39.7],
    [128.1, 45.2],
    [126.0, 53.3],
    [125.5, 110.3],
    [142.1, 120.5],
    [154.5, 132.0],
    [158.5, 138.0],
    [162.2, 146.9],
    [163.8, 154.7],
    [164.0, 167.0],
    [162.5, 176.1],
    [159.8, 183.5],
    [151.9, 196.3],
    [140.5, 207.8],
    [125.5, 219.3],
    [125.7, 284.6],
    [126.5, 285.1],
    [133.1, 279.4],
    [139.2, 276.5],
    [147.9, 273.9],
    [154.8, 270.2],
    [163.2, 261.9],
    [168.5, 251.7],
    [171.7, 247.7],
    [177.0, 244.6],
    [182.3, 244.1],
    [185.7, 245.1],
    [189.9, 248.5],
    [191.5, 251.4],
    [191.2, 253.5],
    [192.8, 257.7],
    [191.5, 258.2],
    [189.4, 256.9],
    [188.3, 259.2],
    [187.3, 259.5],
    [182.5, 257.2],
    [179.4, 260.0],
    [177.0, 264.7],
    [174.3, 273.4],
    [171.7, 278.1],
    [172.2, 282.5],
    [177.5, 282.5],
    [188.1, 276.2],
    [188.6, 271.3],
    [187.3, 264.7],
    [188.6, 264.2],
    [192.6, 267.1],
    [194.7, 267.6],
    [200.5, 274.4],
    [203.7, 274.9],
    [206.3, 277.0],
    [210.0, 284.9],
    [210.0, 288.8],
    [206.8, 292.7],
    [193.4, 303.7],
    [192.0, 308.6],
    [189.7, 313.1],
    [179.6, 321.4],
    [174.9, 332.4],
    [173.3, 334.0],
    [169.3, 335.3],
    [150.3, 335.3],
    [136.8, 338.4],
    [101.4, 340.0],
    [58.4, 339.7],
    [30.1, 338.4]
];

// Outward offset makes the snake body thicker than the traced line art.
SNAKE_BODY_GROW = 6;

// Open mouth pocket; the outward offset would otherwise close it.
// Open gap between the jaws, running out through the front of the snout.
module snake_mouth_2d() {
    polygon([[170.0, 281.0], [206.9, 276.0], [207.5, 270.0], [199.0, 252.0],
             [191.0, 249.0], [183.0, 249.0], [176.0, 255.0], [171.0, 266.0]]);
}

// Fangs hang from the upper jaw and rise from the lower jaw, leaving a clear gap.
module snake_fangs_2d() {
    // Upper fang: broad root inside the upper jaw, curving down to a point.
    polygon([[199.0, 292.0], [211.0, 292.0], [209.0, 276.0],
             [205.0, 267.0], [201.0, 280.0]]);
    // Lower fang: a third of its former height, rising from inside the lower jaw.
    polygon([[188.0, 238.0], [198.0, 238.0], [197.0, 242.7],
             [195.0, 246.0], [193.0, 242.7]]);
    // Lower jaw pulled forward and down, so the jaw tip hangs below the flat underside.
    polygon([[196.0, 246.0], [204.0, 246.0], [214.0, 234.0],
             [208.0, 230.0], [196.0, 236.0]]);
}

module snake_body_2d() {
    union() {
        difference() {
            offset(delta = SNAKE_BODY_GROW)
                polygon(snake_outline);
            snake_mouth_2d();
        }
        snake_fangs_2d();
    }
}

// Diffuser recess shapes in the same 210 x 340 box: eye, jaw line and helix stripes.
module snake_band(a, b, r) {
    hull() {
        translate(a) circle(r = r);
        translate(b) circle(r = r);
    }
}

// Helix rungs: an even ladder of diagonal slots across the helix band, rising to the right
// at about 30 degrees, as in the Inner Diffuser Outline on the Snake-I trace sheet.
module snake_detail_2d() {
    snake_band([138, 248], [182, 256], 1.6);
    for (i = [0 : 9]) {
        y = 30 + i * 30;
        snake_band([44, y], [150, y + 58], 2.2);
    }
}

module snake_i_2d(w = 210, h = 340) {
    scale([w / 210, h / H_BOX])
        snake_body_2d();
}

// 3D snake: a rounded tube standing proud of the diffuser front, with an open jaw and fangs.
// Coordinates are the 210 x 340 box (x right, y up); z is depth, positive toward the viewer.
SNAKE_TUBE_R = 6;

// Spine points are [x, y, depth]. Depth swings in front of the diffuser so the body wraps the column.
snake_spine = [[182, 262, 13], [150, 256, 11], [118, 244, 8], [85, 230, 7], [54, 204, 11],
               [33, 170, 15], [38, 130, 10], [62, 96, 7], [96, 64, 9], [130, 42, 13], [160, 30, 10],
               [122, 16, 12], [80, 8, 16], [44, 16, 12]];

// Sphere scaled so it stays round after the part selector's X/Z scale: wx, wz are world mm per box unit.
module snake_ball(p, r, wx, wz) {
    translate(p) scale([r / wx, r / wz, r]) sphere(r = 1, $fn = 24);
}

module snake_chain(pts, wx, wz) {
    for (i = [0 : len(pts) - 2])
        hull() {
            snake_ball(pts[i], SNAKE_TUBE_R, wx, wz);
            snake_ball(pts[i + 1], SNAKE_TUBE_R, wx, wz);
        }
}

// Skull with an eye socket; upper and lower jaws are separate hulls, opened wide at the snout.
module snake_head_3d(wx, wz) {
    difference() {
        union() {
            hull() {
                snake_ball([158, 274, 15], 15, wx, wz);
                snake_ball([180, 282, 13], 12, wx, wz);
            }
            hull() {
                snake_ball([166, 282, 12], 10, wx, wz);
                snake_ball([206, 290, 9], 6, wx, wz);
            }
            hull() {
                snake_ball([160, 258, 10], 9, wx, wz);
                snake_ball([202, 250, 7], 5, wx, wz);
            }
            // Fangs hang from the upper jaw and rise from the lower jaw
            translate([198, 288, 9]) rotate([90, 0, 0]) cylinder(h = 16, r1 = 3.2, r2 = 0.4, $fn = 12);
            translate([194, 250, 8]) rotate([-90, 0, 0]) cylinder(h = 14, r1 = 3, r2 = 0.4, $fn = 12);
            // Smaller teeth along the jaw edges
            for (t = [[180, 280, 90], [194, 283, 90]])
                translate([t[0], t[1], 9]) rotate([t[2], 0, 0]) cylinder(h = 5, r1 = 1.8, r2 = 0.3, $fn = 10);
            for (t = [[180, 262, -90], [192, 256, -90]])
                translate([t[0], t[1], 9]) rotate([t[2], 0, 0]) cylinder(h = 5, r1 = 1.8, r2 = 0.3, $fn = 10);
        }
        snake_ball([170, 284, 21], 4.5, wx, wz);
    }
}

module snake_3d_body(wx = 1, wz = 1) {
    snake_chain(snake_spine, wx, wz);
    snake_head_3d(wx, wz);
}

// Preview when this file is opened directly; ignored when used by engenesis_lamp.scad.
linear_extrude(height = 10) snake_i_2d(210, 340);
