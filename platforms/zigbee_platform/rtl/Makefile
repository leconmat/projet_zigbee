LIB = $(PROJECT_LIBS_DIR)/lib_zigbee_platform

SVSRCS := ${ZIGBEE_PLATFORM_DIR}/asic/pnr/zigbee_top_pad_pnr.v

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
