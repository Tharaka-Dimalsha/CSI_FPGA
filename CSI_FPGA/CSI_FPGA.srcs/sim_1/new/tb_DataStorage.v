`timescale 1ns/1ns

module tb_DataStorage;
  reg clk;
  reg rst;
  reg [31:0] csi_data;
  reg start_storage;
  reg [7:0] storage_address;
  wire [31:0] stored_data;

  // Instantiate the DataStorage module
  DataStorage data_storage (
    .clk(clk),
    .rst(rst),
    .csi_data(csi_data),
    .start_storage(start_storage),
    .storage_address(storage_address),
    .stored_data(stored_data)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  initial begin
    rst = 1;
    #10 rst = 0;

    // Store CSI data at address 5
    #20 start_storage = 1;
    #20 storage_address = 8'b00000101;
    #20 csi_data = 32'h12345678;
    #20 start_storage = 0;

    // Wait for simulation to finish
    #100 $finish;
  end
endmodule
