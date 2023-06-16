LIB = $(PROJECT_LIBS_DIR)/lib_zigbee_platform_tb

SVSRCS := ${ZIGBEE_PLATFORM_DIR}/testbench/src/zigbee_platform_tb.sv

VHDLSRCS :=

VLOG_OPT += -incr -sv
VCOM_OPT +=

VSIM_OPT +=-voptargs=-O4 \
						-L $(PROJECT_LIBS_DIR)/lib_CDR \
						-L $(PROJECT_LIBS_DIR)/lib_cordic \
						-L $(PROJECT_LIBS_DIR)/lib_codiq \
						-L $(PROJECT_LIBS_DIR)/lib_fifo_tx \
						-L $(PROJECT_LIBS_DIR)/lib_fifo_rx \
						-L $(PROJECT_LIBS_DIR)/lib_iq_demod \
						-L $(PROJECT_LIBS_DIR)/lib_zigbee_platform \
						-L ${AMS_DIR}/verilog/c35b4/lib_Questa107c/c35_CORELIB \
						-L ${AMS_DIR}/verilog/c35b4/lib_Questa107c/c35_IOLIB

LIST_UNITS := ${CDR_DIR} \
							${CORDIC_DIR} \
							${CODIQ_DIR} \
							${FIFO_TX_DIR} \
							${FIFO_RX_DIR} \
							${IQ_DEMOD_DIR} \
							${ZIGBEE_PLATFORM_DIR}

.PHONY: compile
compile: lib
	@echo "**[MAKE] Compiling RTL sources."
	$(foreach dir, $(LIST_UNITS), cd $(dir)/rtl; make;)
	@vlog -work $(LIB) $(VLOG_OPT) $(SVSRCS)

.PHONY: lib
lib:
	@echo "**[MAKE]** Creating library $(LIB)."
	@if [ -d $(LIB) ]; then \
		rm -rf $(LIB); \
		echo "--[MAKE] Removed old library $(LIB)."; \
	fi
	vlib $(LIB);

.PHONY: simu
simu:
	@echo "**[MAKE] Start simulation in GUI mode."
	@vsim -lib $(LIB) $(VSIM_OPT) -gui zigbee_platform_tb &

.PHONY: clean
clean:
	@echo "**[MAKE] Cleaning simulation directory and library $(LIB)."
	$(foreach dir, $(LIST_UNITS), cd $(dir)/rtl; make clean;)
	@if [ -d $(LIB) ]; then rm -rf $(LIB); fi
