include <ISOThread.scad>;

length = 16;
diameter = 8;

// difference() {
//     hex_bolt(8, 16);
//     translate([0, 0, 19.4])
//         cylinder(r=8, h=2);
// }

hex_bolt(diameter, length);