`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:13:35
// Design Name: 
// Module Name: uart_tx
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


module uart_tx#(
    parameter                   P_SYSTEM_CLK      = 50_000_000      ,   //输入时钟
    parameter                   P_UART_BUADRATE   = 9600            ,   //波特率
    parameter                   P_UART_DATA_WIDTH = 8               ,   //数据宽度
    parameter                   P_UART_STOP_WIDTH = 1               ,   //1 or 2
    parameter                   P_UART_CHECK      = 0                   //None = 0 ,Event = 1, Odd = 2    
)
(
    input   wire                                i_clk               ,
    input   wire                                i_rst               ,

    output  wire                                o_uart_tx           ,

    input   wire    [P_UART_DATA_WIDTH - 1 : 0] i_user_tx_data      ,     //用户发送的数据
    input   wire                                i_user_tx_data_vaild,
    output  wire                                o_user_tx_data_ready
);

/***************function**************/
    
/***************parameter*************/
    
/***************port******************/
    
/***************mechine***************/
    
/***************reg*******************/
reg                             ro_uart_tx              ; 
reg                             ro_user_tx_data_ready   ; 
reg [15:0]                      r_cnt                   ;   //计数器位宽高于16 bits时，组合逻辑过高，谨慎使用
reg [P_UART_DATA_WIDTH - 1 : 0] r_tx_data               ;
reg                             r_tx_check              ;


/***************wire******************/
wire                            w_tx_active             ;
/***************component*************/
    
/***************assign****************/
assign o_uart_tx            = ro_uart_tx                                    ; 
assign o_user_tx_data_ready = ro_user_tx_data_ready                         ;

assign w_tx_active          = i_user_tx_data_vaild & o_user_tx_data_ready   ;

/***************always****************/
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        ro_user_tx_data_ready <= 'd1; 
    end else if (w_tx_active) begin
        ro_user_tx_data_ready <= 'd0; 
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 3 && P_UART_CHECK == 0 ) begin
        ro_user_tx_data_ready <= 'd1;    
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 2 && P_UART_CHECK > 0 ) begin
        ro_user_tx_data_ready <= 'd1;    
    end else begin
        ro_user_tx_data_ready <= ro_user_tx_data_ready;
    end
end    

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        r_cnt <= 'd0;
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 3 && P_UART_CHECK == 0) begin //2 表示 开始位  校验位
        r_cnt <= 'd0;
    end else if (r_cnt == 2 + P_UART_DATA_WIDTH + P_UART_STOP_WIDTH - 2 && P_UART_CHECK > 0) begin 
        r_cnt <= 'd0;
    end else if (!ro_user_tx_data_ready) begin
        r_cnt <= r_cnt + 1'd1;
    end else begin
        r_cnt <= r_cnt;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        r_tx_data <= 'd0;
    end else if (w_tx_active) begin
        r_tx_data <= i_user_tx_data;
    end else if (!ro_user_tx_data_ready) begin
        r_tx_data <= r_tx_data >> 1;
    end else begin
        r_tx_data <= r_tx_data;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        ro_uart_tx <= 'd1;
    end else if (w_tx_active) begin
        ro_uart_tx <= 'd0;
    end else if ((r_cnt == 3 + P_UART_DATA_WIDTH - 3) && P_UART_CHECK > 0) begin    //开启校验位
        ro_uart_tx <= P_UART_CHECK == 1 ? ~r_tx_check : r_tx_check;                 //判断是奇还是偶
    end else if ((r_cnt == 3 + P_UART_DATA_WIDTH - 3) && P_UART_CHECK == 0) begin   //未开启校验，直接发送停止
        ro_uart_tx <= 'd1;
    end else if ((r_cnt >= 3 + P_UART_DATA_WIDTH - 2) && P_UART_CHECK > 0) begin    //开启了校验，发送完校验，直接发送停止
        ro_uart_tx <= 'd1;
    end else if (!ro_user_tx_data_ready) begin
        ro_uart_tx <= r_tx_data[0];
    end else begin
        ro_uart_tx <= 'd1;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)begin
        r_tx_check <= 'd0;
    end else if (r_cnt == 3 + P_UART_DATA_WIDTH - 3) begin
        r_tx_check <= 'd0;
    end else begin
        r_tx_check <= r_tx_check ^ r_tx_data[0];
    end
end

endmodule
