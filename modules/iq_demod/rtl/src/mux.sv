module mux(

	input logic [4:0] in_0, in_1, in_2, in_3,
	input logic [1:0] sel,
	output logic [4:0] out
);


always @(sel, in_0, in_1, in_2, in_3)

if(sel==2'b00) out <= in_0; 
else if (sel==2'b01) out <= in_1;
else if (sel==2'b10) out <= in_2;
else out<= in_3;

endmodule 
