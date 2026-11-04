/*
  Engenesis modular divider sign
  Units: mm
  Designed for single-color-at-a-time printing.

  Export workflow:
    1. Set PART to the desired component.
    2. Press F6 in OpenSCAD.
    3. File > Export > Export as STL.

  Available PART values:
    "letter_shell", "letter_diffuser", "bridge_shell", "bridge_diffuser",
    "rail", "divider_clamp", "snake_shell", "snake_diffuser", "assembly_preview"

  Change GLYPH for each letter. The final word is ENGENES + snake-I + S.
*/

PART = "assembly_preview";
GLYPH = "E";

// ---------- Global dimensions ----------
letter_h = 190;
letter_w = 125;
letter_depth = 32;
wall = 3;
front_lip = 2.2;
diffuser_t = 1.2;
letter_spacing = 32;
corner_r = 7;

bridge_len = letter_spacing + 16;
bridge_h = 18;
bridge_depth = 24;
bridge_wall = 2.4;
bridge_diffuser_t = 1.2;
connector_len = 10;
connector_w = 10;
connector_clearance = 0.35;

rail_section_len = 240; // safely below a 300 mm bed
rail_w = 34;
rail_h = 12;
rail_wall = 3;
rail_join_len = 14;
rail_clearance = 0.35;

// Measure the actual divider before printing the clamp.
divider_thickness = 55;
clamp_depth = 48;
clamp_wall = 5;
clamp_grip = 30;
clamp_clearance = 1.0;

led_channel_w = 13;  // fits common 10 mm LED strip with tolerance
led_channel_h = 6;
wire_hole_d = 8;

font_name = "Liberation Sans:style=Bold";

// ---------- Helpers ----------
module rounded_box(size=[10,10,10], r=2) {
    hull() {
        for (x=[r, size[0]-r], y=[r, size[1]-r], z=[r, size[2]-r])
            translate([x,y,z]) sphere(r=r, $fn=24);
    }
}

module rounded_2d(w,h,r) {
    offset(r=r) offset(delta=-r) square([w,h], center=true);
}

module male_tab() {
    // Tapered tongue prints without support when oriented flat.
    linear_extrude(height=connector_w)
        polygon([[0,0],[connector_len,2],[connector_len,connector_w-2],[0,connector_w]]);
}

module female_socket(extra=0) {
    linear_extrude(height=connector_w + 2*extra)
        offset(delta=connector_clearance + extra)
            polygon([[0,0],[connector_len,2],[connector_len,connector_w-2],[0,connector_w]]);
}

module letter_shape(g=GLYPH) {
    resize([letter_w-22, letter_h-24], auto=false)
        text(g, size=letter_h, font=font_name, halign="center", valign="center");
}

// ---------- Letter ----------
module letter_shell(g=GLYPH) {
    difference() {
        union() {
            // Back tray
            linear_extrude(height=letter_depth)
                offset(r=5) letter_shape(g);
            // Standardized bridge ears at mid-height
            translate([-letter_w/2-connector_len+8, -connector_w/2, letter_depth/2-connector_w/2])
                rotate([90,0,0]) male_tab();
            translate([letter_w/2-8, connector_w/2, letter_depth/2-connector_w/2])
                rotate([90,0,180]) male_tab();
            // Rail shoe
            translate([-30,-letter_h/2-8,0]) rounded_box([60,20,letter_depth],3);
        }
        // Main illuminated cavity, leaving opaque wall and back
        translate([0,0,wall])
            linear_extrude(height=letter_depth-wall+0.1)
                offset(delta=-wall) letter_shape(g);
        // Front diffuser recess
        translate([0,0,letter_depth-front_lip])
            linear_extrude(height=front_lip+0.2)
                offset(delta=-wall-front_lip) letter_shape(g);
        // LED/wire passage at bridge height
        translate([-letter_w, -led_channel_h/2, letter_depth/2-led_channel_w/2])
            cube([2*letter_w,led_channel_h,led_channel_w]);
        // Vertical wire drop into rail shoe
        translate([0,-letter_h/2-10,letter_depth/2]) rotate([90,0,0])
            cylinder(d=wire_hole_d,h=30,$fn=32);
        // Rail socket under shoe
        translate([-rail_w/2-rail_clearance,-letter_h/2-8-0.1,wall])
            cube([rail_w+2*rail_clearance,20.2,rail_h+rail_clearance]);
    }
}

module letter_diffuser(g=GLYPH) {
    linear_extrude(height=diffuser_t)
        offset(delta=-wall-front_lip-0.25) letter_shape(g);
}

// ---------- Bridge ----------
module bridge_shell() {
    difference() {
        rounded_box([bridge_len,bridge_depth,bridge_h],3);
        // Through tunnel for LED strip and wires
        translate([2.5,(bridge_depth-led_channel_w)/2,(bridge_h-led_channel_h)/2])
            cube([bridge_len-5,led_channel_w,led_channel_h]);
        // Top/front diffuser window
        translate([5,-0.1,4]) cube([bridge_len-10,bridge_wall+0.3,bridge_h-8]);
        // Female sockets at both ends
        translate([-0.1,bridge_depth/2-connector_w/2,bridge_h/2-connector_w/2])
            rotate([90,0,0]) female_socket(0.1);
        translate([bridge_len+0.1,bridge_depth/2+connector_w/2,bridge_h/2-connector_w/2])
            rotate([90,0,180]) female_socket(0.1);
    }
}

