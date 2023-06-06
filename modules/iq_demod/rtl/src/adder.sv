module ADD_LOOKAHEAD # (
	parameter SIZE = 8
) (
	input wire signed [SIZE - 1 : 0] A,
	input wire signed [SIZE - 1 : 0] B,
	output logic signed [SIZE - 1 : 0] S
);

	wire [SIZE : 0] carries;

	logic [SIZE - 1 : 0] p_and;
	logic [SIZE - 1 : 0] p_xor;

	assign p_and = A & B;
	assign p_xor = A ^ B;
	assign carries[0] = 0;

	genvar i;

	generate
		for(i = 1; i < SIZE + 1; i++)
		begin
			assign carries[i] = p_and[i - 1] || (p_xor[i - 1] && carries[i - 1]);
		end 
	endgenerate

	assign S = p_xor ^ carries[SIZE - 1 : 0];
endmodule
