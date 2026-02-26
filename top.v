module topModule (
    input clk,
    input btnL,
    input [1:0] sw,
    input [3:0] JC_cols,
    input btnR,

    output [3:0] JC_rows,
    output [3:0] an,
    output [6:0] seg
);
    wire clk_500Hz;
    wire [15:0] userPin;
    wire validPin;
    wire [3:0] pin0;
    wire [3:0] pin1;
    wire [3:0] pin2;
    wire [3:0] pin3;

    wire [1:0] status; //0=locked, 1=unlocked, 2=adjustment mode

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
        .status(status),
        .btnL(btnL),
        .sw(sw)
    );

    adjustment u5(
        .clk_500Hz(clk_500Hz),
        .userPin(userPin),
        .validPin(validPin)
    );

endmodule