`timescale 1ns / 1ps

module uarttx #(
parameter clk_freq = 1000000,
parameter baud_rate = 9600
)
(
  input clk, rst,
  input newd,
  input [7:0] tx_data,
  output reg tx,
  output reg donetx
);

  reg [15:0] count;
  reg [3:0] counts;
  reg uclk;
  reg [7:0] din;

  reg [1:0] state;
  
  localparam clkcount = (clk_freq / baud_rate);
  localparam IDLE = 2'b00;
  localparam TRANSFER = 2'b01;

  // UART clock generation
  always @(posedge clk) begin
  
    if (rst) begin
        count <= 0;
        uclk <= 0;
    end
  
    else begin
    
      if (count < (clkcount) / 2) begin
        count <= count + 1;
      end 
      else begin
        count <= 0;
        uclk <= ~uclk;
      end
     end
   end

  // FSM
  always @(posedge uclk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      tx <= 1'b1;
      donetx <= 1'b0;
      counts <= 0;
    end 
    
    else begin
      case(state)
IDLE: begin
          counts <= 0;
          tx <= 1'b1;
          donetx <= 1'b0;

          if (newd) begin
            state <= TRANSFER;
            din <= tx_data;
            tx <= 1'b0;
          end else begin
            state <= IDLE;
          end
        end

TRANSFER: begin
          if (counts <= 7) begin
            counts <= counts + 1;
            tx <= din[counts];
            state <= TRANSFER;
          end else begin
            counts <= 0;
            tx <= 1'b1;
            state <= IDLE;
            donetx <= 1'b1;
          end
        end


        default: state <= IDLE;
      endcase
    end
  end

endmodule
