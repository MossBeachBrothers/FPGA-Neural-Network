`timescale 1ns/1ps

module tb_nn_rgb;

  reg clk;
  reg reset_n;
  reg [2:0] enable_in;
  reg vs_in;
  reg hs_in;
  reg de_in;
  reg [7:0] r_in;
  reg [7:0] g_in;
  reg [7:0] b_in;
  wire vs_out;
  wire hs_out;
  wire de_out;
  wire [7:0] r_out;
  wire [7:0] g_out;
  wire [7:0] b_out;
  wire clk_o;
  wire [2:0] led;

  integer pixel_file;
  integer output_file;
  integer num_pixels;
  integer i;
  reg [7:0] r, g, b;

  // Instantiate the Unit Under Test (UUT)
  nn_rgb uut (
    .clk(clk),
    .reset_n(reset_n),
    .enable_in(enable_in),
    .vs_in(vs_in),
    .hs_in(hs_in),
    .de_in(de_in),
    .r_in(r_in),
    .g_in(g_in),
    .b_in(b_in),
    .vs_out(vs_out),
    .hs_out(hs_out),
    .de_out(de_out),
    .r_out(r_out),
    .g_out(g_out),
    .b_out(b_out),
    .clk_o(clk_o),
    .led(led)
  );

  initial begin
    $dumpfile("tb_nn_rgb.vcd");
    $dumpvars(0, tb_nn_rgb);

    // Initialize inputs
    clk = 0;
    reset_n = 0;
    enable_in = 3'b000;
    vs_in = 0;
    hs_in = 0;
    de_in = 0;
    r_in = 0;
    g_in = 0;
    b_in = 0;

    // Open image data file
    pixel_file = $fopen("test_gradients_720p.txt", "r");
    if (pixel_file == 0) begin
      $display("Error opening file gradient_720p.txt!");
      $finish;
    end else begin
      $display("Successfully opened file gradient_720p.txt.");
    end

    // Open output file
    output_file = $fopen("output_720p.txt", "w");
    if (output_file == 0) begin
      $display("Error opening output file output_720p.txt!");
      $finish;
    end else begin
      $display("Successfully opened output file output_720p.txt.");
    end

    // Reset sequence
    #5 reset_n = 1;
    #10 reset_n = 0;
    #20 reset_n = 1;

    // Allow some time for stabilization
    #50;

    // Test with full image data
    num_pixels = 1280 * 720;  // 720p image size
    $display("Testing with full 720p image (1280x720)...");

    for (i = 0; i < num_pixels; i = i + 1) begin
      // Read RGB values from file
      if ($fscanf(pixel_file, "%d %d %d\n", r, g, b) == 3) begin
        r_in = r;
        g_in = g;
        b_in = b;

        // Set data enable signal
        de_in = 1;
        #10;
        de_in = 0;

        // Simulate VS and HS signals
        vs_in = (i % 1280 == 0);
        hs_in = (i % 1280 == 0);
        #10;

        // Print debug information
        $display("Pixel %d: r_in=%d, g_in=%d, b_in=%d, r_out=%d, g_out=%d, b_out=%d", i, r_in, g_in, b_in, r_out, g_out, b_out);

        // Write output to file
        $fwrite(output_file, "%d %d %d\n", r_out, g_out, b_out);
      end else begin
        $display("Skipping invalid line at pixel %d", i);
      end
    end

    $fclose(pixel_file);
    $fclose(output_file);

    // Run for some time
    #1000 $finish;
  end

  always #5 clk = ~clk;

endmodule
