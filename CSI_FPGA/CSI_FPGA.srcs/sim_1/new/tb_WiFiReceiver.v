`timescale 1ns/1ns

module tb_WiFiReceiver;
  reg clk;
  reg rst;
  reg [31:0] wifi_data;
  wire [15:0] csi_data;

  // Instantiate the WiFiReceiver module
  WiFiReceiver wifi_receiver (
    .clk(clk),
    .rst(rst),
    .wifi_data(wifi_data),
    .csi_data(csi_data)
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

    // Send SYNC sequence
    #20 wifi_data = 32'hAABBCCDD;

    // Send VHT header with CSI data
    #20 wifi_data = 32'hAABBCCDD;
    #10 wifi_data = 32'hXXXXXXXX; // Replace XXXXXXXX with your VHT header

    // Wait for simulation to finish
    #100 $finish;
  end
endmodule
