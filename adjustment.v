module adjustment(
    input wire [1:0] status,
    input wire clk_500Hz,
    input wire [15:0] userPin,
    input wire validPin,

    output reg [15:0] storedPin = 16'b0100_0011_0010_0001  // initial PIN 4-3-2-1
);
    always @(posedge clk_500Hz) begin
        if (status == 2 && validPin) begin
            storedPin <= userPin;
        end
    end
endmodule