module bridge_diffuser() {
    cube([bridge_len-10,bridge_diffuser_t,bridge_h-8]);
}

// ---------- Modular rail ----------
module rail() {
    difference() {
        union() {
            rounded_box([rail_section_len,rail_w,rail_h],2.5);
            // Male dovetail at right
            translate([rail_section_len,rail_w/2-8,2])
                linear_extrude(height=rail_h-4)
                    polygon([[0,0],[rail_join_len,2],[rail_join_len,14],[0,16]]);
        }
        // Wire raceway
        translate([8,(rail_w-led_channel_w)/2,rail_h-led_channel_h])
            cube([rail_section_len-16,led_channel_w,led_channel_h+0.1]);
        // Female dovetail at left
        translate([-0.1,rail_w/2-8-rail_clearance,2-rail_clearance])
            linear_extrude(height=rail_h-4+2*rail_clearance)
                offset(delta=rail_clearance)
                    polygon([[0,0],[rail_join_len,2],[rail_join_len,14],[0,16]]);
        // Clamp mounting holes
        for (x=[45,rail_section_len-45])
            translate([x,rail_w/2,-0.1]) cylinder(d=5.2,h=rail_h+0.2,$fn=28);
    }
}

// Clamp slides over divider; foam pads are recommended on inner faces.
module divider_clamp() {
    outer_w = divider_thickness + 2*clamp_wall + 2*clamp_clearance;
    difference() {
        union() {
            cube([outer_w,clamp_depth,clamp_grip+clamp_wall]);
            // Rail mounting saddle
            translate([(outer_w-rail_w)/2,0,clamp_grip]) cube([rail_w,clamp_depth,rail_h]);
        }
        // Divider opening
        translate([clamp_wall,clamp_wall,-0.1])
            cube([divider_thickness+2*clamp_clearance,clamp_depth-clamp_wall,clamp_grip+0.2]);
        // Rail fastener holes
        for (y=[14,clamp_depth-14])
            translate([outer_w/2,y,clamp_grip-0.1]) cylinder(d=5.2,h=rail_h+clamp_wall+0.2,$fn=28);
    }
}

// ---------- Simplified snake-I showpiece ----------
// This is a manufacturable stylized prototype, not an exact trace of the supplied logo.
module snake_2d() {
    union() {
        // Central I / DNA spine
        rounded_2d(42,letter_h-22,8);
        // Snake body as a thick S-shaped path
        difference() {
            union() {
                translate([0,48]) difference() {
                    circle(r=47,$fn=72); circle(r=30,$fn=72);
                }
                translate([0,-48]) difference() {
                    circle(r=47,$fn=72); circle(r=30,$fn=72);
                }
            }
            translate([-60,45]) square([60,65]);
            translate([0,-110]) square([60,65]);
        }
        // Head
        translate([35,78]) rotate(-12) scale([1.5,0.85]) circle(r=16,$fn=48);
    }
}

module snake_shell() {
    difference() {
        linear_extrude(height=letter_depth) offset(r=4) snake_2d();
        translate([0,0,wall]) linear_extrude(height=letter_depth-wall+0.1)
            offset(delta=-wall) snake_2d();
        translate([0,0,letter_depth-front_lip]) linear_extrude(height=front_lip+0.2)
            offset(delta=-wall-front_lip) snake_2d();
        // Horizontal LED/wire path
        translate([-letter_w,-led_channel_h/2,letter_depth/2-led_channel_w/2])
            cube([2*letter_w,led_channel_h,led_channel_w]);
    }
}

module snake_diffuser() {
    linear_extrude(height=diffuser_t)
        offset(delta=-wall-front_lip-0.25) snake_2d();
}

// ---------- Preview ----------
module assembly_preview() {
    chars = ["E","N","G","E","N","E","S","@","S"];
    pitch = letter_w + letter_spacing;
    total = (len(chars)-1)*pitch;
    color("dimgray") translate([-total/2-70,-letter_h/2-35,-14]) cube([total+140,70,14]);
    for(i=[0:len(chars)-1]) {
        x = i*pitch-total/2;
        if(chars[i]=="@") {
            color("darkgreen") translate([x,0,0]) snake_shell();
            color([0.7,0.9,1,0.8]) translate([x,0,letter_depth+0.2]) snake_diffuser();
        } else {
            color("#111827") translate([x,0,0]) letter_shell(chars[i]);
            color([0.75,0.9,1,0.85]) translate([x,0,letter_depth+0.2]) letter_diffuser(chars[i]);
        }
        if(i < len(chars)-1)
            color("#111827") translate([x+letter_w/2-8,-bridge_depth/2,letter_depth/2-bridge_h/2]) bridge_shell();
    }
}

// ---------- Part selector ----------
if (PART == "letter_shell") letter_shell(GLYPH);
else if (PART == "letter_diffuser") letter_diffuser(GLYPH);
else if (PART == "bridge_shell") bridge_shell();
else if (PART == "bridge_diffuser") bridge_diffuser();
else if (PART == "rail") rail();
else if (PART == "divider_clamp") divider_clamp();
else if (PART == "snake_shell") snake_shell();
else if (PART == "snake_diffuser") snake_diffuser();
else assembly_preview();
