
eps = .01;
thick = 6;
lasRad = .0;
lasWid = 2*lasRad;
trackTh = 33;
edgeSup = 50;

module xoffs(offs) { translate([offs,0,0]) children(); }
module yoffs(offs) { translate([0,offs,0]) children(); }
module ccube(p) // p=[width,depth,height] (centered)
{
    translate([-p[0]/2,-p[1]/2,-p[2]/2])
    cube(p);
}

module fingerH(H, N, selfT=thick, otherT=thick, inv=false)
{
    h = H/N;
    off = inv ? 1 : 0;
    intersection()
    {
        translate([0,-H/2-eps,0])
        union()
        {
            for(i=[off:2:N])
            {
                translate([otherT/2-lasWid,i*h,0])
                ccube([otherT+off*eps,h-lasWid,selfT+eps]);
            }
        }
        translate([otherT/2,0,0])
        ccube([otherT+off*eps,H+eps,selfT+eps]);
    }
}

module fingerV(W, N, selfT=thick, otherT=thick, inv=false)
{
    translate([0, otherT, 0])
    rotate([0,0,-90])
    fingerH(W,N,selfT,otherT,inv);
}

module track_single(height, length)
{
    translate([0, height/2+3-thick/2, -length/2+thick/2])
    difference()
    {
        ccube([37.5, thick, length]);

        translate([-thick/2,0,0])
        rotate([-90,0,0])
        fingerH(length, 30, inv=true);
    }
}

module track_t(height, length)
{
    //translate([0, height/2+3-thick/2, -length/2+thick/2])
    //rotate([0,0,90])
    difference()
    {
        ccube([length, trackTh, thick]);
        
        translate([0,0,0])
        fingerH(trackTh, 1, otherT=thick);
        translate([-length/2-thick,0,0])
        fingerH(trackTh, 1, otherT=thick*3);
        translate([length/2-thick*2,0,0])
        fingerH(trackTh, 1, otherT=thick*3);
        
        yoffs(+trackTh/2-thick+2*eps)
        fingerV(length, 30);
    }
}

module frame(width, height, inv=false, N=4, otherT=thick)
{
    difference()
    {
        union()
        children();
        
        xoffs(-width/2)
        fingerH(height, N, otherT=otherT, inv=inv);

        rotate([0,180,0])
        xoffs(-width/2)
        fingerH(height, N, otherT=otherT, inv=inv);
    }
}

module frame_side(width, height, sH, inv=false)
{
    difference()
    {
        frame(width, height, inv, otherT=thick*2)
        ccube([width,height,thick]);
        
        translate([thick/2,-(height-sH)/2,thick/2])
        rotate([0,90,0])
        fingerH(sH, 4, otherT=thick*2, inv=true);
        
        for(i=[-1:2:1])
        translate([i*(-width/2+edgeSup/2+thick),8,-thick/2])
        rotate([90,0,0])
        fingerV(edgeSup, 4, otherT=thick, inv=true);
        
        for(i=[-1:2:1])
        translate([i*(-width/2+edgeSup/2+thick),-height/2+thick/2,-thick/2])
        rotate([90,0,0])
        fingerV(edgeSup, 4, otherT=thick, inv=true);
    }
}

module frame_support(width, height, sH)
{
    translate([0,-(height-sH)/2,0])
    difference()
    {
        frame(width, sH, inv=false, otherT=thick*2)
        ccube([width,sH,thick]);
        
        for(i=[-1:2:1])
        translate([i*width/4,0,-thick/2-eps])
        cylinder(thick+2*eps, r=15);
        
        translate([thick/2,0,thick/2+eps])
        rotate([0,90,0])
        fingerH(sH, 1, otherT=thick*2, inv=false);
    }
}

module frame_nre_f1(sH)
{
    w = 400;
    h = 100;
    difference()
    {
        frame(w, h)
        translate([-w/2,-h/2,-thick/2])
        linear_extrude(thick)
        import("profiles/n-re-f1.svg");
        
        track_single(h, thick);

        // finger for track t support
        translate([-thick/2,h/2-trackTh/2+thick/2,0])
        fingerH(trackTh, 1, otherT=thick, inv=true);
        
        for(i=[-1:2:1])
        translate([i*w/5,-(h-sH)/2,thick/2])
        rotate([0,90,0])
        fingerH(sH, 4, otherT=thick*2, inv=true);

        for(i=[-1:2:1])
        translate([i*(-w/2+edgeSup/2),8,-thick/2])
        rotate([90,0,0])
        fingerV(edgeSup, 4, otherT=thick, inv=true);

        for(i=[-1:2:1])
        translate([i*(-w/2+edgeSup/2),-h/2+thick/2,-thick/2])
        rotate([90,0,0])
        fingerV(edgeSup, 4, otherT=thick, inv=true);

    }
}


