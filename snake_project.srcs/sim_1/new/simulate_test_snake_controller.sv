//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2016 12:30:42 PM
// Design Name: 
// Module Name: simulate_test_snake_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`include "snake_header.vh"

module simulate_test_snake_controller;

localparam integer CLOCK_PERIOD = 10;
//localparam snake::move_period_type MOVE_PERIODS_SAMPLES = snake::MOVE_PERIODS_SAMPLES;

typedef enum {
    UP,DOWN,RIGHT,LEFT
} button_type;

logic game_clock;
logic low_reset;
//snake::board_type game_board;
logic up_key_is_pressed,down_key_is_pressed,left_key_is_pressed,right_key_is_pressed;
logic pbs[4];
assign up_key_is_pressed = pbs[UP];
assign down_key_is_pressed = pbs[DOWN];
assign left_key_is_pressed = pbs[LEFT];
assign right_key_is_pressed = pbs[RIGHT]; 

test_snake_controller dut (
    .game_clock(game_clock),
    .low_reset(low_reset),
    .up_key_is_pressed(up_key_is_pressed),
    .down_key_is_pressed(down_key_is_pressed),
    .left_key_is_pressed(left_key_is_pressed),
    .right_key_is_pressed(right_key_is_pressed));
    
always begin
    game_clock = 1;
    #(CLOCK_PERIOD/2);
    game_clock = 0;
    #(CLOCK_PERIOD/2);
end

initial begin
    low_reset = 0;
    pbs = {0,0,0,0};
    
    repeat (3) #CLOCK_PERIOD;
    
    low_reset = 1;
    repeat (3) #CLOCK_PERIOD;

    press_pb(UP);
    repeat (40) #CLOCK_PERIOD;
    
    press_pb(UP);
    repeat (40) #CLOCK_PERIOD;
    
    repeat (10) #CLOCK_PERIOD;
    $finish;
end

task press_pb(input button_type button);
    pbs[button] = 1;
    #CLOCK_PERIOD;
    pbs[button] = 0;
    #CLOCK_PERIOD;
endtask
    
endmodule
