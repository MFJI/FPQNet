`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 09:50:32
// Design Name: 
// Module Name: Top_Lenet
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


module Top_Lenet(
	input	wire		i_sclk,
	input	wire		i_rstn,
	
	input   wire        	in_valid,
    	output  wire        	in_ready,
	input   wire[7:0]   	in_data,
	
	output	wire[3:0]	o_Label,
	output  wire       	o_Label_en
);


wire	L0_vsync;
wire	L0_hsync;
wire	L0_valid;
wire	L0_tdata;
wire	L0_vdone;


//------------------------------------------------------------//
//							输入数据
//------------------------------------------------------------//
wire[7:0]       C1_W_in_data;
wire            C1_W_in_en;
wire[7:0]       C1_B_in_data;
wire            C1_B_in_en;
wire[7:0]       C3_W_in_data;
wire            C3_W_in_en;
wire[7:0]       C3_B_in_data;
wire            C3_B_in_en;
wire[7:0]       F5_W_in_data;
wire            F5_W_in_en;
wire[7:0]       F5_B_in_data;
wire            F5_B_in_en;
wire[7:0]       F6_W_in_data;
wire            F6_W_in_en;
wire[7:0]       F6_B_in_data;
wire            F6_B_in_en;
wire[7:0]       F7_W_in_data;
wire            F7_W_in_en;
wire[7:0]       F7_B_in_data;
wire            F7_B_in_en;
wire[7:0]       Test_in_data;
wire            Test_in_en;
wire            Test_ready;

dataconvert dataconvert_inst(
	.clk              (i_sclk),
	.rstn             (i_rstn),     
  
	//input data
	.in_valid         (in_valid),
	.in_ready         (in_ready),
	.in_data          (in_data),
  
	//output data
	//c1_weight
	.c1_weight_data   (C1_W_in_data),
	.c1_weight_en     (C1_W_in_en),
  
	//c1_bias
	.c1_bias_data     (C1_B_in_data),
	.c1_bias_en       (C1_B_in_en),
  
	//c3_weight
	.c3_weight_data   (C3_W_in_data),
	.c3_weight_en     (C3_W_in_en),
  
	//c3_bias
	.c3_bias_data     (C3_B_in_data),
	.c3_bias_en       (C3_B_in_en),
  
	//f5_weight
	.f5_weight_data   (F5_W_in_data),
	.f5_weight_en     (F5_W_in_en),
  
	//f5_bias
	.f5_bias_data     (F5_B_in_data),
	.f5_bias_en       (F5_B_in_en),
  
	//f6_weight
	.f6_weight_data   (F6_W_in_data),
	.f6_weight_en     (F6_W_in_en),
  
	//f6_bias
	.f6_bias_data     (F6_B_in_data),
	.f6_bias_en       (F6_B_in_en),
  
	//f7_weight
	.f7_weight_data   (F7_W_in_data),
	.f7_weight_en     (F7_W_in_en),
  
	//f7_bias
	.f7_bias_data     (F7_B_in_data),
	.f7_bias_en       (F7_B_in_en),
  
	//test_data
	.test_data        (Test_in_data),
	.test_en          (Test_in_en),
	.test_ready       (Test_ready)
);

//------------------------------------------------------------//
//							测试数据
//------------------------------------------------------------//
buffer_test_data buffer_test_data_inst(
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
        .test_data  	(Test_in_data),
        .test_ready 	(Test_ready),
	.test_en    	(Test_in_en),
	
	.o_vsync	(L0_vsync),
	.o_hsync	(L0_hsync),
	.o_valid	(L0_valid),
	.o_tdata	(L0_tdata),
	.o_vdone	(L0_vdone)		//帧结束
);

//------------------------------------------------------------//
//							卷积C1
//------------------------------------------------------------//
wire[5:0]		C1_W_en;
wire[7:0]		C1_W[5:0];
wire[4:0]		C1_W_addr;

buffer_c1_weight buffer_c1_weight_inst(
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.c1_weight_data (C1_W_in_data),
	.c1_weight_en   (C1_W_in_en),
	
	.o_w_en	(C1_W_en),
	.o_w1		(C1_W[0]),
	.o_w2		(C1_W[1]),
	.o_w3		(C1_W[2]),
	.o_w4		(C1_W[3]),
	.o_w5		(C1_W[4]),
	.o_w6		(C1_W[5]),
	.o_w_addr	(C1_W_addr)
);

wire[7:0]	C1_B[5:0];

buffer_c1_bias buffer_c1_bias_inst(
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.c1_bias_data (C1_B_in_data),
	.c1_bias_en   (C1_B_in_en),
	
	.o_b1		(C1_B[0]),
	.o_b2		(C1_B[1]),
	.o_b3		(C1_B[2]),
	.o_b4		(C1_B[3]),
	.o_b5		(C1_B[4]),
	.o_b6		(C1_B[5])
);

wire[5:0]			C1_hsync;
wire[5:0]			C1_valid;
wire				C1_tdata[5:0];

genvar c1_n;
generate
	for(c1_n=0;c1_n<6;c1_n=c1_n+1)
	begin: conv_1
		LeNet_Conv_C1#(
			.WD				(1),
			.WW				(8)
		)LeNet_Conv_C1_inst(
			.i_sclk			(i_sclk),
			.i_rstn			(i_rstn),
			
			.i_vsync		(L0_vsync),
			.i_hsync		(L0_hsync),
			.i_valid		(L0_valid),
			.i_tdata		(L0_tdata),
			
			.i_W_en			(C1_W_en[c1_n]),
			.i_Weight		(C1_W[c1_n]),
			.i_W_addr		(C1_W_addr),
			.i_Bias			(C1_B[c1_n]),
			
			.o_hsync		(C1_hsync[c1_n]),
			.o_valid		(C1_valid[c1_n]),
			.o_tdata		(C1_tdata[c1_n])
		);
	end
endgenerate
//------------------------------------------------------------//
//							池化S2
//------------------------------------------------------------//
wire[5:0]			S2_vsync;
wire[5:0]			S2_hsync;
wire[5:0]			S2_valid;
wire[2:0]			S2_tdata[5:0];

genvar s2_n;
generate
	for(s2_n=0;s2_n<6;s2_n=s2_n+1)
	begin: pooling_s2
		LeNet_Pooling#(
			.WD				(1),
			.SIZE			(12)
		)LeNet_Pooling_S2_inst(	
			.i_sclk			(i_sclk),
			.i_rstn			(i_rstn),
			.i_vsync		(L0_vsync),
			.i_hsync		(C1_hsync[s2_n]),
			.i_valid		(C1_valid[s2_n]),
			.i_tdata		(C1_tdata[s2_n]),
			.o_vsync		(S2_vsync[s2_n]),
			.o_hsync		(S2_hsync[s2_n]),
			.o_valid		(S2_valid[s2_n]),
			.o_tdata		(S2_tdata[s2_n])
		);
	end
endgenerate 

//------------------------------------------------------------//
//							卷积C3
//------------------------------------------------------------//
wire[5:0]		C3_W_en_1,C3_W_en_2,C3_W_en_3,C3_W_en_4;
wire[5:0]		C3_W_en_5,C3_W_en_6,C3_W_en_7,C3_W_en_8;
wire[5:0]		C3_W_en_9,C3_W_en_10,C3_W_en_11,C3_W_en_12;
wire[5:0]		C3_W_en_13,C3_W_en_14,C3_W_en_15,C3_W_en_16;

wire[7:0]		C3_W1[5:0],C3_W2[5:0],C3_W3[5:0],C3_W4[5:0];
wire[7:0]		C3_W5[5:0],C3_W6[5:0],C3_W7[5:0],C3_W8[5:0];
wire[7:0]		C3_W9[5:0],C3_W10[5:0],C3_W11[5:0],C3_W12[5:0];
wire[7:0]		C3_W13[5:0],C3_W14[5:0],C3_W15[5:0],C3_W16[5:0];

wire[4:0]		C3_W_addr;

buffer_c3_weight buffer_c3_weight_inst(
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.c3_weight_data	(C3_W_in_data),
    	.c3_weight_en  	(C3_W_in_en),
	
	.o_w_en_1		(C3_W_en_1),
	.o_w1_1		(C3_W1[0]),
	.o_w1_2		(C3_W1[1]),
	.o_w1_3		(C3_W1[2]),
	.o_w1_4		(C3_W1[3]),
	.o_w1_5		(C3_W1[4]),
	.o_w1_6		(C3_W1[5]),
	
	.o_w_en_2		(C3_W_en_2),
	.o_w2_1		(C3_W2[0]),
	.o_w2_2		(C3_W2[1]),
	.o_w2_3		(C3_W2[2]),
	.o_w2_4		(C3_W2[3]),
	.o_w2_5		(C3_W2[4]),
	.o_w2_6		(C3_W2[5]),
	
	.o_w_en_3		(C3_W_en_3),
	.o_w3_1		(C3_W3[0]),
	.o_w3_2		(C3_W3[1]),
	.o_w3_3		(C3_W3[2]),
	.o_w3_4		(C3_W3[3]),
	.o_w3_5		(C3_W3[4]),
	.o_w3_6		(C3_W3[5]),
	
	.o_w_en_4		(C3_W_en_4),
	.o_w4_1		(C3_W4[0]),
	.o_w4_2		(C3_W4[1]),
	.o_w4_3		(C3_W4[2]),
	.o_w4_4		(C3_W4[3]),
	.o_w4_5		(C3_W4[4]),
	.o_w4_6		(C3_W4[5]),
	
	.o_w_en_5		(C3_W_en_5),
	.o_w5_1		(C3_W5[0]),
	.o_w5_2		(C3_W5[1]),
	.o_w5_3		(C3_W5[2]),
	.o_w5_4		(C3_W5[3]),
	.o_w5_5		(C3_W5[4]),
	.o_w5_6		(C3_W5[5]),
	
	.o_w_en_6		(C3_W_en_6),
	.o_w6_1		(C3_W6[0]),
	.o_w6_2		(C3_W6[1]),
	.o_w6_3		(C3_W6[2]),
	.o_w6_4		(C3_W6[3]),
	.o_w6_5		(C3_W6[4]),
	.o_w6_6		(C3_W6[5]),
	
	.o_w_en_7		(C3_W_en_7),
	.o_w7_1		(C3_W7[0]),
	.o_w7_2		(C3_W7[1]),
	.o_w7_3		(C3_W7[2]),
	.o_w7_4		(C3_W7[3]),
	.o_w7_5		(C3_W7[4]),
	.o_w7_6		(C3_W7[5]),
	
	.o_w_en_8		(C3_W_en_8),
	.o_w8_1		(C3_W8[0]),
	.o_w8_2		(C3_W8[1]),
	.o_w8_3		(C3_W8[2]),
	.o_w8_4		(C3_W8[3]),
	.o_w8_5		(C3_W8[4]),
	.o_w8_6		(C3_W8[5]),
	
	.o_w_en_9		(C3_W_en_9),
	.o_w9_1		(C3_W9[0]),
	.o_w9_2		(C3_W9[1]),
	.o_w9_3		(C3_W9[2]),
	.o_w9_4		(C3_W9[3]),
	.o_w9_5		(C3_W9[4]),
	.o_w9_6		(C3_W9[5]),
	
	.o_w_en_10		(C3_W_en_10),
	.o_w10_1		(C3_W10[0]),
	.o_w10_2		(C3_W10[1]),
	.o_w10_3		(C3_W10[2]),
	.o_w10_4		(C3_W10[3]),
	.o_w10_5		(C3_W10[4]),
	.o_w10_6		(C3_W10[5]),
	
	.o_w_en_11		(C3_W_en_11),
	.o_w11_1		(C3_W11[0]),
	.o_w11_2		(C3_W11[1]),
	.o_w11_3		(C3_W11[2]),
	.o_w11_4		(C3_W11[3]),
	.o_w11_5		(C3_W11[4]),
	.o_w11_6		(C3_W11[5]),
	
	.o_w_en_12		(C3_W_en_12),
	.o_w12_1		(C3_W12[0]),
	.o_w12_2		(C3_W12[1]),
	.o_w12_3		(C3_W12[2]),
	.o_w12_4		(C3_W12[3]),
	.o_w12_5		(C3_W12[4]),
	.o_w12_6		(C3_W12[5]),
	
	.o_w_en_13		(C3_W_en_13),
	.o_w13_1		(C3_W13[0]),
	.o_w13_2		(C3_W13[1]),
	.o_w13_3		(C3_W13[2]),
	.o_w13_4		(C3_W13[3]),
	.o_w13_5		(C3_W13[4]),
	.o_w13_6		(C3_W13[5]),
	
	.o_w_en_14		(C3_W_en_14),
	.o_w14_1		(C3_W14[0]),
	.o_w14_2		(C3_W14[1]),
	.o_w14_3		(C3_W14[2]),
	.o_w14_4		(C3_W14[3]),
	.o_w14_5		(C3_W14[4]),
	.o_w14_6		(C3_W14[5]),
	
	.o_w_en_15		(C3_W_en_15),
	.o_w15_1		(C3_W15[0]),
	.o_w15_2		(C3_W15[1]),
	.o_w15_3		(C3_W15[2]),
	.o_w15_4		(C3_W15[3]),
	.o_w15_5		(C3_W15[4]),
	.o_w15_6		(C3_W15[5]),
	
	.o_w_en_16		(C3_W_en_16),
	.o_w16_1		(C3_W16[0]),
	.o_w16_2		(C3_W16[1]),
	.o_w16_3		(C3_W16[2]),
	.o_w16_4		(C3_W16[3]),
	.o_w16_5		(C3_W16[4]),
	.o_w16_6		(C3_W16[5]),
	
	.o_w_addr		(C3_W_addr)
);

wire[7:0]	C3_B[15:0];

buffer_c3_bias buffer_c3_bias_inst(
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.c3_bias_data 	(C3_B_in_data),
   	.c3_bias_en   	(C3_B_in_en),
	
	.o_b1		(C3_B[0]),
	.o_b2		(C3_B[1]),
	.o_b3		(C3_B[2]),
	.o_b4		(C3_B[3]),
	.o_b5		(C3_B[4]),
	.o_b6		(C3_B[5]),
	.o_b7		(C3_B[6]),
	.o_b8		(C3_B[7]),
	.o_b9		(C3_B[8]),
	.o_b10		(C3_B[9]),
	.o_b11		(C3_B[10]),
	.o_b12		(C3_B[11]),
	.o_b13		(C3_B[12]),
	.o_b14		(C3_B[13]),
	.o_b15		(C3_B[14]),
	.o_b16		(C3_B[15])
);


wire				C3_hsync;
wire				C3_valid;
wire				C3_tdata[15:0];

LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_1(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_1),
	.i_Weight_1	(C3_W1[0]),
	.i_Weight_2	(C3_W1[1]),
	.i_Weight_3	(C3_W1[2]),
	.i_Weight_4	(C3_W1[3]),
	.i_Weight_5	(C3_W1[4]),
	.i_Weight_6	(C3_W1[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[0]),
	
	.o_hsync	(C3_hsync),
	.o_valid	(C3_valid),
	.o_tdata	(C3_tdata[0])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_2(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_2),
	.i_Weight_1	(C3_W2[0]),
	.i_Weight_2	(C3_W2[1]),
	.i_Weight_3	(C3_W2[2]),
	.i_Weight_4	(C3_W2[3]),
	.i_Weight_5	(C3_W2[4]),
	.i_Weight_6	(C3_W2[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[1]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[1])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_3(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_3),
	.i_Weight_1	(C3_W3[0]),
	.i_Weight_2	(C3_W3[1]),
	.i_Weight_3	(C3_W3[2]),
	.i_Weight_4	(C3_W3[3]),
	.i_Weight_5	(C3_W3[4]),
	.i_Weight_6	(C3_W3[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[2]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[2])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_4(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_4),
	.i_Weight_1	(C3_W4[0]),
	.i_Weight_2	(C3_W4[1]),
	.i_Weight_3	(C3_W4[2]),
	.i_Weight_4	(C3_W4[3]),
	.i_Weight_5	(C3_W4[4]),
	.i_Weight_6	(C3_W4[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[3]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[3])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_5(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_5),
	.i_Weight_1	(C3_W5[0]),
	.i_Weight_2	(C3_W5[1]),
	.i_Weight_3	(C3_W5[2]),
	.i_Weight_4	(C3_W5[3]),
	.i_Weight_5	(C3_W5[4]),
	.i_Weight_6	(C3_W5[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[4]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[4])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_6(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_6),
	.i_Weight_1	(C3_W6[0]),
	.i_Weight_2	(C3_W6[1]),
	.i_Weight_3	(C3_W6[2]),
	.i_Weight_4	(C3_W6[3]),
	.i_Weight_5	(C3_W6[4]),
	.i_Weight_6	(C3_W6[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[5]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[5])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_7(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_7),
	.i_Weight_1	(C3_W7[0]),
	.i_Weight_2	(C3_W7[1]),
	.i_Weight_3	(C3_W7[2]),
	.i_Weight_4	(C3_W7[3]),
	.i_Weight_5	(C3_W7[4]),
	.i_Weight_6	(C3_W7[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[6]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[6])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_8(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_8),
	.i_Weight_1	(C3_W8[0]),
	.i_Weight_2	(C3_W8[1]),
	.i_Weight_3	(C3_W8[2]),
	.i_Weight_4	(C3_W8[3]),
	.i_Weight_5	(C3_W8[4]),
	.i_Weight_6	(C3_W8[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[7]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[7])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_9(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_9),
	.i_Weight_1	(C3_W9[0]),
	.i_Weight_2	(C3_W9[1]),
	.i_Weight_3	(C3_W9[2]),
	.i_Weight_4	(C3_W9[3]),
	.i_Weight_5	(C3_W9[4]),
	.i_Weight_6	(C3_W9[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[8]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[8])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_10(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_10),
	.i_Weight_1	(C3_W10[0]),
	.i_Weight_2	(C3_W10[1]),
	.i_Weight_3	(C3_W10[2]),
	.i_Weight_4	(C3_W10[3]),
	.i_Weight_5	(C3_W10[4]),
	.i_Weight_6	(C3_W10[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[9]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[9])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_11(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_11),
	.i_Weight_1	(C3_W11[0]),
	.i_Weight_2	(C3_W11[1]),
	.i_Weight_3	(C3_W11[2]),
	.i_Weight_4	(C3_W11[3]),
	.i_Weight_5	(C3_W11[4]),
	.i_Weight_6	(C3_W11[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[10]),

	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[10])
);
LeNet_Conv_C3_top#(
	.WD		(3),
	.WW		(8),
	.GP		(6)
)LeNet_Conv_C3_top_12(		
	.i_sclk	(i_sclk),
	.i_rstn	(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en	(C3_W_en_12),
	.i_Weight_1	(C3_W12[0]),
	.i_Weight_2	(C3_W12[1]),
	.i_Weight_3	(C3_W12[2]),
	.i_Weight_4	(C3_W12[3]),
	.i_Weight_5	(C3_W12[4]),
	.i_Weight_6	(C3_W12[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias	(C3_B[11]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[11])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_13(		
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en		(C3_W_en_13),
	.i_Weight_1	(C3_W13[0]),
	.i_Weight_2	(C3_W13[1]),
	.i_Weight_3	(C3_W13[2]),
	.i_Weight_4	(C3_W13[3]),
	.i_Weight_5	(C3_W13[4]),
	.i_Weight_6	(C3_W13[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias		(C3_B[12]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[12])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_14(		
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en		(C3_W_en_14),
	.i_Weight_1	(C3_W14[0]),
	.i_Weight_2	(C3_W14[1]),
	.i_Weight_3	(C3_W14[2]),
	.i_Weight_4	(C3_W14[3]),
	.i_Weight_5	(C3_W14[4]),
	.i_Weight_6	(C3_W14[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias		(C3_B[13]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[13])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_15(		
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en		(C3_W_en_15),
	.i_Weight_1	(C3_W15[0]),
	.i_Weight_2	(C3_W15[1]),
	.i_Weight_3	(C3_W15[2]),
	.i_Weight_4	(C3_W15[3]),
	.i_Weight_5	(C3_W15[4]),
	.i_Weight_6	(C3_W15[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias		(C3_B[14]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[14])
);
LeNet_Conv_C3_top#(
	.WD			(3),
	.WW			(8),
	.GP			(6)
)LeNet_Conv_C3_top_16(		
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync	(S2_vsync[0]),
	.i_hsync	(S2_hsync[0]),
	.i_valid	(S2_valid[0]),
	.i_tdata_1	(S2_tdata[0]),
	.i_tdata_2	(S2_tdata[1]),
	.i_tdata_3	(S2_tdata[2]),
	.i_tdata_4	(S2_tdata[3]),
	.i_tdata_5	(S2_tdata[4]),
	.i_tdata_6	(S2_tdata[5]),
	
	.i_W_en		(C3_W_en_16),
	.i_Weight_1	(C3_W16[0]),
	.i_Weight_2	(C3_W16[1]),
	.i_Weight_3	(C3_W16[2]),
	.i_Weight_4	(C3_W16[3]),
	.i_Weight_5	(C3_W16[4]),
	.i_Weight_6	(C3_W16[5]),
	.i_W_addr	(C3_W_addr),
	.i_Bias		(C3_B[15]),
	
	.o_hsync	(),
	.o_valid	(),
	.o_tdata	(C3_tdata[15])
);

//------------------------------------------------------------//
//							池化S4
//------------------------------------------------------------//
wire[15:0]				S4_vsync;
wire[15:0]				S4_hsync;
wire[15:0]				S4_valid;
wire[2:0]				S4_tdata[15:0];

genvar s4_n;
generate
	for(s4_n=0;s4_n<16;s4_n=s4_n+1)
	begin: pooling_s4
		LeNet_Pooling#(
			.WD			(1),
			.SIZE			(4)
		)LeNet_Pooling_S4_inst(	
			.i_sclk		(i_sclk),
			.i_rstn		(i_rstn),
			.i_vsync		(S2_vsync[0]),
			.i_hsync		(C3_hsync),
			.i_valid		(C3_valid),
			.i_tdata		(C3_tdata[s4_n]),
			.o_vsync		(S4_vsync[s4_n]),
			.o_hsync		(S4_hsync[s4_n]),
			.o_valid		(S4_valid[s4_n]),
			.o_tdata		(S4_tdata[s4_n])
		);
	end
endgenerate 

//------------------------------------------------------------//
//							特征映射
//------------------------------------------------------------//
wire				fm_valid;
wire[2:0]			fm_tdata;

feature_map#(
	.WD			(3),
	.WW			(8),
	.SIZE			(16)
)feature_map_inst(		
	.i_sclk		(i_sclk),
	.i_rstn		(i_rstn),
	
	.i_vsync		(S4_vsync[0]),
	.i_hsync		(S4_hsync[0]),
	.i_valid		(S4_valid[0]),
	.i_tdata_1		(S4_tdata[0]),
	.i_tdata_2		(S4_tdata[1]),
	.i_tdata_3		(S4_tdata[2]),
	.i_tdata_4		(S4_tdata[3]),
	.i_tdata_5		(S4_tdata[4]),
	.i_tdata_6		(S4_tdata[5]),
	.i_tdata_7		(S4_tdata[6]),
	.i_tdata_8		(S4_tdata[7]),
	.i_tdata_9		(S4_tdata[8]),
	.i_tdata_10		(S4_tdata[9]),
	.i_tdata_11		(S4_tdata[10]),
	.i_tdata_12		(S4_tdata[11]),
	.i_tdata_13		(S4_tdata[12]),
	.i_tdata_14		(S4_tdata[13]),
	.i_tdata_15		(S4_tdata[14]),
	.i_tdata_16		(S4_tdata[15]),

	.o_valid		(fm_valid),
	.o_tdata		(fm_tdata)
);
//------------------------------------------------------------//
//							全连接F5
//------------------------------------------------------------//
wire					F5_w_en;
wire[7:0]				F5_w_num;
wire[7:0]				F5_weight;
wire[7:0]				F5_w_addr;

wire					F5_b_en;
wire[7:0]				F5_b_num;
wire[7:0]				F5_bias;

buffer_f5_weight buffer_f5_weight_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
	.f5_weight_data (F5_W_in_data),
	.f5_weight_en   (F5_W_in_en),
	
	.o_w_en			(F5_w_en),
	.o_w_num		(F5_w_num),
	.o_weight		(F5_weight),
	.o_w_addr		(F5_w_addr)
);
buffer_f5_bias buffer_f5_bias_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
    .f5_bias_data   (F5_B_in_data),
	.f5_bias_en     (F5_B_in_en),
	
	.o_b_en			(F5_b_en),
	.o_b_num		(F5_b_num),
	.o_bias			(F5_bias)
);

wire[119:0]		        F5_valid;
wire[119:0]			F5_tdata;

genvar f5_n;
generate
	for(f5_n=0;f5_n<120;f5_n=f5_n+1)
	begin: fc_f5
	
		wire					sum_done;
		wire signed[11+8:0]		sum_data;
		
		LeNet_Full_Connect#(
			.WD				(3),
			.WW				(8)
		)LeNet_Full_Connect_inst(
			.i_sclk			(i_sclk),
			.i_rstn			(i_rstn),
			
			.i_valid		(fm_valid),
			.i_tdata		(fm_tdata),
			
			.i_channel		(f5_n+1),
			.i_W_en			(F5_w_en),
			.i_W_num		(F5_w_num),
			.i_Weight		(F5_weight),
			.i_W_addr		(F5_w_addr),
			.i_B_en			(F5_b_en),
			.i_B_num		(F5_b_num),
			.i_Bias			(F5_bias),
			
			.o_valid		(sum_done),
			.o_tdata		(sum_data)
		);
		Sigmoid#(
			.WI 			(20)
		)Sigmoid_inst(
			.i_sclk		(i_sclk),
			.i_rstn      		(i_rstn),
			.i_valid		(sum_done),
			.i_tdata		(sum_data),
			.o_valid		(F5_valid[f5_n]),
			.o_tdata		(F5_tdata[f5_n])
		);
	end
endgenerate 

reg 			F5_valid_d1;
reg [7:0]		cnt_f5;
reg 			F5_dat_en;
reg 			F5_dat;

always@(posedge i_sclk)
	if(!i_rstn)			F5_valid_d1 <= 'd0;
	else 
	  if(F5_valid[0])		F5_valid_d1 <= 'd1;
	  else 
	    if(cnt_f5==119)		F5_valid_d1 <= 'd0;
	    else			F5_valid_d1 <= F5_valid_d1;

always@(posedge i_sclk)
	if(F5_valid_d1)	cnt_f5 <= cnt_f5 + 'd1;
	else			cnt_f5 <= 'd0;

always@(posedge i_sclk)	F5_dat_en <= F5_valid_d1;
always@(posedge i_sclk)
	if(F5_valid_d1)	F5_dat <= F5_tdata[cnt_f5];
	else			F5_dat <= 'd0;

//------------------------------------------------------------//
//							全连接F6
//------------------------------------------------------------//
wire					F6_w_en;
wire[7:0]				F6_w_num;
wire[7:0]				F6_weight;
wire[7:0]				F6_w_addr;

wire					F6_b_en;
wire[7:0]				F6_b_num;
wire[7:0]				F6_bias;

buffer_f6_weight buffer_f6_weight_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
	.f6_weight_data (F6_W_in_data),
	.f6_weight_en   (F6_W_in_en),
	
	.o_w_en		(F6_w_en),
	.o_w_num		(F6_w_num),
	.o_weight		(F6_weight),
	.o_w_addr		(F6_w_addr)
);
buffer_f6_bias buffer_f6_bias_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
    .f6_bias_data   (F6_B_in_data),
	.f6_bias_en     (F6_B_in_en),
	
	.o_b_en			(F6_b_en),
	.o_b_num		(F6_b_num),
	.o_bias			(F6_bias)
);

wire[83:0]			F6_valid;
wire[83:0]			F6_tdata;

genvar f6_n;
generate
	for(f6_n=0;f6_n<84;f6_n=f6_n+1)
	begin: fc_f6
	
		wire					sum_done;
		wire signed[11+8:0]		sum_data;
		
		LeNet_Full_Connect#(
			.WD				(1),
			.WW				(8)
		)LeNet_Full_Connect_inst(
			.i_sclk			(i_sclk),
			.i_rstn			(i_rstn),
			
			.i_valid		(F5_dat_en),
			.i_tdata		(F5_dat),
			
			.i_channel		(f6_n+1),
			.i_W_en			(F6_w_en),
			.i_W_num		(F6_w_num),
			.i_Weight		(F6_weight),
			.i_W_addr		(F6_w_addr),
			.i_B_en			(F6_b_en),
			.i_B_num		(F6_b_num),
			.i_Bias			(F6_bias),
			
			.o_valid		(sum_done),
			.o_tdata		(sum_data)
		);
		Sigmoid#(
			.WI 			(20)
		)Sigmoid_inst(
			.i_sclk		(i_sclk),
			.i_rstn		(i_rstn),
			.i_valid		(sum_done),
			.i_tdata		(sum_data),
			.o_valid		(F6_valid[f6_n]),
			.o_tdata		(F6_tdata[f6_n])
		);
	end
endgenerate 

reg 			F6_valid_d1;
reg [7:0]		cnt_f6;
reg 			F6_dat_en;
reg 			F6_dat;

always@(posedge i_sclk)
	if(!i_rstn)		F6_valid_d1 <= 'd0;
	else 
	  if(F6_valid[0])	F6_valid_d1 <= 'd1;
	  else 
	    if(cnt_f6==83)	F6_valid_d1 <= 'd0;
	    else		F6_valid_d1 <= F6_valid_d1;

always@(posedge i_sclk)
	if(F6_valid_d1)	cnt_f6 <= cnt_f6 + 'd1;
	else			cnt_f6 <= 'd0;

always@(posedge i_sclk)	F6_dat_en <= F6_valid_d1;
always@(posedge i_sclk)
	if(F6_valid_d1)	F6_dat <= F6_tdata[cnt_f6];
	else			F6_dat <= 'd0;

//------------------------------------------------------------//
//							全连接F7
//------------------------------------------------------------//
wire					F7_w_en;
wire[7:0]				F7_w_num;
wire[7:0]				F7_weight;
wire[7:0]				F7_w_addr;

wire					F7_b_en;
wire[7:0]				F7_b_num;
wire[7:0]				F7_bias;

buffer_f7_weight buffer_f7_weight_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
	.f7_weight_data (F7_W_in_data),
	.f7_weight_en   (F7_W_in_en),
	
	.o_w_en			(F7_w_en),
	.o_w_num		(F7_w_num),
	.o_weight		(F7_weight),
	.o_w_addr		(F7_w_addr)
);
buffer_f7_bias buffer_f7_bias_inst(
	.i_sclk			(i_sclk),
	.i_rstn			(i_rstn),
	
    .f7_bias_data   (F7_B_in_data),
	.f7_bias_en     (F7_B_in_en),
	
	.o_b_en			(F7_b_en),
	.o_b_num		(F7_b_num),
	.o_bias			(F7_bias)
);

wire [9:0]		F7_valid;
wire signed[11+8:0]	F7_tdata[9:0];

genvar f7_n;
generate
	for(f7_n=0;f7_n<10;f7_n=f7_n+1)
	begin: fc_f7
	
		//wire					sum_done;
		//wire signed[11+8:0]		sum_data;
		
		LeNet_Full_Connect#(
			.WD				(1),
			.WW				(8)
		)LeNet_Full_Connect_inst(
			.i_sclk			(i_sclk),
			.i_rstn			(i_rstn),
			
			.i_valid		(F6_dat_en),
			.i_tdata		(F6_dat),
			
			.i_channel		(f7_n+1),
			.i_W_en			(F7_w_en),
			.i_W_num		(F7_w_num),
			.i_Weight		(F7_weight),
			.i_W_addr		(F7_w_addr),
			.i_B_en			(F7_b_en),
			.i_B_num		(F7_b_num),
			.i_Bias			(F7_bias),
			
			.o_valid		(F7_valid[f7_n]),
			.o_tdata		(F7_tdata[f7_n])
		);
	end
endgenerate 

reg 				F7_valid_d1;
reg [7:0]			cnt_f7;
reg 				F7_dat_en;
reg  signed[11+4:0]	F7_dat;

always@(posedge i_sclk)
	if(!i_rstn)		F7_valid_d1 <= 'd0;
	else 
	  if(F7_valid[0])	F7_valid_d1 <= 'd1;
	  else 
	    if(cnt_f7==9)	F7_valid_d1 <= 'd0;
	    else		F7_valid_d1 <= F7_valid_d1;

always@(posedge i_sclk)	F7_dat_en <= F7_valid_d1;

always@(posedge i_sclk)
	if(F7_valid_d1 || F7_dat_en)	cnt_f7 <= cnt_f7 + 'd1;
	else				cnt_f7 <= 'd0;

always@(posedge i_sclk)	F7_dat_en <= F7_valid_d1;
always@(posedge i_sclk)
	if(F7_valid_d1)	F7_dat <= F7_tdata[cnt_f7];
	else			F7_dat <= 'd0;

//------------------------------------------------------------//
//				F7不激活，直接找最大值定位label即可
//------------------------------------------------------------//
reg signed[11+4:0]	F7_max;
reg [7:0]		max_label;
reg 			max_label_en;
reg [7:0]		pred_label;
reg                 	pred_label_en;

always@(posedge i_sclk)
	if(F7_dat_en)
	begin
		if(F7_dat>F7_max)
		begin
			F7_max <= F7_dat;
			max_label <= cnt_f7;
			max_label_en <= 'd1;
		end
		else
		begin
			F7_max <= F7_max;
			max_label <= max_label;
			max_label_en <= max_label_en;
		end
	end
	else
	begin
		F7_max <= 'd0;
		max_label <= 'd0;
		max_label_en <= 'd0;
	end

always@(posedge i_sclk)
	if(!i_rstn)	
        begin	
	  pred_label <= 'd0;
	  pred_label_en <= 'd0;
	end
	else 
	begin
	  if(cnt_f7=='d11)	
	  begin
	     pred_label <= max_label;
	     pred_label_en <= 'd1;
	  end
	  else
	  begin
	     pred_label_en <= 'd0;
	  end
    end 
	    

assign o_Label = pred_label;
assign o_Label_en = pred_label_en;



endmodule
