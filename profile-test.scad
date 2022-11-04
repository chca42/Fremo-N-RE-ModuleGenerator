
include <profiles/base.scad>
include <profiles/n-re.scad>

boxW = 400;
boxL = 400;
boxH = 100;
trackW = 36;
supportH = 75;
hdiff = boxH-supportH;
edgeSupOffs = -boxH/2+supportH-thick/2;

render()
frame_nre_f1(boxW, boxH, supportH, trackW);
//stranslate([-boxW/2,-boxH/2,-6]) import("profiles/n-re-f1.svg");
//frame_profile_base(boxW,boxH, trackW);

translate([0,-boxH*1.1, 0])
render()
frame_nre_f1_intermediate_B(boxW, boxH, supportH, trackW);
