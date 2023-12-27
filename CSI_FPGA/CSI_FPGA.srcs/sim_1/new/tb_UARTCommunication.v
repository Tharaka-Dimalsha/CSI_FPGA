`timescale 1ns/1ns

module tb_UARTCommunication;
  reg clk;
  reg rst;
  reg [31:0] csi_data;
  reg start_transmission;
  wire uart_tx;

  // Instantiate the UARTCommunication module
  UARTCommunication uart_communication (
    .clk(clk),
    .rst(rst),
    .csi_data(csi_data),
    .start_transmission(start_transmission),
    .uart_tx(uart_tx)
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

    // Start transmission of CSI data
    #20 start_transmission = 1;
    #20 csi_data = 32'h12345678;
    #20 start_transmission = 0;

    // Wait for simulation to finish
    #100 $finish;
  end
endmodule
