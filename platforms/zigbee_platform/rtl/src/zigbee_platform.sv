module zigbee_platform(

  // Global signals
  input logic clk_i,
  input logic resetn_i,

  // I/Os Tx bus
  input logic [21:0] mux_i,
  output logic [17:0] mux_o,

  // Selection inputs
  input logic [1:0] sel_i
);

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

  FIFO_Tx i_fifo_tx(
    .clk(clk_i),
    .reset_n(resetn_i),
    .pwdata(fifo_tx_pwdata_i),
    .psel(fifo_tx_psel_i),
    .pwrite(fifo_tx_pwrite_i),
    .penable(fifo_tx_pen_i),
    .en_IQ(fifo_tx_enable_i),
    .pready(),
    .pslverr(fifo_tx_pslv_err_o),
    .data_out(fifo_tx_data_o),
    .IQ_rate(fifo_tx_enable_o),
    .mem_state(fifo_tx_mem_state_o)
  );

  // Mod_iq
  logic       mod_iq_data_i;
  logic       mod_iq_enable_i;
  logic       mod_iq_dac_ready_i;
  logic       mod_iq_mem_state_i;
  logic [3:0] mod_iq_ibb_o;
  logic [3:0] mod_iq_qbb_o;
  logic       mod_iq_enable_o;
  logic       mod_iq_valid_o;

  assign mod_iq_dac_ready_i = 1'b1;
  assign fifo_tx_enable_i = mod_iq_enable_o;

  TL_codeur_IQ i_mod_iq(
    .resetn(resetn_i),
    .clk(clk_i),
    .en_2MHz(mod_iq_enable_i),
    .b_in(mod_iq_data_i),
    .mem_state(mod_iq_mem_state_i),
    .dac_ready(mod_iq_dac_ready_i),
    .IBB(mod_iq_ibb_o),
    .QBB(mod_iq_qbb_o),
    .en_dac(mod_iq_valid_o),
    .ready(mod_iq_enable_o)
  );

  // Demod_iq
  logic [4:0] demod_iq_iif_i;
  logic [4:0] demod_iq_qif_i;
  logic       demod_iq_valid_i;
  logic [4:0] demod_iq_ibb_o;
  logic [4:0] demod_iq_qbb_o;
  logic       demod_iq_valid_o;

  top_iq_demod i_iq_demod(
    .clk(clk_i),
    .resetn(resetn_i),
    .ADC_rdy_i(demod_iq_valid_i),
    .I_IF(demod_iq_iif_i),
    .Q_IF(demod_iq_qif_i),
    .demod_iq_valid(demod_iq_valid_o),
    .I_BB(demod_iq_ibb_o),
    .Q_BB(demod_iq_qbb_o)
  );
  // Cordic
  logic [4:0] cordic_ibb_i;
  logic [4:0] cordic_qbb_i;
  logic       cordic_valid_i;
  logic [5:0] cordic_phase_o;
  logic       cordic_valid_o;

  zigbee_cordic_top i_cordic(
    .reset_n(resetn_i),
    .clk(clk_i),
    .ibb(cordic_ibb_i),
    .qbb(cordic_qbb_i),
    .iValid(cordic_valid_i),
    .wout(cordic_phase_o),
    .oValid(cordic_valid_o)
  );

  // CDR
  logic [5:0] cdr_phase_i;
  logic       cdr_valid_i;
  logic       cdr_data_o;
  logic       cdr_valid_o;

  bit_recovery_CDR i_cdr(
    .clk(clk_i),
    .resetn(resetn_i),
    .phase_i(cdr_phase_i),
    .ph_valid_i(cdr_valid_i),
    .data_en_o(cdr_valid_o),
    .data_o(cdr_data_o)
  );

  // Fifo_rx
  logic       fifo_rx_psel_i;
  logic       fifo_rx_pen_i;
  logic       fifo_rx_pwrite_i;
  logic       fifo_rx_data_i;
  logic       fifo_rx_valid_i;
  logic [7:0] fifo_rx_prdata_o;
  logic       fifo_rx_pslv_err_o;
  logic       fifo_rx_pready_o;

  fifo_rx i_fifo_rx(
    .clk(clk_i),
    .reset_n(resetn_i),
    .en_cdr(fifo_rx_valid_i),
    .data_in(fifo_rx_data_i),
    .psel(fifo_rx_psel_i),
    .pwrite(fifo_rx_pwrite_i),
    .penable(fifo_rx_pen_i),
    .pready(),
    .pslverr(fifo_rx_pslv_err_o),
    .prdata(fifo_rx_prdata_o)
  );

  logic fifo_pslverr;
  logic fifo_psel;
  logic fifo_pen;
  logic fifo_pwrite;

  always_comb begin
    fifo_tx_psel_i   = 'b0;
    fifo_tx_pen_i    = 'b0;
    fifo_tx_pwrite_i = 'b0;

    fifo_rx_psel_i   = 'b0;
    fifo_rx_pen_i    = 'b0;
    fifo_rx_pwrite_i = 'b0;

    if(~fifo_psel) begin
      fifo_tx_psel_i   = ~fifo_psel;
      fifo_tx_pen_i    = fifo_pen;
      fifo_tx_pwrite_i = fifo_pwrite;
      fifo_pslverr     = fifo_tx_pslv_err_o;
    end
    else begin
      fifo_rx_psel_i   = fifo_psel;
      fifo_rx_pen_i    = fifo_pen;
      fifo_rx_pwrite_i = fifo_pwrite;
      fifo_pslverr     = fifo_rx_pslv_err_o;
    end
  end

  // I/Os selection
  always_comb begin
    // Default values
    mux_o = 'b0;
    
    fifo_tx_pwdata_i = 'b0;

    fifo_psel          = 'b0;
    fifo_pen           = 'b0;
    fifo_pwrite        = 'b0;

    mod_iq_data_i = fifo_tx_data_o;
    mod_iq_enable_i = fifo_tx_enable_o;
    mod_iq_mem_state_i = fifo_tx_mem_state_o;

    demod_iq_iif_i = 'b0;
    demod_iq_qif_i = 'b0;
    demod_iq_valid_i = 'b0;

    cordic_ibb_i = demod_iq_ibb_o;
    cordic_qbb_i = demod_iq_qbb_o;
    cordic_valid_i = demod_iq_valid_o;

    cdr_phase_i = cordic_phase_o;
    cdr_valid_i = cordic_valid_o;

    fifo_rx_data_i = cdr_data_o;
    fifo_rx_valid_i = cdr_valid_o;

    unique case(sel_i)
      2'b00: begin // Tx/Rx chains
        fifo_psel          = mux_i[0];
        fifo_pen           = mux_i[1];
        fifo_pwrite        = mux_i[2];
        fifo_tx_pwdata_i   = mux_i[10:3];
        demod_iq_iif_i     = mux_i[15:11];
        demod_iq_qif_i     = mux_i[20:16];
        demod_iq_valid_i   = mux_i[21];

        mux_o[7:0]   = fifo_rx_prdata_o;
        mux_o[8]     = fifo_pslverr;
        mux_o[9]     = mod_iq_valid_o;
        mux_o[13:10] = mod_iq_ibb_o;
        mux_o[17:14] = mod_iq_qbb_o;
      end
      2'b01: begin // Fifo Rx/Fifo Tx + CDR
        fifo_psel          = mux_i[0];
        fifo_pen           = mux_i[1];
        fifo_pwrite        = mux_i[2];
        fifo_tx_pwdata_i   = mux_i[10:3];
        cdr_phase_i        = mux_i[16:11];
        cdr_valid_i        = mux_i[17];
        fifo_rx_data_i     = mux_i[18];
        fifo_rx_valid_i    = mux_i[19];

        mux_o[7:0]   = fifo_rx_prdata_o;
        mux_o[8]     = fifo_pslverr;
        mux_o[9]     = cdr_data_o;
        mux_o[10]    = cdr_valid_o;
        mux_o[11]    = fifo_tx_mem_state_o;
        mux_o[12]    = fifo_tx_data_o;
        mux_o[13]    = fifo_tx_enable_o;
      end
      2'b10: begin // CORDIC/CDR + Mod IQ
        cordic_ibb_i       = mux_i[4:0];
        cordic_qbb_i       = mux_i[9:5];
        cordic_valid_i     = mux_i[10];
        cdr_phase_i        = mux_i[16:11];
        cdr_valid_i        = mux_i[17];
        mod_iq_data_i      = mux_i[18];
        mod_iq_enable_i    = mux_i[19];
        mod_iq_mem_state_i = mux_i[20];

        mux_o[5:0]   = cordic_phase_o;
        mux_o[6]     = cordic_valid_o;
        mux_o[7]     = cdr_data_o;
        mux_o[8]     = cdr_valid_o;
        mux_o[9]     = mod_iq_valid_o;
        mux_o[13:10] = mod_iq_ibb_o;
        mux_o[17:14] = mod_iq_qbb_o;
      end
      2'b11: begin // Cordic/Demod IQ
        cordic_ibb_i       = mux_i[4:0];
        cordic_qbb_i       = mux_i[9:5];
        cordic_valid_i     = mux_i[10];
        demod_iq_iif_i     = mux_i[15:11];
        demod_iq_qif_i     = mux_i[20:16];
        demod_iq_valid_i   = mux_i[21];

        mux_o[5:0]   = cordic_phase_o;
        mux_o[6]     = cordic_valid_o;
        mux_o[11:7]  = demod_iq_ibb_o;
        mux_o[16:12] = demod_iq_qbb_o;
        mux_o[17]    = demod_iq_valid_o;
      end
    endcase
  end // End always_comb


endmodule
