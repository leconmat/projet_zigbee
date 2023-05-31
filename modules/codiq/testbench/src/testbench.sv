//==============================================================================
//  Filename    : Testbench of CodIQ                                             
//  Designer    : Nicolas EYER
//  Description : Bench of CodIQ with a stimuli
//                 1 - TBD   : 
//==============================================================================
module testbench ();

timeunit      1ns;
timeprecision 1ps;

// Définition variable
`define PERIOD 20

// TestBench variables

bit sel = 0;
int j = 0;
bit signI;
bit signQ;
bit nextsignI;
bit nextsignQ;
bit oldBit;
real vali;
real valq;
real gapi;
real gapimax;
real gapq;
real gapqmax;
real gaptot;
int itetot = 0;
int ttot = 0;
real moyenne;
real pi = 3.1416;
bit secu = 0;

// FIFO variables
bit clk_50MHz;
bit rst_n;
bit en;
bit bin;
bit mem_state = 0; 
bit dac_ready;
bit en_dac;
bit rdy;
logic signed [3:0] Ibb;
logic signed [3:0] Qbb;

//signes de sin et cos
bit change = 1;

//bitstream
bit bitstream_i[$];
bit newBit = 0;

//DUT
TL_codeur_IQ Codeur_IQ (
	.b_in(bin),
	.resetn(rst_n),
	.en_2MHz(en),
	.mem_state(mem_state),
	.dac_ready(dac_ready),
	.clk(clk_50MHz),
	.IBB(Ibb),
	.QBB(Qbb),
	.ready(rdy),
	.en_dac(en_dac)
);

// Clock and Reset Definition
	always
	begin
		#(`PERIOD/2) clk_50MHz = ~clk_50MHz;	//10 ns at 1 and 10ns at 0 (period = 20ns ==> 50 MHz)
	end   

// Monitor Results format
initial $timeformat ( -9, 1, " ns", 12 );

initial begin

	//reset DUT
	rst_n = 0;
	#100ns;
	rst_n= 1;
	#20ns;
	dac_ready = 1;
	mem_state = 1;

	forever @(posedge clk_50MHz) begin 
		if(rdy & mem_state == 1) begin
			newBit = $urandom();
			bitstream_i.push_back(newBit);
			bin = newBit;
			en = 1;

			for(integer i = 0; i < 13; i++) begin
				@(negedge clk_50MHz);
				@(posedge clk_50MHz);
			end

			en = 0;

			for(integer k = 13; k < 24; k++) begin
				@(negedge clk_50MHz);
				@(posedge clk_50MHz);
			end
		end
	end
end

