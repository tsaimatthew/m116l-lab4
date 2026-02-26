module topModule (
    input clk,
    input btnL,
    input [1:0] sw,
    input [3:0] JC_cols,
    input btnR,

    output wire [3:0] JC_rows,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire audio_out
);

    wire clk_1Hz;
    wire clk_2Hz;
    wire clk_1Hz2;
    wire clk_500Hz;
    wire [15:0] userPin;
    wire validPin;
    wire [3:0] pin0;
    wire [3:0] pin1;
    wire [3:0] pin2;
    wire [3:0] pin3;

    wire [15:0] storedPin;

    wire [1:0] status; //0=locked, 1=unlocked, 2=adjustment mode
    wire success_event;
    wire fail_event;

    reg play        = 0;
    reg ok_not_fail = 0;
    reg [25:0] beep_counter = 0;

    reg success_sync_0 = 0;
    reg success_sync_1 = 0;
    reg fail_sync_0    = 0;
    reg fail_sync_1    = 0;

    clockDivider u1(
        .clk(clk),
        .clk_1Hz(clk_1Hz),
        .clk_2Hz(clk_2Hz),
        .clk_1Hz2(clk_1Hz2),
        .clk_500Hz(clk_500Hz)
    );

    keypadDecode u2(
        .clk_500Hz(clk_500Hz),
        .JC_rows(JC_rows),
        .JC_cols(JC_cols),
        .userPin(userPin),
        .validPin(validPin),
        .status(status),
        .pin0(pin0),
        .pin1(pin1),
        .pin2(pin2),
        .pin3(pin3)
    );

    outputs u3(
        .pin0(pin0),
        .pin1(pin1),
        .pin2(pin2),
        .pin3(pin3),
        .clk_500Hz(clk_500Hz),
        .an(an),
        .seg(seg),
        .status(status)
    );

    pinVerify u4(
        .clk_500Hz(clk_500Hz),
        .storedPin(storedPin),
        .userPin(userPin),
        .validPin(validPin),
        .btnL(btnL),
        .status(status),
        .success_event(success_event),
        .fail_event(fail_event),
        .sw(sw)
    );

    always @(posedge clk) begin
        success_sync_0 <= success_event;
        success_sync_1 <= success_sync_0;
        fail_sync_0    <= fail_event;
        fail_sync_1    <= fail_sync_0;

        if (success_sync_0 && !success_sync_1) begin
            play         <= 1;
            ok_not_fail  <= 1;
            beep_counter <= 10_000_000;
        end else if (fail_sync_0 && !fail_sync_1) begin
            play         <= 1;
            ok_not_fail  <= 0;
            beep_counter <= 10_000_000;
        end else if (beep_counter != 0) begin
            beep_counter <= beep_counter - 1;
            if (beep_counter == 1) begin
                play <= 0;
            end
        end
    end

    tone_gen tone_inst(
        .clk(clk),
        .play(play),
        .ok_not_fail(ok_not_fail),
        .audio_out(audio_out)
    );

    adjustment u5(
        .status(status),
        .clk_500Hz(clk_500Hz),
        .userPin(userPin),
        .validPin(validPin),
        .storedPin(storedPin)
    );

endmodule
