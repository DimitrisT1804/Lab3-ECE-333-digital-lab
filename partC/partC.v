// VSYNC synchroniser
module VSYNC_syncroniser(clk, reset, vsync, vpixel, enable_hsync, v_disp_on);
input clk, reset;
output reg vsync;
output reg [6:0] vpixel;        // metritis pixels gia katakorifo ajona
output reg enable_hsync;

reg [20:0] counter;
reg [13:0] v_pixel_counter;
reg [2:0] current_state, next_state;
reg counter_enable, v_enable_pixels;

output reg v_disp_on;


parameter v_off = 3'b000,
            v_pulse_width = 3'b001,
            signal_for_hsync = 3'b010,
            v_back_porch = 3'b011,
            v_display_time = 3'b100,
            v_front_porch = 3'b101,
            v_reset_counter = 3'b110;

always @(posedge clk or posedge reset)
begin
    if(reset)
        current_state <= v_off;
    else
        current_state <= next_state;
end

always @(current_state or counter or reset)
begin
    vsync = 1;
    next_state = current_state;
    counter_enable = 1;
    v_enable_pixels = 0;
    enable_hsync = 0;
    v_disp_on = 0;

    case(current_state) 
        v_off:
        begin
            counter_enable = 0;
            //if(v_enable == 1)
            if(reset == 0)      // kanonika exo enable alla tha prepei na to vgalo se kapoio koumpi
                next_state = v_pulse_width;
            else
                next_state = current_state;
        end

        v_pulse_width:
        begin
            vsync = 0;
            if(counter == 21'd6399)     // kanonika 6400 alla kano -1
                next_state = v_back_porch;
            else
                next_state = current_state;
        end

        v_back_porch:
        begin
            vsync = 1;
            if(counter == 21'd98622)        /* ipologismeni timi gia na jekinaei to HSYNC kai na ftanei
                                             mazi me to VSYNC sto display time. (exei ipologisthei kai i
                                             kathisterisi apo ta flip flop logo registers) */
            //if(counter == 21'd99199)
            begin
                next_state = signal_for_hsync;
                //next_state = v_display_time;
            end
            else
                next_state = current_state;
        end

        signal_for_hsync:
        begin
            enable_hsync = 1;
            if(counter == 21'd99199)
                next_state = v_display_time;
            else
                next_state = current_state;
        end

        v_display_time:
        begin
            v_disp_on = 1;
            v_enable_pixels = 1;
            //enable_hsync = 1;
            if(counter == 21'd1635199)  //den exo afairesei
                next_state = v_front_porch;
            else
                next_state = current_state;
        end

        v_front_porch:
        begin
            if(counter == 21'd1667198)  //lathos xronos
                next_state = v_reset_counter;
            else
                current_state = next_state;
        end

        v_reset_counter:
        begin
            counter_enable = 0;
            next_state = v_pulse_width;
        end

        default:
        begin
            next_state = v_off;
            $display("To vsync mpike se default ERROR\n");  // prepei na vgei
        end
    endcase
end



always @(posedge clk or posedge reset)      // counter pou metraei apla kiklous rologioy gia enalagi metaji katastaseon stin FSM
begin
    if(reset)
        counter <= 0;
    else
    begin
        if(counter_enable == 1)
            counter <= counter + 21'b1;
        else
            counter <= 0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        v_pixel_counter <= 0;
    else
    begin
        if(v_enable_pixels == 1)
            //v_pixel_counter <= v_pixel_counter + 5'b1;
            v_pixel_counter <= (v_pixel_counter == 14'd15999) ? 0 : v_pixel_counter + 14'b1; 
        else
            v_pixel_counter <= 0;
    end

    // if(pixel_counter == 5'd19)      // lathos dioti elegxo timi ekei poy tin allazo
    //     pixel_counter <= 0;
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        vpixel <= 0;
    else
    begin
        if(v_pixel_counter == 14'd15999)
            //hpixel <= hpixel + 8'b1;
            vpixel <= (vpixel == 7'd95) ? 0 : vpixel + 7'b1;
    end

    // if(hpixel == 8'd128)
    //     hpixel <= 8'b0;
end

endmodule
