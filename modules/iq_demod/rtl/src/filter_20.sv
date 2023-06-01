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

/*`define Q1 6'h00
`define Q2 6'h3F
`define Q3 6'h00
`define Q4 6'h02
`define Q5 6'h02
`define Q6 6'h3E
`define Q7 6'h3B
`define Q8 6'h00
`define Q9 6'h0C
`define Q10 6'h18*/

module filter_20(

	input logic clk,
	input logic resetn,
	input bit in_valid,
	input logic signed [4:0] data_in,
	output logic signed [4:0] data_out,
	output bit out_valid
);
//popo
	logic signed [4:0] data_1_1_1, data_2_1_1,data_1_2_1, data_2_2_1,
			   data_1_1_2, data_2_1_2,data_1_2_2, data_2_2_2,
			   data_1_1_3, data_2_1_3,data_1_2_3, data_2_2_3,
			   data_1_1_4, data_2_1_4,data_1_2_4, data_2_2_4,
			   data_1_1_5, data_2_1_5,data_1_2_5, data_2_2_5;

	logic signed [8:0] out_factor1, out_factor2 ,out_factor3, out_factor4,out_factor5, out_factor6,out_factor7, out_factor8,out_factor9, out_factor10 ;

	logic signed [13:0] mult1_1, mult2_1,mult1_2, mult2_2,mult1_3, mult2_3,mult1_4, mult2_4,mult1_5, mult2_5;
	logic signed [16:0] tot;
	logic signed [5:0] sum1_1, sum2_1,sum1_2, sum2_2,sum1_3, sum2_3,sum1_4, sum2_4,sum1_5, sum2_5;
	logic [2:0] sel;
	logic [2:0] shift_count;
	/*
	mux # (.SIZE(5)) data_reg1 (
		    .in_0(shift_reg0),
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

	mux # (.SIZE(5)) data_reg2 (
		    .in_0(shift_reg19),
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

	mux # (.SIZE(9)) factor (
		    .in_0(`Q1),
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
	);*/

	shift_register_20 shift_r (
				.clk(clk),
				.reset(resetn),
				.data_in(data_in),
				.data_shift_en(in_valid),
				.data_out0(data_1_1_1),
				.data_out1(data_1_2_1),
				.data_out2(data_1_1_2),
				.data_out3(data_1_2_2),
				.data_out4(data_1_1_3),
				.data_out5(data_1_2_3),
				.data_out6(data_1_1_4),
				.data_out7(data_1_2_4),
				.data_out8(data_1_1_5),
				.data_out9(data_1_2_5),
				.data_out10(data_2_2_5),
				.data_out11(data_2_1_5),
				.data_out12(data_2_2_4),
				.data_out13(data_2_1_4),
				.data_out14(data_2_2_3),
				.data_out15(data_2_1_3),
				.data_out16(data_2_2_2),
				.data_out17(data_2_1_2),
				.data_out18(data_2_2_1),
				.data_out19(data_2_1_1),
				.cpt_shift(shift_count)
	);

	
	/*mac mac1 (
		.data_in(sum1_pipe),
		.data_out(mult1),
		.factor_in(out_factor1_pipe)
	);	
	mac mac2 (
		.data_in(sum2_pipe),
		.data_out(mult2),
		.factor_in(out_factor2_pipe)
	);*/	

	typedef enum  {
	  INIT, ZERO, ONE, TWO, THREE, FOUR
	   } fsm_t;

	fsm_t current_state, next_state;


	always_ff @(posedge clk, negedge resetn)
	begin
	     if(~resetn) begin
		out_factor1 <= `Q1;
		out_factor2 <= `Q2;
		out_factor3 <= `Q3;
		out_factor4 <= `Q4;
		out_factor5 <= `Q5;
		out_factor6 <= `Q6;
		out_factor7 <= `Q7;
		out_factor8 <= `Q8;
		out_factor9 <= `Q9;
		out_factor10 <= `Q10;
		current_state <= INIT;
		out_valid <= 0;
	     end
	     else 
	     begin
			if (shift_count == 3'b100) begin

				out_valid <= 1'b1;
			end
			else begin
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
			sel <= 3'b000;
			next_state <= ZERO;
		    end
		ZERO:
		     begin
			sel <= 3'b000;
			next_state <= ONE;
			end
		ONE:
		     begin
			sel <= 3'b001;
			next_state <= TWO;			
			end
		TWO:
		     begin
			sel <= 3'b010;
			next_state <= THREE;		
			end
		THREE:
		     begin
			sel <= 3'b011;
			next_state <= FOUR;
			end
		FOUR:
		     begin
			sel <= 3'b100;
			next_state <= ZERO;
			end
		default:
		begin
			sel <= 3'b000;
			next_state <= INIT;
		end
	      endcase
	end

	assign sum1_1 = data_1_1_1 + data_2_1_1;
	assign sum2_1 = data_1_2_1 + data_2_2_1;

	assign sum1_2 = data_1_1_2 + data_2_1_2;
	assign sum2_2 = data_1_2_2 + data_2_2_2;

	assign sum1_3 = data_1_1_3 + data_2_1_3;
	assign sum2_3 = data_1_2_3 + data_2_2_3;

	assign sum1_4 = data_1_1_4 + data_2_1_4;
	assign sum2_4 = data_1_2_4 + data_2_2_4;

	assign sum1_5 = data_1_1_5 + data_2_1_5;
	assign sum2_5 = data_1_2_5 + data_2_2_5;

	assign mult1_1 = out_factor1 * sum1_1;
	assign mult2_1 = out_factor2 * sum2_1;

	assign mult1_2 = out_factor3 * sum1_2;
	assign mult2_2 = out_factor4 * sum2_2;

	assign mult1_3 = out_factor5 * sum1_3;
	assign mult2_3 = out_factor6 * sum2_3;

	assign mult1_4 = out_factor7 * sum1_4;
	assign mult2_4 = out_factor8 * sum2_4;

	assign mult1_5 = out_factor9 * sum1_5;
	assign mult2_5 = out_factor10 * sum2_5;

	assign tot = mult1_1 + mult2_1 + mult1_2 + mult2_2 + mult1_3 + mult2_3 + mult1_4 + mult2_4 + mult1_5 + mult2_5;
	
	assign data_out = tot[13:9];

endmodule
