`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 13:31:35
// Design Name: 
// Module Name: Mean_Pooling
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: mat_pool = [1 1
//							1 1]/4;
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mean_Pooling#(
	parameter					WD = 1
)(
	input	wire					i_sclk,
	input	wire					i_rstn,
	
	input	wire					i_vsync,
	input	wire					i_hsync,
	input	wire					i_valid,
	input	wire[WD-1:0]				i_tdata,
	
	output	reg 					o_vsync,
	output	reg 					o_hsync,
	output	reg 					o_range,
	output	reg 					o_valid,
	output	reg [WD+1:0]				o_tdata
);

//------------------------------//
//			SIGNALS				//
//------------------------------//
reg [7:0]	cnt_rows;

reg [WD-1:0]	dat_1;
reg 		wr_en_1;
wire		rd_en_1;
wire[WD-1:0]	dat_2;

reg [WD-1:0]	dat_1_d1;
reg [WD-1:0]	dat_2_d1;

reg [2:0]	sum_flag;
reg 		step_r,step_c;
reg [WD:0]	sum_1,sum_2;
reg [WD+2:0]	sum_2x2;
//------------------------------//
//			COUNT				//
//------------------------------//
always@(posedge i_sclk)
        if(!i_rstn)
        begin
          cnt_rows <= 'd0;
        end 
        else
        begin
	  if(i_vsync)		cnt_rows <= 'd0;
	  else 
	    begin
	      if(i_hsync)	cnt_rows <= cnt_rows + 'd1;
	      else             cnt_rows <= cnt_rows;
	    end
	end
//------------------------------//
//			PIPELINE			//
//------------------------------//
always@(posedge i_sclk)	wr_en_1 <= i_valid;
always@(posedge i_sclk)	dat_1 <= i_tdata;

assign rd_en_1 = cnt_rows>1 ? i_valid:'d0;

fifo_1b_32d fifo_1b_32d_r1(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(dat_1),      // input wire [0 : 0] din
  .wr_en(wr_en_1),  // input wire wr_en
  .rd_en(rd_en_1),  // input wire rd_en
  .dout(dat_2),    // output wire [0 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
//------------------------------//
//			Pooling				//
//------------------------------//
always@(posedge i_sclk)
	if(!i_rstn)	sum_flag <= 'd0;
	else		sum_flag <= {sum_flag[1:0],rd_en_1};

always@(posedge i_sclk)	step_r <= !cnt_rows[0]&sum_flag[1];

always@(posedge i_sclk)
	if(step_r)	step_c <= step_c + 'd1;
	else		step_c <= 'd0;

always@(posedge i_sclk)	dat_1_d1 <= dat_1;
always@(posedge i_sclk)	dat_2_d1 <= dat_2;
always@(posedge i_sclk)
        if(!i_rstn)
        begin
		sum_1 <= 'd0;
		sum_2 <= 'd0;
		sum_2x2 <= 'd0;        
        end
        else
        begin
	  if(i_vsync)
	  begin
		sum_1 <= 'd0;
		sum_2 <= 'd0;
		sum_2x2 <= 'd0;
	  end
	  else
	  begin
		sum_1 <= dat_1 + dat_1_d1;
		sum_2 <= dat_2 + dat_2_d1;
		
		sum_2x2 <= (sum_1 + sum_2)<<1;
	  end
	end
//------------------------------//
//			OUTPUTS				//
//------------------------------//
always@(posedge i_sclk)
	if(cnt_rows==0)	o_vsync <= i_hsync;
	else			o_vsync <= 'd0;

always@(posedge i_sclk)
	if(cnt_rows[0])	o_hsync <= i_hsync;
	else			o_hsync <= 'd0;

always@(posedge i_sclk)	o_range <= step_r;
always@(posedge i_sclk)	o_valid <= step_c;
always@(posedge i_sclk)
	if(step_r)
	begin
	  if(step_c)	        o_tdata <= sum_2x2[WD+2:1] + sum_2x2[0];
	  else                 o_tdata <= o_tdata;
	end
	else		        o_tdata <= 'd0;

endmodule