initial begin

	#300ns;

	forever @(posedge clk_50MHz) begin
		if (dac_ready == 1 & mem_state == 1) begin		
			case (sel)
				1'b0 : begin
					signI <= bin;
					signQ <= 1;
					valq <= 7*$sin(2*pi*0.5*j*0.02);
					if (signI == 0) 
						vali <= -7*$cos(2*pi*0.5*j*0.02);
					else
						vali <= 7*$cos(2*pi*0.5*j*0.02);
					gapi <= (Ibb - vali);
					gapq <= (Qbb - valq);
					if (gapi < 0) begin
						gaptot <= gaptot - gapi;
						itetot <= itetot + 1;
					end
					else if (gapi >= 0) begin
						gaptot <= gaptot + gapi;
						itetot <= itetot + 1;
					end
					if (gapq < 0) begin
						gaptot <= gaptot - gapq;
						itetot <= itetot + 1;
					end
					else if (gapi >= 0) begin
						gaptot <= gaptot + gapq;
						itetot <= itetot + 1;
					end
					ttot <= ttot + 20;
					j <= j+1;
					if (j == 24) begin
						sel <= 1;
						oldBit <= bin;
						j <= 0;
						nextsignI <= (oldBit ^ bin) ~^ signI;
					end
				end
				1'b1 : begin
					if (j == 0) 
						change = ~change;
					if (change == 0) begin
						if (j == 0)
							signI <= nextsignI;
						if (signI == 0)
							vali <= -7*$sin(2*pi*0.5*j*0.02);
						else if (signI == 1)
							vali <= 7*$sin(2*pi*0.5*j*0.02);
						else begin
							$display("Erreur valeur change", change);
							$finish;
						end
						if (signQ == 0)
							valq <= -7*$cos(2*pi*0.5*j*0.02);
						else if (signQ == 1)
							valq <= 7*$cos(2*pi*0.5*j*0.02);
						else begin
							$display("Erreur valeur change", change);
							$finish;
						end
						if (j == 24)
							nextsignQ <= (oldBit ^ bin) ~^ signQ;
					end
					else if (change == 1) begin
						if (j == 0)
							signQ <= nextsignQ;
						if (signI == 0)
							vali <= -7*$cos(2*pi*0.5*j*0.02);
						else if (signI == 1)
							vali <= 7*$cos(2*pi*0.5*j*0.02);
						else begin
							$display("Erreur valeur change", change);
							$finish;
						end
						if (signQ == 0)
							valq <= -7*$sin(2*pi*0.5*j*0.02);
						else if (signQ == 1)
							valq <= 7*$sin(2*pi*0.5*j*0.02);
						else begin
							$display("Erreur valeur change", change);
							$finish;
						end
						if (j == 24)
							nextsignI <= (oldBit ^ bin) ~^ signI;
					end
					gapi <= (Ibb - vali);
					gapq <= (Qbb - valq);
					if (gapi < 0) begin
						gaptot <= gaptot - gapi;
						itetot <= itetot + 1;
					end
					else if (gapi >= 0) begin
						gaptot <= gaptot + gapi;
						itetot <= itetot + 1;
					end
					if (gapq < 0) begin
						gaptot <= gaptot - gapq;
						itetot <= itetot + 1;
					end
					else if (gapi >= 0) begin
						gaptot <= gaptot + gapq;
						itetot <= itetot + 1;
					end
					ttot <= ttot + 20;
					j <= j+1;
					if (j == 24) begin
						oldBit <= bin;
						j <= 0;
					end	
				end
				default : $finish;
			endcase
			secu <= 0;
		end
		else if (dac_ready == 1 & mem_state == 0) begin
			if (secu == 0) begin		
				case (sel)
					1'b0 : begin
						signI <= bin;
						signQ <= 1;
						valq <= 7*$sin(2*pi*0.5*j*0.02);
						if (signI == 0) 
							vali <= -7*$cos(2*pi*0.5*j*0.02);
						else
							vali <= 7*$cos(2*pi*0.5*j*0.02);
						gapi <= (Ibb - vali);
						gapq <= (Qbb - valq);
						if (gapi < 0) begin
							gaptot <= gaptot - gapi;
							itetot <= itetot + 1;
						end
						else if (gapi >= 0) begin
							gaptot <= gaptot + gapi;
							itetot <= itetot + 1;
						end
						if (gapq < 0) begin
							gaptot <= gaptot - gapq;
							itetot <= itetot + 1;
						end
						else if (gapi >= 0) begin
							gaptot <= gaptot + gapq;
							itetot <= itetot + 1;
						end
						ttot <= ttot + 20;
						j <= j+1;
						if (j == 24) begin
							secu <= 1;
						end
					end
					1'b1 : begin
						if (j == 0) 
							change = ~change;
						if (change == 0) begin
							if (j == 0)
								signI <= nextsignI;
							if (signI == 0)
								vali <= -7*$sin(2*pi*0.5*j*0.02);
							else if (signI == 1)
								vali <= 7*$sin(2*pi*0.5*j*0.02);
							else begin
								$display("Erreur valeur change", change);
								$finish;
							end
							if (signQ == 0)
								valq <= -7*$cos(2*pi*0.5*j*0.02);
							else if (signQ == 1)
								valq <= 7*$cos(2*pi*0.5*j*0.02);
							else begin
								$display("Erreur valeur change", change);
								$finish;
							end
						end
						else if (change == 1) begin
							if (j == 0)
								signQ <= nextsignQ;
							if (signI == 0)
								vali <= -7*$cos(2*pi*0.5*j*0.02);
							else if (signI == 1)
								vali <= 7*$cos(2*pi*0.5*j*0.02);
							else begin
								$display("Erreur valeur change", change);
								$finish;
							end
							if (signQ == 0)
								valq <= -7*$sin(2*pi*0.5*j*0.02);
							else if (signQ == 1)
								valq <= 7*$sin(2*pi*0.5*j*0.02);
							else begin
								$display("Erreur valeur change", change);
								$finish;
							end
						end
						gapi <= (Ibb - vali);
						gapq <= (Qbb - valq);
						if (gapi < 0) begin
							gaptot <= gaptot - gapi;
							itetot <= itetot + 1;
						end
						else if (gapi >= 0) begin
							gaptot <= gaptot + gapi;
							itetot <= itetot + 1;
						end
						if (gapq < 0) begin
							gaptot <= gaptot - gapq;
							itetot <= itetot + 1;
						end
						else if (gapi >= 0) begin
							gaptot <= gaptot + gapq;
							itetot <= itetot + 1;
						end
						ttot <= ttot + 20;
						j <= j+1;
						if (j == 24) begin
							secu <= 1;
						end	
					end
					default : $finish;
				endcase
			end
			else begin
				vali <= 0;
				valq <= 0;
				j <= 0;	
				sel <= 0;
				ttot <= ttot + 20;
				change <= 1;
			end
		end	
		else if (dac_ready == 0) begin
			if (j > 19 | j == 0)
				j <= 0;
			else if (j > 14 & j <= 19)
				j <= 19;
			else if (j > 9 & j <= 14)
				j <= 14;
			else if (j > 4 & j <= 9)
				j <= 9;
			else if (j > 0 & j <= 4)
				j <= 4;
			else
				$display ("Error1!", j);
			vali <= vali;
			valq <= valq;
			change <= change;
			ttot <= ttot + 20;
			secu <= 0;
		end	
		else 
			$display("Error2!", dac_ready, mem_state);
		if (ttot == 50200) begin
			dac_ready <= 0;
			moyenne <= gaptot / itetot;
		end
		if (ttot == 50220)
			$display ("L'écart moyen entre la théorie et la valeur pratique est : ",moyenne);
		if (ttot == 51080)
			dac_ready <= 1;
		if (ttot == 145100)
			rst_n <= 0;
		if (ttot == 145120) begin
			mem_state <= 0;
			dac_ready <= 0;
		end
		if (ttot == 153980)
			rst_n <= 1;
		if (ttot == 154000) begin
			mem_state <= 1;
			dac_ready <= 1;
		end
		if (ttot == 253980)
			mem_state <= 0;
		if (ttot == 259000) 
			mem_state <= 1;
	end
end
endmodule
