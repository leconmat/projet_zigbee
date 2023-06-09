module demodulation(
	input logic clk,
	input logic resetn,
	input bit ADC_rdy,
	input logic signed [4:0] I_IF,
	input logic signed [4:0] Q_IF,
	input logic signed [1:0] sine_in,
	input logic signed [1:0] cosine_in,
	output logic signed [4:0] I_BB, 
	output logic signed [4:0] Q_BB,
	output bit demod_rdy
);

	logic signed [6:0] I_BB_f;
	logic signed [6:0] Q_BB_f;
	logic signed [6:0] IS;
	logic signed [6:0] IC;
	logic signed [6:0] QS;
	logic signed [6:0] QC;


	enable validation(	.clk(clk),
				.resetn(resetn),
				.ADC_rdy(ADC_rdy),
				.demod_rdy(demod_rdy)
	);

	always_comb
	begin
		unique case (sine_in)
			-2:
			begin
				IS <= 0;
				QS <= 0;
			end
			-1:
			begin
				IS <= -I_IF;
				QS <= -Q_IF;
			end
			0:
			begin
				IS <= 0;
				QS <= 0;
			end
			1:
			begin
				IS <= I_IF;
				QS <= Q_IF;
			end
			default:
			begin
				IS <= 0;
				QS <= 0;
			end
		endcase

		unique case (cosine_in)
			-2:
			begin
				IC <= 0;
				QC <= 0;
			end
			-1:
			begin
				IC <= -I_IF;
				QC <= -Q_IF;
			end
			0:
			begin
				IC <= 0;
				QC <= 0;
			end
			1:
			begin
				IC <= I_IF;
				QC <= Q_IF;
			end
			default:
			begin
				IC <= 0;
				QC <= 0;
			end
		endcase
	end //always comb

	assign I_BB_f = (IC + QS) * -1;
	assign Q_BB_f = (QC - IS) * -1;
	assign I_BB[4:0] = I_BB_f[4:0]; // CARTON ROUGE : à revoir
	assign Q_BB[4:0] = Q_BB_f[4:0];

endmodule
