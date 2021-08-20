`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 13:07:08
// Design Name: 
// Module Name: Sigmoid
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


module Sigmoid#(
	parameter				WI = 16,
	parameter				WO = 1
)(
	input	wire				i_sclk,
	input	wire				i_rstn,
	
	input	wire				i_valid,
	input	wire signed[WI-1:0]		i_tdata,
	
	output	reg 				o_valid,
	output	reg [WO-1:0]			o_tdata
);



always@(posedge i_sclk)	o_valid <= i_valid;
always@(posedge i_sclk)
     if(!i_rstn)
     	o_tdata <= 'd0;
     else
	if(i_valid)
	begin
		if(i_tdata<0)	o_tdata <= 'd0;
		else		o_tdata <= 'd1;
	end
	else
	                       o_tdata <= o_tdata;

endmodule
