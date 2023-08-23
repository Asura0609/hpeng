set_property SRC_FILE_INFO {cfile:d:/Study/Xlinx/FPGA/uart/uart.srcs/sources_1/ip/clk_50M/clk_50M.xdc rfile:../uart.srcs/sources_1/ip/clk_50M/clk_50M.xdc id:1 order:EARLY scoped_inst:clk_50M_inst1/inst} [current_design]
current_instance clk_50M_inst1/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.04
