`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 14:34:05
// Design Name: 
// Module Name: buffer_c3_weight
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


module buffer_c3_weight#(
	parameter				WD  = 8,
	parameter				NW  = 25,
	parameter				GP  = 6,
	parameter				NUM = 16
)(
	input	wire			i_sclk,
	input	wire			i_rstn,
	
	input   wire[WD-1:0]    c3_weight_data,
        input   wire            c3_weight_en,
	
	output	wire[GP-1:0]	o_w_en_1,
	output	wire[WD-1:0]	o_w1_1,
	output	wire[WD-1:0]	o_w1_2,
	output	wire[WD-1:0]	o_w1_3,
	output	wire[WD-1:0]	o_w1_4,
	output	wire[WD-1:0]	o_w1_5,
	output	wire[WD-1:0]	o_w1_6,
	
	output	wire[GP-1:0]	o_w_en_2,
	output	wire[WD-1:0]	o_w2_1,
	output	wire[WD-1:0]	o_w2_2,
	output	wire[WD-1:0]	o_w2_3,
	output	wire[WD-1:0]	o_w2_4,
	output	wire[WD-1:0]	o_w2_5,
	output	wire[WD-1:0]	o_w2_6,
	
	output	wire[GP-1:0]	o_w_en_3,
	output	wire[WD-1:0]	o_w3_1,
	output	wire[WD-1:0]	o_w3_2,
	output	wire[WD-1:0]	o_w3_3,
	output	wire[WD-1:0]	o_w3_4,
	output	wire[WD-1:0]	o_w3_5,
	output	wire[WD-1:0]	o_w3_6,
	
	output	wire[GP-1:0]	o_w_en_4,
	output	wire[WD-1:0]	o_w4_1,
	output	wire[WD-1:0]	o_w4_2,
	output	wire[WD-1:0]	o_w4_3,
	output	wire[WD-1:0]	o_w4_4,
	output	wire[WD-1:0]	o_w4_5,
	output	wire[WD-1:0]	o_w4_6,
	
	output	wire[GP-1:0]	o_w_en_5,
	output	wire[WD-1:0]	o_w5_1,
	output	wire[WD-1:0]	o_w5_2,
	output	wire[WD-1:0]	o_w5_3,
	output	wire[WD-1:0]	o_w5_4,
	output	wire[WD-1:0]	o_w5_5,
	output	wire[WD-1:0]	o_w5_6,
	
	output	wire[GP-1:0]	o_w_en_6,
	output	wire[WD-1:0]	o_w6_1,
	output	wire[WD-1:0]	o_w6_2,
	output	wire[WD-1:0]	o_w6_3,
	output	wire[WD-1:0]	o_w6_4,
	output	wire[WD-1:0]	o_w6_5,
	output	wire[WD-1:0]	o_w6_6,
	
	output	wire[GP-1:0]	o_w_en_7,
	output	wire[WD-1:0]	o_w7_1,
	output	wire[WD-1:0]	o_w7_2,
	output	wire[WD-1:0]	o_w7_3,
	output	wire[WD-1:0]	o_w7_4,
	output	wire[WD-1:0]	o_w7_5,
	output	wire[WD-1:0]	o_w7_6,
	
	output	wire[GP-1:0]	o_w_en_8,
	output	wire[WD-1:0]	o_w8_1,
	output	wire[WD-1:0]	o_w8_2,
	output	wire[WD-1:0]	o_w8_3,
	output	wire[WD-1:0]	o_w8_4,
	output	wire[WD-1:0]	o_w8_5,
	output	wire[WD-1:0]	o_w8_6,
	
	output	wire[GP-1:0]	o_w_en_9,
	output	wire[WD-1:0]	o_w9_1,
	output	wire[WD-1:0]	o_w9_2,
	output	wire[WD-1:0]	o_w9_3,
	output	wire[WD-1:0]	o_w9_4,
	output	wire[WD-1:0]	o_w9_5,
	output	wire[WD-1:0]	o_w9_6,
	
	output	wire[GP-1:0]	o_w_en_10,
	output	wire[WD-1:0]	o_w10_1,
	output	wire[WD-1:0]	o_w10_2,
	output	wire[WD-1:0]	o_w10_3,
	output	wire[WD-1:0]	o_w10_4,
	output	wire[WD-1:0]	o_w10_5,
	output	wire[WD-1:0]	o_w10_6,
	
	output	wire[GP-1:0]	o_w_en_11,
	output	wire[WD-1:0]	o_w11_1,
	output	wire[WD-1:0]	o_w11_2,
	output	wire[WD-1:0]	o_w11_3,
	output	wire[WD-1:0]	o_w11_4,
	output	wire[WD-1:0]	o_w11_5,
	output	wire[WD-1:0]	o_w11_6,
	
	output	wire[GP-1:0]	o_w_en_12,
	output	wire[WD-1:0]	o_w12_1,
	output	wire[WD-1:0]	o_w12_2,
	output	wire[WD-1:0]	o_w12_3,
	output	wire[WD-1:0]	o_w12_4,
	output	wire[WD-1:0]	o_w12_5,
	output	wire[WD-1:0]	o_w12_6,
	
	output	wire[GP-1:0]	o_w_en_13,
	output	wire[WD-1:0]	o_w13_1,
	output	wire[WD-1:0]	o_w13_2,
	output	wire[WD-1:0]	o_w13_3,
	output	wire[WD-1:0]	o_w13_4,
	output	wire[WD-1:0]	o_w13_5,
	output	wire[WD-1:0]	o_w13_6,
	
	output	wire[GP-1:0]	o_w_en_14,
	output	wire[WD-1:0]	o_w14_1,
	output	wire[WD-1:0]	o_w14_2,
	output	wire[WD-1:0]	o_w14_3,
	output	wire[WD-1:0]	o_w14_4,
	output	wire[WD-1:0]	o_w14_5,
	output	wire[WD-1:0]	o_w14_6,
	
	output	wire[GP-1:0]	o_w_en_15,
	output	wire[WD-1:0]	o_w15_1,
	output	wire[WD-1:0]	o_w15_2,
	output	wire[WD-1:0]	o_w15_3,
	output	wire[WD-1:0]	o_w15_4,
	output	wire[WD-1:0]	o_w15_5,
	output	wire[WD-1:0]	o_w15_6,
	
	output	wire[GP-1:0]	o_w_en_16,
	output	wire[WD-1:0]	o_w16_1,
	output	wire[WD-1:0]	o_w16_2,
	output	wire[WD-1:0]	o_w16_3,
	output	wire[WD-1:0]	o_w16_4,
	output	wire[WD-1:0]	o_w16_5,
	output	wire[WD-1:0]	o_w16_6,
	
	output	wire[4:0]		o_w_addr
);

//------------------------------------------//
//					PARAM					//
//------------------------------------------//
parameter	PARA_NUM = NW*GP*NUM;
//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg [4:0]		cnt_nw;
reg [GP-1:0]	        cnt_gp;
reg [7:0]		cnt_num;

//------------------------------------------//
//					CODE					//
//------------------------------------------//

always @(posedge i_sclk)
  if(!i_rstn)
    cnt_nw <= 'd0;
  else
    begin
	  if(c3_weight_en)
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
	  cnt_gp <= 'd1;
	else
	begin
	  if(c3_weight_en)
	    begin
		  if(cnt_nw==NW-1)
		    begin
			    if(cnt_gp[GP-1])	cnt_gp <= 'd1;
			    else				cnt_gp <= cnt_gp<<1;
		    end
	    end
	else
      begin
	    if(cnt_nw==NW-1 && cnt_gp[GP-1])
		  cnt_gp <= 'd1;
	    else
	      cnt_gp <= cnt_gp;
	  end
    end

always @(posedge i_sclk)
  if(!i_rstn)
    cnt_num <= 'd1;
  else
  begin
	if(c3_weight_en)
	begin
		if(cnt_nw==NW-1&&cnt_gp[GP-1])
		begin
			if(cnt_num==NUM)	cnt_num <= 'd1;
			else				cnt_num <= cnt_num + 'd1;
		end
	end
	else
    begin
      if(cnt_nw==NW-1&&cnt_gp[GP-1]&&cnt_num==NUM)	
	    cnt_num <= 'd1;
	  else
	    cnt_num <= cnt_num;
	end
  end

assign o_w_addr = cnt_nw;

assign o_w_en_1  = c3_weight_en&&cnt_num==1  ? cnt_gp:'d0;
assign o_w_en_2  = c3_weight_en&&cnt_num==2  ? cnt_gp:'d0;
assign o_w_en_3  = c3_weight_en&&cnt_num==3  ? cnt_gp:'d0;
assign o_w_en_4  = c3_weight_en&&cnt_num==4  ? cnt_gp:'d0;
assign o_w_en_5  = c3_weight_en&&cnt_num==5  ? cnt_gp:'d0;
assign o_w_en_6  = c3_weight_en&&cnt_num==6  ? cnt_gp:'d0;
assign o_w_en_7  = c3_weight_en&&cnt_num==7  ? cnt_gp:'d0;
assign o_w_en_8  = c3_weight_en&&cnt_num==8  ? cnt_gp:'d0;
assign o_w_en_9  = c3_weight_en&&cnt_num==9  ? cnt_gp:'d0;
assign o_w_en_10 = c3_weight_en&&cnt_num==10 ? cnt_gp:'d0;
assign o_w_en_11 = c3_weight_en&&cnt_num==11 ? cnt_gp:'d0;
assign o_w_en_12 = c3_weight_en&&cnt_num==12 ? cnt_gp:'d0;
assign o_w_en_13 = c3_weight_en&&cnt_num==13 ? cnt_gp:'d0;
assign o_w_en_14 = c3_weight_en&&cnt_num==14 ? cnt_gp:'d0;
assign o_w_en_15 = c3_weight_en&&cnt_num==15 ? cnt_gp:'d0;
assign o_w_en_16 = c3_weight_en&&cnt_num==16 ? cnt_gp:'d0;

assign o_w1_1  = cnt_gp[0]&&cnt_num==1 ? c3_weight_data:'d0;
assign o_w1_2  = cnt_gp[1]&&cnt_num==1 ? c3_weight_data:'d0;
assign o_w1_3  = cnt_gp[2]&&cnt_num==1 ? c3_weight_data:'d0;
assign o_w1_4  = cnt_gp[3]&&cnt_num==1 ? c3_weight_data:'d0;
assign o_w1_5  = cnt_gp[4]&&cnt_num==1 ? c3_weight_data:'d0;
assign o_w1_6  = cnt_gp[5]&&cnt_num==1 ? c3_weight_data:'d0;

assign o_w2_1  = cnt_gp[0]&&cnt_num==2 ? c3_weight_data:'d0;
assign o_w2_2  = cnt_gp[1]&&cnt_num==2 ? c3_weight_data:'d0;
assign o_w2_3  = cnt_gp[2]&&cnt_num==2 ? c3_weight_data:'d0;
assign o_w2_4  = cnt_gp[3]&&cnt_num==2 ? c3_weight_data:'d0;
assign o_w2_5  = cnt_gp[4]&&cnt_num==2 ? c3_weight_data:'d0;
assign o_w2_6  = cnt_gp[5]&&cnt_num==2 ? c3_weight_data:'d0;

assign o_w3_1  = cnt_gp[0]&&cnt_num==3 ? c3_weight_data:'d0;
assign o_w3_2  = cnt_gp[1]&&cnt_num==3 ? c3_weight_data:'d0;
assign o_w3_3  = cnt_gp[2]&&cnt_num==3 ? c3_weight_data:'d0;
assign o_w3_4  = cnt_gp[3]&&cnt_num==3 ? c3_weight_data:'d0;
assign o_w3_5  = cnt_gp[4]&&cnt_num==3 ? c3_weight_data:'d0;
assign o_w3_6  = cnt_gp[5]&&cnt_num==3 ? c3_weight_data:'d0;

assign o_w4_1  = cnt_gp[0]&&cnt_num==4 ? c3_weight_data:'d0;
assign o_w4_2  = cnt_gp[1]&&cnt_num==4 ? c3_weight_data:'d0;
assign o_w4_3  = cnt_gp[2]&&cnt_num==4 ? c3_weight_data:'d0;
assign o_w4_4  = cnt_gp[3]&&cnt_num==4 ? c3_weight_data:'d0;
assign o_w4_5  = cnt_gp[4]&&cnt_num==4 ? c3_weight_data:'d0;
assign o_w4_6  = cnt_gp[5]&&cnt_num==4 ? c3_weight_data:'d0;

assign o_w5_1  = cnt_gp[0]&&cnt_num==5 ? c3_weight_data:'d0;
assign o_w5_2  = cnt_gp[1]&&cnt_num==5 ? c3_weight_data:'d0;
assign o_w5_3  = cnt_gp[2]&&cnt_num==5 ? c3_weight_data:'d0;
assign o_w5_4  = cnt_gp[3]&&cnt_num==5 ? c3_weight_data:'d0;
assign o_w5_5  = cnt_gp[4]&&cnt_num==5 ? c3_weight_data:'d0;
assign o_w5_6  = cnt_gp[5]&&cnt_num==5 ? c3_weight_data:'d0;

assign o_w6_1  = cnt_gp[0]&&cnt_num==6 ? c3_weight_data:'d0;
assign o_w6_2  = cnt_gp[1]&&cnt_num==6 ? c3_weight_data:'d0;
assign o_w6_3  = cnt_gp[2]&&cnt_num==6 ? c3_weight_data:'d0;
assign o_w6_4  = cnt_gp[3]&&cnt_num==6 ? c3_weight_data:'d0;
assign o_w6_5  = cnt_gp[4]&&cnt_num==6 ? c3_weight_data:'d0;
assign o_w6_6  = cnt_gp[5]&&cnt_num==6 ? c3_weight_data:'d0;

assign o_w7_1  = cnt_gp[0]&&cnt_num==7 ? c3_weight_data:'d0;
assign o_w7_2  = cnt_gp[1]&&cnt_num==7 ? c3_weight_data:'d0;
assign o_w7_3  = cnt_gp[2]&&cnt_num==7 ? c3_weight_data:'d0;
assign o_w7_4  = cnt_gp[3]&&cnt_num==7 ? c3_weight_data:'d0;
assign o_w7_5  = cnt_gp[4]&&cnt_num==7 ? c3_weight_data:'d0;
assign o_w7_6  = cnt_gp[5]&&cnt_num==7 ? c3_weight_data:'d0;

assign o_w8_1  = cnt_gp[0]&&cnt_num==8 ? c3_weight_data:'d0;
assign o_w8_2  = cnt_gp[1]&&cnt_num==8 ? c3_weight_data:'d0;
assign o_w8_3  = cnt_gp[2]&&cnt_num==8 ? c3_weight_data:'d0;
assign o_w8_4  = cnt_gp[3]&&cnt_num==8 ? c3_weight_data:'d0;
assign o_w8_5  = cnt_gp[4]&&cnt_num==8 ? c3_weight_data:'d0;
assign o_w8_6  = cnt_gp[5]&&cnt_num==8 ? c3_weight_data:'d0;

assign o_w9_1  = cnt_gp[0]&&cnt_num==9 ? c3_weight_data:'d0;
assign o_w9_2  = cnt_gp[1]&&cnt_num==9 ? c3_weight_data:'d0;
assign o_w9_3  = cnt_gp[2]&&cnt_num==9 ? c3_weight_data:'d0;
assign o_w9_4  = cnt_gp[3]&&cnt_num==9 ? c3_weight_data:'d0;
assign o_w9_5  = cnt_gp[4]&&cnt_num==9 ? c3_weight_data:'d0;
assign o_w9_6  = cnt_gp[5]&&cnt_num==9 ? c3_weight_data:'d0;

assign o_w10_1 = cnt_gp[0]&&cnt_num==10 ? c3_weight_data:'d0;
assign o_w10_2 = cnt_gp[1]&&cnt_num==10 ? c3_weight_data:'d0;
assign o_w10_3 = cnt_gp[2]&&cnt_num==10 ? c3_weight_data:'d0;
assign o_w10_4 = cnt_gp[3]&&cnt_num==10 ? c3_weight_data:'d0;
assign o_w10_5 = cnt_gp[4]&&cnt_num==10 ? c3_weight_data:'d0;
assign o_w10_6 = cnt_gp[5]&&cnt_num==10 ? c3_weight_data:'d0;

assign o_w11_1 = cnt_gp[0]&&cnt_num==11 ? c3_weight_data:'d0;
assign o_w11_2 = cnt_gp[1]&&cnt_num==11 ? c3_weight_data:'d0;
assign o_w11_3 = cnt_gp[2]&&cnt_num==11 ? c3_weight_data:'d0;
assign o_w11_4 = cnt_gp[3]&&cnt_num==11 ? c3_weight_data:'d0;
assign o_w11_5 = cnt_gp[4]&&cnt_num==11 ? c3_weight_data:'d0;
assign o_w11_6 = cnt_gp[5]&&cnt_num==11 ? c3_weight_data:'d0;

assign o_w12_1 = cnt_gp[0]&&cnt_num==12 ? c3_weight_data:'d0;
assign o_w12_2 = cnt_gp[1]&&cnt_num==12 ? c3_weight_data:'d0;
assign o_w12_3 = cnt_gp[2]&&cnt_num==12 ? c3_weight_data:'d0;
assign o_w12_4 = cnt_gp[3]&&cnt_num==12 ? c3_weight_data:'d0;
assign o_w12_5 = cnt_gp[4]&&cnt_num==12 ? c3_weight_data:'d0;
assign o_w12_6 = cnt_gp[5]&&cnt_num==12 ? c3_weight_data:'d0;

assign o_w13_1 = cnt_gp[0]&&cnt_num==13 ? c3_weight_data:'d0;
assign o_w13_2 = cnt_gp[1]&&cnt_num==13 ? c3_weight_data:'d0;
assign o_w13_3 = cnt_gp[2]&&cnt_num==13 ? c3_weight_data:'d0;
assign o_w13_4 = cnt_gp[3]&&cnt_num==13 ? c3_weight_data:'d0;
assign o_w13_5 = cnt_gp[4]&&cnt_num==13 ? c3_weight_data:'d0;
assign o_w13_6 = cnt_gp[5]&&cnt_num==13 ? c3_weight_data:'d0;

assign o_w14_1 = cnt_gp[0]&&cnt_num==14 ? c3_weight_data:'d0;
assign o_w14_2 = cnt_gp[1]&&cnt_num==14 ? c3_weight_data:'d0;
assign o_w14_3 = cnt_gp[2]&&cnt_num==14 ? c3_weight_data:'d0;
assign o_w14_4 = cnt_gp[3]&&cnt_num==14 ? c3_weight_data:'d0;
assign o_w14_5 = cnt_gp[4]&&cnt_num==14 ? c3_weight_data:'d0;
assign o_w14_6 = cnt_gp[5]&&cnt_num==14 ? c3_weight_data:'d0;

assign o_w15_1 = cnt_gp[0]&&cnt_num==15 ? c3_weight_data:'d0;
assign o_w15_2 = cnt_gp[1]&&cnt_num==15 ? c3_weight_data:'d0;
assign o_w15_3 = cnt_gp[2]&&cnt_num==15 ? c3_weight_data:'d0;
assign o_w15_4 = cnt_gp[3]&&cnt_num==15 ? c3_weight_data:'d0;
assign o_w15_5 = cnt_gp[4]&&cnt_num==15 ? c3_weight_data:'d0;
assign o_w15_6 = cnt_gp[5]&&cnt_num==15 ? c3_weight_data:'d0;

assign o_w16_1 = cnt_gp[0]&&cnt_num==16 ? c3_weight_data:'d0;
assign o_w16_2 = cnt_gp[1]&&cnt_num==16 ? c3_weight_data:'d0;
assign o_w16_3 = cnt_gp[2]&&cnt_num==16 ? c3_weight_data:'d0;
assign o_w16_4 = cnt_gp[3]&&cnt_num==16 ? c3_weight_data:'d0;
assign o_w16_5 = cnt_gp[4]&&cnt_num==16 ? c3_weight_data:'d0;
assign o_w16_6 = cnt_gp[5]&&cnt_num==16 ? c3_weight_data:'d0;

endmodule
