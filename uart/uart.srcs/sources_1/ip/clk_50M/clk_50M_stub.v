// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Fri Jul 14 08:50:19 2023
// Host        : DESKTOP-KSIUFRU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Study/Xlinx/FPGA/uart/uart.srcs/sources_1/ip/clk_50M/clk_50M_stub.v
// Design      : clk_50M
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50fgga484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_50M(clk_out1, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,locked,clk_in1" */;
  output clk_out1;
  output locked;
  input clk_in1;
endmodule
