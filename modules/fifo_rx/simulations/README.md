# Simulation flow

This folder is only for simulation. The command to run it is `./run_simulation <top_module> (--synthesis) (--synthVersion=<>)`.

First, check that you have all required design files in the `rtl/src/` folder for source files and `testbench/src/` for testbench.
If you want to simulate a synthesised netlist, check that you have a `synthesis_*` directory in `asic/synth/`

## ============== How to run the simulation ==============

To run to simulation, you must specify the name of the top level (your testbench). **This is the only mandatory flag**. After, you can choose different optional flags:
- `--synthesis` - Run the simulation on the latest version of the `synthesis_*` directory.
- `--synthVersion=<>` - Run the simulation for a specify version of the synthesis. This flag doesn't required the `--synthesis` flag.

If you don't specify any optional flag, the simulation will run with rtl sources.

#### Coming soon
- P&R simulations
- Support for *sdf* timing files