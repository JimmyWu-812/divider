/****************************************
*                 div                   *
****************************************/
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

wire o_out_valid_res;
wire [50:0] numbers [0:13];
wire [4:0] intmdt_r [7:0];
wire [7:0] o_q_res;
wire inv_tmp, tmp;

STAGE1 stage1(i_a[7], i_b, o_q_res[7], intmdt_r[7][0], numbers[0]);
STAGE2 stage2({intmdt_r[7][0], i_a[6]}, i_b, o_q_res[6], intmdt_r[6][1:0], numbers[1]);
STAGE3 stage3({intmdt_r[6][1:0], i_a[5]}, i_b, o_q_res[5], intmdt_r[5][2:0], numbers[2]);
STAGE4 stage4({intmdt_r[5][2:0], i_a[4]}, i_b, o_q_res[4], intmdt_r[4][3:0], numbers[3]);
STAGE5 stage5({intmdt_r[4][3:0], i_a[3]}, i_b, o_q_res[3], intmdt_r[3], numbers[4]);
STAGE678 stage6({intmdt_r[3], i_a[2]}, i_b, o_q_res[2], intmdt_r[2], numbers[5]);
STAGE678 stage7({intmdt_r[2], i_a[1]}, i_b, o_q_res[1], intmdt_r[1], numbers[6]);
STAGE678 stage8({intmdt_r[1], i_a[0]}, i_b, o_q_res[0], intmdt_r[0], numbers[7]);

AN2 an1(tmp, o_q_res[0], intmdt_r[0][4], numbers[8]);
ND2 nd1(inv_tmp, o_q_res[0], intmdt_r[0][4], numbers[9]);
ND2 nd2(o_out_valid_res, tmp, inv_tmp, numbers[10]);

REGP#(8) quotient(clk, rst_n, o_q, o_q_res, numbers[11]);
REGP#(5) remainder(clk, rst_n, o_r, intmdt_r[0], numbers[12]);
REGP#(1) valid(clk, rst_n, o_out_valid, o_out_valid_res, numbers[13]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<14; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 1                *
****************************************/
module STAGE1 (
	input i_a,
	input [4:0] i_b,
	output o_q,
	output o_r,
	output [50:0] number
);

wire [50:0] numbers [0:4];

wire inv_o_nor, o_nor, diff, borrow;

HS1 hs1(i_a, i_b[0], diff, borrow, numbers[0]);
NR4 nr1(o_nor, i_b[4], i_b[3], i_b[2], i_b[1], numbers[1]);
IV iv1(inv_o_nor, o_nor, numbers[2]);
NR2 nr2(o_q, inv_o_nor, borrow, numbers[3]);
MUX21H mux1(o_r, i_a, diff, o_q, numbers[4]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<5; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 2                *
****************************************/
module STAGE2 (
	input [1:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [1:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [1:0] diff;

FSP#(2) fs1(i_a, i_b[1:0], diff, borrow, numbers[0]);
NR4 nr1(o_q, borrow, i_b[4], i_b[3], i_b[2], numbers[1]);
MUXP#(2) mux1(o_r, i_a, diff, o_q, numbers[2]);

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

/****************************************
*                Stage 3                *
****************************************/
module STAGE3 (
	input [2:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [2:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [2:0] diff;

FSP#(3) fs1(i_a, i_b[2:0], diff, borrow, numbers[0]);
NR3 nr1(o_q, borrow, i_b[4], i_b[3], numbers[1]);
MUXP#(3) mux1(o_r, i_a, diff, o_q, numbers[2]);

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

/****************************************
*                Stage 4                *
****************************************/
module STAGE4 (
	input [3:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [3:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [3:0] diff;

FSP#(4) fs1(i_a, i_b[3:0], diff, borrow, numbers[0]);
NR2 nr1(o_q, borrow, i_b[4], numbers[1]);
MUXP#(4) mux1(o_r, i_a, diff, o_q, numbers[2]);

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

/****************************************
*                Stage 5                *
****************************************/
module STAGE5 (
	input [4:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [4:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [4:0] diff;

FSP#(5) fs1(i_a, i_b, diff, borrow, numbers[0]);
MUXP#(5) mux1(o_r, diff, i_a, borrow, numbers[1]);
IV iv1(o_q, borrow, numbers[2]);

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

/****************************************
*               Stage 6-8               *
****************************************/
module STAGE678 (
	input [5:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [4:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:3];

wire borrow, inv_i_a_5;
wire [4:0] diff;

FSP#(5) fs1(i_a[4:0], i_b, diff, borrow, numbers[0]);
IV iv1(inv_i_a_5, i_a[5], numbers[1]);
ND2 nd1(o_q, inv_i_a_5, borrow, numbers[2]);
MUXP#(5) mux1(o_r, i_a[4:0], diff, o_q, numbers[3]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<4; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*              BW-bit FD2               *
****************************************/
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

// sum number of transistors
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

/****************************************
*                  HS1                  *
****************************************/
module HS1(
	input i_a,
	input i_b,
	output o_diff,
	output o_borrow,
	output [50:0] number
);

wire inv_a;
wire [50:0] numbers [0:2];

IV iv1(inv_a, i_a, numbers[0]);
AN2 an1(o_borrow, inv_a, i_b, numbers[1]);
EO eo1(o_diff, i_a, i_b, numbers[2]);

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

/****************************************
*                  FS1                  *
****************************************/
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

IV iv1(inv_a, i_a, numbers[0]);
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

/****************************************
*              BW-bit FS1               *
****************************************/
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
		FS1 fs(i_a[i], i_b[i], intmdt_borrow[i-1], o_diff[i], intmdt_borrow[i], numbers[i]);
	end
endgenerate

assign o_borrow = intmdt_borrow[BW-1];

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

/****************************************
*             BW-bit MUX21H             *
****************************************/
module MUXP#(
	parameter BW = 2
)(
	output [BW-1:0] o_z,
	input [BW-1:0] i_a,
	input [BW-1:0] i_b,
	input i_ctrl,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H mux(o_z[i], i_a[i], i_b[i], i_ctrl, numbers[i]);
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