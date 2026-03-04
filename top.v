module topModule (
    input clk,
    input btnL,
    input [1:0] sw,
    input [3:0] JC_cols,
    input btnR,

    output audio_gain,
    output audio_shutdown,
    output audio_out,
    output [3:0] JC_rows,
    output [3:0] an,
    output [6:0] seg
);
    wire clk_400Hz;
    wire clk_500Hz;
    wire clk_500Hz;
    wire [15:0] userPin;
    wire validPin;
    wire [3:0] pin0;
    wire [3:0] pin1;
    wire [3:0] pin2;
    wire [3:0] pin3;

    wire [1:0] status; //0=locked, 1=unlocked, 2=adjustment mode
    wire [15:0] storedPin;

    //tie shutdown to hi to prevent floating pin, gain to gnd for 6db gain
    audio_shutdown = 1;
    audio_gain = 0;

    clockDivider u1(
        .clk(clk),
        .clk_1kHz(clk_1kHz),
        .clk_400Hz(clk_400Hz),
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
        .validPin(validPin),
        .an(an),
        .seg(seg),
        .status(status)
    );
    
    pinVerify u4(
        .clk_400Hz(clk_400Hz),
        .clk_1kHz(clk_1kHz),
        .audio_out(audio_out)
        .clk_500Hz(clk_500Hz),
        .storedPin(storedPin),
        .userPin(userPin),
        .validPin(validPin),
        .status(status),
        .btnL(btnL),
        .sw(sw)
    );

    adjustment u5(
        .status(status),
        .clk_500Hz(clk_500Hz),
        .userPin(userPin),
        .validPin(validPin),
        .storedPin(storedPin)
    );

endmodule