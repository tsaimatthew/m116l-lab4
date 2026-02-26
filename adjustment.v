module adjustment(
    input wire [1:0] status,
    input wire clk_500Hz,
    input wire [15:0] userPin,
    input wire validPin,

    output reg [15:0] storedPin = 16'b0100001100100001  // initial pin 4321
);
    always @(posedge clk_500Hz) begin
        if (status == 2 && validPin)
            storedPin <= userPin;
    end
endmodule