`timescale 1ns / 1ns

module SIM_uart_drive_TB();

// uart_drive Parameters
localparam PERIOD             = 20        ;

localparam P_SYSTEM_CLK       = 50_000_000;
localparam P_UART_BUADRATE    = 9600      ;
localparam P_UART_DATA_WIDTH  = 8         ;
localparam P_UART_STOP_WIDTH  = 1         ;
localparam P_UART_CHECK       = 0         ;

reg clk     =   0;
reg rst;

reg  [P_UART_DATA_WIDTH - 1: 0] r_user_tx_data          ;
reg                             r_user_tx_valid         ; 

wire                            w_user_tx_ready         ;
wire [P_UART_DATA_WIDTH - 1: 0] w_user_rx_data          ;      
wire                            w_user_rx_data_vaild    ;
wire                            w_user_active           ;
wire                            w_user_clk              ;
wire                            w_user_rst              ;
assign    w_user_active =   r_user_tx_valid && w_user_tx_ready;

initial
begin
    forever #(PERIOD/2)  clk = ~clk;
end

initial
begin
    rst  =  1;
    #100
    rst  =  0;
end

uart_drive #(
    .P_SYSTEM_CLK               ( P_SYSTEM_CLK                  ),
    .P_UART_BUADRATE            ( P_UART_BUADRATE               ),
    .P_UART_DATA_WIDTH          ( P_UART_DATA_WIDTH             ),
    .P_UART_STOP_WIDTH          ( P_UART_STOP_WIDTH             ),
    .P_UART_CHECK               ( P_UART_CHECK                  ))
 u_uart_drive (
    .i_clk                      ( clk                           ),
    .i_rst                      ( rst                           ),

    .o_uart_tx                  ( o_uart_tx                     ),
    .i_uart_rx                  ( o_uart_tx                     ),
 
    .i_user_tx_data             ( r_user_tx_data                ),
    .i_user_tx_data_vaild       ( r_user_tx_valid               ),
    .o_user_tx_data_ready       ( w_user_tx_ready               ),
 
    .o_user_rx_data             ( w_user_rx_data                ),
    .o_user_rx_data_vaild       ( w_user_rx_data_vaild          ),
    .o_user_clk                 ( w_user_clk                    ),
    .o_user_rst                 ( w_user_rst                    )
);

always @(posedge w_user_clk or negedge w_user_rst) begin
    if (w_user_rst)begin
        r_user_tx_data  <= 'd0;
    end else if (w_user_active) begin
        r_user_tx_data  <= r_user_tx_data + 'd1;
    end else begin
        r_user_tx_data  <= r_user_tx_data;
    end
end

always @(posedge w_user_clk or negedge w_user_rst) begin
    if (w_user_rst)begin
        r_user_tx_valid  <= 'd0;
    end else if (w_user_active) begin
        r_user_tx_valid  <= 'd0;
    end else if (w_user_tx_ready) begin
        r_user_tx_valid  <= 'd1;
    end else begin
        r_user_tx_valid  <= r_user_tx_valid;
    end
end

endmodule
