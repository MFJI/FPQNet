`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/12 17:33:50
// Design Name: 
// Module Name: buffer_f6_weight
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


module buffer_f6_weight#(
	parameter			WD  = 8,
	parameter			NW  = 120,
	parameter			NUM = 84
)(
	input	wire			i_sclk,
	input	wire			i_rstn,
	
	input   wire[WD-1:0]           f6_weight_data,
        input   wire                  f6_weight_en,
	
	output	wire			o_w_en,
	output	wire[7:0]		o_w_num,
	output	wire[WD-1:0]	        o_weight,
	output	wire[7:0]		o_w_addr
);

//------------------------------------------//
//					PARAM					//
//------------------------------------------//
parameter	PARA_NUM = NW*NUM;
//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg [7:0]		cnt_nw;
reg [7:0]		cnt_num;

//------------------------------------------//
//					CODE					//
//------------------------------------------//

always @(posedge i_sclk)
  if(!i_rstn)
    cnt_nw <= 'd0;
  else
  begin
	if(f6_weight_en)
	begin
		if(cnt_nw==NW-1)	cnt_nw <= 'd0;
		else				cnt_nw <= cnt_nw + 'd1;
	end
	else
	begin
		if(cnt_nw==NW-1)	cnt_nw <= 'd0;
		else				cnt_nw <= cnt_nw;
	end
  end

always @(posedge i_sclk)
  if(!i_rstn)
    cnt_num <= 'd1;
  else
  begin
	if(f6_weight_en)
	begin
		if(cnt_nw==NW-1)
		begin
			if(cnt_num==NUM)	cnt_num <= 'd1;
			else				cnt_num <= cnt_num + 'd1;
		end
	end
	else						
	begin
	  if(cnt_num==NUM)	cnt_num <= 'd1;
	  else				cnt_num <= cnt_num;
	end
  end

assign o_w_en = f6_weight_en;
assign o_w_num = cnt_num;
assign o_weight = f6_weight_data;
assign o_w_addr = cnt_nw;

endmodule
