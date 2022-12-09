//testbench A
`timescale 1ns/1ps
module testbenchA;
reg clk, reset, we, regce, en, di;
wire red, green, blue;
reg [13:0] addr;

reg [7*8:0] color;      // max 7 characters string

VRAM VRAM_inst(.addr(addr), .clk(clk), .reset(reset), .we(we), .regce(regce), .en(en), .di(di), .red(red), .green(green), .blue(blue));

initial 
begin
    clk = 0;
    reset = 1;
    addr = 14'b0;
    we = 0;
    regce = 0;
    en = 1;
    di = 0;
    #10 reset = 0;
    addr = 14'b0;

    // #100 addr = 14'b00000000000000;
    // #1000 addr = 14'b00000000000111;
end

always @(posedge clk)
begin
    #100 addr <= addr + 1;
    if( (red == 1) && (green == 1) && (blue == 1) )
        color = "white";
    else if ( (red == 1) && (green == 0) && (blue == 0) )
        color = "red";
    else if ( (red == 0) && (green == 1) && (blue == 0) )
        color = "green";
    else if ( (red == 0) && (green == 0) && (blue == 1) )
        color = "blue";
    else if ( (red == 0) && (green == 0) && (blue == 0) )
        color = "black";
    else
        color ="random";


    if(addr == 14'b01100000000000)
        $finish;


    //$monitor("addr: %d r = %d g = %d b =%d\n", addr, red, green, blue);
    $display("addr: %d color = %s\n", addr, color);
end

always #5 clk = ~clk;

endmodule