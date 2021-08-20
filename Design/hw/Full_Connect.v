`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/12 15:23:20
// Design Name: 
// Module Name: LeNet_Full_Connect
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


module LeNet_Full_Connect#(
	parameter					WD = 3,
	parameter					WW = 8
)(		
	input	wire					i_sclk,
	input	wire					i_rstn,
	
	input	wire					i_valid,
	input	wire[WD-1:0]				i_tdata,
	
	input	wire[7:0]				i_channel,
	input	wire					i_W_en,
	input	wire[7:0]				i_W_num,
	input	wire signed[WW-1:0]			i_Weight,
	input	wire[7:0]				i_W_addr,
	input	wire					i_B_en,
	input	wire[7:0]				i_B_num,
	input	wire signed[WW-1:0]			i_Bias,
	
	output	reg 					o_valid,
	output	reg  signed[11+8:0]			o_tdata
);

//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//
reg  signed[WW-1:0]		Bias;

reg 				wr_en;
reg [7:0]			wr_addr;
reg [WW-1:0]			wr_data;

wire				rd_en;
reg [7:0]			rd_addr;
wire signed[WW-1:0]		rd_data;

reg 				valid_d1;
reg [WD-1:0]			tdata_d1;
wire[3:0]			mdata;

reg 				mult_en;
wire signed[11:0]		mult_data;

reg 				sum_en;
reg signed[11+8:0]		sum_data;
reg 				sum_done;

reg                            sum_rst_d;
reg				sum_rst;
//------------------------------------------//
//					CODE					//
//------------------------------------------//
always @(posedge i_sclk)
	if(!i_rstn)				Bias <= 'd0;
	else 
	  if(i_B_en&&i_B_num==i_channel)	Bias <= i_Bias;
	  else					Bias <= Bias;

always @(posedge i_sclk)
	if(i_W_en&&i_W_num==i_channel)
	begin
		wr_en <= i_W_en;
		wr_addr <= i_W_addr;
		wr_data <= i_Weight;
	end
	else
	begin
		wr_en <= 'd0;
		wr_addr <= 'd0;
		wr_data <= 'd0;
	end
	
assign rd_en = i_valid;

always @(posedge i_sclk)
	if(rd_en)	rd_addr <= rd_addr + 'd1;
	else		rd_addr <= 'd0;

always @(posedge i_sclk)
       if(!i_rstn)
       begin
       	valid_d1 <= 'd0;
		tdata_d1 <= 'd0;
		mult_en <= 'd0;
		sum_en <= 'd0;
		sum_done <= 'd0;
		sum_rst_d <= 'd0;
		sum_rst <= 'd0;
       end
       else
	begin
		valid_d1 <= i_valid;
		tdata_d1 <= i_tdata;
		mult_en <= valid_d1;
		sum_en <= mult_en;
		sum_done <= !mult_en&&sum_en;
		sum_rst_d <= sum_done;
		sum_rst <= sum_rst_d;
	end

assign mdata = tdata_d1;

always @(posedge i_sclk)
	if(!i_rstn || sum_rst)		sum_data <= 'd0;
	else 
	  if(mult_en)			sum_data <= sum_data + mult_data;
	  else 
	    if(!mult_en&&sum_en)	sum_data <= sum_data + Bias;
	    else			sum_data <= sum_data;

always @(posedge i_sclk)
	if(!i_rstn)		o_valid <= 'd0;
	else			o_valid <= sum_done;

always @(posedge i_sclk)
	if(!i_rstn)		o_tdata <= 'd0;
	else 
	  if(sum_done)		o_tdata <= sum_data;
	  else			o_tdata <= o_tdata;


ram_8b_256d ram_8b_256d_inst(
  .clka(i_sclk),    // input wire clka
  .ena(wr_en),      // input wire ena
  .wea(wr_en),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [7 : 0] addra
  .dina(wr_data),    // input wire [7 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en),      // input wire enb
  .addrb(rd_addr),  // input wire [7 : 0] addrb
  .doutb(rd_data)  // output wire [7 : 0] doutb
);

mult_8bs_4bs mult_8bs_4bs_inst(
  .CLK(i_sclk),  // input wire CLK
  .A(rd_data),      // input wire [7 : 0] A
  .B(mdata),      // input wire [3 : 0] B
  .P(mult_data)      // output wire [11 : 0] P
);

endmodule
