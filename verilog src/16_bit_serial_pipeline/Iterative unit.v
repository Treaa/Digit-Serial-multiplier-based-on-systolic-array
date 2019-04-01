/*
@Func: the basic iterative unit in algorithm for MSB-first multiplication in GF(2^m)2.
@Author: Jinyu Xie, Wenzhao Xie, Yuteng Huang, Hao Sun. 
@Date: 2018/11/21
*/

module iterative_unit(
	input wire aj,
	input wire gj,
	input wire t_i1_j1,
	input wire t_i1_m1,
	input wire b_mi,

	output wire out_t_i1_m1,
	output wire out_b_mi,
	output wire t_i_j
);


assign out_t_i1_m1 = t_i1_m1;
assign out_b_mi = b_mi;

assign t_i_j = (t_i1_m1&gj)^(b_mi&aj)^t_i1_j1;

endmodule // iterative_unit
