module topModule (
    input clk,
    input btnR,
    input [1:0] sw,
    input [7:0] JC,
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

    reg [15:0] storedPin = 15'b0100001100100001; //initial pin is 1234

    wire lockedStatus = 0; //0=locked, 1=unlocked, 2=adjustment mode?

    clockDivider u1(
        .clk(clk),
        .clk_1Hz(clk_1Hz),
        .clk_2Hz(clk_2Hz),
        .clk_1Hz2(clk_1Hz2),
        .clk_500Hz(clk_500Hz)
    );

    keypadDecode u2(
        .clk_500Hz(clk_500Hz),
        .JC(JC),
        .userPin(userPin),
        .validPin(validPin),

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

endmodule

// module buttonDebounce(
//     input wire btnR,
//     input wire clk_2Hz,
//     output reg btnRDb,
//     output reg btnRPressed
// );
//     always @(posedge clk_2Hz) begin
//         btnRDb <= btnR;
//     end
// endmodule