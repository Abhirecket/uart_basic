`timescale 1ns / 1ps


`timescale 1ns / 1ps

module tb_rx;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ps

  // Signals
  reg clk;
  reg rst;
  reg rx;
  wire [7:0] rxdata;
  wire done;
  integer j;
  reg  min_value = 0;
  reg  max_value = 1;

  // Instantiate the UART RX module
  uartrx #(1000000, 9600) dut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rxdata(rxdata),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #((CLK_PERIOD / 2)) clk = ~clk;
  end

  // Test scenario
  initial begin
    // Initialize signals
    rst = 1;
    rx = 1;

    // Apply reset
    #20 rst = 0;
rx = 0;
@(posedge dut.uclk);
 
for( j = 0; j < 8; j=j+1)
begin
@(posedge dut.uclk);
rx = $urandom_range(min_value, max_value);
@(posedge done);
rx = 0;
end
     // Wait for reception to complete
    #100

    // End simulation
    $finish;
  end

endmodule

