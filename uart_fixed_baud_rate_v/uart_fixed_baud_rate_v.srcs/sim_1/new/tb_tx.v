`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2023 12:01:35
// Design Name: 
// Module Name: tb_tx
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


`timescale 1ns / 1ps

module tb_tx;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ps

  // Signals
  reg clk;
  reg rst;
  reg newd;
  reg [7:0] tx_data;
  wire tx;
  wire donetx;
  integer i,j;

  // Instantiate the UART TX module
  uarttx #(1000000, 9600) uut (
    .clk(clk),
    .rst(rst),
    .newd(newd),
    .tx_data(tx_data),
    .tx(tx),
    .donetx(donetx)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #((CLK_PERIOD / 2)) clk = ~clk;
  end

  // Test scenario
initial begin

rst = 1;
repeat(5) @(posedge clk);
rst = 0;
 
for( i = 0 ; i < 10; i=i+1)
begin
rst = 0;
newd = 1;
tx_data = $urandom();
wait(tx == 0); 
@(posedge donetx);
end

    // Wait for transmission to complete
    #200000;

    // End simulation
    $finish;
end

endmodule

