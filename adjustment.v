module adjustment(
    input wire clk_500Hz,
    input wire [15:0] userPin,
    input wire validPin,

    output reg [15:0] storedPin
);
    reg reset;
    always @(posedge clk_500Hz or reset) begin
        if (reset)
            storedPin = 16'b0100001100100001; //initial pin is 4321
        if (status == 2 && validPin) begin
            storedPin <= userPin;
        end
    end

    initial begin
        reset = 1;
        #10 reset = 0;
    end
endmodule