width = 160;  // X axis
height = 120;  // Y axis
rear_depth = 100;  // Z axis
front_depth = rear_depth/2.5;
surface_angle = atan2(rear_depth-front_depth, height);
thickness = 2;
front_panel_thickness = 6;

module screw_hole(width, height, depth, diameter) {
    difference() {
        cube([width, height, depth]);
        translate([width/2, height/2, depth/5])
            cylinder(r=diameter/2, h=depth, $fs=0.01);
    }
}

module screw_hole_angle(width, height, depth, diameter) {
    screw_hole(width, height, depth, diameter);
    rotate([90, 0, 0])
        translate([0, 0, -height])
            linear_extrude(height=height)
                polygon(points=[
                    [0, 0],
                    [width, 0],
                    [0, -depth]
                ]);
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
}

standoff_size = 10;
front_inside_depth = tan(surface_angle)*thickness;
front_panel_holes_x = width-((thickness*2)-standoff_size);
echo("Front panel holes X: ", front_panel_holes_x);
front_panel_holes_y = (height*0.75)-standoff_size;
echo("Front panel holes Y: ", front_panel_holes_y);

translate([thickness, thickness, front_depth+front_inside_depth]) {
    rotate([surface_angle, 0, 0]) translate([0, 0, -standoff_size-front_panel_thickness]) {
        screw_hole_angle(standoff_size, standoff_size, standoff_size, 4);
        translate([0, height*0.75, 0])
            screw_hole_angle(standoff_size, standoff_size, standoff_size, 4);
        translate([width-(thickness*2)-standoff_size, 0, 0])
            rotate([0, 0, 180]) translate([-standoff_size, -standoff_size, 0])
                screw_hole_angle(standoff_size, standoff_size, standoff_size, 4);
        translate([width-(thickness*2)-standoff_size, height*0.75, 0])
            rotate([0, 0, 180]) translate([-standoff_size, -standoff_size, 0])
                screw_hole_angle(standoff_size, standoff_size, standoff_size, 4);
    }
}