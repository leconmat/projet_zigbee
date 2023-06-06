module MULT_LOOKAHEAD # (
	parameter SIZE = 8
) (
	input wire signed [SIZE - 1 : 0] A,
	input wire signed [SIZE - 1 : 0] B,
	output logic signed [SIZE * 2 - 1 : 0] S,
	input wire clk,
	input wire resetn
);
	logic [SIZE - 1 : 0] register [SIZE : 0];
	logic [SIZE - 1 : 0] register_pipe [SIZE * 2: SIZE];

	logic [SIZE - 1 : 0] S_pipe;
	logic [SIZE - 1 : 0] A_pipe;
	logic B_pipe;

	assign register[0] = {SIZE {1'b0}};

	always @(posedge clk, negedge resetn)
	begin
		if(~resetn)
		begin
			register_pipe[SIZE] <= 0;
			A_pipe <= 0;
			B_pipe <= 0;
			S[SIZE - 1 : 0] <= 0;
		end
		else
		begin
			register_pipe[SIZE] <= register[SIZE];
			S[SIZE - 1 : 0] <= S_pipe[SIZE - 1 : 0];
			A_pipe <= A;
			B_pipe <= B[SIZE - 1];
		end
	end

	genvar i;

	generate
		for(i = 0; i < SIZE; i++)
		begin
			ADD_LOOKAHEAD # (.SIZE(SIZE + 1)) adder (
				.A({A[SIZE - 1], A[SIZE - 1 : 0]} & (B[i] ? {SIZE + 1 {1'b1}} : {SIZE{1'b0}})),
				.B({register[i][SIZE - 1], register[i][SIZE - 1 : 0]}),
				.S({register[i + 1][SIZE - 1 : 0], S_pipe[i]})
			);
		end		

		for(i = SIZE; i < SIZE * 2; i++)
		begin
			ADD_LOOKAHEAD # (.SIZE(SIZE + 1)) adder (
				.A({A_pipe[SIZE - 1], A_pipe[SIZE - 1 : 0]} & (B_pipe ? {SIZE + 1 {1'b1}} : {SIZE{1'b0}})),
				.B({register_pipe[i][SIZE - 1], register_pipe[i][SIZE - 1 : 0]}),
				.S({register_pipe[i + 1][SIZE - 1 : 0], S[i]})
			);
		end
	endgenerate

endmodule
