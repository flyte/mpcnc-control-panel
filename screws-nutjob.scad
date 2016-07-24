include <Nut_Job.scad>

//Distance between flats for the hex nut
nut_diameter                    = 12;   
//Height of the nut
nut_height                  = 6;    
//Outer diameter of the bolt thread to match (usually set about 1mm larger than bolt diameter to allow easy fit - adjust to personal preferences) 
nut_thread_outer_diameter                       = 9;        
//Thread step or Pitch (2mm works well for most applications ref. ISO262: M3=0.5,M4=0.7,M5=0.8,M6=1,M8=1.25,M10=1.5)
nut_thread_step                 = 2;
//Step shape degrees (45 degrees is optimised for most printers ref. ISO262: 30 degrees)
nut_step_shape_degrees                  = 45;   
//Wing radius ratio.  The proportional radius of the wing on the wing nut compared to the nut height value (default = 1)
wing_ratio                                      = 1;
wing_radius=wing_ratio * nut_height;

resolution                      = 0.5;  
nut_resolution                  = resolution;

// hex_nut(
//     nut_diameter,
//     nut_height,
//     nut_thread_step,
//     nut_step_shape_degrees,
//     nut_thread_outer_diameter,
//     nut_resolution
// );

nudge = 0.01;


difference() {
    cube([10, 10, nut_height]);
    translate([5, 5, -nudge])
        screw_thread(
            nut_thread_outer_diameter,
            nut_thread_step,
            nut_step_shape_degrees,
            nut_height+(nudge*2),
            nut_resolution,
            -2);
}

thread_outer_diameter                   = 8;
thread_step = 2;
step_shape_degrees = 45;
thread_length = 8;
countersink = 2;
head_diameter = 10;
head_height = 5;
non_thread_length = 0;
non_thread_diameter = 0;

translate([20, 0, 0])
    hex_screw(
        thread_outer_diameter,
        thread_step,
        step_shape_degrees,
        thread_length,
        resolution,
        countersink,
        head_diameter,
        head_height,
        non_thread_length,
        non_thread_diameter
    );