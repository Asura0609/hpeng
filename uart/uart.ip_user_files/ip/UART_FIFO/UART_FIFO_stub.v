// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Jul 16 15:58:19 2023
// Host        : DESKTOP-KSIUFRU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Study/Xlinx/FPGA/uart/uart.srcs/sources_1/ip/UART_FIFO/UART_FIFO_stub.v
// Design      : UART_FIFO
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50fgga484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1" *)
module UART_FIFO(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty" */;
  input clk;
  input srst;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [7:0]dout;
  output full;
  output empty;
endmodule
