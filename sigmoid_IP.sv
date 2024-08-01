module sigmoid_IP (
  input logic [13:0] address,
  input logic clk,
  output logic [7:0] q
);

  // Internal signal for ROM output
  logic [7:0] sub_wire0;

  // Instantiate the generic ROM
  rom #(
    .ADDR_WIDTH(14),
    .DATA_WIDTH(8),
    .INIT_FILE("sigmoid_14_bit.hex") // Ensure this file is in the correct format
  ) rom_inst (
    .addr(address),
    .clk(clk),
    .q(sub_wire0)
  );

  // Assign internal signal to output
  assign q = sub_wire0;

endmodule
