`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/11 10:43:55
// Design Name: 
// Module Name: buffer_test_data
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


module buffer_test_data(
	input	wire	i_sclk,
	input	wire	i_rstn,

        input   wire[7:0]  test_data,
	input   wire    test_en,
	output  wire    test_ready,
	
	output	wire	o_vsync,
	output	wire	o_hsync,
	output	wire	o_valid,
	output	wire	o_tdata,
	output	wire	o_vdone		//帧结束
);


//------------------------------------------//
//					PARAM					//
//------------------------------------------//
parameter	WDATA    = 8;
parameter	H_FBLANK = 5;
parameter	H_ACTIVE = 28;
parameter	H_BBLANK = 5;
parameter	H_BALNK	 = 5;
parameter	H_TOTAL	 = H_FBLANK + H_ACTIVE + H_BBLANK + H_BALNK;
parameter	V_FBLANK = 1;
parameter	V_ACTIVE = 28;
parameter	V_BBLANK = 1;
parameter	V_BALNK	 = 1;
parameter	V_TOTAL	 = V_FBLANK + V_ACTIVE + V_BBLANK + V_BALNK;

parameter	PIX_NUM = H_ACTIVE*V_ACTIVE - 1;
//------------------------------------------//
//					SIGNAL					//
//------------------------------------------//

reg 		start;
reg 		stop;
reg [7:0]	cnt_c,cnt_r;

reg 		de_ahead;
reg [9:0]	de_cnt;

reg 		vs;
reg 		hs;
reg 		de;

reg            ready;

reg 		vs1;
reg 		hs1;
reg 		de1;
reg 		stop1;
reg 		vs2;
reg 		hs2;
reg 		de2;
reg 		stop2;
reg 		vs3;
reg 		hs3;
reg 		de3;
reg 		stop3;

//------------------------------------------//
//					CODE					//
//------------------------------------------//

assign o_vsync = vs2;
assign o_hsync = hs2;
assign o_valid = de2;
assign o_tdata = test_data[0];
assign o_vdone = stop2;
assign test_ready =ready;

always @(posedge i_sclk)	de <= de_ahead;


always @(posedge i_sclk)
	if(!i_rstn)		start <= 'd0;
	else if(test_en)	start <= 'd1;
	else if(stop)		start <= 'd0;

always @(posedge i_sclk)
	if(!i_rstn)
	begin
		stop <= 'd0;
		cnt_c <= 'd1;
		cnt_r <= 'd1;
	end
	else if(start)
	begin
		if(cnt_c==H_TOTAL)
		begin
			cnt_c <= 'd1;
			if(cnt_r==V_TOTAL)
			begin
				stop <= 'd1;
				cnt_r <= 'd1;
			end
			else
			begin
				stop <= 'd0;
				cnt_r <= cnt_r + 'd1;
			end
		end
		else
		begin
			cnt_c <= cnt_c + 'd1;
			cnt_r <= cnt_r;
		end
	end
	else
	begin
		stop <= 'd0;
		cnt_c <= 'd1;
		cnt_r <= 'd1;
	end

always @(posedge i_sclk)
	if(!i_rstn)								vs <= 'd0;
	else if(cnt_c==H_FBLANK)
	begin
		if(cnt_r==V_FBLANK)					vs <= 'd1;
		else if(cnt_r==V_FBLANK + V_BALNK)	vs <= 'd0;
	end

always @(posedge i_sclk)
	if(!i_rstn)
	begin
		hs <= 'd0;
		de_ahead <= 'd0;
	end
	else if(cnt_r>V_TOTAL-V_ACTIVE&&cnt_r<=V_TOTAL)
	begin
		if(cnt_c==H_FBLANK)					hs <= 'd1;
		else if(cnt_c==H_FBLANK + H_BALNK)	hs <= 'd0;
		
		if(cnt_c==H_TOTAL-H_ACTIVE-1)		de_ahead <= 'd1;
		else if(cnt_c==H_TOTAL-1)			de_ahead <= 'd0;
	end

always @(posedge i_sclk)
	if(!i_rstn)
        begin				
	  de_cnt <= 'd0;
	  ready <= 0;
	end
	else
	begin 
	  if(de_ahead)
	  begin
		if(de_cnt==PIX_NUM+1)
		begin	       
		  de_cnt <= 'd0;
		  ready <= 0;
		end
		else				
		begin 
		  de_cnt <= de_cnt + 'd1;
		  ready <= 1;
		end
	  end
	  else
	  begin
	    if(de_cnt==PIX_NUM+1)
	    begin
	      de_cnt <= 'd0;
	      ready <= 0;
	    end
	    else
	    begin
	      de_cnt <= de_cnt;
	      ready <= 0;
	    end
	  end
	end

always @(posedge i_sclk)
begin
  vs1 <= vs;
  hs1 <= hs;
  de1 <= de;
  stop1 <= stop;
  vs2 <= vs1;
  hs2 <= hs1;
  de2 <= de1;
  stop2 <= stop1;
  vs3 <= vs2;
  hs3 <= hs2;
  de3 <= de2;
  stop3 <= stop2;
end

endmodule
