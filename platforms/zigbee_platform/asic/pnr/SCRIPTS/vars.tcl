# ############################################################################ #
# Foundation Flow Codegen Vars Record
# Executed on 07:02:29 PM(Feb06) by user: louahdi
# Copyright 2008-2012, Cadence Design Systems, Inc.
# All Rights Reserved
# ############################################################################ #

# This file contains all default (seeded) variables and user-defined variables that were resolved during code generation.
if {![info exists vars]} {
   global vars
}
global env
set env(VPATH) make
set vars(ff_exe_dir) "./"
set vars(rundir) "./"
set vars(script_dir) "FF"

set vars(plug_dir) "PLUG"


set vars(abort) {false}
set vars(abutted_design) {0}
set vars(active_hold_views) {hold_func_min}
set vars(active_setup_views) {setup_func_max}
set vars(activity_file_format) {TCF}
set vars(all_analysis_views) {hold_func_max hold_func_min hold_func_typ setup_func_max setup_func_min setup_func_typ}
set vars(always_source_tcl) {./PLUG/INNOVUS/always_source.tcl}
set vars(arg_list) {codegen edi flat makefile mode rc novus synth_flow rundir script_dir style user_mode verbose version}
set vars(argv) {init}
set vars(backup_data) {0}
set vars(batch) {true}
set vars(black_box) {true}
set vars(bsteps) {init}
set vars(budget_mode) {giga_opt}
set vars(captbl_file) {-best /softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-typical.capTable -worst /softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-typical.capTable}
set vars(capture_metrics) {true}
set vars(catch_errors) {false}
set vars(ccopt_effort) {low}
set vars(ccopt_integration) {native}
set vars(cdb_file) {}
set vars(cdb_file,max) {}
set vars(cdb_file,min) {}
set vars(check_setup) {0}
set vars(check_setup_errors) {}
set vars(clk_tree_bottom_layer) {1}
set vars(clk_tree_top_layer) {4}
set vars(clock_gate_aware) {true}
set vars(clock_gate_aware_opt) {false}
set vars(codegen) {true}
set vars(config_files) {./setup.tcl ./innovus_config.tcl}
set vars(congestion_effort) {medium}
set vars(constraint_modes) {setup_func_mode hold_func_mode}
set vars(corner_max,clock_cell_early) {0.97}
set vars(corner_max,clock_cell_late) {1.03}
set vars(corner_max,clock_net_early) {0.97}
set vars(corner_max,clock_net_late) {1.03}
set vars(corner_max,data_cell_early) {0.97}
set vars(corner_max,data_cell_late) {1.03}
set vars(corner_max,data_net_early) {0.97}
set vars(corner_max,data_net_late) {1.03}
set vars(corner_max,library_set) {slow_libs}
set vars(corner_max,rc_corner) {rc_worst}
set vars(corner_min,clock_cell_early) {0.97}
set vars(corner_min,clock_cell_late) {1.05}
set vars(corner_min,clock_net_early) {0.97}
set vars(corner_min,clock_net_late) {1.05}
set vars(corner_min,data_cell_early) {0.95}
set vars(corner_min,data_cell_late) {1.05}
set vars(corner_min,data_net_early) {0.97}
set vars(corner_min,data_net_late) {1.05}
set vars(corner_min,library_set) {fast_libs}
set vars(corner_min,rc_corner) {rc_best}
set vars(corner_typ,clock_cell_early) {1}
set vars(corner_typ,clock_cell_late) {1}
set vars(corner_typ,clock_net_early) {1}
set vars(corner_typ,clock_net_late) {1}
set vars(corner_typ,data_cell_early) {1}
set vars(corner_typ,data_cell_late) {1}
set vars(corner_typ,data_net_early) {1}
set vars(corner_typ,data_net_late) {1}
set vars(corner_typ,library_set) {typ_libs}
set vars(corner_typ,rc_corner) {rc_typ}
set vars(cpf_isolation) {false}
set vars(cpf_keep_rows) {false}
set vars(cpf_level_shifter) {false}
set vars(cpf_power_domain) {false}
set vars(cpf_power_switch) {false}
set vars(cpf_state_retention) {false}
set vars(cpf_timing) {false}
set vars(cpus_per_remote_host) {1}
set vars(create_flexfiller_blockage) {false}
set vars(cts,time_design,skip) {true}
set vars(cts_buffer_cells) {BUF2 BUF4 BUF6 BUF8 BUF12}
set vars(cts_cell_list) {CLKIN0 CLKIN1 CLKIN2 CLKIN3 CLKIN4 CLKIN6 CLKIN8 CLKIN10 CLKIN12 CLKIN15 CLKBU2 CLKBU4 CLKBU6 CLKBU8 CLKBU12 CLKBU15}
set vars(cts_effort) {medium}
set vars(cts_engine) {ccopt_cts}
set vars(cts_inverter_cells) {INV0 INV1 INV2 INV3 INV4 INV8 INV10 INV12}
set vars(cts_target_slew) {2.00}
set vars(cts_use_inverters) {true}
set vars(custom_rundir_name_append) {}
set vars(cwd) {./Template}
set vars(data_dir) {./CONSTRAINTS}
set vars(dbs_dir) {DBS}
set vars(dbs_format) {fe}
set vars(debug) {0}
set vars(default_hold_view) {hold_func_typ}
set vars(default_setup_view) {setup_func_typ}
set vars(delay_corners) {corner_min corner_typ corner_max}
set vars(design) {filter_io}
set vars(design_dir) {.}
set vars(dont_use_list) {BUF15 INV15}
set vars(dynamic_power_effort) {high}
set vars(eco_dir) {ECO}
set vars(edi) {false}
set vars(enable_aocv) {false}
set vars(enable_celtic_steps) {false}
set vars(enable_cppr) {both}
set vars(enable_flexilm) {false}
set vars(enable_nrgr) {false}
set vars(enable_ocv) {pre_cts}
set vars(enable_pac) {false}
set vars(enable_pam) {false}
set vars(enable_qor_check) {false}
set vars(enable_rcp) {false}
set vars(enable_si_aware) {true}
set vars(enable_signoff_eco) {false}
set vars(enable_socv) {false}
set vars(enable_ss) {false}
set vars(error_count) {0}
set vars(execute_string) {/softslin/calibre2015_1_38_27/ixl_cal_2015.1_38.27/pkgs/icv_comp/8.4/bin/tclsh ./SCRIPTS/gen_flow.tcl -m flat -d FF -v 15.2.0 -s . -y none -n init}
set vars(fast_libs,timing) {/softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_BC.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_BC.lib}
set vars(fff_info_level) {0}
set vars(filler_cells) {FILL25 FILL10 FILL5 FILL2 FILLRT25 FILLRT10 FILLRT5 FILLRT2 FILLRT1}
set vars(fix_hold) {postcts postroute postroute_si}
set vars(fix_hold_allow_tns_degradation) {false}
set vars(fix_hold_ignore_ios) {false}
set vars(fix_litho) {false}
set vars(flat) {off}
set vars(flavor) {flat}
set vars(flexmodel_art_based) {true}
set vars(flexmodel_as_ptn) {1}
set vars(flow) {mmmc}
set vars(flow_effort) {standard}
set vars(format_lines) {true}
set vars(freeze_vars) {false}
set vars(gds_layer_map) {./INPUT_DATA/gds2.map}
set vars(generate_flow_steps) {0}
set vars(generate_tracks) {true}
set vars(genus_config_tcl) {}
set vars(globbed) {true}
set vars(good_corners) {corner_min corner_typ corner_max}
set vars(ground_nets) {gnd! gnd3r! gnd3o!}
set vars(hier_flow_type) {1pass}
set vars(high_timing_effort) {false}
set vars(hold_analysis_views) {hold_func_min hold_func_typ hold_func_max}
set vars(hold_func_max,constraint_mode) {hold_func_mode}
set vars(hold_func_max,delay_corner) {corner_max}
set vars(hold_func_min,constraint_mode) {hold_func_mode}
set vars(hold_func_min,delay_corner) {corner_min}
set vars(hold_func_mode,post_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_postcts.sdc ./CONSTRAINTS/constraints_def_best.sdc}
set vars(hold_func_mode,pre_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_prects.sdc ./CONSTRAINTS/constraints_def_best.sdc}
set vars(hold_func_typ,constraint_mode) {hold_func_mode}
set vars(hold_func_typ,delay_corner) {corner_typ}
set vars(hosts) {1}
set vars(html_dir) {HTML}
set vars(html_summary) {RPT/summary.html}
set vars(ieee1801_isolation) {false}
set vars(ieee1801_keep_rows) {false}
set vars(ieee1801_level_shifter) {false}
set vars(ieee1801_power_domain) {false}
set vars(ieee1801_power_switch) {false}
set vars(ieee1801_state_retention) {false}
set vars(ieee1801_timing) {false}
set vars(ilm) {0}
set vars(ilm_list) {}
set vars(import_mode) {-treatUndefinedCellAsBbox 0 -keepEmptyModule 1 -useLefDef56 1 }
set vars(in_place_opt) {true}
set vars(info_count) {0}
set vars(initialized) {1}
set vars(innovus_config_tcl) {./innovus_config.tcl}
set vars(insert_feedthrough) {1}
set vars(io_filler_list) {100_P 50_P 20_P 10_P 5_P 2_P 1_P 01_P}
set vars(leakage_power_effort) {low}
set vars(lef_files) {/softslin/AMS_410_ISR15/cds/HK_C35/LEF/c35b4/c35b4.lef /softslin/AMS_410_ISR15/cds/HK_C35/LEF/c35b4/CORELIB.lef /softslin/AMS_410_ISR15/cds/HK_C35/LEF/c35b4/IOLIB_4M.lef}
set vars(library_dir) {/softslin/AMS_410_ISR15}
set vars(library_sets) {slow_libs typ_libs fast_libs}
set vars(litho_driven_routing) {true}
set vars(loaded) {1}
set vars(local_cpus) {4}
set vars(log_dir) {LOG}
set vars(lp_config_tcl) {}
set vars(make) {init}
set vars(make_browser) {netscape}
set vars(make_syn_tool) {genus}
set vars(make_syn_tool_args) {-64 -legacy_ui}
set vars(make_tool) {innovus}
set vars(make_tool_args) {-nowin -64}
set vars(makefile) {false}
set vars(max_route_layer) {3}
set vars(metalfill) {false}
set vars(mode) {flat}
set vars(multi_cut_effort) {high}
set vars(netlist) {./VERILOG/zigbee_cordic_top.v}
set vars(netlist_type) {verilog}
set vars(novus) {false}
set vars(oa_abstract_name) {}
set vars(oa_design_cell) {}
set vars(oa_design_lib) {}
set vars(oa_design_view) {}
set vars(oa_layout_name) {}
set vars(orig_dbs_dir) {DBS}
set vars(orig_log_dir) {LOG}
set vars(orig_rpt_dir) {RPT}
set vars(pac_scratch_dir) {PAC_SCRATCH}
set vars(parent) {edi}
set vars(partition_dir) {PARTITION}
set vars(partition_dir_pass2) {PARTITION_CTS}
set vars(place,time_design,skip) {true}
set vars(place_io_pins) {false}
set vars(place_opt_design) {true}
set vars(placement_based_ptn) {0}
set vars(plugins) {pre_init_tcl always_source_tcl post_init_tcl}
set vars(plugins_defined) {always_source_tcl pre_init_tcl post_init_tcl pre_place_tcl post_place_tcl pre_cts_tcl post_cts_tcl pre_prects_tcl post_prects_tcl pre_postcts_tcl post_postcts_tcl pre_postcts_hold_tcl post_postcts_hold_tcl pre_route_tcl post_route_tcl pre_postroute_tcl post_postroute_tcl pre_postroute_hold_tcl post_postroute_hold_tcl pre_signoff_tcl post_signoff_tcl}
set vars(plugins_found) {always_source_tcl pre_init_tcl post_init_tcl pre_place_tcl post_place_tcl pre_cts_tcl post_cts_tcl pre_prects_tcl post_prects_tcl pre_postcts_tcl post_postcts_tcl pre_postcts_hold_tcl post_postcts_hold_tcl pre_route_tcl post_route_tcl pre_postroute_tcl post_postroute_tcl pre_postroute_hold_tcl post_postroute_hold_tcl pre_signoff_tcl post_signoff_tcl}
set vars(post_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_postcts.sdc ./CONSTRAINTS/constraints_def_worst.sdc}
set vars(post_cts_tcl) {./PLUG/INNOVUS/post_cts.tcl}
set vars(post_init_tcl) {./PLUG/INNOVUS/post_init.tcl}
set vars(post_place_tcl) {./PLUG/INNOVUS/post_place.tcl}
set vars(post_postcts_hold_tcl) {./PLUG/INNOVUS/post_postcts_hold.tcl}
set vars(post_postcts_tcl) {./PLUG/INNOVUS/post_postcts.tcl}
set vars(post_postroute_hold_tcl) {./PLUG/INNOVUS/post_postroute_hold.tcl}
set vars(post_postroute_tcl) {./PLUG/INNOVUS/post_postroute.tcl}
set vars(post_prects_tcl) {./PLUG/INNOVUS/post_prects.tcl}
set vars(post_route_tcl) {./PLUG/INNOVUS/post_route.tcl}
set vars(post_signoff_tcl) {./PLUG/INNOVUS/post_signoff.tcl}
set vars(postcts_setup_hold) {false}
set vars(postroute_extraction_effort) {high}
set vars(postroute_setup_hold) {true}
set vars(postroute_spread_wires) {false}
set vars(power_analysis_view) {hold_func_min}
set vars(power_effort) {low}
set vars(power_nets) {vdd! vdd3r1! vdd3r2! vdd3o!}
set vars(pre_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_prects.sdc ./CONSTRAINTS/constraints_def_worst.sdc}
set vars(pre_cts_tcl) {./PLUG/INNOVUS/pre_cts.tcl}
set vars(pre_init_tcl) {./PLUG/INNOVUS/pre_init.tcl}
set vars(pre_place_tcl) {./PLUG/INNOVUS/pre_place.tcl}
set vars(pre_postcts_hold_tcl) {./PLUG/INNOVUS/pre_postcts_hold.tcl}
set vars(pre_postcts_tcl) {./PLUG/INNOVUS/pre_postcts.tcl}
set vars(pre_postroute_hold_tcl) {./PLUG/INNOVUS/pre_postroute_hold.tcl}
set vars(pre_postroute_tcl) {./PLUG/INNOVUS/pre_postroute.tcl}
set vars(pre_prects_tcl) {./PLUG/INNOVUS/pre_prects.tcl}
set vars(pre_route_tcl) {./PLUG/INNOVUS/pre_route.tcl}
set vars(pre_signoff_tcl) {./PLUG/INNOVUS/pre_signoff.tcl}
set vars(proc_file) {1}
set vars(process) {250nm}
set vars(qrc_layer_map) {./INPUT_DATA/qrclay.map}
set vars(qxconf_file) {}
set vars(qxlayermap_file) {./INPUT_DATA/qrclay.map}
set vars(qxlib_file) {}
set vars(qxtech_file) {/softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-typical/qrcTechFile}
set vars(rc) {false}
set vars(rc_best,T) {-25}
set vars(rc_best,cap_table) {/softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-best.capTable}
set vars(rc_best,post_route_cap_factor) {1.0}
set vars(rc_best,post_route_res_factor) {1.0}
set vars(rc_best,post_route_xcap_factor) {1.0}
set vars(rc_best,pre_route_cap_factor) {1.0}
set vars(rc_best,pre_route_res_factor) {1.0}
set vars(rc_best,qx_tech_file) {/softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-best/qrcTechFile}
set vars(rc_corners) {rc_best rc_typ rc_worst}
set vars(rc_typ,T) {25}
set vars(rc_typ,cap_table) {/softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-typical.capTable}
set vars(rc_typ,post_route_cap_factor) {1.0}
set vars(rc_typ,post_route_clk_cap_factor) {1.0}
set vars(rc_typ,post_route_clk_res_factor) {1.0}
set vars(rc_typ,post_route_res_factor) {1.0}
set vars(rc_typ,post_route_xcap_factor) {1.0}
set vars(rc_typ,pre_route_cap_factor) {1.0}
set vars(rc_typ,pre_route_clk_cap_factor) {1.0}
set vars(rc_typ,pre_route_clk_res_factor) {1.0}
set vars(rc_typ,pre_route_res_factor) {1.0}
set vars(rc_typ,qx_tech_file) {/softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-typical/qrcTechFile}
set vars(rc_worst,T) {125}
set vars(rc_worst,cap_table) {/softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-worst.capTable}
set vars(rc_worst,post_route_cap_factor) {1.0}
set vars(rc_worst,post_route_clk_cap_factor) {1.0}
set vars(rc_worst,post_route_clk_res_factor) {1.0}
set vars(rc_worst,post_route_res_factor) {1.0}
set vars(rc_worst,post_route_xcap_factor) {1.0}
set vars(rc_worst,pre_route_cap_factor) {1.0}
set vars(rc_worst,pre_route_clk_cap_factor) {1.0}
set vars(rc_worst,pre_route_clk_res_factor) {1.0}
set vars(rc_worst,pre_route_res_factor) {1.0}
set vars(rc_worst,qx_tech_file) {/softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-worst/qrcTechFile}
set vars(remote_hosts) {0}
set vars(report_power) {true}
set vars(report_run_time) {true}
set vars(report_system_info) {true}
set vars(required_procs) {source_file system_info get_clock_ports report_time insert_welltaps_endcaps  save_results load_applet get_tool load_path_groups }
set vars(resize_shifter_and_iso_insts) {true}
set vars(restore_design) {1}
set vars(route,check_place,skip) {true}
set vars(route,time_design,skip) {true}
set vars(route_clock_nets) {true}
set vars(rpt_dir) {RPT}
set vars(run_clp) {true}
set vars(run_cts) {true}
set vars(run_lec) {true}
set vars(rundir_namechange_method) {suffix}
set vars(save_constraints) {true}
set vars(save_on_catch) {false}
set vars(save_rc) {true}
set vars(script_path) {./SCRIPTS}
set vars(script_root) {./SCRIPTS}
set vars(seed) {1}
set vars(setup_analysis_views) {setup_func_min setup_func_typ setup_func_max}
set vars(setup_func_max,constraint_mode) {setup_func_mode}
set vars(setup_func_max,delay_corner) {corner_max}
set vars(setup_func_min,constraint_mode) {setup_func_mode}
set vars(setup_func_min,delay_corner) {corner_min}
set vars(setup_func_mode,post_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_postcts.sdc ./CONSTRAINTS/constraints_def_worst.sdc}
set vars(setup_func_mode,pre_cts_sdc) {./CONSTRAINTS/clock_def.sdc ./CONSTRAINTS/clock_uncertainty_prects.sdc ./CONSTRAINTS/constraints_def_worst.sdc}
set vars(setup_func_typ,constraint_mode) {setup_func_mode}
set vars(setup_func_typ,delay_corner) {corner_typ}
set vars(setup_path) {.}
set vars(setup_tcl) {./setup.tcl}
set vars(si_analysis_type) {default}
set vars(signoff_extraction_effort) {signoff}
set vars(signoff_extraction_engine) {qrc}
set vars(skew_buffers) {CLKBU2 CLKBU4 CLKBU6 CLKBU8 CLKBU12 CLKBU15}
set vars(skip_cts) {false}
set vars(skip_signoff_checks) {false}
set vars(slow_libs,timing) {/softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_WC.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_WC.lib}
set vars(sourced) {true}
set vars(step) {init}
set vars(step_arg) {init}
set vars(steps) {init place prects cts postcts postcts_hold route postroute postroute_hold signoff}
set vars(stop_step) {signoff}
set vars(style) {none}
set vars(superhosts) {0}
set vars(superthreads) {1}
set vars(synth_flow) {default_synthesis_flow_3step}
set vars(threads) {1}
set vars(tie_cells) {TIE1 TIE0}
set vars(time_info_db) {RPT/time_info.db}
set vars(time_info_rpt) {RPT/time_info.rpt}
set vars(timelib) {}
set vars(timelib,max) {/softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_TYP.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_TYP.lib}
set vars(timelib,min) {/softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_TYP.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_TYP.lib}
set vars(top) {0}
set vars(top_cell) {filter_io}
set vars(track_opt) {false}
set vars(typ_libs,timing) {/softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_TYP.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_TYP.lib}
set vars(uniquify_netlist) {1}
set vars(update_io_latency) {false}
set vars(use_flexmodels) {0}
set vars(use_proto_net_delay_model) {false}
set vars(useful_skew) {true}
set vars(user_comments) {0}
set vars(user_mode) {flat}
set vars(verbose) {false}
set vars(verify_litho) {false}
set vars(version) {15.2.0}
set vars(vpath) {make}
set vars(warning_count) {2}
set vars(wc_cap_table) {/softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-typical.capTable}
set vars(restore_design) {true}
