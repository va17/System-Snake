// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Sun Mar 06 20:05:51 2016
// Host        : idea-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Xilinx/Projects/snake_project/snake_project.srcs/sources_1/ip/clk_wiz_pixel/clk_wiz_pixel_stub.v
// Design      : clk_wiz_pixel
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_pixel(clk_in1, clk_out1, resetn)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,clk_out1,resetn" */;
  input clk_in1;
  output clk_out1;
  input resetn;
endmodule
