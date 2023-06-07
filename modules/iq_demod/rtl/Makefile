LIB = $(PROJECT_LIBS_DIR)/lib_iq_demod

SVSRCS := ${IQ_DEMOD_DIR}/rtl/src/mux.sv \
					${IQ_DEMOD_DIR}/rtl/src/adder.sv \
					${IQ_DEMOD_DIR}/rtl/src/mult.sv \
					${IQ_DEMOD_DIR}/rtl/src/gen_sin.sv \
					${IQ_DEMOD_DIR}/rtl/src/shift_register_20.sv \
					${IQ_DEMOD_DIR}/rtl/src/filter_signal_valid.sv \
					${IQ_DEMOD_DIR}/rtl/src/filter_20.sv \
					${IQ_DEMOD_DIR}/rtl/src/demod.sv \
					${IQ_DEMOD_DIR}/rtl/src/top_iq_demod.sv

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
