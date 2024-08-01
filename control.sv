module control #(
    parameter delay = 9  // Removed 'int' as it might not be fully supported
)(
    input  wire clk,     // Changed 'logic' to 'wire' for inputs
    input  wire reset,
    input  wire vs_in,
    input  wire hs_in,
    input  wire de_in,
    output reg vs_out,   // Changed 'logic' to 'reg' for outputs
    output reg hs_out,
    output reg de_out
);
    reg [delay-1:0] vs_delay;
    reg [delay-1:0] hs_delay;
    reg [delay-1:0] de_delay;

    always @(posedge clk or posedge reset) begin  // Changed always_ff to always
        if (reset) begin
            vs_delay <= {delay{1'b0}};  // Changed '0 to explicit zeros
            hs_delay <= {delay{1'b0}};
            de_delay <= {delay{1'b0}};
        end else begin
            vs_delay <= {vs_delay[delay-2:0], vs_in};
            hs_delay <= {hs_delay[delay-2:0], hs_in};
            de_delay <= {de_delay[delay-2:0], de_in};
        end
    end

    always @(*) begin  // Continuous assignment replaced with combinational always block
        vs_out = vs_delay[delay-1];
        hs_out = hs_delay[delay-1];
        de_out = de_delay[delay-1];
    end
endmodule