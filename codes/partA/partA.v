//`define BRAM_SINGLE_MACRO(do, addr, clk, di, en, regce, rst, we) "bram_red"

module VRAM(clk, reset, addr, we, regce, en, di, red, green, blue);
input clk, reset, we, regce, en, di;
input [13:0] addr;
output red, green, blue;

 bram_red bram_red_inst      // genika i mnimi argei 1 periodo clk na vgalei output
 (
     .do(red),       // Output data, width defined by READ_WIDTH parameter
     .addr(addr),   // Input address, width defined by read/write port depth
     .clk(clk),     // 1-bit input clock
     .di(di),       // Input data port, width defined by WRITE_WIDTH parameter
     .en(en),       // 1-bit input RAM enable
     .regce(regce), // 1-bit input output register enable
     .reset(reset),     // 1-bit input reset
     .we(we)
 );

 bram_green bram_green_inst
 (
     .do(green),       // Output data, width defined by READ_WIDTH parameter
     .addr(addr),   // Input address, width defined by read/write port depth
     .clk(clk),     // 1-bit input clock
     .di(di),       // Input data port, width defined by WRITE_WIDTH parameter
     .en(en),       // 1-bit input RAM enable
     .regce(regce), // 1-bit input output register enable
     .reset(reset),     // 1-bit input reset
     .we(we)
 );

 bram_blue bram_blue_inst
 (
     .do(blue),       // Output data, width defined by READ_WIDTH parameter
     .addr(addr),   // Input address, width defined by read/write port depth
     .clk(clk),     // 1-bit input clock
     .di(di),       // Input data port, width defined by WRITE_WIDTH parameter
     .en(en),       // 1-bit input RAM enable
     .regce(regce), // 1-bit input output register enable
     .reset(reset),     // 1-bit input reset
     .we(we)
 );

endmodule