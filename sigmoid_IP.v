module sigmoid_IP (
  input wire clk,
  input wire [13:0] address,
  output wire [7:0] q
);

  // Instantiate the ROM module
  rom #(
    .ADDR_WIDTH(14),
    .DATA_WIDTH(8),
    .INIT_FILE("sigmoid_14_bit.hex")
  ) rom_inst (
    .clk(clk),
    .address(address),
    .q(q)
  );

endmodule
