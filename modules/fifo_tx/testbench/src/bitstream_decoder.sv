/*
THIS FILE IS FOR SIMULATION ONLY.
*/
module bistream_decoder (
	input logic bitstream,
	input logic bitstream_en,
	input logic clk,
	output logic [7:0] data,
	output logic data_pulse
);

	logic bitstream_en_prev = 0;
	logic [7:0] data_buff;
	integer cpt = 0;

	always @(posedge clk)
	begin
		bitstream_en_prev <= bitstream_en;
		if(bitstream_en == 1 && bitstream_en_prev == 0)
		begin
			data_buff[cpt] = bitstream;
			if(cpt == 7)
			begin
				data = data_buff;
				data_pulse = 1;
				cpt = 0;
			end
			else
			begin
				data_pulse = 0;
				cpt= cpt + 1;
			end
		end
	end
endmodule
