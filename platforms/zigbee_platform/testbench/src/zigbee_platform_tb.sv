`timescale 1ps/100fs
`define PERIOD 20ns

module zigbee_platform_tb();

logic tb_clk = 1;
logic tb_resetn = 0;

logic [21:0] tb_mux_i;
logic [17:0] tb_mux_o;
logic [1:0] tb_sel_i = 2'b00;

  zigbee_top_pad dut(
    .clk(tb_clk),
    .resetn(tb_resetn),
    .in(tb_mux_i),
    .out(tb_mux_o),
    .sel(tb_sel_i)
  );


// CDR signals
logic signed [5:0] cdr_phase_i;
logic cdr_valid_i;
logic cdr_data_o;
logic cdr_valid_o;

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


bit [7:0] sentData[$];

// Mod_iq
logic       mod_iq_data_i;
logic       mod_iq_enable_i;
logic       mod_iq_dac_ready_i = 1'b1;
logic       mod_iq_mem_state_i = 1'b1;
logic [3:0] mod_iq_ibb_o;
logic [3:0] mod_iq_qbb_o;
logic       mod_iq_enable_o;
logic       mod_iq_valid_o;


// Demod_iq
logic signed [4:0] demod_iq_iif_i;
logic signed [4:0] demod_iq_qif_i;
logic       demod_iq_valid_i;
logic signed [4:0] demod_iq_ibb_o;
logic signed [4:0] demod_iq_qbb_o;
logic       demod_iq_valid_o;

parameter real quantum = 0.03226;
integer fd_I_in, fd_I_out, fd_Q_in, fd_Q_out;
real matlab_in_I_real, matlab_in_Q_real;
real matlab_out_I_real, matlab_out_Q_real;
real filter_out_I_real, filter_out_Q_real;
typedef logic signed [4:0] sample_t;
sample_t matlab_out_I_digital, matlab_out_Q_digital;

// Cordic
logic signed [4:0] cordic_ibb_i;
logic signed [4:0] cordic_qbb_i;
logic       cordic_valid_i;
logic signed [5:0] cordic_phase_o;
logic       cordic_valid_o;

bit newBit;
bit bitstream_i[$];

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
  #(`PERIOD/2) tb_clk = ~tb_clk;
end

initial begin
  tb_sel_i = 2'b10;
  #(`PERIOD*5) tb_resetn = ~tb_resetn;
  modiq_cordic_cdr();
end

logic fifo_pslverr;
logic fifo_psel;
logic fifo_pen;
logic fifo_pwrite;
logic fifo_pready;

always_comb begin
  tb_mux_i = 'b0;
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
      mod_iq_valid_o   = tb_mux_o[9];
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
      tb_mux_i[20]    = mod_iq_mem_state_i;

      cordic_phase_o  = tb_mux_o[5:0];
      cordic_valid_o  = tb_mux_o[6];
      cdr_data_o      = tb_mux_o[7];
      cdr_valid_o     = tb_mux_o[8];
      mod_iq_valid_o  = tb_mux_o[9];
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

