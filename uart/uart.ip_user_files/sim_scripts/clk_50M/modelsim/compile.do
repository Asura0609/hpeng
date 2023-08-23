vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" \
"../../../../uart.srcs/sources_1/ip/clk_50M/clk_50M_clk_wiz.v" \
"../../../../uart.srcs/sources_1/ip/clk_50M/clk_50M.v" \


vlog -work xil_defaultlib \
"glbl.v"

