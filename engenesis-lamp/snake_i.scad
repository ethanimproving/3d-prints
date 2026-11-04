// Snake "I" traced from images/snake-trace-sheet.jpg (front view).
// Centreline points are in the trace's pixel space (700x1120 zoomed crop);
// they are mapped into a 210 x 340 box so the glyph scales like the other letters.

H_BOX = 340;

function zx(p) = (p[0] - 30) * 0.331;
function zy(p) = (1070 - p[1]) * 0.327;

// Catmull-Rom control points in box units (210 x 340), from the sheet's front view.
ctrl = [[150, 300], [19, 227], [100, 170], [168, 120], [50, 20], [30, 4]];

function cr(a, b, c, d, t) = [for (k = [0:1])
    0.5 * ((2 * b[k]) + (-a[k] + c[k]) * t + (2 * a[k] - 5 * b[k] + 4 * c[k] - d[k]) * t * t + (-a[k] + 3 * b[k] - 3 * c[k] + d[k]) * t * t * t)];

function spline_pts(n = 10) = [for (i = [0 : len(ctrl) - 2]) for (j = [0 : n - 1])
    cr(ctrl[max(i - 1, 0)], ctrl[i], ctrl[i + 1], ctrl[min(i + 2, len(ctrl) - 1)], j / n),
    ctrl[len(ctrl) - 1]];

body_pts = spline_pts();

function body_r(i) = 12 - 4 * i / (len(body_pts) - 1);

module body_2d() {
    for (i = [0 : len(body_pts) - 2])
        hull() {
            translate(body_pts[i]) circle(r = body_r(i), $fn = 24);
            translate(body_pts[i + 1]) circle(r = body_r(i + 1), $fn = 24);
        }
}

module head_2d() {
    hull() {
        translate([158, 306]) circle(r = 14, $fn = 32);
        translate([196, 320]) circle(r = 7, $fn = 24);
    }
    hull() {
        translate([166, 290]) circle(r = 8, $fn = 24);
        translate([198, 300]) circle(r = 5, $fn = 20);
    }
}

module mouth_cut_2d() {
    polygon([[178, 310], [206, 320], [192, 302]]);
}

module column_2d() {
    translate([72, 10]) square([58, 320]);
    translate([10, 0]) square([180, 14]);
    translate([0, 326]) square([190, 14]);
}

module snake_i_2d(w = 210, h = 340) {
    scale([w / 210, h / H_BOX])
        difference() {
            union() {
                column_2d();
                body_2d();
                head_2d();
            }
            mouth_cut_2d();
        }
}
