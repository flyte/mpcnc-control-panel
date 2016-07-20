include <threads.scad>;

thread_length = 20;
thread_diameter = 8;
thread_pitch = 2;

head_length = 5;
head_diameter = 7;

cylinder(r=head_diameter, h=head_length, $fs=8);
translate([0, 0, head_length])
    metric_thread(thread_diameter, thread_pitch, thread_length);
