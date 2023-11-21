`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2023 17:12:07
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;
reg clk = 0,rst = 0;
reg rx = 1;
reg [7:0] dintx;
reg newd;
wire tx; 
wire [7:0] doutrx;
wire donetx;
wire donerx;
integer i,j;
 
uart_top #(1000000, 9600) dut (clk, rst, rx, dintx, newd, tx, doutrx, donetx, donerx);
  
always #5 clk = ~clk;  
 
reg [7:0] rx_data = 0;
reg [7:0] tx_data = 0;
 
initial begin
rst = 1;
repeat(5) @(posedge clk);
rst = 0;
 
for(i = 0 ; i < 10; i=i+1)
begin
rst = 0;
newd = 1;
dintx = $urandom();
 
wait(tx == 0);
@(posedge dut.utx.uclk);
 
for( j = 0; j < 8; j=j+1)
begin
@(posedge dut.utx.uclk);
tx_data = {tx,tx_data[7:1]};
end
 
@(posedge donetx);
 
end
 
for(i = 0 ; i < 10; i=i+1)
begin
rst = 0;
newd = 0;
 
rx = 1'b0;
@(posedge dut.utx.uclk);
 
for( j = 0; j < 8; j=j+1)
begin
@(posedge dut.utx.uclk);
rx = $urandom;
rx_data = {rx, rx_data[7:1]};
end
 
@(posedge donerx);
 
end
 
 
end
 
 
endmodule
