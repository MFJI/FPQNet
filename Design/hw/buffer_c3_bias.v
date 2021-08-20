`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 15:05:03
// Design Name: 
// Module Name: buffer_c3_bias
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


module buffer_c3_bias#(
	parameter		 WD = 8,
	parameter		 NW = 16
)(
	input	wire		 i_sclk,
	input	wire		 i_rstn,
	
	input   wire[WD-1:0]    c3_bias_data,
        input   wire            c3_bias_en,
	
	output	reg [WD-1:0]	o_b1,
	output	reg [WD-1:0]	o_b2,
	output	reg [WD-1:0]	o_b3,
	output	reg [WD-1:0]	o_b4,
	output	reg [WD-1:0]	o_b5,
	output	reg [WD-1:0]	o_b6,
	output	reg [WD-1:0]	o_b7,
	output	reg [WD-1:0]	o_b8,
	output	reg [WD-1:0]	o_b9,
	output	reg [WD-1:0]	o_b10,
	output	reg [WD-1:0]	o_b11,
	output	reg [WD-1:0]	o_b12,
	output	reg [WD-1:0]	o_b13,
	output	reg [WD-1:0]	o_b14,
	output	reg [WD-1:0]	o_b15,
	output	reg [WD-1:0]	o_b16
);

//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg [4:0]	rd_cnt;

reg             c3_bias_en_a;
reg             c3_bias_en_b;
reg [WD-1:0]    c3_bias_data_a;
reg [WD-1:0]    c3_bias_data_b;

//------------------------------------------//
//					CODE					//
//------------------------------------------//

always@(posedge i_sclk)
  begin
    c3_bias_en_a <= c3_bias_en;
    c3_bias_en_b <= c3_bias_en_a;
    c3_bias_data_a <= c3_bias_data;
    c3_bias_data_b <= c3_bias_data_a;
  end

always @(posedge i_sclk)
  if(!i_rstn)
    rd_cnt <= 'd0;
  else
  begin
	if(c3_bias_en_a)	
	  rd_cnt <= rd_cnt + 'd1;
	else
    begin	
	  if(rd_cnt=='d16)
	    rd_cnt <= 'd0;
	  else
	    rd_cnt <= rd_cnt;
	end
  end

always @(posedge i_sclk)
	if(!i_rstn)
	begin
		o_b1  <= 'd0;
		o_b2  <= 'd0;
		o_b3  <= 'd0;
		o_b4  <= 'd0;
		o_b5  <= 'd0;
		o_b6  <= 'd0;
		o_b7  <= 'd0;
		o_b8  <= 'd0;
		o_b9  <= 'd0;
		o_b10 <= 'd0;
		o_b11 <= 'd0;
		o_b12 <= 'd0;
		o_b13 <= 'd0;
		o_b14 <= 'd0;
		o_b15 <= 'd0;
		o_b16 <= 'd0;
	end
	else
	begin
		case (rd_cnt)
		1 :		o_b1  <= c3_bias_data_b;
		2 :     o_b2  <= c3_bias_data_b;
		3 :     o_b3  <= c3_bias_data_b;
		4 :     o_b4  <= c3_bias_data_b;
		5 :     o_b5  <= c3_bias_data_b;
		6 :     o_b6  <= c3_bias_data_b;
		7 :	o_b7  <= c3_bias_data_b;
		8 :     o_b8  <= c3_bias_data_b;
		9 :     o_b9  <= c3_bias_data_b;
		10:     o_b10 <= c3_bias_data_b;
		11:     o_b11 <= c3_bias_data_b;
		12:     o_b12 <= c3_bias_data_b;
		13:     o_b13 <= c3_bias_data_b;
		14:     o_b14 <= c3_bias_data_b;
		15:     o_b15 <= c3_bias_data_b;
		16:     o_b16 <= c3_bias_data_b;
		endcase
	end

endmodule
