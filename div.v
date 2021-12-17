module div (
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [7:0] i_a,
	input  [4:0] i_b,
	output [7:0] o_q,
	output [4:0] o_r,
	output       o_out_valid,
	output [50:0] number
);

endmodule

module stage_1 (
	input  [7:0] i_a,
	input  [4:0] i_b,
	output o_diff;
	output [6:0] o_a;
	output o_q,
	output [4:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:100];

wire inv_b_nor, b_nor, mux_ctrl, diff, borrow;

NR4 nr1(b_nor, i_b[4], i_b[3], i_b[2], i_b[1], numbers[0]);
IV in1(inv_b_nor, b_nor, numbers[1]);
HS1 hs1(i_a[3], i_b[3], diff, borrow, numbers[2]);
OR2 or1(mux_ctrl, borrow, inv_b_nor, numbers[3]);
MUX21H mux1(mux_ctrl, diff, i_a);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input clk,
	input rst_n,
	output [BW-1:0] Q,
	input [BW-1:0] D,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module HS1(
	input i_a,
	input i_b,
	output o_diff,
	output o_borrow,
	output [50:0] number,
);

wire inv_a;
wire [50:0] numbers [0:2];

IV inv1(inv_a, i_a, numbers[0]);
ND2 nd1(o_borrow, inv_a, i_b, numbers[1]);
EO2 eo1(o_diff, i_a, i_b, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module FS1(
	input i_a,
	input i_b,
	input i_borrow,
	output o_diff,
	output o_borrow,
	output [50:0] number
);

wire inv_a;
wire [2:0] prod;
wire [50:0] numbers [0:5];

IV inv1(inv_a, i_a, numbers[0]);
ND2 nd1(prod[0], inv_a, i_b, numbers[1]);
ND2 nd2(prod[1], i_b, i_borrow, numbers[2]);
ND2 nd3(prod[2], inv_a, i_borrow, numbers[3]);
ND3 nd4(o_borrow, prod[0], prod[1], prod[2], numbers[4]);
EO3 eo1(o_diff, i_a, i_b, i_borrow, numbers[5]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<6; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module FSP#(
	parameter BW = 2
)(
	input [BW-1:0] i_a,
	input [BW-1:0] i_b,
	output [BW-1:0] o_diff,
	output o_borrow,
	output [50:0] number
);

wire [BW-1:0] intmdt_borrow;
wire [50:0] numbers [0:BW-1];

HS1 hs1(i_a[0], i_b[0], o_diff[0], intmdt_borrow[0], numbers[0]);

genvar i;
generate
	for (i=1; i<BW; i=i+1) begin
		FS1 fs(i_a[i], i_b[i], o_diff[i], intmdt_borrow[i-1], intmdt_borrow[i], numbers[i]);
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module MUXP#(
	parameter BW = 2
)(
	output [BW-1:0] z,
	input [BW-1:0] a,
	input [BW-1:0] b,
	input ctrl,
	output [50:0] number
);

wire [BW-1:0];
wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H mux(z[i], a[i], b[i], ctrl, numbers[i]);
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule
