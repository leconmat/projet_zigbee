`define Q1 9'h001
`define Q2 9'h1F7
`define Q3 9'h1FE
`define Q4 9'h00D
`define Q5 9'h00E
`define Q6 9'h1F2
`define Q7 9'h1D9
`define Q8 9'h1FD
`define Q9 9'h063
`define Q10 9'h0C1

module filter(

	input logic clk,
	input logic resetn,
	input bit in_valid,
	input logic signed [4:0] data_in,
	output logic signed [4:0] data_out,
	output bit pret,
	output bit out_valid
);

logic signed [4:0] data_1_1, data_2_1,data_1_2, data_2_2;
logic signed [4:0] data_out_2, data_out_3;
logic signed [8:0] out_factor1, out_factor2;
logic signed [18:0] mult1,mult2;
logic signed [25:0] tot,temp;
logic signed [5:0] sum1, sum2;
logic [2:0] sel;
logic signed [4:0] shift_reg0, shift_reg1, shift_reg2, shift_reg3, shift_reg4, shift_reg5, shift_reg6, shift_reg7, shift_reg8, shift_reg9,shift_reg10, shift_reg11, shift_reg12, shift_reg13, shift_reg14, shift_reg15, shift_reg16, shift_reg17, shift_reg18, shift_reg19;

logic [2:0] shift_count;

mux2 data_reg1 (.in_0(shift_reg0),
	    .in_1(shift_reg1),
	    .in_2(shift_reg2),
	    .in_3(shift_reg3),
	    .in_4(shift_reg4),
	    .in_5(shift_reg5),
	    .in_6(shift_reg6),
	    .in_7(shift_reg7),
	    .in_8(shift_reg8),
	    .in_9(shift_reg9),
	    .sel(sel),
	    .out1(data_1_1),
	    .out2(data_2_1)
);
mux2 data_reg2 (.in_0(shift_reg19),
	    .in_1(shift_reg18),
	    .in_2(shift_reg17),
	    .in_3(shift_reg16),
	    .in_4(shift_reg15),
	    .in_5(shift_reg14),
	    .in_6(shift_reg13),
	    .in_7(shift_reg12),
	    .in_8(shift_reg11),
	    .in_9(shift_reg10),
	    .sel(sel),
	    .out1(data_1_2),
	    .out2(data_2_2)
);
mux factor (.in_0(`Q1),
	    .in_1(`Q2),
	    .in_2(`Q3),
	    .in_3(`Q4),
	    .in_4(`Q5),
	    .in_5(`Q6),
	    .in_6(`Q7),
	    .in_7(`Q8),
	    .in_8(`Q9),
	    .in_9(`Q10),
	    .sel(sel),
	    .out1(out_factor1),
	    .out2(out_factor2)
);


shift_register shift_r (.clk(clk),
			.reset(resetn),
			.data_in(data_in),
			.data_shift_en(in_valid),
			.data_out0(shift_reg0),
			.data_out1(shift_reg1),
			.data_out2(shift_reg2),
			.data_out3(shift_reg3),
			.data_out4(shift_reg4),
			.data_out5(shift_reg5),
			.data_out6(shift_reg6),
			.data_out7(shift_reg7),
			.data_out8(shift_reg8),
			.data_out9(shift_reg9),
			.data_out10(shift_reg10),
			.data_out11(shift_reg11),
			.data_out12(shift_reg12),
			.data_out13(shift_reg13),
			.data_out14(shift_reg14),
			.data_out15(shift_reg15),
			.data_out16(shift_reg16),
			.data_out17(shift_reg17),
			.data_out18(shift_reg18),
			.data_out19(shift_reg19),
			.cpt_shift(shift_count)
);

typedef enum  {
  INIT, ZERO, ONE, TWO, THREE, FOUR
   } fsm_t;

fsm_t current_state, next_state;

 always_ff @(posedge clk, negedge resetn)
	begin
	     if(~resetn) begin
		current_state <= INIT;
		data_out <= 0;
		temp <= 0;
	     end
	     else 
		begin
			if (shift_count == 3'b100) begin 
				data_out <= temp[13:9];
				data_out_2 <= temp[12:8];
				data_out_3 <= temp[13:9];
				
				temp <= tot;
				out_valid <= 1'b1;
			end
			else begin
				temp <= temp + tot;
				out_valid <= 1'b0;
			end
		current_state <= next_state;
		end
	end 


always_comb
	begin
	     unique case(current_state)
		INIT:
		    begin
			next_state = ZERO;
		    end
		ZERO:
		     begin
			sel = 3'b000;
			next_state = ONE;
			end
		ONE:
		     begin
			sel = 3'b001;
			next_state = TWO;			
			end
		TWO:
		     begin
			sel = 3'b010;
			next_state = THREE;		
			end
		THREE:
		     begin
			sel = 3'b011;
			next_state = FOUR;
			end
		FOUR:
		     begin
			sel = 3'b100;
			next_state = ZERO;
			end
		endcase
	end
	assign sum1 = data_1_1 + data_2_1;
	assign sum2 = data_1_2 + data_2_2;
	assign mult1 = out_factor1 * sum1; 
	assign mult2 = out_factor2 * sum2;
	assign tot = mult1 + mult2;
endmodule