/*
 * Everyday Dose Frother Fridge Holder — v2
 *
 * Based on Pen Holder Fridge Magnet by Code and Make (https://codeandmake.com/)
 * https://codeandmake.com/post/pen-holder-fridge-magnet
 *
 * Same design as codeandmakecom_pen_holder_fridge_magnet_v10 (7).scad,
 * adapted for a 33 mm diameter frother handle and 110 mm depth.
 *
 * v2: adds a third magnet hole in the middle of the back for extra grip.
 */

/* [General] */

// The minimum thickness of the material
Material_Thickness = 2; // [1:0.1:5]

/* [Frother Hole] */

// Diameter of the frother handle hole (33 mm handle + ~2.5 mm extra clearance)
Frother_Hole_Diameter = 35.5; // [5:0.1:50]

// Total depth of the frother hole
Frother_Hole_Depth = 110; // [25:1:150]

/* [Magnet Holes] */

// Diameter of the magnet hole (12 mm disc magnets)
Magnet_Hole_Diameter = 12; // [1:0.1:15]

// Depth of the magnet hole (3 mm thick magnets)
Magnet_Hole_Depth = 3; // [1:0.1:5]

module penHolder() {
  $fn = 100;

  penHoleDiameter = max(Frother_Hole_Diameter, Magnet_Hole_Diameter);
  cutOutDepth = penHoleDiameter + Material_Thickness;
  penHoleDepth = max(Frother_Hole_Depth, (cutOutDepth * 2) + penHoleDiameter + (Material_Thickness * 2));
  baseWidth = penHoleDiameter + (Material_Thickness * 2);
  baseHeight = penHoleDepth + Material_Thickness;
  cutOutHeight = penHoleDepth - penHoleDiameter - (Material_Thickness * 2);

  module pen() {
    // v2: hollow all the way through the bottom so the froter handle
    // can slide in fully — straight bore, no solid cone at the base.
    translate([0, 0, -0.01]) {
      cylinder(d = penHoleDiameter, h = penHoleDepth + 0.02);
    }
  }

  module base() {
    translate([0, 0, -Material_Thickness]) {
      cylinder(d = baseWidth, h = baseHeight);
      translate([-baseWidth / 2, 0, 0]) {
        cube(size=[baseWidth, (penHoleDiameter / 2) + Material_Thickness + Magnet_Hole_Depth, baseHeight]);
      }
    }
  }

  module frontCutOut() {
    translate([0, -(penHoleDiameter / 2) - Material_Thickness, cutOutDepth + penHoleDiameter]) {
      hull() {
        // bottom
        rotate([0, 90, 0]) {
          cylinder(r=cutOutDepth, h = baseWidth + 1, center = true);
        }

        translate([0, 0, cutOutHeight - (cutOutDepth * 2)]) {
          // top
          rotate([0, 90, 0]) {
            cylinder(r=cutOutDepth, h = baseWidth + 1, center = true);
          }
        }
      }
    }
  }

  module magnetHole() {
    rotate([270, 0, 0]) {
      cylinder(d = Magnet_Hole_Diameter, h = Magnet_Hole_Depth + 1);
    }
  }

  module magnetHoles() {
    // bottom
    translate([0, (penHoleDiameter / 2) + Material_Thickness, (baseWidth / 2) - Material_Thickness]) {
      magnetHole();
    }

    // middle (v2)
    translate([0, (penHoleDiameter / 2) + Material_Thickness, baseHeight / 2]) {
      magnetHole();
    }

    // top
    translate([0, (penHoleDiameter / 2) + Material_Thickness, baseHeight - (baseWidth / 2) - Material_Thickness]) {
      magnetHole();
    }
  }

  module ridge() {
    rotate_extrude(convexity = 10) {
      translate([(penHoleDiameter / 2) + (Material_Thickness / 2), 0, 0]) {
        circle(d = Material_Thickness);
      }
    }
  }

  module ridges() {
    translate([0, 0, penHoleDiameter]) {
      ridge();
    }

    translate([0, 0, baseHeight - Material_Thickness]) {
      ridge();
    }
  }

  rotate([-90, 0, 0]) {
    difference() {
      base();
      pen();
      frontCutOut();
      magnetHoles();
    }

    ridges();
  }
}

penHolder();
