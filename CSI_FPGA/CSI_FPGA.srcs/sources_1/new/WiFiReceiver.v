`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2023 05:43:40 PM
// Design Name: 
// Module Name: WiFiReceiver
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


module WiFiReceiver(
    input wire clk,
    input wire rst,
    input wire [31:0] wifi_data,
    output reg [15:0] csi_data
);
  // State machine states
  parameter IDLE = 2'b00;
  parameter SYNC = 2'b01;
  parameter VHT_HEADER = 2'b10;

  // Internal signals
  reg [1:0] state;
  reg [31:0] shift_reg;
  reg [3:0] bit_count;
  reg [15:0] vht_csi;

  // CSI extraction parameters (example, adapt based on your packet structure)
  parameter CSI_START_BIT = 64;
  parameter CSI_BIT_WIDTH = 16;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      shift_reg <= 32'b0;
      bit_count <= 4'b0;
      csi_data <= 16'b0;
    end else begin
      // State machine
      case (state)
        IDLE: begin
          if (wifi_data == 32'hAABBCCDD) begin
            state <= SYNC;
          end
        end
        SYNC: begin
          shift_reg <= {shift_reg[30:0], wifi_data[31]};
          if (shift_reg == 32'bAABBCCDD) begin
            state <= VHT_HEADER;
            bit_count <= 4'b0;
          end
        end
        VHT_HEADER: begin
          // Assuming CSI is located at specific bits in the VHT header
          shift_reg <= {shift_reg[30:0], wifi_data[31]};
          bit_count <= bit_count + 1;
          if (bit_count == CSI_START_BIT + CSI_BIT_WIDTH - 1) begin
            vht_csi <= shift_reg[CSI_START_BIT + CSI_BIT_WIDTH - 1: CSI_START_BIT];
            state <= IDLE;
            csi_data <= vht_csi;
          end
        end
        default: state <= IDLE;
      endcase
    end
  end
    
endmodule
