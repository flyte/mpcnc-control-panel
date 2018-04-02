include <Nut_Job.scad>;

quick_render = false;

nudge = 0.01;

width = 160;  // X axis
height = 120;  // Y axis
rear_depth = 100;  // Z axis
front_depth = rear_depth/2.5;
surface_angle = atan2(rear_depth-front_depth, height);
thickness = 2;
front_panel_thickness = 6;
rear_panel_thickness = 6;

screw_diameter = 8;
screw_pitch = 2;
screw_shape_degs = 45;

fan_diameter = 30;
fan_screw_diameter = 4;

base_surround_width = 10;

module screw_hole(width, height, depth, diameter) {
    difference() {
        cube([width, height, depth]);
        translate([width/2, height/2, -nudge]) {
            screw_thread(screw_diameter+1, screw_pitch, screw_shape_degs, depth+(nudge*2), 0.5);
        }
    }
}

module screw_hole_angle(width, height, depth, diameter) {
    difference() {
        union() {
            cube([width, height, depth]);
            rotate([90, 0, 0])
                translate([0, 0, -height])
                    linear_extrude(height=height)
                        polygon(points=[
                            [0, 0],
                            [width, 0],
                            [0, -depth]
                        ]);
        }
        translate([width/2, height/2, -depth/1.1])
            screw_thread(screw_diameter+1, screw_pitch, screw_shape_degs, depth*2, 0.5);
    }
}



module fan_hole(fan_diameter, fan_screw_diameter) {
    hole_diameter = fan_diameter*0.93;
    screw_hole_distance = fan_diameter*0.8;
    cylinder(r=hole_diameter/2, h=thickness+(nudge*2));
    translate([screw_hole_distance/2, screw_hole_distance/2, 0])
        cylinder(r=fan_screw_diameter/2, h=thickness+(nudge*2));
    translate([-screw_hole_distance/2, screw_hole_distance/2, 0])
        cylinder(r=fan_screw_diameter/2, h=thickness+(nudge*2));
    translate([screw_hole_distance/2, -screw_hole_distance/2, 0])
        cylinder(r=fan_screw_diameter/2, h=thickness+(nudge*2));
    translate([-screw_hole_distance/2, -screw_hole_distance/2, 0])
        cylinder(r=fan_screw_diameter/2, h=thickness+(nudge*2));
}


difference() {
    hull() {
        // Front
        cube([width, 1, front_depth]);
        // Back
        translate([0, height, 0])
            cube([width, 1, rear_depth]);
    }
    translate([thickness, thickness, thickness])
        cube([width-(thickness*2), height, rear_depth]);

    // Fan holes
    translate([-nudge, height/1.6, rear_depth/4]) {
        rotate([0, 90, 0])
            fan_hole(fan_diameter, fan_screw_diameter);
        translate([width-thickness, 0, 0])
            rotate([0, 90, 0])
                fan_hole(fan_diameter, fan_screw_diameter);
    }

    // Plastic savings
    translate([thickness+base_surround_width, base_surround_width, -nudge])
        cube([width-(base_surround_width*2)-thickness*2, height-(base_surround_width*2), thickness+(nudge*2)]);
}

standoff_size = 10;
front_inside_depth = tan(surface_angle)*thickness;
front_panel_holes_x = width-((thickness*2)-standoff_size);
echo("Front panel holes X: ", front_panel_holes_x);
front_panel_holes_y = (height*0.75)-standoff_size;
echo("Front panel holes Y: ", front_panel_holes_y);


translate([thickness, thickness, front_depth+front_inside_depth]) {
    rotate([surface_angle, 0, 0]) translate([0, 0, -standoff_size-front_panel_thickness]) {
        // Screw standoffs for front panel
        screw_hole_angle(standoff_size, standoff_size, standoff_size, screw_diameter);
        translate([0, height*0.75, 0])
            screw_hole_angle(standoff_size, standoff_size, standoff_size, screw_diameter);
        translate([width-(thickness*2)-standoff_size, 0, 0])
            rotate([0, 0, 180]) translate([-standoff_size, -standoff_size, 0])
                screw_hole_angle(standoff_size, standoff_size, standoff_size, screw_diameter);
        translate([width-(thickness*2)-standoff_size, height*0.75, 0])
            rotate([0, 0, 180]) translate([-standoff_size, -standoff_size, 0])
                screw_hole_angle(standoff_size, standoff_size, standoff_size, screw_diameter);

        // Lip for the front panel to sit on
        translate([0, height/4, 0]) {
            // LHS
            cube([standoff_size, height/3, standoff_size]);
            rotate([90, 0, 0])
                translate([0, 0, -height/3])
                    linear_extrude(height=height/3)
                        polygon(points=[
                            [0, 0],
                            [standoff_size, 0],
                            [0, -standoff_size]
                        ]);

            // RHS
            translate([width-(thickness*2), height/3, 0]) {
                rotate([0, 0, 180]) {
                    cube([standoff_size, height/3, standoff_size]);
                    rotate([90, 0, 0])
                        translate([0, 0, -height/3])
                            linear_extrude(height=height/3)
                                polygon(points=[
                                    [0, 0],
                                    [standoff_size, 0],
                                    [0, -standoff_size]
                                ]);
                }
            }
        }
    }
}

