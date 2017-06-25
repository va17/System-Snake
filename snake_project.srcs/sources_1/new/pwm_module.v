`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:54:30 10/28/2014 
// Design Name: 
// Module Name:    pwm_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pwm_module( 
    input clk, 
    output ampPWM, 
    output vcc,
    input en_sound,
    input en_sound_snack,
    output out_snack
    ); 

   localparam TCQ = 1; 
   assign vcc = 1'b1; 
    
   reg [31:0] counter2;
   reg [15:0] counter1; 
   reg [15:0] counter; 
   reg ampPWM;
   reg sound_snack;
   //reg en_sound_snack;
   reg out_snack;

    always @(posedge clk) 
     begin 
        if(en_sound_snack == 1 || en_sound == 1) begin
                if(counter2 != 40000000  || en_sound == 1) begin 
                    if(counter == 53628) //rounded half period clck cycle count for desired freq 
                        begin 
                        counter <= 0; 
                        ampPWM <= ~ampPWM; 
                        end 
                    else begin
                        counter <= counter+1; 
                    end
                end
                else if (en_sound_snack == 1 && counter2 != 40000000) begin
                    counter2 <= counter2+1;
                end
                else if (en_sound_snack == 1 && counter2 == 40000000) begin
                    out_snack = 0;
                end
         end
     end 
  
endmodule


