module mux(

	input logic [5:0] in_0, in_1, in_2, in_3, in_4,
	input logic [2:0] sel,
	output logic [5:0] out
);


always_comb
begin
	if(sel==3'b000) out = in_0; 
	else if (sel==3'b001) out = in_1;
	else if (sel==3'b010) out = in_2;
	else if (sel==3'b011) out = in_3;
	else out= in_4;
end
endmodule 
