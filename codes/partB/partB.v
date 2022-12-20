//part B
module HSYNC_synchroniser(clk, reset, enable, hsync, hpixel, h_disp_on);
input clk, reset, enable;
output reg hsync;
output reg [6:0] hpixel;

reg [2:0] current_state, next_state;
reg [11:0] counter;
reg [4:0] pixel_counter;
reg counter_enable, enable_pixels;

output reg h_disp_on;

parameter off_state = 3'b000,       //parametropoiisi ton states gia eukolotoeri katanoisi
            width_pulse = 4'b001,
            back_porch = 4'b010,
            display_time = 4'b011,
            front_porch = 4'b100,
            counter_reset = 4'b101;

//module poy allazei katastasi stin FSM
always @(posedge clk or posedge reset)
begin
    if(reset)
        current_state <= off_state;
    else
        current_state <= next_state;
end

always @(current_state or enable or counter)
begin
    next_state = current_state;     // arxikopoiisis gia apofigi latches
    hsync = 1;
    counter_enable = 1;
    enable_pixels = 0;   
    h_disp_on = 0;


    case (current_state)
        off_state: 
        begin
            counter_enable = 0;
            if(enable == 1)
                next_state = width_pulse;
            else
                next_state = current_state;
        end

        width_pulse:
        begin
            hsync = 0;          
            if(counter == 12'd383)      //prepei na to allazo ena piso dioti oi register pairnoun ena clk gia na allajoun timi
                next_state = back_porch;
            else
                next_state = current_state;
        end

        back_porch:
        begin
            hsync = 1;
            if(counter == 12'd575)      //pali -1
                next_state = display_time;
            else
                next_state = current_state;
        end

        display_time:
        begin
            h_disp_on = 1;
            enable_pixels = 1;
            //counter_enable = 0;
            if(counter == 12'd3135)     // pali -1
                next_state = front_porch;
            else
                next_state = current_state;
        end

        front_porch:
        begin
            if(counter == 12'd3198)     //-2 gt einai kai to counter reset apo kato 
                next_state = counter_reset;
            else
                next_state = current_state;
        end

        counter_reset:
        begin
            counter_enable = 0;
            next_state = width_pulse;
        end

        default:
        begin
            next_state = off_state; //ean mpei se default paei sto arxiko stadio
        end
    endcase
end

always @(posedge clk or posedge reset)      // counter 12 bits gia na metraei xrono
begin
    if(reset)
        counter <= 0;
    else
    begin
        if(counter_enable == 1)
            counter <= counter + 12'b1;
        else
            counter <= 0;
    end
end
/*couter pou metraei 20 periodoys diladi ena pixel kai meta kanei reset */
always @(posedge clk or posedge reset)  
begin
    if(reset)
        pixel_counter <= 0;
    else
    begin
        if(enable_pixels == 1)
            pixel_counter <= (pixel_counter == 5'd19) ? 0 : pixel_counter + 5'b1; 
        else
            pixel_counter <= 0;
    end
end

/*kathe fora poy erxetai o apo pano counter iso me 20, anevainei kata 1 diladi metraei tin thesi ton pixels*/
always @(posedge clk or posedge reset)
begin
    if(reset)
        hpixel <= 7'b0;
    else
    begin
        if(pixel_counter == 5'd19)
            hpixel <= (hpixel == 7'd127) ? 0 : hpixel + 7'b1;
    end
end            
            
endmodule