`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2023 05:57:36 PM
// Design Name: 
// Module Name: DataStorage
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


module DataStorage(
    input wire clk,
    input wire rst,
    input wire [31:0]  csi_data,
    input wire start_storage,
    input wire [7:0] storage_address,
    output reg [31:0] stored_data
    );
    reg [31:0] memory [0:255]; // 256 locations of 32-bit data for storage

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset logic
      stored_data <= 0;
    end else if (start_storage) begin
      // Store CSI data at the specified address
      memory[storage_address] <= csi_data;
    end
  end

  // Output the stored data at the specified address
  always @* begin
    stored_data = memory[storage_address];
  end
endmodule
