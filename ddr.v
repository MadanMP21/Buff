`timescale 1ns / 1ps

module ddr #(parameter T = 32) (
  input wire clk,
  input wire rstn,
  input wire we,
  input wire re,
  input wire [T-1:0] addr,
  input wire [T-1:0] data_in,
  output reg [T-1:0] data_out
);
  reg [T-1:0] mem [0:255];
 
  always @(*/*posedge clk or negedge clk*/) begin
    if (rstn == 1) begin 
      if (we == 1) begin
            mem[addr[8:0]] <= data_in;
      end 
      else if (re == 1) begin 
            data_out <= mem[addr[8:0]];
      end
    end
  end

endmodule
