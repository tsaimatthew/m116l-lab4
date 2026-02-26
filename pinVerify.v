module pinVerify(
    input wire clk_500Hz,
    input wire [15:0] storedPin,
    input wire [15:0] userPin,
    input wire validPin,
    input btnR,

    output reg status

);
    reg [3:0] rst_debounce_reg = 0;
    reg clean_rst = 0;

    always @(posedge clk_500Hz) begin

        rst_debounce_reg <= {rst_debounce_reg[2:0], btnR};
        if (rst_debounce_reg == 4'b1111) 
            clean_rst <= 1;
        else if (rst_debounce_reg == 4'b0000)
            clean_rst <= 0;

        if (validPin) begin
            if (userPin == storedPin)
                status <= 1;
            else
                status <= 0;
        end
        if (clean_rst)
            status <= 0; //locked
    end
endmodule