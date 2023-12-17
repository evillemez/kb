function board_extrude_1_outline_fn(){
    return new CSG.Path2D([[145.9128116,-91.5934024],[75.1599828,-74.607151]]).appendArc([72.7483522,-76.085],{"radius":2,"clockwise":false,"large":false}).appendPoint([60.4000628,-127.5193272]).appendArc([60.9135212,-129.3831552],{"radius":2,"clockwise":false,"large":false}).appendPoint([82.0222817,-151.0108839]).appendArc([82.9925543,-151.5600893],{"radius":2,"clockwise":false,"large":false}).appendPoint([134.8394513,-163.8417541]).appendArc([135.5566389,-164.1717738],{"radius":2,"clockwise":true,"large":false}).appendPoint([171.2228274,-190.1733719]).appendArc([172.4010239,-190.557249],{"radius":2,"clockwise":false,"large":false}).appendPoint([219.9985775,-190.557249]).appendArc([221.1767739,-190.1733719],{"radius":2,"clockwise":false,"large":false}).appendPoint([256.8429624,-164.1717738]).appendArc([257.5601501,-163.8417541],{"radius":2,"clockwise":true,"large":false}).appendPoint([309.4070471,-151.5600893]).appendArc([310.3773197,-151.0108839],{"radius":2,"clockwise":false,"large":false}).appendPoint([331.4860802,-129.3831552]).appendArc([331.9995386,-127.5193272],{"radius":2,"clockwise":false,"large":false}).appendPoint([319.6512492,-76.085]).appendArc([317.2396186,-74.607151],{"radius":2,"clockwise":false,"large":false}).appendPoint([246.4867898,-91.5934024]).appendArc([246.019899,-91.6486626],{"radius":2,"clockwise":true,"large":false}).appendPoint([146.3797024,-91.6486626]).appendArc([145.9128116,-91.5934024],{"radius":2,"clockwise":true,"large":false}).close().innerToCAG()
.extrude({ offset: [0, 0, 1] });
}




                function bottom_case_fn() {
                    

                // creating part 0 of case bottom
                let bottom__part_0 = board_extrude_1_outline_fn();

                // make sure that rotations are relative
                let bottom__part_0_bounds = bottom__part_0.getBounds();
                let bottom__part_0_x = bottom__part_0_bounds[0].x + (bottom__part_0_bounds[1].x - bottom__part_0_bounds[0].x) / 2
                let bottom__part_0_y = bottom__part_0_bounds[0].y + (bottom__part_0_bounds[1].y - bottom__part_0_bounds[0].y) / 2
                bottom__part_0 = translate([-bottom__part_0_x, -bottom__part_0_y, 0], bottom__part_0);
                bottom__part_0 = rotate([0,0,0], bottom__part_0);
                bottom__part_0 = translate([bottom__part_0_x, bottom__part_0_y, 0], bottom__part_0);

                bottom__part_0 = translate([0,0,0], bottom__part_0);
                let result = bottom__part_0;
                
            
                    return result;
                }
            
            
        
            function main() {
                return bottom_case_fn();
            }

        