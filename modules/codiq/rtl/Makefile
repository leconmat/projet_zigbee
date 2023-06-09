LIB = $(PROJECT_LIBS_DIR)/lib_codiq

SVSRCS :=

VHDLSRCS := ${CODIQ_DIR}/rtl/src/en_gen.vhd \
						${CODIQ_DIR}/rtl/src/zigbee_fsm.vhd \
						${CODIQ_DIR}/rtl/src/TL_codeur_IQ.vhd

VLOG_OPT += -incr -sv
VCOM_OPT += -2008

compile: lib
	@echo "**[MAKE] Compiling RTL sources."
	@vcom -work $(LIB) $(VCOM_OPT) $(VHDLSRCS)

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
