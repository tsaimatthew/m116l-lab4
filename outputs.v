//Control 7-seg and audio output. 
// if unlocked, display OPEN. if locked, display LOCK, unless user has started inputting pin. In that case, display the pin

module outputs(
    input clk_500Hz,

    //current input if user is typing it in
    input wire [3:0] pin0,
    input wire [3:0] pin1,
    input wire [3:0] pin2,
    input wire [3:0] pin3,

    input wire status,

    output reg [3:0] an,
    output reg [6:0] seg
);
    reg [2:0] lastAckStatus = 3'b111; //init 7 (invalid). Last status acknowledged to ensure tones only play once
    reg [4:0] LED_display = 0; //current number being displayed on selected an
    reg [1:0] LEDActivationCtr = 0; //cycle an0 to an3

  always @(posedge clk_500Hz) begin
        case (LEDActivationCtr)
        2'b00: begin
            an <= 4'b0111;
            if (!status) begin //locked
                if (pin0 != 15) //show inputted pin
                    LED_display <= pin0;
                else //else show LOCD
                    LED_display <= 5'b01010;
            end else if (status == 1) begin //open
                LED_display <= 0;
            end
        end
        2'b01: begin
            an <= 4'b1011;
            if (!status) begin //locked
                if (pin1 != 15) //show inputted pin
                    LED_display <= pin1;
                else if (pin0 != 15) //show dash if pin not fully inputted
                    LED_display <= 5'b01111;
                else //else show LOCD
                    LED_display <= 0;
            end else if (status == 1) begin //open
                LED_display <= 5'b01100;
            end
        end
        2'b10: begin
            an <= 4'b1101;
            if (!status) begin //locked
                if (pin2 != 15) //show inputted pin
                    LED_display <= pin2;
                else if (pin0 != 15) //show dash if pin not fully inputted
                    LED_display <= 5'b01111;
                else //else show LOCD
                    LED_display <= 5'b10000;
            end else if (status == 1) begin //open
                LED_display <= 5'b01101;
            end
        end
        2'b11: begin

            an <= 4'b1110;
            if (!status) begin //locked
                if (pin3 != 15) //show inputted pin
                    LED_display <= pin3;
                else if (pin0 != 15) //show dash if pin not fully inputted
                    LED_display <= 5'b01111;
                else //else show LOCD
                    LED_display <= 5'b01011;
            end else if (status == 1) begin //open
                LED_display <= 5'b01110;
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

            default: seg = 7'b0000001; // "0"
            
        endcase
    end


endmodule