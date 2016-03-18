
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2016 12:48:36 PM
// Design Name: 
// Module Name: simulate_score_module
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

module simulate_score_module;

localparam integer CLOCK_PERIOD = 10;

logic raw_clock,low_reset;
snake::score_type score;

score_module score_inst (
    .raw_clock(raw_clock),
    .low_reset(low_reset),
    .score(score));
    
always begin
    raw_clock = 1;
    #(CLOCK_PERIOD/2);
    raw_clock = 0;
    #(CLOCK_PERIOD/2);
end

initial begin
    low_reset = 0;
    score = 0;
    repeat (4) #CLOCK_PERIOD;
    
    low_reset = 1;
    score = 15;
    repeat (100) #CLOCK_PERIOD;
    
    low_reset = 1;
    score = 976;
    repeat (100) #CLOCK_PERIOD;
    $finish;
end
    
endmodule
