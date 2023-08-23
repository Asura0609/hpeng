`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:20:18
// Design Name: 
// Module Name: uart_drive
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


module uart_drive#(
    parameter                   P_SYSTEM_CLK      = 50_000_000      ,   //输入时钟
    parameter                   P_UART_BUADRATE   = 9600		    ,   //波特率
    parameter                   P_UART_DATA_WIDTH = 8               ,   //数据位宽
    parameter                   P_UART_STOP_WIDTH = 1               ,   //1 or 2
    parameter                   P_UART_CHECK      = 0                   //None = 0 ,Odd = 1, Event = 2
)
(
    input       wire                                i_clk               ,
    input       wire                                i_rst               ,   //跨时钟了

    input       wire                                i_uart_rx           ,
    output      wire                                o_uart_tx           ,

	input   	wire    [P_UART_DATA_WIDTH - 1 : 0] i_user_tx_data      ,     //用户发送的数据
    input   	wire                                i_user_tx_data_vaild,
    output  	wire                                o_user_tx_data_ready,

	output      wire    [P_UART_DATA_WIDTH - 1 : 0] o_user_rx_data      ,
    output      wire                                o_user_rx_data_vaild,
	
	output		wire								o_user_clk			,
	output		wire								o_user_rst	
);

/***************function**************/
    
/***************parameter*************/
localparam P_CLK_DIV_NUMBER = P_SYSTEM_CLK / P_UART_BUADRATE; //上电后只计算一次，  
/***************port******************/
    
/***************mechine***************/
    
/***************reg*******************/
reg										r_uart_rx_rst					;
reg		[2:0]							r_rx_overvalue					;
reg		[2:0]							r_rx_overvalue_1d				;
reg										r_rx_overlock					;

reg										ro_user_rx_data_vaild 			;
reg		[P_UART_DATA_WIDTH - 1:0]		r_user_rx_data_1				;
reg		[P_UART_DATA_WIDTH - 1:0] 		r_user_rx_data_2				;
reg										r_user_rx_data_vaild_1			;
reg										r_user_rx_data_vaild_2			;
/***************wire******************/

wire 									w_uart_buadclk                	;
wire 									w_uart_rst                    	;

wire									w_uart_rx_clk					;
wire	[P_UART_DATA_WIDTH - 1:0]		w_user_rx_data      			;
wire									w_user_rx_data_vaild			;
/***************component*************/
clk_div #(
	.P_CLK_DIV_CNT 	            ( P_CLK_DIV_NUMBER          ))
clk_div_tx(                  
	//ports                 
	.i_clk     		            ( i_clk     		        ),
	.i_rst     		            ( i_rst				        ),
	.o_clk_dev 		            ( w_uart_buadclk	        )
);

clk_div #(
	.P_CLK_DIV_CNT 	            ( P_CLK_DIV_NUMBER          ))
clk_div_rx(                  
	//ports                 
	.i_clk     		            ( i_clk     		        ),
	.i_rst     		            ( r_uart_rx_rst		        ),
	.o_clk_dev 		            ( w_uart_rx_clk		        )
);

rst_gen #(
	.P_RST_CYCLE 		        ( 10 		                ))
u_rst_gen(
	//ports
	.i_clk 		                ( w_uart_buadclk            ),
	.o_rst 		                ( w_uart_rst	            )
);

uart_rx #(
	.P_SYSTEM_CLK      		    ( P_SYSTEM_CLK     	        ),
	.P_UART_BUADRATE   		    ( P_UART_BUADRATE  	        ),
	.P_UART_DATA_WIDTH 		    ( P_UART_DATA_WIDTH	        ),
	.P_UART_STOP_WIDTH 		    ( P_UART_STOP_WIDTH	        ),
    .P_UART_CHECK               ( P_UART_CHECK			    ))
u_uart_rx(
	//ports
	.i_clk                		( w_uart_rx_clk       		),
	.i_rst                		( w_uart_rst        		),
	.i_uart_rx            		( i_uart_rx            		),
	.o_user_rx_data       		( w_user_rx_data       		),
	.o_user_rx_data_vaild 		( w_user_rx_data_vaild 		)
);

uart_tx #(
	.P_SYSTEM_CLK      		    ( P_SYSTEM_CLK     	        ),
	.P_UART_BUADRATE   		    ( P_UART_BUADRATE  	        ),
	.P_UART_DATA_WIDTH 		    ( P_UART_DATA_WIDTH	        ),
	.P_UART_STOP_WIDTH 		    ( P_UART_STOP_WIDTH	        ),
    .P_UART_CHECK               ( P_UART_CHECK				))
u_uart_tx(
	//ports
	.i_clk                		( w_uart_buadclk       		),
	.i_rst                		( w_uart_rst          		),

	.o_uart_tx            		( o_uart_tx            		),

	.i_user_tx_data       		( i_user_tx_data       		),
	.i_user_tx_data_vaild 		( i_user_tx_data_vaild 		),
	.o_user_tx_data_ready 		( o_user_tx_data_ready		)
);
/***************assign****************/
assign	o_user_clk 				= w_uart_buadclk			;
assign	o_user_rst 				= w_uart_rst				;

assign	o_user_rx_data      	= r_user_rx_data_2			;	
assign	o_user_rx_data_vaild	= r_user_rx_data_vaild_2	;
/***************always****************/
always @(posedge i_clk or posedge i_rst) begin
	if (i_rst)begin
		r_rx_overvalue <= 'd0;
	end else if (!r_rx_overlock) begin
		r_rx_overvalue <= {r_rx_overvalue[1:0],i_uart_rx};
	end else begin
		r_rx_overvalue <= 3'b111;
	end
end

always @(posedge i_clk or posedge i_rst) begin
	if (i_rst)begin
		r_rx_overvalue_1d <= 'd0;
	end else begin
		r_rx_overvalue_1d <= r_rx_overvalue;
	end
end

always @(posedge i_clk or posedge i_rst) begin
	if (i_rst)begin
		r_rx_overlock <= 'd0;
	end else if (!w_user_rx_data_vaild && ro_user_rx_data_vaild) begin
		r_rx_overlock <= 'd0;
	end else if (r_rx_overvalue == 3'b000 && r_rx_overvalue_1d != 3'b000) begin
		r_rx_overlock <= 'd1;
	end else begin
		r_rx_overlock <= r_rx_overlock;
	end
end

always @(posedge i_clk or posedge i_rst) begin
	if (i_rst)begin
		ro_user_rx_data_vaild <= 'd0;
	end else begin
		ro_user_rx_data_vaild <= w_user_rx_data_vaild;
	end
end

always @(posedge i_clk or posedge i_rst) begin
	if (i_rst)begin
		r_uart_rx_rst <= 'd1;
	end else if (!w_user_rx_data_vaild && ro_user_rx_data_vaild) begin
		r_uart_rx_rst <= 'd1;
	end else if (r_rx_overvalue == 3'b000 && r_rx_overvalue_1d != 3'b000) begin
		r_uart_rx_rst <= 'd0;
	end else begin
		r_uart_rx_rst <= r_uart_rx_rst;
	end 
end

always @(posedge w_uart_buadclk or posedge w_uart_rst) begin 
	if (w_uart_rst)begin
		r_user_rx_data_1		<= 'd0;	
		r_user_rx_data_2		<= 'd0;	
		r_user_rx_data_vaild_1	<= 'd0;
		r_user_rx_data_vaild_2	<= 'd0;
	end else begin
		r_user_rx_data_1		<= w_user_rx_data			;	
		r_user_rx_data_2		<= r_user_rx_data_1			;	
		r_user_rx_data_vaild_1	<= w_user_rx_data_vaild		;
		r_user_rx_data_vaild_2	<= r_user_rx_data_vaild_1	;
	end
end
endmodule
