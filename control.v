module control #(
  parameter signed [31:0] delay = 0
)(
  input wire clk,
  input wire reset,
  input wire vs_in,
  input wire hs_in,
  input wire de_in,
  output wire vs_out,
  output wire hs_out,
  output wire de_out
);

  reg [delay-1:0] vs_delay;
  reg [delay-1:0] hs_delay;
  reg [delay-1:0] de_delay;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      vs_delay <= {delay{1'b0}};
      hs_delay <= {delay{1'b0}};
      de_delay <= {delay{1'b0}};
    end else begin
      vs_delay <= {vs_delay[delay-2:0], vs_in};
      hs_delay <= {hs_delay[delay-2:0], hs_in};
      de_delay <= {de_delay[delay-2:0], de_in};
    end
  end

  assign vs_out = vs_delay[delay-1];
  assign hs_out = hs_delay[delay-1];
  assign de_out = de_delay[delay-1];

endmodule
