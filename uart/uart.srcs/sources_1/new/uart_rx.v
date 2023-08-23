`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:13:35
// Design Name: 
// Module Name: uart_rx
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


module uart_rx#(
    parameter                   P_SYSTEM_CLK      = 50_000_000      ,   //输入时钟
    parameter                   P_UART_BUADRATE   = 9600            ,   //波特率
    parameter                   P_UART_DATA_WIDTH = 8               ,   //数据宽度
    parameter                   P_UART_STOP_WIDTH = 1               ,   //1 or 2
    parameter                   P_UART_CHECK      = 0                   //None = 0 ,Odd = 1, Event = 2
)
(
    input       wire                                i_clk               ,
    input       wire                                i_rst               ,

    input       wire                                i_uart_rx           ,

    output      wire    [P_UART_DATA_WIDTH - 1 : 0] o_user_rx_data      ,
    output      wire                                o_user_rx_data_vaild
);

/***************function**************/
    
/***************parameter*************/
    
/***************port******************/
    
/***************mechine***************/
    
/***************reg*******************/
reg [P_UART_DATA_WIDTH - 1 : 0]                 ro_user_rx_data                 ;
reg                                             ro_user_rx_data_vaild           ;
reg [1:0]                                       ri_uart_rx                      ;
reg [3:0]                                       r_cnt                           ;
reg                                             r_rx_check                      ;

/***************wire******************/
    
/***************component*************/
    
/***************assign****************/
assign o_user_rx_data       = ro_user_rx_data       ;
assign o_user_rx_data_vaild = ro_user_rx_data_vaild ;
/***************always****************/
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        ri_uart_rx <= 2'b11;
    end else begin
        ri_uart_rx <= {ri_uart_rx[0],i_uart_rx};
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        r_cnt <= 'd0;
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 2 && P_UART_CHECK == 0) begin
        r_cnt <= 'd0;
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 1 && P_UART_CHECK > 0) begin
        r_cnt <= 'd0;
    end else if (i_uart_rx == 1'b0 || r_cnt > 0) begin
        r_cnt <= r_cnt + 'd1;
    end else begin
        r_cnt <= r_cnt;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        ro_user_rx_data <= 'd0;
    end else if (r_cnt >= 1 && r_cnt <= P_UART_DATA_WIDTH) begin
        ro_user_rx_data <= {i_uart_rx,ro_user_rx_data[P_UART_DATA_WIDTH - 1 :1]};
    end else begin
        ro_user_rx_data <= ro_user_rx_data;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        ro_user_rx_data_vaild <= 'd0;
    end else if (r_cnt == P_UART_DATA_WIDTH + 0 && P_UART_CHECK == 0) begin
        ro_user_rx_data_vaild <= 'd1;
    end else if (r_cnt == P_UART_DATA_WIDTH + 1 && P_UART_CHECK == 1 && i_uart_rx == !r_rx_check) begin
        ro_user_rx_data_vaild <= 'd1;
    end else if (r_cnt == P_UART_DATA_WIDTH + 1 && P_UART_CHECK == 2 && i_uart_rx == r_rx_check) begin
        ro_user_rx_data_vaild <= 'd1;
    end else begin
        ro_user_rx_data_vaild <= 'd0;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        r_rx_check <= 'd0;
    end else if (r_cnt >= 1 && r_cnt <= P_UART_DATA_WIDTH) begin
        r_rx_check <= r_rx_check ^ i_uart_rx;
    end else begin
        r_rx_check <= 'd0;
    end
end

endmodule
