include <ISOThread.scad>;

length = 16;
diameter = 8;
pitch = 2;

// difference() {
//     hex_bolt(8, 16);
//     translate([0, 0, 19.4])
//         cylinder(r=8, h=2);
// }

hex_bolt(diameter, length, pitch);

nudge = 0.01;
depth = 10;
quick_render = false;
screw_diameter = diameter;

translate([20, 0, 0])
    difference() {
        cube([10, 10, 10]);
        translate([5, 5, 0])
            difference() {
                cylinder(r=screw_diameter/2, depth+(nudge*2));
                if (!quick_render) {
                    thread_in_pitch(screw_diameter, depth+(nudge*2), pitch);
                }
            }
    }
