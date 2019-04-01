/*
@Func: This is the wrapper of N_bit_b_digital_serial, there are self-circulation in this module,
	   and the start & done signals are added.
@Author: Jinyu Xie, Wenzhao Xie, Yuteng Huang, Hao Sun.
@Date: 2018/11/21
*/

`include "configuration.vh"

module N_bit_wrapper(
	input wire clk,
	input wire rst_n,
	input wire start,
	input wire [`DATA_WIDTH - 1 : 0] a,
	input wire [`DATA_WIDTH - 1 : 0] g,
	input wire [`N_DIGITAL - 1 : 0] b,

	output reg [`DATA_WIDTH - 1 : 0] t_i_j,
	output reg done
);

parameter ITERATION_NUMBER = `DATA_WIDTH / `N_DIGITAL;

parameter IDLE = 1'b0;
parameter CAL  = 1'b1;

reg state;
reg [12:0] counter;

wire [`DATA_WIDTH - 1 : 0] wire_t_i_j;

N_serial N_serial_wrapper(
	.b(b),
	.a(a),
	.g(g),
	.t_i1_j1(t_i_j),		//self-circulation

	.t_i_j(wire_t_i_j)
);


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
	end else begin
		case (state)
			IDLE: begin  
				counter <= 6'd0;
			end
			CAL: begin 
				if( counter < ITERATION_NUMBER) 
					counter <= counter + 1;
				else 
					counter <= 6'd0;
			end		
			default : ;
		endcase
	end
end


always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		t_i_j <= 0;
	end else begin
		case (state)
			IDLE : t_i_j <= 0;
			CAL : t_i_j <= wire_t_i_j;			//self-circulation
			default : t_i_j <= 0;
		endcase
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		done <= 0;
	end else begin
		case (state)
			IDLE : done <= 0;
			CAL : begin 
				if( counter < ITERATION_NUMBER) 
					done <= 0;
				else 
					done <= 1'b1;
			end	
			default : done <= 0;
		endcase
	end
end

//FSM
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= IDLE;
	end else begin
		case (state)
			IDLE: begin
				if (start)
					state <= CAL;
				else
					state <= state;
			end
			CAL: begin
				if ( counter < ITERATION_NUMBER)
					state <= CAL;
				else
					state <= IDLE;
			end
			default : state <= IDLE;
		endcase
	end
end

endmodule // N_bit_wrapper
