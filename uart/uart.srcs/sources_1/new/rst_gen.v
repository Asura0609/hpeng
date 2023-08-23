`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:44:33
// Design Name: 
// Module Name: rst_gen
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


module rst_gen#(
    parameter   P_RST_CYCLE =   1
)
(
    input   wire    i_clk          ,
    output  wire    o_rst   
);
    
/***************reg*******************/
reg         ro_rst  = 1               ;     //上电位高
reg [7:0]   ro_cnt  = 0               ;
    
/***************assign****************/
assign  o_rst   =   ro_rst  ;   
/***************always****************/
always @(posedge i_clk) begin
    if (ro_cnt == P_RST_CYCLE - 1 || P_RST_CYCLE == 0) begin
        ro_cnt <= ro_cnt;
    end else begin
        ro_cnt <= ro_cnt + 1;
    end
end

always @(posedge i_clk) begin
    if ((ro_cnt == P_RST_CYCLE - 1) || (P_RST_CYCLE == 0)) begin
        ro_rst <= 'd0;
    end else begin
        ro_rst <= 'd1;
    end
end

endmodule
