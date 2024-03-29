// Testbench for vgacontroller
`timescale 1ns/1ps
module testbench_top;
reg clk, reset;

wire VGA_RED, VGA_GREEN, VGA_BLUE;
wire VGA_HSYNC, VGA_VSYNC;

reg [7*8:0] color;

vgacontroller vgacontroller_inst(clk, reset, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);

initial 
begin
    clk = 0;
    reset = 1;
    //enable = 0;
    //fd = $fopen("C:\Users\jimar\Desktop\digital_lab\lab3\Lab3\colors.txt", "w");  
    #100 reset = 0;  
end

// always @(addr)       // den katafera na to leitourgiso me arxeio
// begin
//     //#100 addr <= addr + 1;
//     if( (VGA_RED == 1) && (VGA_GREEN == 1) && (VGA_BLUE == 1) )
//         color = "white";
//     else if ( (VGA_RED == 1) && (VGA_GREEN == 0) && (VGA_BLUE == 0) )
//         color = "RED";
//     else if ( (VGA_RED == 0) && (VGA_GREEN == 1) && (VGA_BLUE == 0) )
//         color = "GREEN";
//     else if ( (VGA_RED == 0) && (VGA_GREEN == 0) && (VGA_BLUE == 1) )
//         color = "BLUE";
//     else if ( (VGA_RED == 0) && (VGA_GREEN == 0) && (VGA_BLUE == 0) )
//         color = "black";
//     else
//         color ="random";

//     //$monitor("addr: %d r = %d g = %d b =%d\n", addr, red, green, blue);
//     //$fdisplay(fd, "addr: %d color = %s\n", addr, color);
//     //#10 $fdisplay(fd, VGA_RED);
// end
 

always #5 clk = ~clk;       // prosomoiosi tou clk tis FPGA

endmodule