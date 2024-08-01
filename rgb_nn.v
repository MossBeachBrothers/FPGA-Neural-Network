module nn_rgb (
  input wire clk,
  input wire reset_n,
  input wire [2:0] enable_in,
  input wire vs_in,
  input wire hs_in,
  input wire de_in,
  input wire [7:0] r_in,
  input wire [7:0] g_in,
  input wire [7:0] b_in,
  output wire vs_out,
  output wire hs_out,
  output wire de_out,
  output wire [7:0] r_out,
  output wire [7:0] g_out,
  output wire [7:0] b_out,
  output wire clk_o,
  output wire [2:0] led
);

  reg reset;
  reg [2:0] enable;
  reg vs_0, hs_0, de_0;
  reg signed [31:0] r_0, g_0, b_0;
  wire signed [31:0] h_0, h_1, h_2, output_wire;
  wire vs_1, hs_1, de_1;  // Changed from reg to wire
  reg [7:0] result;

  neuron #(
    .w1(29),
    .w2(-45),
    .w3(-87),
    .bias(-18227)
  ) hidden0 (
    .clk(clk),
    .x1(r_0),
    .x2(g_0),
    .x3(b_0),
    .neuron_output(h_0)
  );

  neuron #(
    .w1(-361),
    .w2(126),
    .w3(371),
    .bias(2845)
  ) hidden1 (
    .clk(clk),
    .x1(r_0),
    .x2(g_0),
    .x3(b_0),
    .neuron_output(h_1)
  );

  neuron #(
    .w1(-313),
    .w2(96),
    .w3(337),
    .bias(4513)
  ) hidden2 (
    .clk(clk),
    .x1(r_0),
    .x2(g_0),
    .x3(b_0),
    .neuron_output(h_2)
  );

  neuron #(
    .w1(51),
    .w2(-158),
    .w3(-129),
    .bias(41760)
  ) output0 (
    .clk(clk),
    .x1(h_0),
    .x2(h_1),
    .x3(h_2),
    .neuron_output(output_wire)  // Changed from output to output_wire
  );

  control #(
    .delay(9)
  ) control_inst (
    .clk(clk),
    .reset(reset),
    .vs_in(vs_0),
    .hs_in(hs_0),
    .de_in(de_0),
    .vs_out(vs_1),
    .hs_out(hs_1),
    .de_out(de_1)
  );

  always @(posedge clk) begin
    reset <= ~reset_n;
    enable <= enable_in;
    vs_0 <= vs_in;
    hs_0 <= hs_in;
    de_0 <= de_in;
    r_0 <= $signed(r_in); 
    g_0 <= $signed(g_in);
    b_0 <= $signed(b_in);
  end

  // always @(posedge clk) begin
  //   if (output_wire > 127) begin  // Changed from output to output_wire
  //       result <= 8'hFF;
  //   end else begin
  //       result <= 8'h00;
  //   end

  // end
 always @(posedge clk) begin
    result <= output_wire[7:0];  // Assign the least significant 8 bits of output_wire to result
  end

  assign vs_out = vs_1;
  assign hs_out = hs_1;
  assign de_out = de_1;
  assign r_out = result;
  assign g_out = result;
  assign b_out = result;
  assign clk_o = clk;
  assign led = 3'b000;

endmodule