slot_x_thickness = 2;
slot_y_thickness = 1;
rear_slot_tolerance = 0.2;

// Mounting for rear panel
translate([thickness, 1+height-slot_y_thickness, thickness]) {
    cube([slot_x_thickness, slot_y_thickness, rear_depth*0.75]);
    translate([0, -rear_panel_thickness-slot_y_thickness-rear_slot_tolerance, 0])
        cube([slot_x_thickness, slot_y_thickness, rear_depth*0.75]);
    translate([width-(thickness*2)-slot_x_thickness, 0, 0]) {
        cube([slot_x_thickness, slot_y_thickness, rear_depth*0.75]);
        translate([0, -rear_panel_thickness-slot_y_thickness-rear_slot_tolerance, 0])
            cube([slot_x_thickness, slot_y_thickness, rear_depth*0.75]);
    }
}

usb_overhang = 6.25;
pcb_width = 53.3;
pcb_height = 68.6;
pcb_rear_overhang = pcb_height-50.8-1.3-14;

bl_hole_x = 2.5+5.1;
bl_hole_y = pcb_rear_overhang;
br_hole_x = bl_hole_x+27.9;
br_hole_y = pcb_rear_overhang;
tr_hole_x = br_hole_x+15.2;
tr_hole_y = br_hole_y+50.8;
tl_hole_x = 2.5;
tl_hole_y = tr_hole_y+1.3;
hole_diameter = 3;
pole_height = 8;
mountings_width = 8;

// Position of the inside of the rear panel
inside_y = height-slot_y_thickness-rear_panel_thickness-rear_slot_tolerance;

// Mounting for Arduino Uno
translate([width-pcb_width-25, inside_y-pcb_height, 0]) {
    difference() {
        cube([pcb_width, pcb_height, thickness]);
        translate([mountings_width, mountings_width, -nudge])
            cube([pcb_width-(mountings_width*2), pcb_height-mountings_width, thickness+(nudge*2)]);
    }
    translate([bl_hole_x, bl_hole_y, thickness])
        cylinder(r=hole_diameter/2, h=pole_height);
    translate([br_hole_x, br_hole_y, thickness])
        cylinder(r=hole_diameter/2, h=pole_height);
    translate([tl_hole_x, tl_hole_y, thickness])
        cylinder(r=hole_diameter/2, h=pole_height);
    translate([tr_hole_x, tr_hole_y, thickness])
        cylinder(r=hole_diameter/2, h=pole_height);
}
translate([width-pcb_width-25+(pcb_width/2)-(mountings_width/2), base_surround_width, 0])
    cube([base_surround_width, height-pcb_height-base_surround_width, thickness]);

relay_width = 45;
relay_height = 60;
bottom_hole_y = 6;
top_hole_y = relay_height-7;
relay_pole_diameter = 4.2;
relay_pole_height = 6;

// Mounting for solid state relay (SSR-25-DA)
translate([40, base_surround_width, 0]) {
    cube([mountings_width, height-(base_surround_width*2), thickness]);
    translate([-(relay_width/2)+(mountings_width/2), height/2-base_surround_width-(relay_height/2), 0])
        difference() {
            cube([relay_width, relay_height, thickness]);
            translate([mountings_width, mountings_width, -nudge])
                cube([relay_width-(mountings_width*2), relay_height-(mountings_width*2), thickness+(nudge*2)]);
        }
    translate([mountings_width/2, height/2-base_surround_width-(relay_height/2), thickness]) {
        translate([0, bottom_hole_y, 0])
            cylinder(r=relay_pole_diameter/2, h=relay_pole_height);
        translate([0, top_hole_y, 0])
            cylinder(r=relay_pole_diameter/2, h=relay_pole_height);
    }
}
