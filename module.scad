
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

module fingerH(H, N=4, selfT=thick, otherT=thick, inv=false)
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
                translate([0,i*h,0])
                ccube([2*otherT+off*eps-lasWid,h-lasWid,selfT+eps]);
            }
        }
        ccube([2*otherT+off*eps,H,selfT+eps]);
    }
}

module fingerV(W, N=4, selfT=thick, otherT=thick, inv=false)
{
    rotate([0,0,90])
    fingerH(W,N,selfT,otherT,inv);
}

module frame(width, height, inv=false)
{
    difference()
    {
        union()
        children();
        
        xoffs(-width/2)
        fingerH(height, inv=inv);
        xoffs(width/2)
        fingerH(height, inv=inv);
    }
}

module frame_simple(width, height, inv=false)
{
    frame(width, height, inv)
    ccube([width,height,thick]);
}

module frame_nre_f1()
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
    }
}

module track_single(height, length)
{
    translate([0, height/2+3-thick/2, -length/2+thick/2])
    ccube([37.5, thick, length]);
}

//frame_simple(400,100);
//frame_nre_f1();

boxW = 400;
boxL = 400;
boxH = 100;

union() {
    color("red")
    translate([0,boxL-thick,0])
    rotate([90,0,0])
    frame_nre_f1();

    rotate([90,0,0])
    frame_nre_f1();

    color("blue")
    translate([-boxW/2+thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_simple(boxL,boxH,inv=true);

    color("blue")
    translate([boxW/2-thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame_simple(boxL,boxH,inv=true);
    
    color("green")
    rotate([90,0,0])
    track_single(boxH, boxL);
}

projection()
{
    gap = 2;
    translate([0,-boxH,0]) frame_nre_f1();
    translate([boxW+gap,-boxH]) frame_nre_f1();
    translate([0,-2*boxH-gap,0]) frame_simple(boxL,boxH,inv=true);
    translate([boxL+gap,-2*boxH-gap,0]) frame_simple(boxL,boxH,inv=true);
}

