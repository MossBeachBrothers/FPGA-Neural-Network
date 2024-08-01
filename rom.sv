module rom #(
    parameter address_width = 14;
    parameter data_width = 8;
    parameter init_file = "sigmoid_14_bit.hex"
)(
    input logic [address_width-1:0] address,
    input logic clk,
    output logic [data_width-1:0] q //output of storage element
);

//Memory array
logic [DATA_WIDTH-1:0] mem [(2**address_width)-1:0];

//memory array from init file
initial begin
    $readmemh(init_file, mem);
 end 

 always_ff @(posedge clk) begin
    q <= mem[address];
  end 


endmodule 


