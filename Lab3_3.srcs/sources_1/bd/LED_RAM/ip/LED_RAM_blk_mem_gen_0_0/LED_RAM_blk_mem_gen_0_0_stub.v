// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Fri Mar 15 12:31:02 2019
// Host        : jacoboffersen running 64-bit Ubuntu 18.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jacoboffersen/Repos/Lab3_3/Lab3_3.srcs/sources_1/bd/LED_RAM/ip/LED_RAM_blk_mem_gen_0_0/LED_RAM_blk_mem_gen_0_0_stub.v
// Design      : LED_RAM_blk_mem_gen_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module LED_RAM_blk_mem_gen_0_0(clka, rsta, wea, addra, dina, douta, clkb, web, addrb, 
  dinb, doutb, rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,wea[3:0],addra[31:0],dina[31:0],douta[31:0],clkb,web[3:0],addrb[31:0],dinb[31:0],doutb[31:0],rsta_busy,rstb_busy" */;
  input clka;
  input rsta;
  input [3:0]wea;
  input [31:0]addra;
  input [31:0]dina;
  output [31:0]douta;
  input clkb;
  input [3:0]web;
  input [31:0]addrb;
  input [31:0]dinb;
  output [31:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule
