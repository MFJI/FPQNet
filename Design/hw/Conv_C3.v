`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 16:53:41
// Design Name: 
// Module Name: LeNet_Conv_C3
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


module LeNet_Conv_C3#(
	parameter					WD = 3,
	parameter					WW = 8
)(		
	input	wire					i_sclk,
	input	wire					i_rstn,
	
	input	wire					i_vsync,
	input	wire					i_hsync,
	input	wire					i_valid,
	input	wire[WD-1:0]			        i_tdata,
	
	input	wire					i_W_en,
	input	wire[WW-1:0]			        i_Weight,
	input	wire[4:0]				i_W_addr,
	
	output	reg 					o_hsync,
	output	wire					o_valid,
	output	wire signed[WD+WW+5:0]	o_tdata
);

//------------------------------//
//			SIGNALS				//
//------------------------------//
reg [7:0]	cnt_cols,cnt_rows;

reg [WD-1:0]	dat_1;
reg 		wr_en_1;
wire		rd_en_1;
wire[WD-1:0]	dat_2;
reg 		wr_en_2;
wire		rd_en_2;
wire[WD-1:0]	dat_3;
reg 		wr_en_3;
wire		rd_en_3;
wire[WD-1:0]	dat_4;
reg 		wr_en_4;
wire		rd_en_4;
wire[WD-1:0]	dat_5;

reg [WD:0]	dat_1_d1,dat_1_d2,dat_1_d3,dat_1_d4;
reg [WD:0]	dat_2_d1,dat_2_d2,dat_2_d3,dat_2_d4;
reg [WD:0]	dat_3_d1,dat_3_d2,dat_3_d3,dat_3_d4;
reg [WD:0]	dat_4_d1,dat_4_d2,dat_4_d3,dat_4_d4;
reg [WD:0]	dat_5_d1,dat_5_d2,dat_5_d3,dat_5_d4;

reg  signed[WW-1:0]		W_11,W_12,W_13,W_14,W_15;
reg  signed[WW-1:0]		W_21,W_22,W_23,W_24,W_25;
reg  signed[WW-1:0]		W_31,W_32,W_33,W_34,W_35;
reg  signed[WW-1:0]		W_41,W_42,W_43,W_44,W_45;
reg  signed[WW-1:0]		W_51,W_52,W_53,W_54,W_55;

wire signed[WD+WW:0]	M11,M12,M13,M14,M15;
wire signed[WD+WW:0]	M21,M22,M23,M24,M25;
wire signed[WD+WW:0]	M31,M32,M33,M34,M35;
wire signed[WD+WW:0]	M41,M42,M43,M44,M45;
wire signed[WD+WW:0]	M51,M52,M53,M54,M55;

reg [9:0]		sum_flag;
reg  signed[WD+WW+2:0]	sum_11,sum_12;
reg  signed[WD+WW+2:0]	sum_21,sum_22;
reg  signed[WD+WW+2:0]	sum_31,sum_32;
reg  signed[WD+WW+2:0]	sum_41,sum_42;
reg  signed[WD+WW+2:0]	sum_51,sum_52;

reg  signed[WD+WW+3:0]	sum_1,sum_2,sum_3,sum_4,sum_5;

reg  signed[WD+WW+4:0]	sum_t1,sum_t2;
reg  signed[WD+WW+5:0]	sum_5x5;

//------------------------------//
//			COUNT				//
//------------------------------//
always@(posedge i_sclk)
	if(i_valid)		cnt_cols <= cnt_cols + 'd1;
	else			cnt_cols <= 'd1;

always@(posedge i_sclk)
	if(!i_rstn)		cnt_rows <= 'd0;
	else
	  if(i_vsync)		cnt_rows <= 'd0;
	  else 
	    if(i_hsync)		cnt_rows <= cnt_rows + 'd1;
	    else			cnt_rows <= cnt_rows;
//------------------------------//
//			PIPELINE			//
//------------------------------//
always@(posedge i_sclk)	wr_en_1 <= i_valid;
always@(posedge i_sclk)	dat_1 <= i_tdata;

assign rd_en_1 = cnt_rows>1 ? i_valid:'d0;
assign rd_en_2 = cnt_rows>2 ? i_valid:'d0;
assign rd_en_3 = cnt_rows>3 ? i_valid:'d0;
assign rd_en_4 = cnt_rows>4 ? i_valid:'d0;

always@(posedge i_sclk)	wr_en_2 <= rd_en_1;
always@(posedge i_sclk)	wr_en_3 <= rd_en_2;
always@(posedge i_sclk)	wr_en_4 <= rd_en_3;

fifo_3b_16d fifo_3b_16d_r1(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(dat_1),      // input wire [2 : 0] din
  .wr_en(wr_en_1),  // input wire wr_en
  .rd_en(rd_en_1),  // input wire rd_en
  .dout(dat_2),    // output wire [2 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
fifo_3b_16d fifo_3b_16d_r2(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(dat_2),      // input wire [2 : 0] din
  .wr_en(wr_en_2),  // input wire wr_en
  .rd_en(rd_en_2),  // input wire rd_en
  .dout(dat_3),    // output wire [2 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
fifo_3b_16d fifo_3b_16d_r3(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(dat_3),      // input wire [2 : 0] din
  .wr_en(wr_en_3),  // input wire wr_en
  .rd_en(rd_en_3),  // input wire rd_en
  .dout(dat_4),    // output wire [2 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
fifo_3b_16d fifo_3b_16d_r4(
  .clk(i_sclk),      // input wire clk
  .rst(i_vsync),      // input wire rst
  .din(dat_4),      // input wire [2 : 0] din
  .wr_en(wr_en_4),  // input wire wr_en
  .rd_en(rd_en_4),  // input wire rd_en
  .dout(dat_5),    // output wire [2 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
//------------------------------//
//				CONV			//
//------------------------------//
always@(posedge i_sclk)
	begin
		dat_1_d1 <= dat_1;
		dat_2_d1 <= dat_2;
		dat_3_d1 <= dat_3;
		dat_4_d1 <= dat_4;
		dat_5_d1 <= dat_5;
		
		dat_1_d2 <= dat_1_d1;
		dat_2_d2 <= dat_2_d1;
		dat_3_d2 <= dat_3_d1;
		dat_4_d2 <= dat_4_d1;
		dat_5_d2 <= dat_5_d1;
		
		dat_1_d3 <= dat_1_d2;
		dat_2_d3 <= dat_2_d2;
		dat_3_d3 <= dat_3_d2;
		dat_4_d3 <= dat_4_d2;
		dat_5_d3 <= dat_5_d2;
		
		dat_1_d4 <= dat_1_d3;
		dat_2_d4 <= dat_2_d3;
		dat_3_d4 <= dat_3_d3;
		dat_4_d4 <= dat_4_d3;
		dat_5_d4 <= dat_5_d3;
	end

always @(posedge i_sclk)
	if(!i_rstn)
	begin
		W_11 <= 'd0;
		W_12 <= 'd0;
		W_13 <= 'd0;
		W_14 <= 'd0;
		W_15 <= 'd0;
		W_21 <= 'd0;
		W_22 <= 'd0;
		W_23 <= 'd0;
		W_24 <= 'd0;
		W_25 <= 'd0;
		W_31 <= 'd0;
		W_32 <= 'd0;
		W_33 <= 'd0;
		W_34 <= 'd0;
		W_35 <= 'd0;
		W_41 <= 'd0;
		W_42 <= 'd0;
		W_43 <= 'd0;
		W_44 <= 'd0;
		W_45 <= 'd0;
		W_51 <= 'd0;
		W_52 <= 'd0;
		W_53 <= 'd0;
		W_54 <= 'd0;
		W_55 <= 'd0;
	end
	else if(i_W_en)
	begin
		case (i_W_addr)
		0 :	W_11 <= i_Weight;
		1 :     W_12 <= i_Weight;
		2 :     W_13 <= i_Weight;
		3 :     W_14 <= i_Weight;
		4 :     W_15 <= i_Weight;
		5 :     W_21 <= i_Weight;
		6 :     W_22 <= i_Weight;
		7 :     W_23 <= i_Weight;
		8 :     W_24 <= i_Weight;
		9 :     W_25 <= i_Weight;
		10:     W_31 <= i_Weight;
		11:     W_32 <= i_Weight;
		12:     W_33 <= i_Weight;
		13:     W_34 <= i_Weight;
		14:     W_35 <= i_Weight;
		15:     W_41 <= i_Weight;
		16:     W_42 <= i_Weight;
		17:     W_43 <= i_Weight;
		18:     W_44 <= i_Weight;
		19:     W_45 <= i_Weight;
		20:     W_51 <= i_Weight;
		21:     W_52 <= i_Weight;
		22:     W_53 <= i_Weight;
		23:     W_54 <= i_Weight;
		24:     W_55 <= i_Weight;
		endcase
	end
	else
	begin
		W_11 <= W_11;
		W_12 <= W_12;
		W_13 <= W_13;
		W_14 <= W_14;
		W_15 <= W_15;
		W_21 <= W_21;
		W_22 <= W_22;
		W_23 <= W_23;
		W_24 <= W_24;
		W_25 <= W_25;
		W_31 <= W_31;
		W_32 <= W_32;
		W_33 <= W_33;
		W_34 <= W_34;
		W_35 <= W_35;
		W_41 <= W_41;
		W_42 <= W_42;
		W_43 <= W_43;
		W_44 <= W_44;
		W_45 <= W_45;
		W_51 <= W_51;
		W_52 <= W_52;
		W_53 <= W_53;
		W_54 <= W_54;
		W_55 <= W_55;
	end

mult_8bs_4bs mult_8bs_4bs_M11(
  .CLK(i_sclk),  // input wire CLK
  .A(W_11),      // input wire [7 : 0] A
  .B(dat_5_d4),      // input wire [3 : 0] B
  .P(M11)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M12(
  .CLK(i_sclk),  // input wire CLK
  .A(W_12),      // input wire [7 : 0] A
  .B(dat_5_d3),      // input wire [3 : 0] B
  .P(M12)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M13(
  .CLK(i_sclk),  // input wire CLK
  .A(W_13),      // input wire [7 : 0] A
  .B(dat_5_d2),      // input wire [3 : 0] B
  .P(M13)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M14(
  .CLK(i_sclk),  // input wire CLK
  .A(W_14),      // input wire [7 : 0] A
  .B(dat_5_d1),      // input wire [3 : 0] B
  .P(M14)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M15(
  .CLK(i_sclk),  // input wire CLK
  .A(W_15),      // input wire [7 : 0] A
  .B({1'b0,dat_5}),      // input wire [3 : 0] B
  .P(M15)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M21(
  .CLK(i_sclk),  // input wire CLK
  .A(W_21),      // input wire [7 : 0] A
  .B(dat_4_d4),      // input wire [3 : 0] B
  .P(M21)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M22(
  .CLK(i_sclk),  // input wire CLK
  .A(W_22),      // input wire [7 : 0] A
  .B(dat_4_d3),      // input wire [3 : 0] B
  .P(M22)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M23(
  .CLK(i_sclk),  // input wire CLK
  .A(W_23),      // input wire [7 : 0] A
  .B(dat_4_d2),      // input wire [3 : 0] B
  .P(M23)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M24(
  .CLK(i_sclk),  // input wire CLK
  .A(W_24),      // input wire [7 : 0] A
  .B(dat_4_d1),      // input wire [3 : 0] B
  .P(M24)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M25(
  .CLK(i_sclk),  // input wire CLK
  .A(W_25),      // input wire [7 : 0] A
  .B({1'b0,dat_4}),      // input wire [3 : 0] B
  .P(M25)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M31(
  .CLK(i_sclk),  // input wire CLK
  .A(W_31),      // input wire [7 : 0] A
  .B(dat_3_d4),      // input wire [3 : 0] B
  .P(M31)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M32(
  .CLK(i_sclk),  // input wire CLK
  .A(W_32),      // input wire [7 : 0] A
  .B(dat_3_d3),      // input wire [3 : 0] B
  .P(M32)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M33(
  .CLK(i_sclk),  // input wire CLK
  .A(W_33),      // input wire [7 : 0] A
  .B(dat_3_d2),      // input wire [3 : 0] B
  .P(M33)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M34(
  .CLK(i_sclk),  // input wire CLK
  .A(W_34),      // input wire [7 : 0] A
  .B(dat_3_d1),      // input wire [3 : 0] B
  .P(M34)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M35(
  .CLK(i_sclk),  // input wire CLK
  .A(W_35),      // input wire [7 : 0] A
  .B({1'b0,dat_3}),      // input wire [3 : 0] B
  .P(M35)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M41(
  .CLK(i_sclk),  // input wire CLK
  .A(W_41),      // input wire [7 : 0] A
  .B(dat_2_d4),      // input wire [3 : 0] B
  .P(M41)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M42(
  .CLK(i_sclk),  // input wire CLK
  .A(W_42),      // input wire [7 : 0] A
  .B(dat_2_d3),      // input wire [3 : 0] B
  .P(M42)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M43(
  .CLK(i_sclk),  // input wire CLK
  .A(W_43),      // input wire [7 : 0] A
  .B(dat_2_d2),      // input wire [3 : 0] B
  .P(M43)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M44(
  .CLK(i_sclk),  // input wire CLK
  .A(W_44),      // input wire [7 : 0] A
  .B(dat_2_d1),      // input wire [3 : 0] B
  .P(M44)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M45(
  .CLK(i_sclk),  // input wire CLK
  .A(W_45),      // input wire [7 : 0] A
  .B({1'b0,dat_2}),      // input wire [3 : 0] B
  .P(M45)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M51(
  .CLK(i_sclk),  // input wire CLK
  .A(W_51),      // input wire [7 : 0] A
  .B(dat_1_d4),      // input wire [3 : 0] B
  .P(M51)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M52(
  .CLK(i_sclk),  // input wire CLK
  .A(W_52),      // input wire [7 : 0] A
  .B(dat_1_d3),      // input wire [3 : 0] B
  .P(M52)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M53(
  .CLK(i_sclk),  // input wire CLK
  .A(W_53),      // input wire [7 : 0] A
  .B(dat_1_d2),      // input wire [3 : 0] B
  .P(M53)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M54(
  .CLK(i_sclk),  // input wire CLK
  .A(W_54),      // input wire [7 : 0] A
  .B(dat_1_d1),      // input wire [3 : 0] B
  .P(M54)      // output wire [11 : 0] P
);
mult_8bs_4bs mult_8bs_4bs_M55(
  .CLK(i_sclk),  // input wire CLK
  .A(W_55),      // input wire [7 : 0] A
  .B({1'b0,dat_1}),      // input wire [3 : 0] B
  .P(M55)      // output wire [11 : 0] P
);

always@(posedge i_sclk)
	if(!i_rstn)	sum_flag <= 'd0;
	else		sum_flag <= {sum_flag[8:0],rd_en_4};

always@(posedge i_sclk)
	if(!i_rstn)
	begin
		sum_11 <= 'd0;
		sum_12 <= 'd0;
		sum_21 <= 'd0;
		sum_22 <= 'd0;
		sum_31 <= 'd0;
		sum_32 <= 'd0;
		sum_41 <= 'd0;
		sum_42 <= 'd0;
		sum_51 <= 'd0;
		sum_52 <= 'd0;
		sum_1 <= 'd0;
		sum_2 <= 'd0;
		sum_3 <= 'd0;
		sum_4 <= 'd0;
		sum_5 <= 'd0;
		sum_t1 <= 'd0;
		sum_t2 <= 'd0;
		sum_5x5 <= 'd0;
	end
	else
	begin
	if(i_vsync)
	begin
		sum_11 <= 'd0;
		sum_12 <= 'd0;
		sum_21 <= 'd0;
		sum_22 <= 'd0;
		sum_31 <= 'd0;
		sum_32 <= 'd0;
		sum_41 <= 'd0;
		sum_42 <= 'd0;
		sum_51 <= 'd0;
		sum_52 <= 'd0;
		sum_1 <= 'd0;
		sum_2 <= 'd0;
		sum_3 <= 'd0;
		sum_4 <= 'd0;
		sum_5 <= 'd0;
		sum_t1 <= 'd0;
		sum_t2 <= 'd0;
		sum_5x5 <= 'd0;
	end
	else
	begin
		if(sum_flag[5])
		begin
			sum_11 <= M11 + M12;
			sum_12 <= M13 + M14 + M15;
			sum_21 <= M21 + M22;
			sum_22 <= M23 + M24 + M25;
			sum_31 <= M31 + M32;
			sum_32 <= M33 + M34 + M35;
			sum_41 <= M41 + M42;
			sum_42 <= M43 + M44 + M45;
			sum_51 <= M51 + M52;
			sum_52 <= M53 + M54 + M55;
		end
		else
		begin
			sum_11 <= sum_11;
			sum_12 <= sum_12;
			sum_21 <= sum_21;
			sum_22 <= sum_22;
			sum_31 <= sum_31;
			sum_32 <= sum_32;
			sum_41 <= sum_41;
			sum_42 <= sum_42;
			sum_51 <= sum_51;
			sum_52 <= sum_52;
		end
		
		sum_1 <= sum_11 + sum_12;
		sum_2 <= sum_21 + sum_22;
		sum_3 <= sum_31 + sum_32;
		sum_4 <= sum_41 + sum_42;
		sum_5 <= sum_51 + sum_52;
		
		sum_t1 <= sum_1 + sum_2;
		sum_t2 <= sum_3 + sum_4 + sum_5;
		
		sum_5x5 <= sum_t1 + sum_t2;
	end
	end

always@(posedge i_sclk)
	if(cnt_rows>3)	o_hsync <= i_hsync;
	else		o_hsync <= 'd0;

assign	o_valid = sum_flag[5]&sum_flag[9];
assign	o_tdata = sum_5x5;



// always@(posedge i_sclk)
	// if(cnt_rows>4)	o_hsync <= sum_flag[0]&&!sum_flag[1];
	// else			o_hsync <= 'd0;

// always@(posedge i_sclk)	o_valid <= sum_flag[5]&sum_flag[9];

// always@(posedge i_sclk)
	// if(sum_flag[5]&&sum_flag[9])	o_tdata <= sum_5x5;
	// else							o_tdata <= 'd0;


endmodule
