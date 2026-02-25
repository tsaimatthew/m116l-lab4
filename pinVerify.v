module pinVerify(
    input wire clk_500Hz,
    input wire [15:0] storedPin,
    input wire [15:0] userPin,
    input wire validPin,

    output reg status

);
    always @(posedge clk_500Hz) begin
        if (validPin) begin
            if (userPin == storedPin)
                status = 1;
            else
                status = 0;
        end
    end
endmodule