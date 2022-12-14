//top module for vga controller
module vgacontroller(clk, reset, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);
input clk, reset;

output VGA_RED, VGA_GREEN, VGA_BLUE;
output VGA_HSYNC, VGA_VSYNC;

//vram variables
reg [13:0] addr;
//output reg [13:0] addr;
wire we , regce, en, di;

//HSYNC variables
wire [6:0] hpixel;

//VSYNC variables
wire [6:0] vpixel; 
wire enable_hsync;

wire h_disp_on, v_disp_on;


VRAM VRAM_inst(.clk(clk), .reset(reset), .addr(addr), .we(we), .regce(regce), .en(en), .di(di), .red(VGA_RED), .green(VGA_GREEN), .blue(VGA_BLUE));
HSYNC_synchroniser HSYNC_synchroniser_inst (.clk(clk), .reset(reset), .enable(enable_hsync), .hsync(VGA_HSYNC), .hpixel(hpixel), .h_disp_on(h_disp_on));
VSYNC_syncroniser VSYNC_syncroniser_inst (.clk(clk), .reset(reset), .vsync(VGA_VSYNC), .vpixel(vpixel), .enable_hsync(enable_hsync), .v_disp_on(v_disp_on));

//assign addr = {vpixel, hpixel};     // bus gia to address
assign we = 0;
assign en = 1;
assign di = 0;
assign regce = 0;

always @ (vpixel or hpixel or v_disp_on or h_disp_on)
begin
    if( (v_disp_on == 0) || (h_disp_on == 0) )
    begin
        addr = 14'd12288;
    end
    else
        addr = {vpixel, hpixel};
end

//$display("The addr is %d and red: %d green: %d blue: %d\n", addr, VGA_RED, VGA_GREEN, VGA_BLUE);

endmodule