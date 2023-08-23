vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../uart.srcs/sources_1/ip/UART_FIFO/sim/UART_FIFO.v" \


vlog -work xil_defaultlib \
"glbl.v"

