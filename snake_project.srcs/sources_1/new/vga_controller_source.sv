`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2016 08:36:29 PM
// Design Name: 
// Module Name: vga_controller_source
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

`include "vga_controller_header.vh"

module vga_controller_module #(
    vga::config_type config_ = vga::possible_configs[vga::_800x600])(
    output logic horizontal_synch,
    output logic vertical_synch,
    vga_driver_interface.slave vga_inter);
     
localparam vga::dimension_type config_hori = config_.horizontal;
localparam vga::dimension_type config_vert = config_.vertical;
localparam integer COL_PERIOD = compute_period(config_hori);
localparam integer ROW_PERIOD = compute_period(config_vert);
    
always @(posedge vga_inter.pixel_clock or negedge vga_inter.low_reset)
    if (!vga_inter.low_reset) begin
        horizontal_synch = 0;
        vertical_synch = 0;
        vga_inter.counters.col = 0;
        vga_inter.counters.row = 0;
        vga_inter.displaying_flag = 0;
    end else begin
    
        // drive display flag
        if ((vga_inter.counters.col < (config_hori.width)) &&
            (vga_inter.counters.row < (config_vert.width))) begin
            vga_inter.displaying_flag = 1;
        end else begin
            vga_inter.displaying_flag = 0;
        end
    
        // drive vga synchronization signals
        horizontal_synch = drive_synch_signal(vga_inter.counters.col,config_hori);
        vertical_synch = drive_synch_signal(vga_inter.counters.row,config_vert);
        
        // drive counters
        if (vga_inter.counters.col != (COL_PERIOD-1)) begin
            vga_inter.counters.col++;
        end else begin
            vga_inter.counters.col = 0;
            if (vga_inter.counters.row != (ROW_PERIOD-1)) begin
                vga_inter.counters.row++;
            end else begin
                vga_inter.counters.row = 0;
            end
        end
        
    end
    
function integer compute_period;
    input vga::dimension_type dim;
begin
    compute_period = dim.synch + dim.back_porch + dim.width + dim.front_porch;
end
endfunction
    
function logic drive_synch_signal;
    input integer counter;
    input vga::dimension_type dim;
begin
    if ((counter < (dim.width + dim.front_porch)) || 
        (counter > (dim.width + dim.front_porch + dim.synch))) begin
        drive_synch_signal = !dim.polarity;
    end else begin
        drive_synch_signal = dim.polarity;
    end 
end
endfunction
    
endmodule
