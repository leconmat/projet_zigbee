module mux # (parameter SIZE = 8) (

	input logic [SIZE - 1:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9,
	input logic [2:0] sel,
	output logic [SIZE - 1:0] out1, out2
);


always_comb
begin
	unique case (sel)
		0 : begin
			out1 <= in_0;
			out2 <= in_1;
		end

		1: begin
			out1 <= in_2;
			out2 <= in_3;	
		end

		2: begin
			out1 <= in_4;
			out2 <= in_5;
		end

		3: begin
			out1 <= in_6;
			out2 <= in_7;
		end

		4: begin
			out1 <= in_8;
			out2 <= in_9;
		end

		default: begin
			out1 <= 0;
			out2 <= 0;
		end
	endcase
end
endmodule
