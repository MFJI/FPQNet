module dataconvert#(
	parameter				WD  = 8
)(
  input wire clk,
  input wire rstn,
  
  //input data
  input wire in_valid,
  output reg in_ready,
  input wire[WD-1:0] in_data,
  
  //output data
  //c1_weight
  output reg[WD-1:0] c1_weight_data,
  output reg c1_weight_en,
  
  //c1_bias
  output reg[WD-1:0] c1_bias_data,
  output reg c1_bias_en,
  
  //c3_weight
  output reg[WD-1:0] c3_weight_data,
  output reg c3_weight_en,
  
  //c3_bias
  output reg[WD-1:0] c3_bias_data,
  output reg c3_bias_en,
  
  //f5_weight
  output reg[WD-1:0] f5_weight_data,
  output reg f5_weight_en,
  
  //f5_bias
  output reg[WD-1:0] f5_bias_data,
  output reg f5_bias_en,
  
  //f6_weight
  output reg[WD-1:0] f6_weight_data,
  output reg f6_weight_en,
  
  //f6_bias
  output reg[WD-1:0] f6_bias_data,
  output reg f6_bias_en,
  
  //f7_weight
  output reg[WD-1:0] f7_weight_data,
  output reg f7_weight_en,
  
  //f7_bias
  output reg[WD-1:0] f7_bias_data,
  output reg f7_bias_en,
  
  //test_data
  output reg[WD-1:0] test_data,
  output reg test_en,
  input  wire test_ready 
);

  reg[18:0] count; 
  
  always @(posedge clk)
    if(!rstn)
	  count <= 1;
	else
	begin
	  if(in_valid && in_ready)
	    count <= count + 1;
	  else
	    count <= count;
	end
 
always @(posedge clk)
  if(!rstn)
    in_ready <= 0;
  else
    if(count > 0 && count < 44426)
      in_ready <= 1;
    else
      in_ready <= test_ready;
 
 
 
always @(posedge clk)
if(rstn && in_valid && in_ready && count>0 && count<151)
  c1_weight_data <= in_data;
else
  c1_weight_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>0 && count<151)
  c1_weight_en <= 1;
else
  c1_weight_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>150 && count<157)
  c1_bias_data <= in_data;
else
  c1_bias_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>150 && count<157)
  c1_bias_en <= 1;
else
  c1_bias_en <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>156 && count<2557)
  c3_weight_data <= in_data;
else
  c3_weight_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>156 && count<2557)
  c3_weight_en <= 1;
else
  c3_weight_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>2556 && count<2573)
  c3_bias_data <= in_data;
else
  c3_bias_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>2556 && count<2573)
  c3_bias_en <= 1;
else
  c3_bias_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>2572 && count<33293)
  f5_weight_data <= in_data;
else
  f5_weight_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>2572 && count<33293)
  f5_weight_en <= 1;
else
  f5_weight_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>33292  && count<33413)
  f5_bias_data <= in_data;
else
  f5_bias_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>33292  && count<33413)
  f5_bias_en <= 1;
else
  f5_bias_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>33412  && count<43493)
  f6_weight_data <= in_data;
else
  f6_weight_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>33412  && count<43493)
  f6_weight_en <= 1;
else
  f6_weight_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>43492  && count<43577)
  f6_bias_data <= in_data;
else
  f6_bias_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>43492  && count<43577)
  f6_bias_en <= 1;
else
  f6_bias_en <= 0;  
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>43576  && count<44417)
  f7_weight_data <= in_data;
else
  f7_weight_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>43576  && count<44417)
  f7_weight_en <= 1;
else
  f7_weight_en <= 0;
  
always @(posedge clk)
if(rstn && in_valid && in_ready && count>44416  && count<44427)
  f7_bias_data <= in_data;
else
  f7_bias_data <= 0;

always @(posedge clk)
if(rstn && in_valid && in_ready && count>44416  && count<44427)
  f7_bias_en <= 1;
else
  f7_bias_en <= 0;  

always @(posedge clk)
if(rstn && in_valid && in_ready && count> 44426)
  test_data <= in_data;
else
  test_data <= 0;

always @(posedge clk)
if(rstn && in_valid && count> 44426 )
  test_en <= 1;
else
  test_en <= 0;  
  
//  assign in_ready = 1;

endmodule