always_comb begin
  if(tb_sel_i == 2'b01) begin
    fifo_rx_data_i = fifo_tx_data_o;
    fifo_rx_valid_i = fifo_tx_enable_o;
  end
  else if(tb_sel_i == 2'b10) begin
    cdr_phase_i = cordic_phase_o;
    cdr_valid_i = cordic_valid_o;
    cordic_ibb_i = {mod_iq_ibb_o, 1'b0};
    cordic_qbb_i = {mod_iq_qbb_o, 1'b0};
    cordic_valid_i = mod_iq_valid_o;
  end
  else if(tb_sel_i == 2'b11) begin
    cordic_ibb_i = demod_iq_ibb_o;
    cordic_qbb_i = demod_iq_qbb_o;
    cordic_valid_i = demod_iq_valid_o;
 end
end

task tx_rx();

  fork

    begin
      fifo_tx_pwdata_i = 8'b00000000;	
      fifo_psel = 1'b0;
      fifo_pwrite = 1'b0;
      fifo_pen = 1'b0;
      #20ns;
      fifo_pwrite = 1'b1;
      fifo_pen = 1'b1;
      for(integer i = 0 ; i < 10000 ; i++) begin
        fifo_tx_pwdata_i = $urandom;
        sentData.push_back(fifo_tx_pwdata_i);
        #20ns;
      end
    end

    begin
      fd_I_in = $fopen("../data/I_in.csv", "r");
      fd_I_out = $fopen("../data/I_out.csv", "r");
      fd_Q_in = $fopen("../data/Q_in.csv", "r");	
      fd_Q_out = $fopen("../data/Q_out.csv", "r");
      
      if(~fd_I_in) $display("I_in not opened");
      if(~fd_I_out) $display("I_out not opened");
      if(~fd_Q_in) $display("Q_in not opened");
      if(~fd_Q_out) $display("Q_out not opened");

      forever begin
        $fscanf(fd_I_in, "%f\n", matlab_in_I_real);
        $fscanf(fd_Q_in, "%f\n", matlab_in_Q_real);
        
        demod_iq_iif_i = sample_t'(matlab_in_I_real / quantum);
        demod_iq_qif_i = sample_t'(matlab_in_Q_real / quantum);
        
        $fscanf(fd_I_out, "%f\n", matlab_out_I_real);
        $fscanf(fd_Q_out, "%f\n", matlab_out_Q_real);
        
        matlab_out_I_digital = sample_t'((matlab_out_I_real*0.90) / quantum);
        matlab_out_Q_digital = sample_t'((matlab_out_Q_real*0.90) / quantum);
        
        filter_out_I_real = (demod_iq_ibb_o * quantum);
        filter_out_Q_real = (demod_iq_qbb_o * quantum);
        
        for(integer i  = 0; i < 5; i++) begin
          if (i == 0) demod_iq_valid_i = 1;
          else demod_iq_valid_i = 0;
          @(posedge tb_clk);
        end
      end 
    end

  join_any
endtask

task fifos();

  fifo_tx_pwdata_i = 8'b00000000;	
  fifo_psel = 1'b0;
  fifo_pwrite = 1'b0;
  fifo_pen = 1'b0;
  #20ns;
  fifo_pwrite = 1'b1;
  fifo_pen = 1'b1;
  for(integer i = 0 ; i < 10000 ; i++) begin
    fifo_tx_pwdata_i = $urandom;
    sentData.push_back(fifo_tx_pwdata_i);
    #20ns;
  end

endtask

task modiq_cordic_cdr();

  forever @(posedge tb_clk) begin 
    newBit = $urandom();
    bitstream_i.push_back(newBit);
    mod_iq_data_i = newBit;
    mod_iq_enable_i = 1;

    for(integer i = 0; i < 13; i++) begin
      @(negedge tb_clk);
      @(posedge tb_clk);
    end

    mod_iq_enable_i = 0;

    for(integer k = 13; k < 24; k++) begin
      @(negedge tb_clk);
      @(posedge tb_clk);
    end
  end

endtask

task demodiq_cordic();

  fd_I_in = $fopen("../data/I_in.csv", "r");
  fd_I_out = $fopen("../data/I_out.csv", "r");
  fd_Q_in = $fopen("../data/Q_in.csv", "r");	
  fd_Q_out = $fopen("../data/Q_out.csv", "r");
  
  if(~fd_I_in) $display("I_in not opened");
  if(~fd_I_out) $display("I_out not opened");
  if(~fd_Q_in) $display("Q_in not opened");
  if(~fd_Q_out) $display("Q_out not opened");

  forever begin
    $fscanf(fd_I_in, "%f\n", matlab_in_I_real);
    $fscanf(fd_Q_in, "%f\n", matlab_in_Q_real);
    
    demod_iq_iif_i = sample_t'(matlab_in_I_real / quantum);
    demod_iq_qif_i = sample_t'(matlab_in_Q_real / quantum);
    
    $fscanf(fd_I_out, "%f\n", matlab_out_I_real);
    $fscanf(fd_Q_out, "%f\n", matlab_out_Q_real);
    
    matlab_out_I_digital = sample_t'((matlab_out_I_real*0.90) / quantum);
    matlab_out_Q_digital = sample_t'((matlab_out_Q_real*0.90) / quantum);
    
    filter_out_I_real = (demod_iq_ibb_o * quantum);
    filter_out_Q_real = (demod_iq_qbb_o * quantum);
    
    for(integer i  = 0; i < 5; i++) begin
      if (i == 0) demod_iq_valid_i = 1;
      else demod_iq_valid_i = 0;
      @(posedge tb_clk);
    end
  end

endtask

endmodule
