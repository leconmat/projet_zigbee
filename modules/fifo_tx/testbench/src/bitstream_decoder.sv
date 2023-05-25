/*
THIS FILE IS FOR SIMULATION ONLY.
*/
module bistream_decoder (
	input logic bitstream,
	input logic bitstream_en,
	output logic [7:0] data,
	output logic data_pulse
);

	logic [7:0] data_buff;
	integer cpt = 0;

	always @(posedge bitstream_en)
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
endmodule
