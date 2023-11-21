`timescale 1ns / 1ps

module uartrx (
  input clk,
  input rst,
  input rx,
  output reg done,
  output reg [7:0] rxdata
);

  parameter clk_freq = 1000000; // MHz
  parameter baud_rate = 9600;

  localparam clkcount = (clk_freq / baud_rate);

  reg [15:0] count;
  reg [3:0] counts;
  reg uclk;

  reg [1:0] state;

  localparam IDLE = 2'b00;
  localparam START = 2'b01;

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
  

  // UART receive FSM
  always @(posedge uclk or posedge rst) begin
    if (rst) begin
      rxdata <= 8'h00;
      counts <= 0;
      done <= 1'b0;
      state <= IDLE;
    end else begin
      case (state)
IDLE: begin
          rxdata <= 8'h00;
          counts <= 0;
          done <= 1'b0;

          if (rx == 1'b0)
            state <= START;
          else
            state <= IDLE;
        end

START: begin
          if (counts <= 7) begin
            counts <= counts + 1;
            rxdata <= {rx, rxdata[7:1]};
          end else begin
            counts <= 0;
            done <= 1'b1;
            state <= IDLE;
          end
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule
