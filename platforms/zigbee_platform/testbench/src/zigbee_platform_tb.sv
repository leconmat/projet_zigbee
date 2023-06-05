`timescale 1 ns/10 ps
`define PERIOD 20

module zigbee_platform_tb();

logic clk = 1;
logic resetn = 0;

logic [21:0] tb_mux_i;
logic [17:0] tb_mux_o;
logic [1:0] tb_sel_i = 2'b00;

  zigbee_platform dut(
    .clk_i(clk),
    .resetn_i(resetn),
    .mux_i(tb_mux_i),
    .mux_o(tb_mux_o),
    .sel_i(tb_sel_i)
  );
// CDR TB signals
logic signed [5:0] cdr_phase_i = 'b0;
logic cdr_valid_i = 1;
logic cdr_data_o;
logic output_wanted = 0;
logic test = 1;
logic cdr_valid_o;
int variance = 0;
int count = 0;

// Fifo_tx
logic [7:0] fifo_tx_pwdata_i;
logic       fifo_tx_psel_i;
logic       fifo_tx_pen_i;
logic       fifo_tx_pwrite_i;
logic       fifo_tx_enable_i;
logic       fifo_tx_pslv_err_o;
logic       fifo_tx_pready_o;
logic       fifo_tx_mem_state_o;
logic       fifo_tx_enable_o;
logic       fifo_tx_data_o;


// Mod_iq
logic       mod_iq_data_i;
logic       mod_iq_enable_i;
logic       mod_iq_dac_ready_i = 1'b1;
logic       mod_iq_mem_state_i;
logic [3:0] mod_iq_ibb_o;
logic [3:0] mod_iq_qbb_o;
logic       mod_iq_enable_o;
logic       mod_iq_valid_o;


// Demod_iq
logic [4:0] demod_iq_iif_i;
logic [4:0] demod_iq_qif_i;
logic       demod_iq_valid_i;
logic [4:0] demod_iq_ibb_o;
logic [4:0] demod_iq_qbb_o;
logic       demod_iq_valid_o;


// Cordic
logic [4:0] cordic_ibb_i;
logic [4:0] cordic_qbb_i;
logic       cordic_valid_i;
logic [5:0] cordic_phase_o;
logic       cordic_valid_o;

real ibbReal, qbbReal, angleRad, angleDeg, deltaError, woutDeg;

assign ibbReal = $cos(angleRad) * AMPLITUDE;
assign qbbReal = $sin(angleRad) * AMPLITUDE;
assign cordic_ibb_i = int'(ibbReal);
assign cordic_qbb_i = int'(qbbReal);
assign woutDeg = $itor(wout) * 5.625;


// Fifo_rx
logic       fifo_rx_psel_i;
logic       fifo_rx_pen_i;
logic       fifo_rx_pwrite_i;
logic       fifo_rx_data_i;
logic       fifo_rx_valid_i;
logic [7:0] fifo_rx_prdata_o;
logic       fifo_rx_pslv_err_o;
logic       fifo_rx_pready_o;

always begin
  #(`PERIOD/2) clk = ~clk;
end

initial begin
  #(`PERIOD*5) resetn = ~resetn;
  cdr();
end

logic fifo_pslverr;
logic fifo_psel;
logic fifo_pen;
logic fifo_pwrite;
logic fifo_pready;

always_comb begin
  unique case(tb_sel_i)
    2'b00: begin // Tx/Rx chains
      tb_mux_i[0]     = fifo_psel;
      tb_mux_i[1]     = fifo_pen;
      tb_mux_i[2]     = fifo_pwrite;
      tb_mux_i[10:3]  = fifo_tx_pwdata_i;
      tb_mux_i[15:11] = demod_iq_iif_i;
      tb_mux_i[20:16] = demod_iq_qif_i;
      tb_mux_i[21]    = demod_iq_valid_i;

      fifo_rx_prdata_o = tb_mux_o[7:0];
      fifo_pslverr     = tb_mux_o[8];
      mod_iq_enable_o  = tb_mux_o[9];
      mod_iq_ibb_o     = tb_mux_o[13:10];
      mod_iq_qbb_o     = tb_mux_o[17:14];
    end
    2'b01: begin // Fifo Rx/Fifo Tx + CDR
      tb_mux_i[0]     = fifo_psel;
      tb_mux_i[1]     = fifo_pen;
      tb_mux_i[2]     = fifo_pwrite;
      tb_mux_i[10:3]  = fifo_tx_pwdata_i;
      tb_mux_i[16:11] = cdr_phase_i;
      tb_mux_i[17]    = cdr_valid_i;
      tb_mux_i[18]    = fifo_rx_data_i;
      tb_mux_i[19]    = fifo_rx_valid_i;

      fifo_rx_prdata_o    = tb_mux_o[7:0];
      fifo_pslverr        = tb_mux_o[8];
      cdr_data_o          = tb_mux_o[9];
      cdr_valid_o         = tb_mux_o[10];
      fifo_tx_mem_state_o = tb_mux_o[11];
      fifo_tx_data_o      = tb_mux_o[12];
      fifo_tx_enable_o    = tb_mux_o[13];
    end
    2'b10: begin // CORDIC/CDR + Mod IQ
      tb_mux_i[4:0]   = cordic_ibb_i;
      tb_mux_i[9:5]   = cordic_qbb_i;
      tb_mux_i[10]    = cordic_valid_i;
      tb_mux_i[16:11] = cdr_phase_i;
      tb_mux_i[17]    = cdr_valid_i;
      tb_mux_i[18]    = mod_iq_data_i;
      tb_mux_i[19]    = mod_iq_enable_i;

      cordic_phase_o  = tb_mux_o[5:0];
      cordic_valid_o  = tb_mux_o[6];
      cdr_data_o      = tb_mux_o[7];
      cdr_valid_o     = tb_mux_o[8];
      mod_iq_enable_o = tb_mux_o[9];
      mod_iq_ibb_o    = tb_mux_o[13:10];
      mod_iq_qbb_o    = tb_mux_o[17:14];
    end
    2'b11: begin // Cordic/Demod IQ
      tb_mux_i[4:0]   = cordic_ibb_i;
      tb_mux_i[9:5]   = cordic_qbb_i;
      tb_mux_i[10]    = cordic_valid_i;
      tb_mux_i[15:11] = demod_iq_iif_i;
      tb_mux_i[20:16] = demod_iq_qif_i;
      tb_mux_i[21]    = demod_iq_valid_i;

      cordic_phase_o   = tb_mux_o[5:0];
      cordic_valid_o   = tb_mux_o[6];
      demod_iq_ibb_o   = tb_mux_o[11:7];
      demod_iq_qbb_o   = tb_mux_o[16:12];
      demod_iq_valid_o = tb_mux_o[17];
    end
  endcase
end // End always_comb


task cdr();
  tb_sel_i = 2'b10;

  fork

    begin
      forever begin
        #50 cdr_valid_i = ~cdr_valid_i;
      end
    end

    begin
      forever begin
        @(posedge cdr_valid_o);
        if(output_wanted != cdr_data_o)
          test = 0;
      end
    end

    begin
      $display("start");
      #100
      #33
      for(int i = 0; i<100;i++) begin
        output_wanted = $urandom(i)%2;
        variance = 1 - $urandom(i)%3;
        if(output_wanted == 0) begin
          for(int j = 0; j <5 ; j++) begin
            cdr_phase_i -=4+variance;
            #100;
          end
        end
        else begin
          for(int j = 0; j<5; j++) begin
            cdr_phase_i += 4+variance;
            #100;
          end
        end
        if(test == 0)begin
          $display("cdr_data_o != output_wanted at t = %t ",$realtime);
          count = count + 1;
        end
        test = 1;
      end
      if(count != 0)
      	$display("test failed");
      else
      	$display("test passed");
    end

  join_any

endtask //end cdr

task cordic();
  tb_sel_i = 2'b10;

  fork
    
    begin
      forever begin
        deltaError = woutDeg - angleDeg;
        if(deltaError > 180)
          deltaError -= 360;
        if(deltaError <= -180)
          deltaError += 360;
      end
    end

    begin
      forever begin
        angleRad = $itor($urandom_range(2 * PI * 10000)) / 10000;
        angleDeg = (angleRad * 360) / (2 * PI);
        iValid <= 1;
        #200ns;
        
        if((deltaError > 0 ? deltaError : -deltaError) > maxError)
          maxError = deltaError > 0 ? deltaError : -deltaError;
      end
    end

endtask //end cordic

endmodule
