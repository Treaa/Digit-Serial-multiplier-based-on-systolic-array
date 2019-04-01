/*
@Func: the process element of systolic multiplier based on N bit of parameter b.
@Author: Jinyu Xie, Wenzhao Xie, Yuteng Huang, Hao Sun. 
@Date: 2018/11/21
*/

`include "configuration.vh"

module N_serial(
	input wire [`N_DIGITAL - 1:0] b,
	input wire [`DATA_WIDTH - 1 : 0] a,
	input wire [`DATA_WIDTH - 1 : 0] g,
	input wire [`DATA_WIDTH - 1 : 0] t_i1_j1,

	output wire [`DATA_WIDTH - 1 : 0] t_i_j
);

generate
	genvar j;
	for(j = 0; j< `N_DIGITAL + 1; j = j + 1)
	begin : interconnector
		wire [`DATA_WIDTH - 1 : 0] t_i_j_wire;
	end
endgenerate

assign t_i_j = interconnector[`N_DIGITAL].t_i_j_wire;
assign interconnector[0].t_i_j_wire = t_i1_j1;

generate
	genvar i;
	for(i = 0; i < `N_DIGITAL; i = i + 1)
	begin: array
		single_bit_b_pe inst_pe(
			.b(b[`N_DIGITAL - i - 1]),
			.a(a),
			.g(g),
			.t_i1_m1(interconnector[i].t_i_j_wire[`DATA_WIDTH - 1]),
			.t_i1_j1({interconnector[i].t_i_j_wire[`DATA_WIDTH - 2:0], 1'b0}),

			.t_i_j(interconnector[i + 1].t_i_j_wire)
			);
	end
endgenerate

endmodule // N_serial
