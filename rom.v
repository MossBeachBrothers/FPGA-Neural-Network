module rom #(
  parameter ADDR_WIDTH = 14,
  parameter DATA_WIDTH = 8,
  parameter INIT_FILE = "sigmoid_14_bit.hex"
)(
  input wire clk,
  input wire [ADDR_WIDTH-1:0] address,
  output reg [DATA_WIDTH-1:0] q
);

  // Define the ROM memory array
  reg [DATA_WIDTH-1:0] rom_data [0:(1<<ADDR_WIDTH)-1];

  // Initialize the ROM with the contents of the hex file
  initial begin
    $readmemh(INIT_FILE, rom_data);
  end

  // Output the data at the given address on the positive edge of the clock
  always @(posedge clk) begin
    q <= rom_data[address];
  end

endmodule
