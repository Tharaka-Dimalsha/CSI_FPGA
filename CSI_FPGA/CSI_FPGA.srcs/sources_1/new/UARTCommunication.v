`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2023 06:28:45 PM
// Design Name: 
// Module Name: UARTCommunication
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


module UARTCommunication(
    input wire clk,
    input wire rst,
    input wire [31:0] csi_data,
    input wire start_transmission,
    output reg uart_tx
    );
    // UART parameters
  parameter BAUD_RATE = 9600; // Adjust as needed
  parameter CLK_FREQ = 50000000; // Adjust based on your clock frequency
  localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;
  localparam HALF_BIT_PERIOD = BIT_PERIOD / 2;

  // Internal signals
  reg [3:0] tx_state;
  reg [6:0] bit_count;
  reg [7:0] data_to_send;

  // UART transmitter state machine
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx_state <= 4'b0000;
      bit_count <= 7'd0;
      data_to_send <= 8'd0;
      uart_tx <= 1;
    end else begin
      case (tx_state)
        4'b0000: // Idle state
          if (start_transmission) begin
            tx_state <= 4'b0001; // Start bit
            bit_count <= 7'd0;
            data_to_send <= csi_data[7:0];
          end
        4'b0001: // Start bit
          begin
            uart_tx <= 0;
            if (bit_count == 7) begin
              tx_state <= 4'b0010; // Data bits
              bit_count <= 7'd0;
            end else begin
              bit_count <= bit_count + 1;
            end
          end
        4'b0010: // Data bits
          begin
            uart_tx <= data_to_send[bit_count];
            if (bit_count == 7) begin
              tx_state <= 4'b0011; // Stop bit
              bit_count <= 7'd0;
            end else begin
              bit_count <= bit_count + 1;
            end
          end
        4'b0011: // Stop bit
          begin
            uart_tx <= 1;
            tx_state <= 4'b0000; // Return to idle state
          end
      endcase
    end
  end
endmodule
