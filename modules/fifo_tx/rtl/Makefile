LIB = $(PROJECT_LIBS_DIR)/lib_fifo_tx

SVSRCS := ${FIFO_TX_DIR}/rtl/src/FIFO_Tx.sv

VHDLSRCS :=

VLOG_OPT += -incr -sv
VCOM_OPT +=

compile: lib
	@echo "**[MAKE] Compiling RTL sources."
	@vlog -work $(LIB) $(VLOG_OPT) $(SVSRCS)

lib:
	@echo "**[MAKE]** Creating library $(LIB)."
	@if [ -d $(LIB) ]; then \
		rm -rf $(LIB); \
		echo "--[MAKE] Removed old library $(LIB)."; \
	fi
	vlib $(LIB);

clean:
	@echo "**[MAKE] Cleaning simulation directory and library $(LIB)."
	@if [ -d $(LIB) ]; then rm -rf $(LIB); fi
