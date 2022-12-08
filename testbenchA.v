//testbench A
`timescale 1ns/1ps
module testbenchA;
reg clk, reset, we, regce, en, di;
wire do;
reg [13:0] addr;

topA topA_inst(.addr(addr), .clk(clk), .reset(reset), .we(we), .regce(regce), .en(en), .di(di), .do(do));

initial 
begin
    clk = 0;
    reset = 0;
    addr = 14'b0;
    we = 0;
    regce = 0;
    en = 1;
    di = 0;

    #100 addr = 14'b00000000000001;
    #1000 addr = 14'b10000000000000;
end

always #5 clk = ~clk;

endmodule