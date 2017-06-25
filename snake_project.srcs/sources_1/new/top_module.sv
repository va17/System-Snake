`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Andrew Powell 
// 
// Create Date: 02/29/2016 07:58:37 PM
// Design Name: system snake
// Module Name: top_module
// Project Name: system snake
// Target Devices: Digilent Nexys 4 DDR (Artix-7)
// Tool Versions: Vivado 2015.3
// Description: This project is the basic implementation of the classic game snake, 
// developed in SystemVerilog for the Digilent Nexys 4 DDR board. The main goal of 
// this project was really to learn SystemVerilog for behavioral synthesis. An 
// attempt was made to make the project as portable as possible, but the Clock Wizard IP
// was needed to generate the precise frequency needed to drive VGA module.
//
// Apart from the target hardware, the project requires a VGA monitor capable of 
// handling 800x600 resolution with a refresh rate of 60 Hz. The controls consist
// of only the directional pushbuttons, so not including the center pushbutton. 
// Please note, in order to trigger a pushbutton, you must press and release the
// pushbutton!
//
// At the start, a white block appears at the center of the screen, signifying the
// snake head. Triggerring any of the four directional pushbuttons causes the game
// to start. The snake head will always start in the up direction. While moving, the
// direction of the snake head can be changed with the directional pushbuttons, 
// although its direction cannot be reversed. Green blocks signify snacks the snake head
// must consume. Each snack consumed causes the snake to grow in size and also increase 
// the score. As certain breakpoints in the score is reached, the snake will begin to move
// faster.
//
// The game is over when the snake head collides with either a snake body or the screen's 
// boundary.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "snake_header.vh"

module top_module(
    input PS2_CLK,
    input PS2_DATA,
    inout logic aud_pwm,
    output logic aud_sd,
    output logic pdm_clk_o,
    input logic pdm_data_i,
    output logic pdm_lrsel_o,
    input logic has_walls,
    input logic is_inverted,
    input logic full_speed,
    input logic raw_clock,
    output logic vga_horizontal_synch,
    output logic vga_vertical_synch,
    output logic [3:0] vga_red,
    output logic [3:0] vga_green,
    output logic [3:0] vga_blue,
    input logic raw_up_pb,
    input logic raw_down_pb,
    input logic raw_left_pb,
    input logic raw_right_pb,
    output logic ssegment_a,
    output logic ssegment_b,
    output logic ssegment_c,
    output logic ssegment_d,
    output logic ssegment_e,
    output logic ssegment_f,
    output logic ssegment_g,
    output logic ssegment_dp,
    output logic [7:0] ssegment_an);
    
logic game_clock,pixel_clock,low_reset;
logic up_key_is_pressed, down_key_is_pressed, left_key_is_pressed, right_key_is_pressed;
snake::board_type game_board;
vga::pixel_type vga_pixel;
snake::score_type score;
snake::ssegment_type ssegment;
snake::anodes_type anode;

reg CLK50MHZ=0;    
wire [31:0]keycode;
logic done_ser;
logic aud_pwm;
logic en_i;
wire en_sound;
wire en_sound_snack;
wire out_snack;

assign low_reset = 1;
assign vga_red = vga_pixel.red[7:4];
assign vga_green = vga_pixel.green[7:4];
assign vga_blue = vga_pixel.blue[7:4];
assign ssegment_a = ssegment.a;
assign ssegment_b = ssegment.b;
assign ssegment_c = ssegment.c;
assign ssegment_d = ssegment.d;
assign ssegment_e = ssegment.e;
assign ssegment_f = ssegment.f;
assign ssegment_g = ssegment.g;
assign ssegment_dp = ssegment.dp;
assign ssegment_an = anode;

vga_driver_interface vga_inter (
    .pixel_clock(pixel_clock),
    .low_reset(low_reset));
    
axi4s #(.WORD(snake::loc_type)) request_interface();
axi4s #(.WORD(lfsr16::WORD)) random_interface();

clk_wiz_pixel clk_wiz_pixel_inst( 
    .clk_in1(raw_clock),
    .clk_out1(pixel_clock),
    .resetn(low_reset)); // 40 MHz
step_down_clock_module #(
    .DESIRED_FREQ(snake::GAME_CLOCK_FREQ),
    .RAW_CLOCK_FREQ(snake::RAW_CLOCK_FREQ))
step_down_clock_inst (
    .raw_clock(raw_clock),
    .low_reset(low_reset),
    .down_clock(game_clock)); // 1 MHz

vga_controller_module #(
    .config_(snake::vga_config))
vga_controller_inst (
    .horizontal_synch(vga_horizontal_synch),
    .vertical_synch(vga_vertical_synch),
    .vga_inter(vga_inter));
    
snake_painter_module snake_painter_inst(
    .board(game_board),
    .vga_pixel(vga_pixel),
    .vga_inter(vga_inter));
    
acquire_random_position acquire_random_position_inst (
    .game_clock(game_clock),
    .low_reset(low_reset),
    .request(request_interface),
    .random(random_interface));
lfsr16_module lfsr16_inst (
    .clock(game_clock),
    .low_reset(low_reset),
    .data_out(random_interface));
    
sample_pushbutton_module #(.WIDTH(4),.SAMPLE_RATE(10000))
sample_pushbutton_inst (
    .raw_clock(raw_clock),
    .game_clock(game_clock),
    .low_reset(low_reset),
    .input_({raw_up_pb,raw_down_pb,raw_left_pb,raw_right_pb}),
    .output_({up_key_is_pressed,down_key_is_pressed,left_key_is_pressed,right_key_is_pressed}));
    
score_module score_inst (
    .raw_clock(raw_clock),
    .low_reset(low_reset),
    .score(score),
    .ssegment(ssegment),
    .anode(anode));

PS2Receiver keyboard (
    .clk(raw_clock),
    .game_clock(game_clock),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .keycodeout(keycode[31:0])
    );
    
pwm_module pwm_out (
        .clk(raw_clock),
        .vcc(aud_sd),
        .ampPWM(aud_pwm),
        .en_sound(en_sound),
        .en_sound_snack(en_sound_snack),
        .out_snack(out_snack));
    
    
    
snake_controller_module snake_controller_inst(
    .game_clock(game_clock),
    .low_reset(low_reset),
    .up_key_is_pressed(up_key_is_pressed),
    .down_key_is_pressed(down_key_is_pressed),
    .left_key_is_pressed(left_key_is_pressed),
    .right_key_is_pressed(right_key_is_pressed),
    .request_interface(request_interface),
    .game_board(game_board),
    .score(score),
    .keycode(keycode[31:0]),
    .has_walls(has_walls),
    .is_inverted(is_inverted),
    .full_speed(full_speed),
    .en_sound(en_sound),
    .en_sound_snack(en_sound_snack),
    .out_snack(out_snack));

endmodule


