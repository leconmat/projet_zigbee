# Makefile for compiling HDL code with Questasim

# Set the name of your top-level HDL module
TOP_MODULE = my_top_module

# Set the path to your Questasim executable
QUESTASIM = /path/to/questasim/bin/vsim

# Set the path to your HDL source files
HDL_DIR = ./hdl

# Set the path to your testbench files
TEST_DIR = ./testbench

# Set the name of your testbench module
TEST_MODULE = my_testbench

# Set the name of your simulation wave file
WAVE_FILE = simulation.wlf

# Set the flags for Questasim
QUESTASIM_FLAGS = -c -do "run -all; quit" -l $(WAVE_FILE)

all: compile simulate

compile:
	$(QUESTASIM) $(QUESTASIM_FLAGS) $(HDL_DIR)/*.v

simulate:
	$(QUESTASIM) $(QUESTASIM_FLAGS) -t 1ps -voptargs=+acc $(TEST_DIR)/$(TEST_MODULE).v

clean:
	rm -rf $(WAVE_FILE)

