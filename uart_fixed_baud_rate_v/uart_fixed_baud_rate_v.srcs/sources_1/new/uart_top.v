`timescale 1ns / 1ps

module uart_top (
  input clk, rst,
  input rx,
  input [7:0] dintx,
  input newd,
  output tx,
  output [7:0] doutrx,
  output donetx,
  output donerx
);

  parameter clk_freq = 1000000;
  parameter baud_rate = 9600;

  // Instantiate UART Transmit module
  uarttx #(clk_freq, baud_rate) utx (
    .clk(clk),
    .rst(rst),
    .newd(newd),
    .tx(tx),
    .donetx(donetx),
    .tx_data(dintx)
  );

  // Instantiate UART Receive module
  uartrx #(clk_freq, baud_rate) rtx (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .done(donerx),
    .rxdata(doutrx)
  );

endmodule
