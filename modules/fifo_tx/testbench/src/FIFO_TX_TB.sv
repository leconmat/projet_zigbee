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
	for(integer j = 0 ; j < 64 ; j++) begin
		 @(posedge decoded_pulse);
		 if(decoded_data != j)
			$display("Invalid data");
		else
			$display("Good data!");
	end
end


initial begin
		en_IQ = 0;
		pwdata = 8'b00000000;	
		psel = 1'b0;
	   	pwrite = 1'b0;
	   	penable = 1'b0;
		reset_n = 0;
		#20;
		reset_n = 1;
		
// Ecriture normale 
	   	psel = 1'b1;
	   	pwrite = 1'b1;
	   	penable = 1'b1;
	   			
		for(integer i = 0 ; i < 64 ; i++) begin 
			pwdata <= i;
			#20;
		end
		penable = 1'b0;
// Lecture normale
		#20;
		en_IQ = 1'b1;  
		$display("Donnée lue : %h", data_out);
	
// Lecture depuis une FIFO vide
		/*pwdata = 8'b00000000;
		en_IQ = 1'b1;
		#10;
		$display("Donnée lue : %h", data_out);*/

// Test APB 

// Ecriture dans une mémoire pleine 
		
	
	
end
  	 
	  // Affichage des valeurs de sortie
	  /*always @(posedge clk) begin
		if (PREADY) begin
			$display("Data Out: %h", data_out);
		  	$display("IQ Rate: %b", IQ_rate);
		  	$display("Memory State: %b", mem_state);
		end
		// Terminer la simulation
		$finish;
	  end*/
	
endmodule
