/*
@Func: the pipeline top module of the 16 bit digital-serial systolic multiplier. 
@Author: Jinyu Xie, Wenzhao Xie, Yuteng Huang, Hao Sun.
@Date: 2018/11/23
*/

`include "configuration.vh"

module pipeline_16bit_top(
	input wire clk,
	input wire rst_n,
	input wire [`DATA_WIDTH - 1 : 0] a,
	input wire [`DATA_WIDTH - 1 : 0] g,
	input wire [BWIDTH - 1:0] b,

	output wire [`DATA_WIDTH - 1 : 0] t_i_j_out
);

parameter ITERATION_NUMBER = `DATA_WIDTH / `N_DIGITAL;
parameter BWIDTH = (ITERATION_NUMBER + 1)*`N_DIGITAL;
 
// 1st stage
reg [`DATA_WIDTH - 1 : 0] reg_a;
reg [`DATA_WIDTH - 1 : 0] reg_g;
reg [BWIDTH - 1 : 0] reg_b;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1;
wire [`DATA_WIDTH - 1 : 0] t_i_j;

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a <= 'b0;
		reg_g <= 'b0;
		reg_b <= 'b0;
		t_i1_j1 <= 'b0;
	end
	else begin
		reg_a <= a;
		reg_g <= g;
		reg_b <= b;
		t_i1_j1 <= 'b0;
	end
end

N_serial inst1(
	.b(reg_b[175:160]),
	.a(reg_a),
	.g(reg_g),
	.t_i1_j1(t_i1_j1),

	.t_i_j(t_i_j)
);

