//==============================================================================
//  Filename    : Testbench of Filter                                              
//  Designer    : Clement
//  Description : Bench of filter with some stimuli
//                 1 - Dirac   : Enable to see coeff on output (!! divider)
//                 2 - Echelon : Enable to see saturation of filter (output must be close to 255 (5V) at DAC output
//                 3 - Sinus   : Measure Cut-off Frequency 
//==============================================================================
module tbench_filtre ();

timeunit      1ns;
timeprecision 1ns;

bit clk = 1'b1;
bit reset;        
bit validation,pret;
logic [4:0] filter_in; 
logic [4:0] filter_out;

// Other Variables Definition
real freq = 1000; //freq en kHz
real sinus;
integer stimuli_choice = 32'h3;
integer i;


 // connexion avec le filtre
filter duv (.clk(clk),         
  	    .resetn(reset),
  	    .data_in(filter_in),
	    .validation(validation),
	    .pret(pret),
            .data_out(filter_out)
	    );

 // connexion le générateur de sinus 
fsm dut (.clk(clk),
	 .resetn(reset),
	 .sine_out(sinus),
	 .cosine_out(cosine)
	);

enable valid (.clk(clk),
	      .resetn(resetn),
	      .valid_ADC(validation),
	      .ready_ADC(pret)
);

// Monitor Results format
initial
begin
	$timeformat ( -9, 1, " ns", 12 );
	reset = 1'b0;
	#60 reset = 1'b1; //reset à l'etat bas
end

// Clock and Reset Definition
always
begin
  #10 clk = ~clk; //période 20 ns = 50Mhz
end

// Apply Stimulus on filter inputs
// verify filter behaviour for Dirac and step function (echelon)
initial                                                                
   	unique case (stimuli_choice)
		32'h1 : begin //dirac
				filter_in = 'b0;
				#60 filter_in = 3;
				#40 filter_in = 0;		
				stimuli_choice = 0;
			end
		32'h2 : begin //Echelon
				filter_in = 0;
				#60 filter_in = 3;
				#50000 stimuli_choice = 0;
			end
		32'h3 : //Sinus a freq variable
		forever 
			begin
				
				for(i = 1; i < 100000; i += 1)
				begin
				 #100; 
				validation = 1; 
				 #100;
				 validation = 1;   
					//freq = freq+0.001;
					filter_in = sinus;
					#100;
				end
			stimuli_choice = 0;
			end


		default : begin
			  	filter_in = 0;
			  end	
  	endcase;                                                                       

// Automatic checker to compare Filter value with expected Output

endmodule