module mux(

	input logic [8:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9,
	input logic [2:0] sel,
	output logic [8:0] out1, out2
);


always_comb
begin
	if(sel==3'b000)begin
		out1 = in_0;
		out2 = in_1;
	end 
	else if (sel==3'b001)begin
		out1 = in_2;
		out2 = in_3;		 
	end
	else if (sel==3'b010)begin
		out1 = in_4;
		out2 = in_5;
	end
	else if (sel==3'b011)begin
		out1 = in_6;
		out2 = in_7;
	end
	else if (sel==3'b100)begin
		out1 = in_8;
		out2= in_9;
	end
end
endmodule 
