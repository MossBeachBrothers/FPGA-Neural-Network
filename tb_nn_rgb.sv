`timescale 1ns/1ps

module tb_nn_rgb;

  logic clk;
  logic reset_n;
  logic [2:0] enable_in;
  logic vs_in;
  logic hs_in;
  logic de_in;
  logic [7:0] r_in;
  logic [7:0] g_in;
  logic [7:0] b_in;
  logic vs_out;
  logic hs_out;
  logic de_out;
  logic [7:0] r_out;
  logic [7:0] g_out;
  logic [7:0] b_out;
  logic clk_o;
  logic [2:0] led;

  integer pixel_file;
  integer r, g, b;
  integer num_pixels;
  integer i;

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
    enable_in = 3'b0;
    vs_in = 0;
    hs_in = 0;
    de_in = 0;
    r_in = 0;
    g_in = 0;
    b_in = 0;

    // Reset sequence
    #5 reset_n = 1;
    #10 reset_n = 0;
    #20 reset_n = 1;

    // Open image data file
    pixel_file = $fopen("gradient_720p.txt", "r");
    if (pixel_file == 0) begin
      $display("Error opening file!");
      $finish;
    end

    // Read number of pixels
    num_pixels = 1280 * 720;  // 720p image size
    $display("Testing with 720p image (1280x720)...");
    
    // Test with image data
    for (i = 0; i < num_pixels; i = i + 1) begin
      // Read RGB values from file
      $fscanf(pixel_file, "%d %d %d\n", r, g, b);
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
    end

    $fclose(pixel_file);

    // Run for some time
    #1000 $finish;
  end

  always #5 clk = ~clk;

endmodule
