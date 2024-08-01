module nueron #(
    parameter w1 = 0,
    parameter w2 = 0,
    parameter w3 = 0,
    parameter bias = 0
)(
    input wire clk,
    input wire x1,
    input wire x2,
    input wire x3,
    output reg [7:0] out  // Changed 'output logic' to 'output reg [7:0]'
);
    // Internal Signals
    reg signed [31:0] sum;  // Changed 'int' to 'reg signed [31:0]'
    reg [15:0] sum_address;
    wire [7:0] activated_data;

    // Sum inputs with Weights + Bias
    always @(posedge clk) begin  // Changed always_ff to always
        sum <= ((w1*x1) + (w2*x2) + (w3*x3) + bias);  // Changed 'multiply_and_sum' to 'sum'
        if (sum < -32768) begin
            // If out of bounds, set to lowest address
            sum_address <= 16'h0000;
        end else if (sum > 32767) begin
            // If out of bounds, set to highest address
            sum_address <= 16'hFFFF;
        end else begin
            sum_address <= sum + 32768;  // Removed $unsigned as it's implicit
        end
    end

    sigmoid_IP sigmoid_inst (
        .clock(clk),
        .address(sum_address[15:2]),
        .q(activated_data)
    );

    always @(posedge clk) begin
        out <= activated_data;  // Changed 'output' to 'out' and made it registered
    end
endmodule