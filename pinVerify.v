module pinVerify(
    input wire clk_500Hz,
    input wire clk_400Hz,
    input wire clk_1kHz,
    input wire [15:0] storedPin,
    input wire [15:0] userPin,
    input wire validPin,
    input wire [1:0] sw,
    input btnL,
    
    output wire audio_out,
    output reg [1:0] status
);

    reg [11:0] tone_timer = 0; // 5 sec tone
    reg play_enable = 0;
    reg [1:0] pinStatus = 0; //0 = inactive, 1 = fail, 2 = valid
    reg [15:0] lastEnteredPin = 0;

    reg [3:0] rst_debounce_reg = 0;
    reg clean_rst = 0;

    always @(posedge clk_500Hz) begin
        if (status == 1 && sw[0] == 1) begin
            //in adjustment mode
            status <= 2;
        end
        if (play_enable) begin
            if (tone_timer <= 2499)
                tone_timer <= tone_timer + 1;
            else begin
                play_enable <= 0;
                tone_timer <= 0;
            end
        end
        if (clean_rst) begin
            status <= 0; 
        end else begin
            case (status)
                0: begin // Locked
                    if (validPin) begin
                        if (userPin == storedPin) begin
                            status <= 1;
                            pinStatus <= 2;
                            play_enable <= 1;
                            tone_timer <= 0;
                        end
                        else begin
                            if (userPin != lastEnteredPin) begin
                                lastEnteredPin <= userPin; //prevent multiple activations of tone
                                status <= 0;
                                pinStatus <= 1;
                                play_enable <= 1;
                                tone_timer <= 0;
                            end 
                        end

                    end 
                end
                1: begin // Open
                    if (sw[0] == 1) status <= 2; // Enter adjustment
                end
                2: begin // Adjustment
                    if (validPin) status <= 0; // Lock after setting new pin
                end
            endcase
        end

        //debounce btnL
        rst_debounce_reg <= {rst_debounce_reg[2:0], btnL};
        if (rst_debounce_reg == 4'b1111) 
            clean_rst <= 1;
        else if (rst_debounce_reg == 4'b0000)
            clean_rst <= 0;
    end
    assign audio_out = (play_enable) ? ((pinStatus == 1) ? clk_400Hz : clk_1kHz) : 1'b0;
endmodule