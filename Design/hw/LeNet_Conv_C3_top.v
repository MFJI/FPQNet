`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 17:10:31
// Design Name: 
// Module Name: LeNet_Conv_C3_top
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


module LeNet_Conv_C3_top#(
	parameter				WD = 3,
	parameter				WW = 8,
	parameter				GP = 6
)(		
	input	wire				i_sclk,
	input	wire				i_rstn,
	
	input	wire				i_vsync,
	input	wire				i_hsync,
	input	wire				i_valid,
	input	wire[WD-1:0]			i_tdata_1,
	input	wire[WD-1:0]			i_tdata_2,
	input	wire[WD-1:0]			i_tdata_3,
	input	wire[WD-1:0]			i_tdata_4,
	input	wire[WD-1:0]			i_tdata_5,
	input	wire[WD-1:0]			i_tdata_6,
	
	input	wire[GP-1:0]			i_W_en,
	input	wire[WW-1:0]			i_Weight_1,
	input	wire[WW-1:0]			i_Weight_2,
	input	wire[WW-1:0]			i_Weight_3,
	input	wire[WW-1:0]			i_Weight_4,
	input	wire[WW-1:0]			i_Weight_5,
	input	wire[WW-1:0]			i_Weight_6,
	input	wire[4:0]			i_W_addr,
	input	wire signed[WW-1:0]		i_Bias,
	
	output	wire				o_hsync,
	output	wire				o_valid,
	output	wire				o_tdata
);

wire					C3_hsync;
wire					C3_valid;
wire signed[WD+WW+5:0]			C3_tdata[5:0];

reg  signed[WD+WW+8:0]			sum_1,sum_2;
reg 					sum_en;
reg 					C3_dat_en;
reg  signed[WD+WW+8:0]			C3_dat;

wire		C3_sigm_dat_en;
wire		C3_sigm_dat;


assign o_hsync = C3_hsync;
assign o_valid = C3_sigm_dat_en;
assign o_tdata = C3_sigm_dat;

//------------------------------------------------------------//
//				卷积C3:  6层卷积结果求和加Bias				  //
//------------------------------------------------------------//

LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_1(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_1),

	.i_W_en		(i_W_en[0]),
	.i_Weight		(i_Weight_1),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(C3_hsync),
	.o_valid		(C3_valid),
	.o_tdata		(C3_tdata[0])
);
LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_2(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_2),

	.i_W_en		(i_W_en[1]),
	.i_Weight		(i_Weight_2),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(),
	.o_valid		(),
	.o_tdata		(C3_tdata[1])
);
LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_3(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_3),

	.i_W_en		(i_W_en[2]),
	.i_Weight		(i_Weight_3),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(),
	.o_valid		(),
	.o_tdata		(C3_tdata[2])
);
LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_4(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_4),

	.i_W_en		(i_W_en[3]),
	.i_Weight		(i_Weight_4),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(),
	.o_valid		(),
	.o_tdata		(C3_tdata[3])
);
LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_5(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_5),

	.i_W_en		(i_W_en[4]),
	.i_Weight		(i_Weight_5),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(),
	.o_valid		(),
	.o_tdata		(C3_tdata[4])
);
LeNet_Conv_C3#(
	.WD			(WD),
	.WW			(WW)
)LeNet_Conv_C3_6(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(i_vsync),
	.i_hsync		(i_hsync),
	.i_valid		(i_valid),
	.i_tdata		(i_tdata_6),

	.i_W_en		(i_W_en[5]),
	.i_Weight		(i_Weight_6),
	.i_W_addr		(i_W_addr),
	
	.o_hsync		(),
	.o_valid		(),
	.o_tdata		(C3_tdata[5])
);

always@(posedge i_sclk)
	if(!i_rstn || i_vsync)
	begin
		sum_1 <= 'd0;
		sum_2 <= 'd0;
	end
	else 
	begin
	  if(C3_valid)
	  begin
		sum_1 <= C3_tdata[0] + C3_tdata[1] + C3_tdata[2];
		sum_2 <= C3_tdata[3] + C3_tdata[4] + C3_tdata[5];
	  end
	  else
	  begin
		sum_1 <= sum_1;
		sum_2 <= sum_2;	
	  end
	end

always@(posedge i_sclk)	sum_en <= C3_valid;
always@(posedge i_sclk)	C3_dat_en <= sum_en;

always@(posedge i_sclk)
	if(!i_rstn || i_vsync)	C3_dat <= 'd0;
	else 
	begin
	  if(sum_en)	        C3_dat <= sum_1 + sum_2 + i_Bias;
	  else 		C3_dat <= C3_dat;
	end

//------------------------------------------------------------//
//							卷积C3: SIGM					  //
//------------------------------------------------------------//
Sigmoid#(
	.WI 			(WD+WW+9)
)Sigmoid_C31(
	.i_sclk		(i_sclk),
	.i_rstn                (i_rstn),
	.i_valid		(C3_dat_en),
	.i_tdata		(C3_dat),
	.o_valid		(C3_sigm_dat_en),
	.o_tdata		(C3_sigm_dat)
);

endmodule
