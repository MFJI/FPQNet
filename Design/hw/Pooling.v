`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 13:29:55
// Design Name: 
// Module Name: LeNet_Pooling
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


module LeNet_Pooling#(
	parameter					WD   = 1,
	parameter					SIZE = 12
)(	
	input	wire					i_sclk,
	input	wire					i_rstn,
	
	input	wire					i_vsync,
	input	wire					i_hsync,
	input	wire					i_valid,
	input	wire[WD-1:0]			        i_tdata,
	
	output	wire					o_vsync,
	output	reg 					o_hsync,
	output	reg 					o_valid,
	output	wire[WD+1:0]				o_tdata
);


wire			mp_hsync;
wire			mp_range;
wire			mp_valid;
wire[WD+1:0]		mp_tdata;

Mean_Pooling#(
	.WD			(WD)
)Mean_Pooling_inst(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata),
	
	.o_vsync		(o_vsync),
	.o_hsync		(mp_hsync),
	.o_range		(mp_range),
	.o_valid		(mp_valid),
	.o_tdata		(mp_tdata)
);


reg 				wr_en;
reg [7:0]			wr_cnt;
reg [WD+1:0]			wr_data;
reg 				rd_en;
reg [7:0]			rd_cnt;


always@(posedge i_sclk)	wr_en <= mp_valid;

always@(posedge i_sclk)
       if(!i_rstn)            wr_data <= 'd0;
       else
       begin
	  if(mp_valid)		wr_data <= mp_tdata;
	  else                 wr_data <= wr_data;
       end

always@(posedge i_sclk)
	if(!i_rstn)				wr_cnt <= 'd1;
	else
	begin
	  if(wr_en)	
	  begin
	    if(wr_cnt==SIZE)			wr_cnt <= 'd1;
	    else				wr_cnt <= wr_cnt + 'd1;
	  end
	  else                                wr_cnt <= wr_cnt;
	end
	
always@(posedge i_sclk)
	if(!i_rstn)				rd_en <= 'd0;
	else 
	begin
	  if(rd_cnt==SIZE)			rd_en <= 'd0;
	  else 
	  begin
	    if(wr_cnt>(SIZE>>1)+1)		rd_en <= 'd1;
	    else                               rd_en <= rd_en;
	  end
	end     

always@(posedge i_sclk)
       if(!i_rstn)     rd_cnt <= 'd1;
       else
       begin
	  if(rd_en)	rd_cnt <= rd_cnt + 'd1;
	  else		rd_cnt <= 'd1;
       end

fifo_3b_16d fifo_3b_16d_S2(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(wr_data),      // input wire [2 : 0] din
  .wr_en(wr_en),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(o_tdata),    // output wire [2 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);

always@(posedge i_sclk)	o_hsync <= mp_hsync;
always@(posedge i_sclk)	o_valid <= rd_en;


endmodule
