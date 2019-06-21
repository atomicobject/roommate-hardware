// The corner of the PCB is the reference point for the design at (0, 0, 0)

function in_to_mm(in) = (in * 25.4);

board_length = in_to_mm(4.00);
board_width = in_to_mm(1.85);
board_thickness = in_to_mm(0.064);
common_clearance = in_to_mm(0.030);
board_guide_length = in_to_mm(0.50);
board_guide_width = in_to_mm(0.0625);
board_guide_height = board_thickness * 2;
board_guide_width_with_clearance = board_guide_width + common_clearance;
enclosure_wall_thickness = in_to_mm(0.100);
sides_height = in_to_mm(1);
notch_height = in_to_mm(0.20);
board_bed_height = in_to_mm(0.125);


module draw_connector() {
    // This is used to draw the connector on the board AND to extrude the cutout for it in the side of the enclosure
    connector_width = in_to_mm(0.5);
    connector_height = in_to_mm(0.375);
    translate([in_to_mm(0.95), -10, board_thickness + in_to_mm(0.25)]) {
        cube(size = [connector_width, 20, connector_height]);
    }
}

module draw_board() {
    color("purple") {
        cube([board_width, board_length, board_thickness]);
        draw_connector();
    }
}
//draw_board();

// The platform that that board sits on **************************************************************


module draw_board_bed() {
    board_bed_width = in_to_mm(0.125);
    
    translate([0, 0, -board_bed_height]) {
        linear_extrude(board_bed_height) {
            difference() {
                square([board_width, board_length]);
                translate([board_bed_width, board_bed_width, 0]) {
                    square([board_width - board_bed_width * 2, board_length - board_bed_width * 2]);
                }
            }
        }
    }
}
draw_board_bed();

// The board guides that hold the corners of the board ******************************************
module guide() {
    translate([-board_guide_width_with_clearance, -board_guide_width_with_clearance, -board_bed_height]) {
        cube([board_guide_width, board_guide_length, board_guide_height + board_bed_height]);
        cube([board_guide_length, board_guide_width, board_guide_height+ board_bed_height]);
    }
}

module draw_guides() {
guide();
    translate([board_width, board_length, 0]) {
        rotate([0, 0, 180]) {
            guide();
        }
    }
}
draw_guides();

// Outer Shell Bottom **************************************************************************
module draw_outer_shell_bottom() {
    translate([-board_guide_width_with_clearance, -board_guide_width_with_clearance, - (board_bed_height + enclosure_wall_thickness)]) {
        cube([board_width + (board_guide_width_with_clearance * 2), board_length + (board_guide_width_with_clearance * 2), enclosure_wall_thickness]);
    }
}
draw_outer_shell_bottom();

// Outer Shell Sides **************************************************************************

module outer_shell_2d() {
    difference() {
        offset(r = in_to_mm(.20)) {
            square([board_width + (board_guide_width_with_clearance * 2), board_length + (board_guide_width_with_clearance * 2)]);
        }
        square([board_width + (board_guide_width_with_clearance * 2), board_length + (board_guide_width_with_clearance * 2)]);
    }
}

module draw_outer_shell_sides() {
    difference() {
        translate([-board_guide_width_with_clearance, -board_guide_width_with_clearance, - (board_bed_height + enclosure_wall_thickness)]) {
            linear_extrude(sides_height) {
                outer_shell_2d();
            }
        }
        draw_connector();
    }
}
draw_outer_shell_sides();

// Lid notch **************************************************************************
starting_y = sides_height - board_bed_height - enclosure_wall_thickness;
translate([-board_guide_width_with_clearance, -board_guide_width_with_clearance, starting_y]) {
    linear_extrude(notch_height) {
        difference() {
            offset(r = in_to_mm(0.1)) {
                square([board_width + (board_guide_width_with_clearance * 2), board_length + (board_guide_width_with_clearance * 2)]);
            }
            square([board_width + (board_guide_width_with_clearance * 2), board_length + (board_guide_width_with_clearance * 2)]);
        }
    }
}

