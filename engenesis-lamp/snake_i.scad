// Engenesis "I": helix snake with an open-jawed head, after the Snake-I drawing.
// Reference geometry is in mm for a 210 x 340 box (base on y=0, head at top).

// Body centreline as [x, y, radius]; drawn as tapered capsules joined by hulls.
snake_centreline = [
    [188, 22, 2], [168, 28, 6], [140, 44, 10], [105, 62, 14], [70, 78, 17], [40, 100, 19],
    [24, 135, 21], [22, 170, 22], [38, 200, 22], [75, 230, 21], [118, 245, 20], [135, 258, 19]
];

// Head facing right with the upper jaw raised and the lower jaw dropped; fangs hang into the gape.
snake_head = [
    [99, 262], [109, 305], [136, 334], [164, 339], [193, 327], [208, 309], [208, 298],
    [196, 298], [191, 279], [184, 298], [164, 293], [136, 286], [172, 267], [205, 257],
    [198, 250], [174, 250], [150, 250], [131, 248]
];

module snake_ref_2d() {
    difference() {
        union() {
            polygon(snake_head);
            for (i = [0 : len(snake_centreline) - 2])
                hull() {
                    translate([snake_centreline[i][0], snake_centreline[i][1]])
                        circle(r = snake_centreline[i][2], $fn = 24);
                    translate([snake_centreline[i + 1][0], snake_centreline[i + 1][1]])
                        circle(r = snake_centreline[i + 1][2], $fn = 24);
                }
        }
        translate([155, 315]) circle(r = 5, $fn = 24);
    }
}

module snake_i_2d(w, h) {
    scale([w / 210, h / 340]) snake_ref_2d();
}
