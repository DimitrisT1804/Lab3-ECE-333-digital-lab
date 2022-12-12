//testbench B
`timescale 1ns/1ps
module testbench_HSYNC;
reg clk, reset, enable;
wire hsync;
wire [7:0] hpixel;

initial 
begin
    clk = 0;
    reset = 1;
    enable = 0;
    #100 reset = 0;  
    #1000 enable = 1;  
end

HSYNC_synchroniser HSYNC_synchroniser_inst (.clk(clk), .reset(reset), .enable(enable), .hsync(hsync), .hpixel(hpixel));

always #5 clk = ~clk;       // prosomoiosi tou clk tis FPGA

endmodule