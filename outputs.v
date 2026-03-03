//Control 7-seg and audio output. 
// if unlocked, display OPEN. if locked, display LOCK, unless user has started inputting pin. In that case, display the pin

module outputs(
    input clk_500Hz,

    //current input if user is typing it in
    input wire [3:0] pin0,
    input wire [3:0] pin1,
    input wire [3:0] pin2,
    input wire [3:0] pin3,

    input wire [1:0] status,
    input wire       validPin,

    output reg [3:0] an,
    output reg [6:0] seg
);
    reg [4:0] LED_display = 0; //current number being displayed on selected an
    reg [1:0] LEDActivationCtr = 0; //cycle an0 to an3
    reg       adj_set = 0;          // show SET after new PIN stored

  always @(posedge clk_500Hz) begin
        // track whether we've just set a new PIN in adjustment mode
        if (status != 2'b10)
            adj_set <= 1'b0;
        else if (validPin)
            adj_set <= 1'b1;
        case (LEDActivationCtr)
        2'b00: begin
            an <= 4'b0111;
            if (status == 2'b00) begin // locked
                if (pin0 != 15)
                    LED_display <= pin0;       // PIN digit
                else
                    LED_display <= 5'b01010;   // L in LOCD
            end else if (status == 2'b01) begin // open
                LED_display <= 5'b00000;       // O in OPEN (reuse 0)
            end else begin // status == 2'b10, adjustment
                if (adj_set)
                    LED_display <= 5'b10101;   // S in SET
                else if (pin0 != 15)
                    LED_display <= pin0;       // new PIN digit
                else
                    LED_display <= 5'b10100;   // A in ADJ
            end
        end
        2'b01: begin
            an <= 4'b1011;
            if (status == 2'b00) begin // locked
                if (pin1 != 15)
                    LED_display <= pin1;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b00000;   // O in LOCD
            end else if (status == 2'b01) begin // open
                LED_display <= 5'b01100;       // P
            end else begin // adjustment
                if (adj_set)
                    LED_display <= 5'b01101;   // E in SET
                else if (pin1 != 15)
                    LED_display <= pin1;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b01011;   // d in ADJ (approx J)
            end
        end
        2'b10: begin
            an <= 4'b1101;
            if (status == 2'b00) begin // locked
                if (pin2 != 15)
                    LED_display <= pin2;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b10000;   // C in LOCD
            end else if (status == 2'b01) begin // open
                LED_display <= 5'b01101;       // E
            end else begin // adjustment
                if (adj_set)
                    LED_display <= 5'b10110;   // T-ish in SET
                else if (pin2 != 15)
                    LED_display <= pin2;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b10111;   // blank for ADJ
            end
        end
        2'b11: begin
            an <= 4'b1110;
            if (status == 2'b00) begin // locked
                if (pin3 != 15)
                    LED_display <= pin3;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b01011;   // d in LOCD
            end else if (status == 2'b01) begin // open
                LED_display <= 5'b01110;       // n in OPEN
            end else begin // adjustment
                if (adj_set)
                    LED_display <= 5'b10111;   // blank after SET
                else if (pin3 != 15)
                    LED_display <= pin3;
                else if (pin0 != 15)
                    LED_display <= 5'b01111;   // dash
                else
                    LED_display <= 5'b10111;   // blank in ADJ
            end
        end
        endcase

        //activate numbers sequentially
        if (LEDActivationCtr >= 2'b11) begin
            LEDActivationCtr <= 0;
        end else begin
            LEDActivationCtr <= LEDActivationCtr + 1;
        end
    end

    always @(*) begin
        case(LED_display)
            5'b00000: seg = 7'b0000001; // "0"     
            5'b00001: seg = 7'b1001111; // "1" 
            5'b00010: seg = 7'b0010010; // "2" 
            5'b00011: seg = 7'b0000110; // "3" 
            5'b00100: seg = 7'b1001100; // "4" 
            5'b00101: seg = 7'b0100100; // "5" 
            5'b00110: seg = 7'b0100000; // "6" 
            5'b00111: seg = 7'b0001111; // "7" 
            5'b01000: seg = 7'b0000000; // "8"     
            5'b01001: seg = 7'b0000100; // "9" 

            5'b01010: seg = 7'b1110001; // L
            5'b10000: seg = 7'b0110001; // C
            5'b01011: seg = 7'b1000010; // d
            5'b01100: seg = 7'b0011000; // P
            5'b01101: seg = 7'b0110000; // E
            5'b01110: seg = 7'b1101010; // n
            5'b01111: seg = 7'b1111110; // -

            5'b10100: seg = 7'b0001000; // A (approx, same as 0 with middle on)
            5'b10101: seg = 7'b0100100; // S (reuse 5)
            5'b10110: seg = 7'b1110000; // T-ish (top + middle + right segments)
            5'b10111: seg = 7'b1111111; // blank

            default: seg = 7'b0000001; // "0"
            
        endcase
    end


endmodule