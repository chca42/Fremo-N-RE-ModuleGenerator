
include <profiles/base.scad>
include <profiles/n-re.scad>


boxW = 400;
boxL = 400;
boxH = 100;
trackW = 36;
supportH = 75;
hdiff = boxH-supportH;
edgeSupOffs = -boxH/2+supportH-thick/2;


union() {
    color("red")
    translate([0,boxL-thick,0])
    rotate([90,0,0])
    render()
    frame_nre_f1(boxW, boxH, supportH, trackW);

    color("yellow")
    rotate([90,0,0])
    render()
    frame_nre_f1(boxW, boxH, supportH, trackW);

    color("blue")
    translate([-boxW/2+thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    render()
    frame_side(boxL,boxH,supportH,inv=true);

    color("blue")
    translate([boxW/2-thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    render()
    frame_side(boxL,boxH,supportH,inv=true);
    
    color("orange")
    translate([0,boxL/2,0])
    rotate([90,0,0])
    render()
    frame_nre_f1_intermediate_B(boxW, boxH, 75, trackW);

    color("green")
    rotate([90,0,0])
    render()
    track_single(boxH, trackW, boxL);
    
    color("pink",0.5)
    translate([0,boxL/2-thick/2,boxH/2-trackTh/2+thick/2])
    rotate([90,0,90])
    render()
    track_t(boxH,boxL);

    color("deepskyblue")
    translate([-boxW/2+edgeSup/2,edgeSup/2-thick/2,edgeSupOffs])
    render()
    edge_support();
}


projection()
{
    gap = 2;
    translate([0,-boxH,0]) frame_nre_f1(boxW, boxH, supportH, trackW);
    translate([0,-2*boxH-gap,0]) frame_side(boxL,boxH,supportH,inv=true);

    translate([0,-4*boxH-gap-15,0]) frame_nre_f1_intermediate_B(boxW, boxH, 75, trackW);
    translate([0,-3*boxH-gap-10,0]) frame_nre_f1_intermediate_B(boxW, boxH, 75, trackW);
    
    translate([boxL*1.5+gap,-3.5*boxH-gap,0]) rotate([90,0,90]) track_single(boxH, trackW, boxL);
    translate([boxL+gap,-3.9*boxH-gap,0]) track_t(boxH,boxL);
    
    translate([boxW/2+gap+edgeSup/2+5,-4.4*boxH-gap,0])
        for(i=[0,1,2,3,4,5]) translate([edgeSup*1.1*i,0,0]) rotate([0,0,90]) edge_support();
}


