//testbench C
`timescale 1ns/1ps
module testbench_VSYNC;
reg clk, reset, enable;
wire vsync, hsync;
wire [6:0] vpixel;
wire [6:0] hpixel;
wire enable_hsync;

initial 
begin
    clk = 0;
    reset = 1;
    enable = 0;
    #100 reset = 0;  
    #1000 enable = 1;  
end

VSYNC_syncroniser VSYNC_syncroniser_inst (.clk(clk), .reset(reset), .v_enable(enable), .vsync(vsync), .vpixel(vpixel), .enable_hsync(enable_hsync));
HSYNC_synchroniser HSYNC_synchroniser_inst (.clk(clk), .reset(reset), .enable(enable_hsync), .hsync(hsync), .hpixel(hpixel));

always #5 clk = ~clk;       // prosomoiosi tou clk tis FPGA

endmodule