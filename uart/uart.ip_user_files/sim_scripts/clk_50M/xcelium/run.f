-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/SoftWare/Vivado/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/SoftWare/Vivado/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../uart.srcs/sources_1/ip/clk_50M/clk_50M_clk_wiz.v" \
  "../../../../uart.srcs/sources_1/ip/clk_50M/clk_50M.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

