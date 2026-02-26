module adjustment(
    input wire clk_500Hz,
    input wire [15:0] userPin,
    input wire validPin,

    output reg [15:0] storedPin = 16'b0100001100100001; //initial pin is 4321
);
    always @(posedge clk_500Hz) begin
        if (status == 2 && validPin) begin
            storedPin <= userPin;
        end
    end
endmodule