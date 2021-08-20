`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 13:12:06
// Design Name: 
// Module Name: buffer_c1_bias
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


module buffer_c1_bias#(
	parameter				WD = 8,
	parameter				NW = 6
)(
	input	wire			i_sclk,
	input	wire			i_rstn,
	
	input   wire[WD-1:0]    c1_bias_data,
        input   wire            c1_bias_en,            
	
	output	reg [WD-1:0]	o_b1,
	output	reg [WD-1:0]	o_b2,
	output	reg [WD-1:0]	o_b3,
	output	reg [WD-1:0]	o_b4,
	output	reg [WD-1:0]	o_b5,
	output	reg [WD-1:0]	o_b6
);

//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//
reg [2:0]		rd_cnt;

reg             c1_bias_en_a;
reg             c1_bias_en_b;
reg[WD-1:0]     c1_bias_data_a;
reg[WD-1:0]     c1_bias_data_b;



//------------------------------------------//
//					CODE					//
//------------------------------------------//

always@(posedge i_sclk)
begin
c1_bias_en_a <= c1_bias_en;
c1_bias_en_b <= c1_bias_en_a;
c1_bias_data_a <= c1_bias_data;
c1_bias_data_b <= c1_bias_data_a;
end

always @(posedge i_sclk)
  if(!i_rstn)
    rd_cnt <= 'd0;
  else
    begin
	  if(c1_bias_en_a)	
	    rd_cnt <= rd_cnt + 'd1;
	  else	
	    begin
          if(rd_cnt==6)	  
	        rd_cnt <= 'd0;
		  else
		    rd_cnt <= rd_cnt;
		end
	end

always @(posedge i_sclk)
	if(!i_rstn)
	begin
		o_b1 <= 'd0;
		o_b2 <= 'd0;
		o_b3 <= 'd0;
		o_b4 <= 'd0;
		o_b5 <= 'd0;
		o_b6 <= 'd0;
	end
	else
	begin
		case (rd_cnt)
		1 :		o_b1 <= c1_bias_data_b;
		2 :     o_b2 <= c1_bias_data_b;
		3 :     o_b3 <= c1_bias_data_b;
		4 :     o_b4 <= c1_bias_data_b;
		5 :     o_b5 <= c1_bias_data_b;
		6 :     o_b6 <= c1_bias_data_b;
		endcase
	end

endmodule
