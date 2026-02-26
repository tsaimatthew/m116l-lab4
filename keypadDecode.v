module keypadDecode(
    input wire clk_500Hz,
    input wire [3:0] JC_cols,
    input wire status,
    output reg [3:0] JC_rows,
    output reg [15:0] userPin,
    output reg validPin,

    //current pins for display on 7-seg
    output reg [3:0] pin0,
    output reg [3:0] pin1,
    output reg [3:0] pin2,
    output reg [3:0] pin3

);
    reg [3:0] currentPin [0:3];
    reg [3:0] currentInput;
    reg [2:0] inputCtr = 0;
    reg keyPressedPrev = 0;
    reg [1:0] rowSel = 0;
    reg [15:0] debounce_timer = 0;
    reg stable_keyPressed = 0;

    always @(posedge clk_500Hz) begin
        if (status == 0) begin
            if (JC_cols != 4'b1111) begin
                if (debounce_timer < 20) begin
                    debounce_timer <= debounce_timer + 1;
                    stable_keyPressed <= 0;
                end else begin
                    stable_keyPressed <= 1;
                end
            end else begin
                debounce_timer <= 0;
                stable_keyPressed <= 0;

                rowSel <= rowSel + 1;
                case (rowSel)
                    2'b00: JC_rows <= 4'b1110;
                    2'b01: JC_rows <= 4'b1101;
                    2'b10: JC_rows <= 4'b1011;
                    2'b11: JC_rows <= 4'b0111;
                endcase
            end

            keyPressedPrev <= stable_keyPressed;

            if (stable_keyPressed && !keyPressedPrev) begin
                if (currentInput < 4'b1010) begin
                    if (inputCtr < 4) begin
                        currentPin[inputCtr] <= currentInput;
                        inputCtr <= inputCtr + 1;
                    end
                    validPin <= 0;
                end else if (currentInput == 4'b1010) begin
                    inputCtr <= 0;
                    validPin <= 0;
                    pin0 <= 15;
                    pin1 <= 15;
                    pin2 <= 15;
                    pin3 <= 15;
                end else if (currentInput == 4'b1011 && inputCtr >= 4) begin
                    userPin <= {currentPin[0], currentPin[1], currentPin[2], currentPin[3]};
                    inputCtr <= 0;
                    validPin <= 1;
                    pin0 <= 15;
                    pin1 <= 15;
                    pin2 <= 15;
                    pin3 <= 15;
                end else if (currentInput == 4'b1100 && inputCtr > 0) begin
                    inputCtr <= inputCtr - 1;
                end
            end else begin
                validPin <= 0;
            end

            pin0 <= (inputCtr >= 1) ? currentPin[0] : 15;
            pin1 <= (inputCtr >= 2) ? currentPin[1] : 15;
            pin2 <= (inputCtr >= 3) ? currentPin[2] : 15;
            pin3 <= (inputCtr >= 4) ? currentPin[3] : 15;
        end
    end

    always @(*) begin
        case ({JC_rows, JC_cols})
            8'b11100111: currentInput = 4'b0000;
            8'b11101110: currentInput = 4'b0001;
            8'b11011110: currentInput = 4'b0010;
            8'b10111110: currentInput = 4'b0011;
            8'b11101101: currentInput = 4'b0100;
            8'b11011101: currentInput = 4'b0101;
            8'b10111101: currentInput = 4'b0110;
            8'b11101011: currentInput = 4'b0111;
            8'b11011011: currentInput = 4'b1000;
            8'b10111011: currentInput = 4'b1001;

            8'b01111011: currentInput = 4'b1010;
            8'b10110111: currentInput = 4'b1011;
            8'b01110111: currentInput = 4'b1100;
            default:     currentInput = 4'b1111;
        endcase
    end
endmodule