module frame_nre_f1_intermediate(sH)
{
    w = 400;
    h = 100;
    difference()
    {
        translate([0,-(h-sH)/2,0])
        frame(w,sH)
        translate([-w/2,-sH/2,-thick/2])
        linear_extrude(thick)
        import("profiles/n-re-f1-intermediate.svg");
        
        track_single(h, thick);
        
        // finger for track t support
        translate([-thick/2,h/2-trackTh/2+thick/2,0])
        fingerH(33, 1, otherT=thick, inv=true);

        for(i=[-1:2:1])
        translate([i*w/5,-(h-sH)/2,thick/2+eps])
        rotate([180,90,0])
        fingerH(sH, 1, otherT=thick*2, inv=false);
       
        for(i=[-1:1:1])
        translate([i*w/3,-(h-sH)/2,-thick/2-eps])
        cylinder(thick+2*eps, r=15);
    }
}

module edge_support()
{
    l = edgeSup;
    difference()
    {
        translate([-l/2,-l/2,-thick/2])
        linear_extrude(thick)
        polygon([[0,0],[l,0],[l,10],[10,l],[0,l]]);
        
        xoffs(-l/2) yoffs(thick)
        fingerH(l, 4, otherT=thick, inv=false);
        
        yoffs(-l/2)
        fingerV(l, 4, otherT=2*thick, inv=false);
    }
}

boxW = 400;
boxL = 400;
boxH = 100;
supportH = 75;
hdiff = boxH-supportH;

union() {
    color("red")
    translate([0,boxL-thick,0])
    rotate([90,0,0])
    render()
    frame_nre_f1(supportH);

    color("yellow")
    rotate([90,0,0])
    render()
    frame_nre_f1(supportH);

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
    
    color("deepskyblue")
    translate([-boxW/5,boxL/2-thick/2,0])
    rotate([90,0,90])
    render()
    frame_support(boxL,boxH,supportH);

    color("deepskyblue")
    translate([boxW/5,boxL/2-thick/2,0])
    rotate([90,0,90])
    render()
    frame_support(boxL,boxH,supportH);
    
    color("orange")
    translate([0,boxL/2,0])
    rotate([90,0,0])
    render()
    frame_nre_f1_intermediate(75);
    
    color("green")
    rotate([90,0,0])
    render()
    track_single(boxH, boxL);
    
    color("pink",0.5)
    translate([0,boxL/2-thick/2,boxH/2-trackTh/2+thick/2])
    rotate([90,0,90])
    render()
    track_t(boxH,boxL);

    color("deepskyblue")
    translate([-boxW/2+edgeSup/2,edgeSup/2-thick/2,0])
    render()
    edge_support();
}

!projection()
{
    gap = 2;
    translate([boxW+10*gap,10*gap,0]) frame_nre_f1(supportH);
    translate([boxW+10*gap,12*gap+boxH,0]) frame_nre_f1(supportH);
    translate([0,-boxH,0]) frame_nre_f1(supportH);
    translate([boxW+gap,-boxH]) frame_nre_f1(supportH);
    translate([0,-2*boxH-gap,0]) frame_side(boxL,boxH,supportH,inv=true);
    translate([boxL+gap,-2*boxH-gap,0]) frame_side(boxL,boxH,supportH,inv=true);
    translate([0,-3*boxH-gap+hdiff/2,0]) frame_support(boxL,boxH,supportH);
    translate([boxL+gap,-3*boxH-gap+hdiff/2,0]) frame_support(boxL,boxH,supportH);
    translate([0,-4*boxH-gap-15,0]) frame_nre_f1_intermediate(75);
    translate([boxL*1.5+gap,-3.6*boxH-gap,0]) rotate([90,0,90]) track_single(boxH, boxL);
    translate([boxL+gap,-4.0*boxH-gap,0]) track_t(boxH,boxL);
    translate([-boxW/2+edgeSup-15,-3.63*boxH-gap,0])
        for(i=[0,1,4,5,6]) translate([edgeSup*1.1*i,0,0]) rotate([0,0,90]) edge_support();
    translate([boxW/2+gap+edgeSup,-4.4*boxH-gap,0])
        for(i=[0,1,2,3,4]) translate([edgeSup*1.1*i,0,0]) rotate([0,0,90]) edge_support();
}

