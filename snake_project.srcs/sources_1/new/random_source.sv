`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2016 10:33:28 PM
// Design Name: 
// Module Name: random_source
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

`include "random_header.vh"

module lfsr16_module(
    input logic clock,
    input logic low_reset,
    axi4s.master data_out);
    
localparam type word = lfsr16::WORD;
word taps = 'hB400;
word start_seed = 'hACE1;
word lfsr = start_seed;
    
always @(posedge clock or negedge low_reset)
    if (!low_reset) begin
        lfsr = start_seed;
        data_out.master_reset();
    end else begin
        data_out.master_send(lfsr);
        if (lfsr[0]) begin
            lfsr ^= taps;
        end
        lfsr >>= 1;
    end
    

endmodule

module divide_by_constant #(integer DIVISOR=10,type DIVIDER_TYPE = logic [15:0])(
    input logic clock,
    input logic low_reset,
    axi4s.slave dividend_intf,
    axi4s.master quotient_intf);
    
enum {CS_GET_DIVIDEND,CS_PERFORM_DIVISION,CS_SEND_QUOTIENT} current_state;
DIVIDER_TYPE dividend_buff;
quotient#(DIVIDER_TYPE)::quotient_type quotient_buff;
    
always @(posedge clock or negedge low_reset)
    if (!low_reset) begin
        current_state = CS_GET_DIVIDEND;
        dividend_intf.slave_reset();
        quotient_intf.master_reset();
        dividend_buff = 0;
        quotient_buff = 0;
    end else
        case (current_state)
        CS_GET_DIVIDEND:
            begin
                if (dividend_intf.slave_receive(dividend_buff)) begin
                    quotient_buff = 0;
                    current_state = CS_PERFORM_DIVISION;
                end
            end
        CS_PERFORM_DIVISION:
            begin
                if (dividend_buff<DIVISOR) begin
                    quotient_buff.remainder = dividend_buff;
                    current_state = CS_SEND_QUOTIENT;
                end else begin
                    quotient_buff.quotient++;
                    dividend_buff -= DIVISOR;
                end
            end
        CS_SEND_QUOTIENT:
            begin
                if (quotient_intf.master_send(quotient_buff)) begin
                    current_state = CS_GET_DIVIDEND;
                end
            end
        endcase
    
endmodule
