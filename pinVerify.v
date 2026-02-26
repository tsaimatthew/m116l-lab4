module pinVerify(
    input wire clk_500Hz,
    input wire [15:0] storedPin,
    input wire [15:0] userPin,
    input wire validPin,
    input wire [1:0] sw,
    input btnR,

    output reg status

    output reg status,
    output reg success_event,
    output reg fail_event
);

    reg [3:0] rst_debounce_reg = 0;
    reg       clean_rst        = 0;
    reg       prev_validPin    = 0;

    always @(posedge clk_500Hz) begin
        if (status == 1 && sw[0] == 1) begin
            //in adjustment mode
            status <= 2;
        end
        rst_debounce_reg <= {rst_debounce_reg[2:0], btnR};
        if (rst_debounce_reg == 4'b1111)
            clean_rst <= 1;
        else if (rst_debounce_reg == 4'b0000)
            clean_rst <= 0;

        success_event <= 0;
        fail_event    <= 0;

        if (status == 0 && validPin) begin
            if (userPin == storedPin) begin
                status        <= 1;
                success_event <= 1;
            end else begin
                status     <= 0;
                fail_event <= 1;
            end
        end

        if (clean_rst)
            status <= 0;

        prev_validPin <= validPin;
    end

endmodule
