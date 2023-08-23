`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:38:28
// Design Name: 
// Module Name: clk_dev
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


module clk_div
#(
    parameter       P_CLK_DIV_CNT   =   2   //最大为65535
)
(
    input   wire    i_clk   ,
    input   wire    i_rst   ,
    output  wire    o_clk_dev
);

reg         ro_clk_dev;
reg [15:0]  r_cnt;   
   
/***************assign****************/
assign o_clk_dev = ro_clk_dev;   
/***************always****************/
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        r_cnt <= 'd0;
    end else if (r_cnt == P_CLK_DIV_CNT >> 1) begin
        r_cnt <= 'd0;
    end else begin
        r_cnt <= r_cnt + 'd1;
    end
end

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        ro_clk_dev <= 'd0;
    end else if (r_cnt == P_CLK_DIV_CNT >> 1) begin
        ro_clk_dev <= ~ro_clk_dev;
    end else begin
        ro_clk_dev <= ro_clk_dev;
    end
end 

endmodule
