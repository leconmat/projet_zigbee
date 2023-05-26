module shift_register_20 (
  input  logic                       clk,           // Main Clock
  input  logic                       reset,         // Reset actif à l'état bas
  input  logic                [4:0] data_in,       // Donnée à shifter
  input  logic                       data_shift_en, // Signal de validation
  output  logic                 [2:0] cpt_shift, // Sel
  output logic                 [4:0] data_out0, data_out1,  data_out2,  data_out3,  data_out4,  data_out5,  data_out6,  data_out7,  data_out8,  data_out9, data_out10, data_out11,  data_out12,  data_out13,  data_out14,  data_out15,  data_out16,  data_out17,  data_out18,  data_out19        // Data Register  
);


always_ff @(posedge clk) begin //1

  if      (~reset)         begin //2
                            data_out19<=10'b0;
			    data_out18<=10'b0;
                            data_out17<=10'b0;
			    data_out16<=10'b0;
                            data_out15<=10'b0;
			    data_out14<=10'b0;
                            data_out13<=10'b0;
			    data_out12<=10'b0;
                            data_out11<=10'b0;
			    data_out10<=10'b0;
                            data_out9<=10'b0;
			    data_out8<=10'b0;
                            data_out7<=10'b0;
			    data_out6<=10'b0;
                            data_out5<=10'b0;
			    data_out4<=10'b0;
                            data_out3<=10'b0;
			    data_out2<=10'b0;
                            data_out1<=10'b0;
			    data_out0<=10'b0;
			    cpt_shift<=3'b0;
			//    current_state <= INIT;
			  end //2
 
  else if ((data_shift_en) && ((cpt_shift == 3'b100))) begin //3
		       data_out19<=data_out18;
		       data_out18<=data_out17;
		       data_out17<=data_out16;
		       data_out16<=data_out15;
		       data_out15<=data_out14;
		       data_out14<=data_out13;
		       data_out13<=data_out12;
	   	       data_out12<=data_out11;
		       data_out11<=data_out10;
		       data_out10<=data_out9;
		       data_out9<=data_out8;
		       data_out8<=data_out7;
		       data_out7<=data_out6;
		       data_out6<=data_out5;
		       data_out5<=data_out4;
		       data_out4<=data_out3;
		       data_out3<=data_out2;
	   	       data_out2<=data_out1;
		       data_out1<=data_out0;
		       data_out0<=data_in;
		       cpt_shift<=3'b0;
		      // current_state <= ZERO;
		         	     		    end//3
 else cpt_shift<=cpt_shift+1;			   
end //1

endmodule
