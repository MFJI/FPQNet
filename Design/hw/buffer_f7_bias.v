`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/12 17:52:29
// Design Name: 
// Module Name: buffer_f7_bias
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


module buffer_f7_bias#(
	parameter			WD  = 8,
	parameter			NUM = 10
)(
	input	wire			i_sclk,
	input	wire			i_rstn,
	
	input   wire[WD-1:0]          f7_bias_data,
        input   wire                  f7_bias_en,
	
	output	wire			o_b_en,
	output	wire[7:0]		o_b_num,
	output	wire[WD-1:0]	        o_bias
);

//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg [7:0]		cnt_nw;

//------------------------------------------//
//					CODE					//
//------------------------------------------//

always @(posedge i_sclk)
  if(!i_rstn)
    cnt_nw <= 'd0;
  else
  begin
	if(f7_bias_en)
	begin
		if(cnt_nw==NUM-1)	cnt_nw <= 'd0;
		else				cnt_nw <= cnt_nw + 'd1;
	end
	else					
	begin
		if(cnt_nw==NUM-1)	cnt_nw <= 'd0;
		else				cnt_nw <= cnt_nw;
	end
  end

assign o_b_en = f7_bias_en;
assign o_b_num = cnt_nw + 'd1;
assign o_bias = f7_bias_data;


endmodule
