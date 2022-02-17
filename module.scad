
eps = .01;
thick = 8;
lasRad = .05;
lasWid = 2*lasRad;

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
    rotate([0,0,90])
    fingerH(W,N,selfT,otherT,inv);
}

module track_single(height, length)
{
    translate([0, height/2+3-thick/2, -length/2+thick/2])
    ccube([37.5, thick, length]);
}

module frame(width, height, inv=false, N=4)
{
    difference()
    {
        union()
        children();
        
        xoffs(-width/2)
        fingerH(height, N, inv=inv);

        rotate([0,180,0])
        xoffs(-width/2)
        fingerH(height, N, inv=inv);
    }
}

module frame_side(width, height, sH, inv=false)
{
    difference()
    {
        frame(width, height, inv)
        ccube([width,height,thick]);
        
        translate([thick/2,-(height-sH)/2,thick/2])
        rotate([0,90,0])
        fingerH(sH, 4, otherT=thick*2, inv=true);
    }
}

module frame_support(width, height, sH)
{
    translate([0,-(height-sH)/2,0])
    difference()
    {
        frame(width, sH, inv=false)
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
        
        for(i=[-1:2:1])
        translate([i*w/5,-(h-sH)/2,thick/2])
        rotate([0,90,0])
        fingerH(sH, 4, otherT=thick*2, inv=true);
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

        for(i=[-1:2:1])
        translate([i*w/5,-(h-sH)/2,thick/2+eps])
        rotate([180,90,0])
        fingerH(sH, 1, otherT=thick*2, inv=false);
       
        for(i=[-1:1:1])
        translate([i*w/3,-(h-sH)/2,-thick/2-eps])
        cylinder(thick+2*eps, r=15);
    }
}


//frame_side(400,100);
//frame_nre_f1();

boxW = 400;
boxL = 400;
boxH = 100;
supportH = 75;

union() {
    color("red")
    translate([0,boxL-thick,0])
    rotate([90,0,0])
    frame_nre_f1(supportH);

    rotate([90,0,0])
    frame_nre_f1(supportH);

    color("blue")
    translate([-boxW/2+thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_side(boxL,boxH,supportH,inv=true);

    color("blue")
    translate([boxW/2-thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_side(boxL,boxH,supportH,inv=true);
    
    color("deepskyblue", 0.2)
    translate([-boxW/5,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_support(boxL,boxH,supportH);

    color("deepskyblue", 0.2)
    translate([boxW/5,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_support(boxL,boxH,supportH);
    
    color("orange", 0.2)
    translate([0,boxL/2,0])
    rotate([90,0,0])
    frame_nre_f1_intermediate(75);
    
    color("green")
    rotate([90,0,0])
    track_single(boxH, boxL);
}

projection()
{
    gap = 2;
    translate([0,-boxH,0]) frame_nre_f1(supportH);
    translate([boxW+gap,-boxH]) frame_nre_f1(supportH);
    translate([0,-2*boxH-gap,0]) frame_side(boxL,boxH,supportH,inv=true);
    translate([boxL+gap,-2*boxH-gap,0]) frame_side(boxL,boxH,supportH,inv=true);
}

