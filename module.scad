
eps = .01;
thick = 10;
lasRad = .1;
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
    w = width+lasWid;
    h = height+lasWid;
    difference()
    {
        ccube([w,h,thick]);
        
        xoffs(-w/2)
        fingerH(h, inv=inv);
        xoffs(w/2)
        fingerH(h, inv=inv);

    }
}

boxW = 400;
boxL = 400;
boxH = 100;

union() {
    color("red")
    translate([0,boxL-thick,0])
    rotate([90,0,0])
    frame(boxW,boxH);

    rotate([90,0,0])
    frame(boxW,boxH);

    color("blue")
    translate([-boxW/2+thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame(boxW,boxH,inv=true);

    color("blue")
    translate([boxW/2-thick/2,boxL/2-thick/2,0])
    rotate([90,0,90])
    frame(boxW,boxH,inv=true);
}

!projection()
{
    gap = 5;
    translate([0,-boxH,0]) frame(boxW,boxH);
    translate([0,-2*boxH-gap,0]) frame(boxW,boxH,inv=true);
}