reg [`DATA_WIDTH - 1 : 0] reg_a2;
reg [BWIDTH - 1 : 0] reg_b2;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_2;

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a2 <= 'b0;
		reg_b2 <= 'b0;
		t_i1_j1_2 <= 'b0;
	end
	else begin
		reg_a2 <= reg_a;
		reg_b2 <= reg_b;
		t_i1_j1_2 <= t_i_j;
	end
end


// 2nd stage
reg [`DATA_WIDTH - 1 : 0] reg_a3;
reg [BWIDTH - 1 : 0] reg_b3;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_3;
wire [`DATA_WIDTH - 1 : 0] t_i_j_2;

N_serial inst2(
	.b(reg_b2[159:144]),
	.a(reg_a2),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_2),

	.t_i_j(t_i_j_2)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a3 <= 'b0;
		reg_b3 <= 'b0;
		t_i1_j1_3 <= 'b0;
	end
	else begin
		reg_a3 <= reg_a2;
		reg_b3 <= reg_b2;
		t_i1_j1_3 <= t_i_j_2;
	end
end


// 3rd stage
reg [`DATA_WIDTH - 1 : 0] reg_a4;
reg [BWIDTH - 1 : 0] reg_b4;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_4;
wire [`DATA_WIDTH - 1 : 0] t_i_j_3;

N_serial inst3(
	.b(reg_b3[143:128]),
	.a(reg_a3),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_3),

	.t_i_j(t_i_j_3)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a4 <= 'b0;
		reg_b4 <= 'b0;
		t_i1_j1_4 <= 'b0;
	end
	else begin
		reg_a4 <= reg_a3;
		reg_b4 <= reg_b3;
		t_i1_j1_4 <= t_i_j_3;
	end
end


// 4th stage
reg [`DATA_WIDTH - 1 : 0] reg_a5;
reg [BWIDTH - 1 : 0] reg_b5;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_5;
wire [`DATA_WIDTH - 1 : 0] t_i_j_4;

N_serial inst4(
	.b(reg_b4[127:112]),
	.a(reg_a4),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_4),

	.t_i_j(t_i_j_4)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a5 <= 'b0;
		reg_b5 <= 'b0;
		t_i1_j1_5 <= 'b0;
	end
	else begin
		reg_a5 <= reg_a4;
		reg_b5 <= reg_b4;
		t_i1_j1_5 <= t_i_j_4;
	end
end


// 5th stage
reg [`DATA_WIDTH - 1 : 0] reg_a6;
reg [BWIDTH - 1 : 0] reg_b6;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_6;
wire [`DATA_WIDTH - 1 : 0] t_i_j_5;

N_serial inst5(
	.b(reg_b5[111:96]),
	.a(reg_a5),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_5),

	.t_i_j(t_i_j_5)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a6 <= 'b0;
		reg_b6 <= 'b0;
		t_i1_j1_6 <= 'b0;
	end
	else begin
		reg_a6 <= reg_a5;
		reg_b6 <= reg_b5;
		t_i1_j1_6 <= t_i_j_5;
	end
end


// 6th stage
reg [`DATA_WIDTH - 1 : 0] reg_a7;
reg [BWIDTH - 1 : 0] reg_b7;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_7;
wire [`DATA_WIDTH - 1 : 0] t_i_j_6;

N_serial inst6(
	.b(reg_b6[95:80]),
	.a(reg_a6),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_6),

	.t_i_j(t_i_j_6)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a7 <= 'b0;
		reg_b7 <= 'b0;
		t_i1_j1_7 <= 'b0;
	end
	else begin
		reg_a7 <= reg_a6;
		reg_b7 <= reg_b6;
		t_i1_j1_7 <= t_i_j_6;
	end
end


// 7th stage
reg [`DATA_WIDTH - 1 : 0] reg_a8;
reg [BWIDTH - 1 : 0] reg_b8;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_8;
wire [`DATA_WIDTH - 1 : 0] t_i_j_7;

N_serial inst7(
	.b(reg_b7[79:64]),
	.a(reg_a7),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_7),

	.t_i_j(t_i_j_7)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a8 <= 'b0;
		reg_b8 <= 'b0;
		t_i1_j1_8 <= 'b0;
	end
	else begin
		reg_a8 <= reg_a7;
		reg_b8 <= reg_b7;
		t_i1_j1_8 <= t_i_j_7;
	end
end


// 8th stage
reg [`DATA_WIDTH - 1 : 0] reg_a9;
reg [BWIDTH - 1 : 0] reg_b9;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_9;
wire [`DATA_WIDTH - 1 : 0] t_i_j_8;

N_serial inst8(
	.b(reg_b8[63:48]),
	.a(reg_a8),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_8),

	.t_i_j(t_i_j_8)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a9 <= 'b0;
		reg_b9 <= 'b0;
		t_i1_j1_9 <= 'b0;
	end
	else begin
		reg_a9 <= reg_a8;
		reg_b9 <= reg_b8;
		t_i1_j1_9 <= t_i_j_8;
	end
end


// 9th stage
reg [`DATA_WIDTH - 1 : 0] reg_a10;
reg [BWIDTH - 1 : 0] reg_b10;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_10;
wire [`DATA_WIDTH - 1 : 0] t_i_j_9;

N_serial inst9(
	.b(reg_b9[47:32]),
	.a(reg_a9),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_9),

	.t_i_j(t_i_j_9)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a10 <= 'b0;
		reg_b10 <= 'b0;
		t_i1_j1_10 <= 'b0;
	end
	else begin
		reg_a10 <= reg_a9;
		reg_b10 <= reg_b9;
		t_i1_j1_10 <= t_i_j_9;
	end
end


// 10th stage
reg [`DATA_WIDTH - 1 : 0] reg_a11;
reg [BWIDTH - 1 : 0] reg_b11;
reg [`DATA_WIDTH - 1 : 0] t_i1_j1_11;
wire [`DATA_WIDTH - 1 : 0] t_i_j_10;

N_serial inst10(
	.b(reg_b10[31:16]),
	.a(reg_a10),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_10),

	.t_i_j(t_i_j_10)
);

always@ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_a11 <= 'b0;
		reg_b11 <= 'b0;
		t_i1_j1_11 <= 'b0;
	end
	else begin
		reg_a11 <= reg_a10;
		reg_b11 <= reg_b10;
		t_i1_j1_11 <= t_i_j_10;
	end
end


// 11th stage
wire [`DATA_WIDTH - 1 : 0] t_i_j_11;

N_serial inst11(
	.b(reg_b11[15:0]),
	.a(reg_a11),
	.g(reg_g),
	.t_i1_j1(t_i1_j1_11),

	.t_i_j(t_i_j_11)
);


assign t_i_j_out = t_i_j_11;


endmodule // pipeline_16bit_top
