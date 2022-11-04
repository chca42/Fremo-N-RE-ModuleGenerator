
module track_rolloff(h,tw)
{
    th = 3;
    x = th/2/(sqrt(2)-1);
    cr = sqrt(2)*th/2/(sqrt(2)-1);
    translate([0,h/2,0])
    {
        translate([0,th/2,0]) square([tw,th],true);
        translate([tw/2,0,0])
        {
            translate([0,th/2-x,0]) circle(cr, $fn=32);
            difference()
            {
                square([2*x,th/2],false);
                translate([2*x,th/2+x,0]) circle(cr, $fn=32);
            }
        }
    }
}

module frame_profile_base(w,h,tw)
{
    translate([w/2,h/2,0])
    difference()
    {
        union()
        {
            square([w,h],true);
            track_rolloff(h,tw);
            mirror([-1,0,0]) track_rolloff(h,tw);
        }
        translate([-120,0,0]) circle(5);
        translate([120,0,0]) circle(5);
        square([100,40],true);
        translate([-50,0,0]) circle(20);
        translate([50,0,0]) circle(20);
    }
}

module frame_profile_intermediate(w,h,sH,tw)
{
    rollW = 7;
    depth = h-sH;
    translate([w/2,h/2,0])
    difference()
    {
        union()
        {
            square([w,h],true);
            track_rolloff(h,tw);
            mirror([-1,0,0]) track_rolloff(h,tw);
        }
        translate([-w/2,h/2-depth,0])
        square([(w-tw-rollW*2)/2,depth],false);
        translate([tw/2+rollW,h/2-depth,0])
        square([(w-tw-rollW*2)/2,depth],false);
    }
}


module frame_nre_f1(w, h, sH, tw)
{
    difference()
    {
        frame(w, h, otherT=thick*2)
        translate([-w/2,-h/2,-thick/2])
        linear_extrude(thick)
        frame_profile_base(w,h,tw);
        
        track_single(h, tw, thick);

        // finger for track t support
        translate([-thick/2,h/2-trackTh/2+thick/2,0])
        fingerH(trackTh, 1, otherT=thick, inv=true);
        
        for(i=[-1:2:1])
        translate([i*(-w/2+thick+edgeSup/2),edgeSupOffs,-thick/2])
        rotate([90,0,0])
        fingerV(edgeSup, 4, otherT=thick, inv=true);

    }
}

module frame_nre_f1_intermediate_B(w, h, sH, tw, otherT=thick*2)
{
    difference()
    {
        translate([0,-(h-sH)/2,0])
        frame(w,sH, otherT=otherT)
        translate([-w/2,-sH/2,-thick/2])
        linear_extrude(thick)
        //import("profiles/n-re-f1-intermediate.svg");
        frame_profile_intermediate(w,h,sH,tw);
        
        track_single(h, trackW, thick);
        
        // finger for track t support
        translate([-thick/2,h/2-trackTh/2+thick/2,0])
        fingerH(33, 1, otherT=thick, inv=true);

        yoffs(-h/2+sH-thick)
        fingerV(w, 2);
       
        for(i=[-1:1:1])
        translate([i*w/3,-(h-sH)/2,-thick/2-eps])
        cylinder(thick+2*eps, r=15);
    }
}