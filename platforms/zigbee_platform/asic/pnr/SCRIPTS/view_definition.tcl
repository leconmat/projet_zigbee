create_rc_corner -name rc_best \
   -cap_table /softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-best.capTable \
   -T \
   -25 \
   -qx_tech_file /softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-best/qrcTechFile \
   -preRoute_res 1.0 \
   -preRoute_cap 1.0 \
   -postRoute_res 1.0 \
   -postRoute_cap 1.0 \
   -postRoute_xcap 1.0
#------------------------------------------------
# Additional (unused) options ....
#------------------------------------------------
# -preRoute_clkres $vars(rc_best,pre_route_clk_res_factor)
# -preRoute_clkcap $vars(rc_best,pre_route_clk_cap_factor)
# -postRoute_res $vars(rc_best,post_route_clk_res_factor)
# -postRoute_clkcap $vars(rc_best,post_route_clk_cap_factor)
#------------------------------------------------
create_rc_corner -name rc_typ \
   -cap_table /softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-typical.capTable \
   -T 25 \
   -qx_tech_file /softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-typical/qrcTechFile \
   -preRoute_res 1.0 \
   -preRoute_cap 1.0 \
   -preRoute_clkres 1.0 \
   -preRoute_clkcap 1.0 \
   -postRoute_res 1.0 \
   -postRoute_cap 1.0 \
   -postRoute_clkres 1.0 \
   -postRoute_clkcap 1.0 \
   -postRoute_xcap 1.0
create_rc_corner -name rc_worst \
   -cap_table /softslin/AMS_410_ISR15/cds/HK_C35/LEF/encounter/c35b4_thick-worst.capTable \
   -T 125 \
   -qx_tech_file /softslin/AMS_410_ISR15/assura/c35b4/c35b4thickall/RCX-worst/qrcTechFile \
   -preRoute_res 1.0 \
   -preRoute_cap 1.0 \
   -preRoute_clkres 1.0 \
   -preRoute_clkcap 1.0 \
   -postRoute_res 1.0 \
   -postRoute_cap 1.0 \
   -postRoute_clkres 1.0 \
   -postRoute_clkcap 1.0 \
   -postRoute_xcap 1.0
create_library_set -name slow_libs \
   -timing [list /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_WC.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_WC.lib]
create_library_set -name typ_libs \
   -timing [list /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_TYP.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_TYP.lib]
create_library_set -name fast_libs \
   -timing [list /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_CORELIB_BC.lib /softslin/AMS_410_ISR15/liberty/c35_3.3V/c35_IOLIB_BC.lib]
create_delay_corner -name corner_min -library_set fast_libs -rc_corner rc_best
create_delay_corner -name corner_typ -library_set typ_libs -rc_corner rc_typ
create_delay_corner -name corner_max -library_set slow_libs -rc_corner rc_worst
create_constraint_mode -name setup_func_mode \
   -sdc_files [list ./CONSTRAINTS/clock_def.sdc \
                    ./CONSTRAINTS/clock_uncertainty_prects.sdc \
                    ./CONSTRAINTS/constraints_def_worst.sdc]
create_constraint_mode -name hold_func_mode \
   -sdc_files [list ./CONSTRAINTS/clock_def.sdc \
                    ./CONSTRAINTS/clock_uncertainty_prects.sdc \
                    ./CONSTRAINTS/constraints_def_best.sdc]
create_analysis_view -name hold_func_max \
   -constraint_mode hold_func_mode \
   -delay_corner corner_max
create_analysis_view -name hold_func_min \
   -constraint_mode hold_func_mode \
   -delay_corner corner_min
create_analysis_view -name hold_func_typ \
   -constraint_mode hold_func_mode \
   -delay_corner corner_typ
create_analysis_view -name setup_func_max \
   -constraint_mode setup_func_mode \
   -delay_corner corner_max
create_analysis_view -name setup_func_min \
   -constraint_mode setup_func_mode \
   -delay_corner corner_min
create_analysis_view -name setup_func_typ \
   -constraint_mode setup_func_mode \
   -delay_corner corner_typ



set_analysis_view -setup [list setup_func_max] -hold [list hold_func_max]

