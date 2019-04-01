/*
@Func: the process element of systolic multiplier based on single bit of parameter b. 
@Author: Jinyu Xie, Wenzhao Xie, Yuteng Huang, Hao Sun.
@Date: 2018/11/21
*/

`include "configuration.vh"

module single_bit_b_pe(
	input wire b,
	input wire [`DATA_WIDTH - 1 : 0] a,
	input wire [`DATA_WIDTH - 1 : 0] g,
	input wire t_i1_m1,
	input wire [`DATA_WIDTH - 1 : 0] t_i1_j1,

	output wire [`DATA_WIDTH - 1 : 0] t_i_j
);


generate
	genvar j;
	for(j = `DATA_WIDTH - 1; j >= 0; j = j - 1)
	begin: unit
		iterative_unit inst(
			.aj(a[j]),
			.gj(g[j]),
			.t_i1_j1(t_i1_j1[j]),
			.t_i1_m1(t_i1_m1),
			.b_mi(b),

			.out_t_i1_m1(),
			.out_b_mi(),
	 		.t_i_j(t_i_j[j])
			);
	end
endgenerate

endmodule // single_bit_b_pe
