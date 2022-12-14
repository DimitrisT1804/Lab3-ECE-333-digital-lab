//top module for vga controller
module vgacontroller(clk, reset, enable, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC, addr);
input clk, reset, enable;

output VGA_RED, VGA_GREEN, VGA_BLUE;
output VGA_HSYNC, VGA_VSYNC;

//vram variables
//wire [13:0] addr;
output [13:0] addr;
wire we , regce, en, di;

//HSYNC variables
wire [6:0] hpixel;

//VSYNC variables
wire [6:0] vpixel; 
wire enable_hsync;


VRAM VRAM_inst(.clk(clk), .reset(reset), .addr(addr), .we(we), .regce(regce), .en(en), .di(di), .red(VGA_RED), .green(VGA_GREEN), .blue(VGA_BLUE));
HSYNC_synchroniser HSYNC_synchroniser_inst (.clk(clk), .reset(reset), .enable(enable_hsync), .hsync(VGA_HSYNC), .hpixel(hpixel));
VSYNC_syncroniser VSYNC_syncroniser_inst (.clk(clk), .reset(reset), .v_enable(enable), .vsync(VGA_VSYNC), .vpixel(vpixel), .enable_hsync(enable_hsync));

assign addr = {vpixel, hpixel};
assign we = 0;
assign en = 1;
assign di = 0;
assign regce = 0;

//$display("The addr is %d and red: %d green: %d blue: %d\n", addr, VGA_RED, VGA_GREEN, VGA_BLUE);

endmodule