`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 19:11:13
// Design Name: 
// Module Name: feature_map
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


module feature_map#(
	parameter				WD = 3,
	parameter				WW = 8,
	parameter				SIZE = 16
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
	input	wire[WD-1:0]			i_tdata_7,
	input	wire[WD-1:0]			i_tdata_8,
	input	wire[WD-1:0]			i_tdata_9,
	input	wire[WD-1:0]			i_tdata_10,
	input	wire[WD-1:0]			i_tdata_11,
	input	wire[WD-1:0]			i_tdata_12,
	input	wire[WD-1:0]			i_tdata_13,
	input	wire[WD-1:0]			i_tdata_14,
	input	wire[WD-1:0]			i_tdata_15,
	input	wire[WD-1:0]			i_tdata_16,

	output	reg 				o_valid,
	output	reg [WD-1:0]			o_tdata
);

//------------------------------------------//
//					PARAM					//
//------------------------------------------//
parameter	FM = SIZE*16;

//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//
reg [3:0]		wr_addr;
reg 			wr_done;

reg 			rd_en;
reg [3:0]		rd_addr;
reg [7:0]		rd_num;

reg [15:0]		rd_en_s;

reg [15:0]		rd_en_s_d1;
wire[2:0]		rd_d1,rd_d2,rd_d3,rd_d4;
wire[2:0]		rd_d5,rd_d6,rd_d7,rd_d8;
wire[2:0]		rd_d9,rd_d10,rd_d11,rd_d12;
wire[2:0]		rd_d13,rd_d14,rd_d15,rd_d16;

//------------------------------------------//
//					CODE					//
//------------------------------------------//
always@(posedge i_sclk)
	if(!i_rstn)				wr_addr <= 'd0;
	else 
	begin
	  if(i_valid)
	  begin
	    if(wr_addr==SIZE-1)		wr_addr <= 'd0;
	    else				wr_addr <= wr_addr + 'd1;
	  end
	  else					wr_addr <= wr_addr;
	end

always@(posedge i_sclk)
	if(!i_rstn)				wr_done <= 'd0;
	else 
	  if(rd_en)				wr_done <= 'd0;
	  else 
	    if(i_valid&&wr_addr==SIZE-1)	wr_done <= 'd1;
            else                            	wr_done <= wr_done;
always@(posedge i_sclk)
	if(!i_rstn)				rd_en <= 'd0;
	else 
	  if(wr_done)	                	rd_en <= 'd1;
	  else 
	    if(rd_num==FM-1)	              	rd_en <= 'd0;
	    else				rd_en <= rd_en;

always@(posedge i_sclk)
	if(!i_rstn)		rd_num <= 'd0;
	else if(rd_en)	        rd_num <= rd_num + 'd1;
	else			rd_num <= 'd0;

always@(posedge i_sclk)
	if(!i_rstn)		rd_en_s <= 'd0;
	else 
	  if(wr_done)	rd_en_s <= 'd1;
	  else 
	    if(&rd_num[3:0])	rd_en_s <= rd_en_s<<1;
	    else             	rd_en_s <= rd_en_s;

always@(posedge i_sclk)	
if(!i_rstn)
	rd_en_s_d1 <= 'd0;
else
	rd_en_s_d1 <= rd_en_s;

always@(posedge i_sclk)
	if(!i_rstn)	        rd_addr <= 'd0;
	else if(|rd_en_s)
	begin
		case(rd_addr)
		0 :      rd_addr <= 4;
		1 :      rd_addr <= 5;
		2 :      rd_addr <= 6;
		3 :	 rd_addr <= 7;
		4 :	 rd_addr <= 8;
		5 :	 rd_addr <= 9;
		6 :      rd_addr <= 10;
		7 :      rd_addr <= 11;
		8 :	 rd_addr <= 12;
		9 :	 rd_addr <= 13;
		10:      rd_addr <= 14;
		11:      rd_addr <= 15;
		12:      rd_addr <= 1;
		13:	 rd_addr <= 2;
		14:	 rd_addr <= 3;
		15:      rd_addr <= 0;
		default: rd_addr <= 0;
		endcase
	end
	else
	begin
			rd_addr <= rd_addr;
	end

always@(posedge i_sclk)	
if(!i_rstn)
	o_valid <= 'd0;
else
	o_valid <= |rd_en_s_d1;

always@(posedge i_sclk)
	if(!i_rstn)		o_tdata <= 'd0;
	else
	case(rd_en_s_d1)
		16'b00000000_00000001:	o_tdata <= rd_d1;
		16'b00000000_00000010:	o_tdata <= rd_d2;
		16'b00000000_00000100:	o_tdata <= rd_d3;
		16'b00000000_00001000:	o_tdata <= rd_d4;
		16'b00000000_00010000:	o_tdata <= rd_d5;
		16'b00000000_00100000:	o_tdata <= rd_d6;
		16'b00000000_01000000:	o_tdata <= rd_d7;
		16'b00000000_10000000:	o_tdata <= rd_d8;
		16'b00000001_00000000:	o_tdata <= rd_d9;
		16'b00000010_00000000:	o_tdata <= rd_d10;
		16'b00000100_00000000:	o_tdata <= rd_d11;
		16'b00001000_00000000:	o_tdata <= rd_d12;
		16'b00010000_00000000:	o_tdata <= rd_d13;
		16'b00100000_00000000:	o_tdata <= rd_d14;
		16'b01000000_00000000:	o_tdata <= rd_d15;
		16'b10000000_00000000:	o_tdata <= rd_d16;
	default:			o_tdata <= 'd0;
	endcase



ram_3b_16d ram_3b_16d_1(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_1),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[0]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d1)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_2(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_2),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[1]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d2)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_3(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_3),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[2]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d3)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_4(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_4),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[3]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d4)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_5(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_5),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[4]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d5)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_6(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_6),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[5]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d6)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_7(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_7),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[6]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d7)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_8(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_8),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[7]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d8)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_9(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_9),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[8]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d9)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_10(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_10),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[9]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d10)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_11(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_11),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[10]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d11)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_12(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_12),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[11]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d12)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_13(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_13),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[12]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d13)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_14(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_14),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[13]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d14)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_15(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_15),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[14]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d15)  // output wire [2 : 0] doutb
);
ram_3b_16d ram_3b_16d_16(
  .clka(i_sclk),    // input wire clka
  .ena(i_valid),      // input wire ena
  .wea(i_valid),      // input wire [0 : 0] wea
  .addra(wr_addr),  // input wire [3 : 0] addra
  .dina(i_tdata_16),    // input wire [2 : 0] dina
  .clkb(i_sclk),    // input wire clkb
  .enb(rd_en_s[15]),      // input wire enb
  .addrb(rd_addr),  // input wire [3 : 0] addrb
  .doutb(rd_d16)  // output wire [2 : 0] doutb
);


endmodule
