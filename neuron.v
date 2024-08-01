module neuron #(
  parameter signed [31:0] w1 = 0,
  parameter signed [31:0] w2 = 0,
  parameter signed [31:0] w3 = 0,
  parameter signed [31:0] bias = 0
)(
  input wire clk,
  input wire signed [31:0] x1,
  input wire signed [31:0] x2,
  input wire signed [31:0] x3,
  output wire signed [31:0] neuron_output
);

  reg signed [31:0] sum;
  reg [15:0] sumAdress;
  wire [7:0] afterActivation;  // Changed from reg to wire

  always @(posedge clk) begin
    sum <= (w1 * x1 + w2 * x2 + w3 * x3 + bias);

    if (sum < -32768) begin
      sumAdress <= 16'h0000;
    end else if (sum > 32767) begin
      sumAdress <= 16'hFFFF;
    end else begin
      sumAdress <= sum[15:0] + 32768;
    end
  end

  sigmoid_IP sigmoid_inst (
    .clk(clk),
    .address(sumAdress[15:2]),
    .q(afterActivation)
  );

  assign neuron_output = $signed(afterActivation);

endmodule
