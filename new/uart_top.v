`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/13 20:52:16
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top#(
    parameter                   P_SYSTEM_CLK      = 50_000_000      ,   //输入时钟
    parameter                   P_UART_BUADRATE   = 115200		    ,   //波特率
    parameter                   P_UART_DATA_WIDTH = 8               ,   //数据位宽
    parameter                   P_UART_STOP_WIDTH = 1               ,   //1 or 2
    parameter                   P_UART_CHECK      = 0                   //None = 0 ,Odd = 1, Event = 2
)
(
    input       wire                                i_clk               ,

    input       wire                                i_uart_rx           ,
    output      wire                                o_uart_tx           
);

wire 							w_clk_50MHz					;
wire 							w_clk_rst					;
wire							w_system_pll_locked			;

wire 							w_user_tx_ready				;
wire [P_UART_DATA_WIDTH-1:0]	w_user_tx_data				;
wire 							w_user_tx_vaild				;

wire [P_UART_DATA_WIDTH-1:0]	w_user_rx_data				;
wire 							w_user_rx_vaild				;

wire							w_user_clk					;
wire							w_user_rst					;
wire							w_fifo_empty				;

reg								r_fifo_rd_en				;
reg								r_uart_tx_vaild				;
reg								r_rden_lock					;

reg								r_user_tx_ready_1d			;

assign	w_clk_rst = ~w_system_pll_locked;

clk_50M clk_50M_inst1(
    .clk_out1					( w_clk_50MHz				),   
    .locked						( w_system_pll_locked		),   
    .clk_in1					( i_clk						)
); 

uart_drive #(
	.P_SYSTEM_CLK      			( P_SYSTEM_CLK      		),
	.P_UART_BUADRATE   			( P_UART_BUADRATE   		),
	.P_UART_DATA_WIDTH 			( P_UART_DATA_WIDTH 		),
	.P_UART_STOP_WIDTH 			( P_UART_STOP_WIDTH 		),
	.P_UART_CHECK      			( P_UART_CHECK      		))
uart_drive_inst2(
	//ports
	.i_clk                		( w_clk_50MHz          		),
	.i_rst                		( w_clk_rst           		),

	.i_uart_rx            		( i_uart_rx            		),
	.o_uart_tx            		( o_uart_tx            		),

	.i_user_tx_data       		( w_user_tx_data	 		),
	.i_user_tx_data_vaild 		( r_uart_tx_vaild	  		),
	.o_user_tx_data_ready 		( w_user_tx_ready	 		),

	.o_user_rx_data       		( w_user_rx_data	  		),
	.o_user_rx_data_vaild 		( w_user_rx_vaild	 		),
	.o_user_clk					( w_user_clk				),				
	.o_user_rst					( w_user_rst				)	
);

UART_FIFO UART_FIFO_inst3 (
  .clk							( w_user_clk				),      // input wire clk
  .srst							( w_user_rst				),    	// input wire srst
  .din							( w_user_rx_data			),      // input wire [7 : 0] din
  .wr_en						( w_user_rx_vaild			),  	// input wire wr_en
  .rd_en						( r_fifo_rd_en				),  	// input wire rd_en
  .dout							( w_user_tx_data			),    	// output wire [7 : 0] dout
  .full							(							),    	// output wire full
  .empty						( w_fifo_empty				)  		// output wire empty
);

always @(posedge w_user_clk or posedge w_user_rst) begin
	if (w_user_rst)begin
		r_user_tx_ready_1d <= 'd0;
	end else begin
		r_user_tx_ready_1d <= w_user_tx_ready;
	end
end

always @(posedge w_user_clk or posedge w_user_rst) begin
	if (w_user_rst)begin
		r_rden_lock <= 'd0;
	end else if (w_user_tx_ready && !r_user_tx_ready_1d) begin
		r_rden_lock <= 'd0;
	end else if (!w_fifo_empty && w_user_tx_ready) begin
		r_rden_lock <= 'd1;
	end else begin
		r_rden_lock <= r_rden_lock;
	end
end

always @(posedge w_user_clk or posedge w_user_rst) begin
	if (w_user_rst)begin
		r_fifo_rd_en <= 'd0;
	end else if (~w_fifo_empty && !r_rden_lock) begin
		r_fifo_rd_en <= 'd1;
	end else begin
		r_fifo_rd_en <= 'd0;
	end
end

always @(posedge w_user_clk or posedge w_user_rst) begin
	if (w_user_rst)begin
		r_uart_tx_vaild <= 'd0;
	end else begin
		r_uart_tx_vaild <= r_fifo_rd_en;
	end
end

endmodule
