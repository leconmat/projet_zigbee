`timescale 1ns/10ps;
//module test bench
module FIFO_TX_TB;
	// Signaux système
	reg clk;
	reg pclk;
	reg reset_n;
	reg [7:0] pwdata;
	reg [7:0] paddr;
	reg psel;
	reg pwrite;
	reg en_IQ;
	reg penable;
	wire pready;
	wire pslverr; 
	reg data_out ;
	wire IQ_rate;
	reg  mem_state;
	// parameter DEPTH = 8;
	integer i;
	// Instanciation nom du module + instance du module
	FIFO_Tx FIFO_TX_inst(	
							.clk(clk),
							.pclk (pclk),
							.reset_n(reset_n),
							.pwdata(pwdata),
							.paddr(paddr),
							.psel(psel),
							.pwrite(pwrite),
							.penable(penable),
							.en_IQ(en_IQ),
							.pready(pready),
							.pslverr(pslverr),
							.data_out(data_out),
							.IQ_rate(IQ_rate),
							.mem_state(mem_state));
	
// Clock generation	
always begin
		clk = 1'b1; // 50 MHz
		#10; 
		clk = 1'b0;
		#10; 
end
always begin
		pclk = 1'b1; // 100 MHz
		#5; 
		pclk = 1'b0;
		#5; 
end


initial begin
		reset_n = 0;
		#10;
		reset_n = 1;
// Ecriture normale 
		en_IQ =0;
		paddr = 'b0;
	   	psel = 1'b1;
	   	pwrite = 1'b1;
	   	penable = 1'b1;
	   	pwdata = 8'b00000000;		
		for(i = 0 ; i < 256 ; i++) begin 
			pwdata <= pwdata + 1;
			#10;
		end
		penable = 1'b0;
//lecture normale
		#20;
		en_IQ = 1'b1;  
		$display("Donnée lue : %h", data_out);
/*	
//Lecture sur une FIFO vide
			PWDATA = 8'b00000000;
			en_IQ = 1'b1;
			#10;
			$display("Donnée lue : %h", data_out);

	  if (PREADY) begin
		  $display("Data Out: %h", data_out);
		  $display("IQ Rate: %b", IQ_rate);
		  $display("Memory State: %b", mem_state);
		end
*/
		// Terminer la simulation
		
	
	
end
  	 
	  // Affichage des valeurs de sortie
	 // always @(posedge clk) begin
		//if (PREADY) begin
		 // $display("Data Out: %h", data_out);
		  //$display("IQ Rate: %b", IQ_rate);
		  //$display("Memory State: %b", mem_state);
		//end
		// Terminer la simulation
		//$finish;
	  //end
	
endmodule
