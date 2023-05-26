# Synthesis flow

This folder is only for the synthesis. The command to run it is `./run_synthesis`.

First, check in the `rtl/src/` folder that you have only final design files, because the synthesis will takes all the content of this folder.

## ============== synth_attributes.do editing ==============

Next, you need to edit the file `synth_attributes.do`, which declares some variables mandatory by the flow:

### Design properties
- `vars(is_hierarchical) 0` - If the design contains submodules (for example the top of the chip)
- `vars(submodules) [list ""]` - Mandatory if the design is hierarchical. List all submodules used by the top level
- `vars(top_level_module) "<top_module_name>"` - Write the name of the top_level
- `vars(clk_net) "<clock_name>"` - Write the name of the clock in the top_level
- `vars(clock_period) 20` - The period of the top clock in ns (default: 20ns)

### Optimization efforts
- `vars(map_effort) "high"` - Map optimization effort (none, low, medium, high)
- `vars(area_effort) "high"` - Area optimization effort (none, low, medium, high)
- `vars(power_effort) "high"` - Power optimization effort (medium, high)

## ============== Synthesis results ==============

After synthesis, you will have a folder `synthesis_*`. Into it, there are `REPORTS/` of each corners (`BEST/`, `TYPICAL/` & `WORST/`) in terms of:
- Design
- Constraints
- Clock
- Area
- Compile options
- Power
- Timing

And you will have a `synthesis_RTL/` folder too, which contains the synthesised netlist in verilog.

---
# IMPORTANT
If you have some **WARNINGS** in the `synthesis.log` file, don't ignore them, even if the synthesis exits correctly.

Before used the synthesised netlist, **feel free to check reports for each corner**, particulary for the `WORST/`.

Important reports are:
- **Timing** - Check that the path slack is greater than 0
- **Consumption** - Check that the total consumption is not to high