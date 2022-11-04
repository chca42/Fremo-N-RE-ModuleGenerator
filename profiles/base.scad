
eps = .01;
thick = 6;
lasRad = .0;
lasWid = 2*lasRad;
cutWid = 0.3; // retract finger depth to avoid poking out
trackTh = 33;
edgeSup = 60;

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

module fingerHcut(H, selfT=thick, otherT=thick)
{
    ccube([cutWid*2, H+eps, selfT+eps]);
}

module fingerV(W, N, selfT=thick, otherT=thick, inv=false)
{
    // TODO: implement without rotate (many side-effects)
    translate([0, otherT, 0])
    rotate([0,0,-90])
    fingerH(W,N,selfT,otherT,inv);
}

module fingerVcut(W, selfT=thick, otherT=thick)
{
    //translate([0,otherT,0])
    ccube([W+eps, cutWid*2, selfT+eps]);
}

module track_single(height, width, length)
{
    translate([0, height/2+3-thick/2, -length/2+thick/2])
    difference()
    {
        ccube([width, thick, length]);

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
        
        translate([-thick,0,0])
        fingerH(trackTh, 1, otherT=thick*2);
        translate([-length/2-thick,0,0])
        fingerH(trackTh, 1, otherT=thick*3);
        translate([length/2-thick*2,0,0])
        fingerH(trackTh, 1, otherT=thick*3);
        
        yoffs(+trackTh/2-thick+2*eps) // TODO: rotate requires -thick
        fingerV(length, 30);
        yoffs(+trackTh/2+2*eps) // TODO: remove when rotate removed
        fingerVcut(length);
    }
}

module frame(width, height, inv=false, N=4, otherT=thick)
{
    difference()
    {
        union()
        children();
        
        xoffs(-width/2)
        {
            fingerH(height, N, otherT=otherT, inv=inv);
            fingerHcut(height);
        }

        rotate([0,180,0])
        xoffs(-width/2)
        {
            fingerH(height, N, otherT=otherT, inv=inv);
            fingerHcut(height);
        }
    }
}


module frame_side(width, height, sH, inv=false)
{
    difference()
    {
        frame(width, height, inv, otherT=thick*2)
        ccube([width,height,thick]);
        
        translate([0,-(height-sH)/2,thick/2])
        rotate([0,90,0])
        fingerH(sH, 4, selfT=thick*2, otherT=thick*2, inv=true);
        
        for(i=[-1:2:1])
        translate([i*(-width/2+edgeSup/2+thick),edgeSupOffs,-thick/2])
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

module edge_support()
{
    l = edgeSup;
    difference()
    {
        translate([-l/2,-l/2,-thick/2])
        linear_extrude(thick)
        polygon([[0,0],[l,0],[l,10],[10,l],[0,l]]);
        
        xoffs(-l/2) yoffs(thick)
        {
            fingerH(l, 4, otherT=2*thick, inv=false);
            fingerHcut(l);
        }
        
        yoffs(-l/2) xoffs(thick)
        {
            fingerV(l, 4, otherT=2*thick, inv=false);
            fingerVcut(l, otherT=2*thick);
        }
    }
}
