`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 12:15:15
// Design Name: 
// Module Name: buffer_c1_weight
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


module buffer_c1_weight#(
	parameter				WD  = 8,
	parameter				NW  = 25,
	parameter				NUM = 6
)(
	input	wire			i_sclk,
	input	wire			i_rstn,
	
	
	input   wire[WD-1:0]    c1_weight_data,
        input   wire            c1_weight_en,
	
	output	wire[NUM-1:0]	o_w_en,
	output	wire[WD-1:0]	o_w1,
	output	wire[WD-1:0]	o_w2,
	output	wire[WD-1:0]	o_w3,
	output	wire[WD-1:0]	o_w4,
	output	wire[WD-1:0]	o_w5,
	output	wire[WD-1:0]	o_w6,
	output	wire[4:0]		o_w_addr
);

//------------------------------------------//
//					PARAM					//
//------------------------------------------//
parameter	PARA_NUM = NW*NUM;
//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg [NUM-1:0]		rd_en_s;
reg [4:0]			cnt_nw;
reg                 c1_weight_en_a;
reg                 c1_weight_en_b;
reg [WD-1:0]        c1_weight_data_a;
reg [WD-1:0]        c1_weight_data_b;


//------------------------------------------//
//					CODE					//
//------------------------------------------//


always@(posedge i_sclk)
begin
c1_weight_en_a <= c1_weight_en;
c1_weight_en_b <= c1_weight_en_a;
c1_weight_data_a <= c1_weight_data;
c1_weight_data_b <= c1_weight_data_a;
end

always@(posedge i_sclk)
	if(!i_rstn)				
	  rd_en_s <= 'd0;
	else 
	begin
	  if(c1_weight_en_a)	
	    begin
		  if(rd_en_s == 'd0)
		    rd_en_s <= 'd1;
		  else
		    begin
	          if(cnt_nw==NW-1)	
		        rd_en_s <= rd_en_s<<1;
		    end    
	    end
	   else
	     begin
	       if(cnt_nw==NW-1)
		     rd_en_s <= 'd0;
		   else
		     rd_en_s <= rd_en_s;
		 end
    end
	
always @(posedge i_sclk)
  if(!i_rstn)
    cnt_nw <= 'd0;
  else
  begin
	if(c1_weight_en_b)
	begin
		if(cnt_nw==NW-1)	cnt_nw <= 'd0;
		else				cnt_nw <= cnt_nw + 'd1;
	end
	else					
	  begin
	    if(cnt_nw==NW-1)
	      cnt_nw <= 'd0;
		else
		  cnt_nw <= cnt_nw;
	  end
  end  

assign o_w_en = rd_en_s;

assign o_w1 = rd_en_s[0] ? c1_weight_data_b:'d0;
assign o_w2 = rd_en_s[1] ? c1_weight_data_b:'d0;
assign o_w3 = rd_en_s[2] ? c1_weight_data_b:'d0;
assign o_w4 = rd_en_s[3] ? c1_weight_data_b:'d0;
assign o_w5 = rd_en_s[4] ? c1_weight_data_b:'d0;
assign o_w6 = rd_en_s[5] ? c1_weight_data_b:'d0;

assign o_w_addr = cnt_nw;

endmodule
