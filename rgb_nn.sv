module rgb_nn (
    input logic clk, //input clock 74.25 MHz, 720 pixels
    input logic reset_n, //reset
    input logic [2:0] enable_in, //three switches
    //video in
    input logic vs_in, //start new frame
    input logic hs_in, //start new line within frame
    input logic de_in, //data enable, '1' for valid pixel
    input logic [7:0] r_in, //Rin
    input logic [7:0] g_in, //Gin
    input logic [7:0] b_in, //Bin

    //video out
    output logic vs_out, 
    output logic hs_out,
    output logic de_out, //indicates when pixel data valid if high, rgb processed
    output logic [7:0] r_out, //Rout
    output logic [7:0] g_out, //Gout
    output logic [7:0] b_out, //Bout
    output logic clk_o, //output clock
    output logic [2:0] led

);

//Internal Signals

logic reset; //store inverted value of reset_n
logic [2:0] enable; //holds state of three enable switches


//Synchronize incoming video frame and line timings
logic vs_0, hs_0, de_0; //store v sync, h sync, data enable 
logic vs_1, hs_1, de_1; //synchronize outgoing video with original input


int r_0, g_0, b_0; //integer values of r,g,b
int unsigned h_0, h_1, h_2, output; //store outputs of hidden layer nuerons 

logic [7:0] result; //hold 8 bit value of neural network computation 

  // Neuron Instances

    neuron hidden0 (
        .clk(clk),
        .x1(r_0),
        .x2(g_0),
        .x3(b_0),
        .output(h_0)
    );
    defparam hidden0.w1 = 29;
    defparam hidden0.w2 = -45;
    defparam hidden0.w3 = -87;
    defparam hidden0.bias = -18227;


    //Forward Pass
    neuron hidden1 (
        .clk(clk),
        .x1(r_0),
        .x2(g_0),
        .x3(b_0),
        .output(h_1)
    );
    defparam hidden1.w1 = -361;
    defparam hidden1.w2 = 126;
    defparam hidden1.w3 = 371;
    defparam hidden1.bias = 2845;

    neuron hidden2 (
        .clk(clk),
        .x1(r_0),
        .x2(g_0),
        .x3(b_0),
        .output(h_2)
    );
    defparam hidden2.w1 = -313;
    defparam hidden2.w2 = 96;
    defparam hidden2.w3 = 337;
    defparam hidden2.bias = 4513;

    nueron output0 (
        .clk(clk),
        .x1(h_0),
        .x2(h_1),
        .x3(h_2),
        .output(output)
    );
    defparam output0.w1 = 51;
    defparam output0.w2 = -158;
    defparam output0.w3 = -129;
    defparam output0.bias = 41760;


    control control_inst (
        .clk(clk),
        .reset(reset),
        .vs_in(vs_0),
        .hs_in(hs_0),
        .de_in(de_0),
        .vs_out(vs_1),
        .hs_out(hs_1),
        .de_out(de_1)
    );
    defparam control_inst.delay = 9









//Capture Input Signals 
always_ff @(posedge clk) begin
    reset <= ~reset_n;
    enable <= enable_in;
    vs_0 <= vs_in;
    hs_0 <= hs_in;
    r_0 <= $signed(r_in);
    g_0 <= $signed(g_in);
    b_0 <= $signed(b_in);
 end 



//Generate Output Signals (Color Mapping)
always_ff @(posedge clk) begin
    if (output > 127) begin
        //if valid, set to 1
        result <= 8'hFF;
    end else begin
        //if not valid, set to 0
        result <= 8'h00;
    end 
    vs_out <= vs_1;
    hs_out <= hs_1;
    de_out <= de_1;
    //set pixel to either black or white if color detected
    r_out <= result;
    g_out <= result;
    b_out <= result; 
 end 

 assign clk_o = clk;
 assign lead = 3'b000;


endmodule 





