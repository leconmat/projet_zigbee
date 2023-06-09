`timescale 1ns/10ps;
//module test bench
module FIFO_TX_TB;
	// Signaux système
	reg clk;
	reg reset_n;
	reg [7:0] pwdata;
	reg psel;
	reg pwrite;
	reg en_IQ;
	reg penable;
	wire pready;
	wire pslverr; 
	reg data_out ;
	wire IQ_rate;
	reg  mem_state;
	reg [7:0] decoded_data;
	reg decoded_pulse;

	bit [7:0] sentData[$];	

	// parameter DEPTH = 8;
	// Instanciation nom du module + instance du module
	FIFO_Tx FIFO_TX_inst(	
							.clk(clk),
							.reset_n(reset_n),
							.pwdata(pwdata),
							.psel(psel),
							.pwrite(pwrite),
							.penable(penable),
							.en_IQ(en_IQ),
							.pready(pready),
							.pslverr(pslverr),
							.data_out(data_out),
							.IQ_rate(IQ_rate),
							.mem_state(mem_state));

	bistream_decoder DECODEUR ( .bitstream(data_out),
				     .bitstream_en(IQ_rate),
				     .clk(clk),
				     .data(decoded_data),
				     .data_pulse(decoded_pulse));
					
	
// Clock generation	
always begin
		clk = 1'b1; // 50 MHz
		#10; 
		clk = 1'b0;
		#10; 
end

always begin 
	automatic bit [7:0] expectedData;
	
	@(posedge decoded_pulse);
	expectedData = sentData.pop_front();
	if(decoded_data != expectedData)
		$display("Invalid data %d. Expected %d", decoded_data, expectedData);
	else
		$display("Good data!");

end


initial begin
		pwdata = 8'b00000000;	
		psel = 1'b0;
	   	pwrite = 1'b0;
	   	penable = 1'b0;
		reset_n = 0;
		#20;
		reset_n = 1;
		#20;
		psel = 1'b1;
	   	pwrite = 1'b1;

		for(integer i = 0 ; i < 10000 ; i++) begin
			penable = 1'b1;
			pwdata = $urandom;
			sentData.push_back(pwdata);
			#20;
			penable = 1'b0;
			#20000;
		end

// Fonctionnement basique : validé 
/*		@(posedge clk); 
		psel = 1'b1;
	   	pwrite = 1'b1;
	   	penable = 1'b1;	
		for(integer i = 0 ; i < 64 ; i++) begin 
			pwdata <= i;
			sentData.push_back(i);
			#20;
		end
		#20;
		penable = 1'b0;
		#100;
		en_IQ = 1'b1;  
		#350000;
		//penable = 1'b0;
	   	penable = 1'b1;
		for(integer i = 64 ; i < 128 ; i++) begin 
			pwdata <= i;
			sentData.push_back(i);
			#20;
		end
		#20;
		penable = 1'b0;
		#100;
		$display("Donnée lue : %h", data_out); */
// Lecture depuis une FIFO vide : validé
		/*pwdata = 8'b00000000;
		en_IQ = 1'b1;
		#10;
		$display("Donnée lue : %h", data_out);*/

// Test APB : validé
/*		@(posedge clk); 
		psel = 1'b1;
	   	pwrite = 1'b0;
	   	penable = 1'b1;	
		for(integer i = 0 ; i < 64 ; i++) begin 
			pwdata <= i;
			sentData.push_back(i);
			#20;
		end*/
	
// Ecriture dans une mémoire pleine 
		
	
	
end
initial begin
// Fonctionnement en continu 
		en_IQ = 0;
		#200;
		en_IQ = 1;
end
	
endmodule
