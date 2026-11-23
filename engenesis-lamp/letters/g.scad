include <glyph_params.scad>

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

function logo_g_points() =
    [for (p = concat(g_outer_pts, g_counter_pts)) [p[0] * glyph_w("g"), p[1] * letter_h]];

module logo_g_2d(pts = logo_g_points()) {
    n_out = len(g_outer_pts);
    n_in = len(g_counter_pts);
    polygon(
        points = pts,
        paths = [[for (i = [0 : n_out - 1]) i], [for (i = [n_out : n_out + n_in - 1]) i]]
    );
}

logo_g_2d();  // preview when opened directly; ignored by `use`
