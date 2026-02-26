module clockDivider (
    input clk,
    output reg clk_1Hz = 0,
    output reg clk_2Hz = 0,
    output reg clk_1Hz2 = 0,
    output reg clk_500Hz = 0
);
    reg [26:0] ctr_1Hz = 0;
    reg [26:0] ctr_2Hz = 0;
    reg [26:0] ctr_1Hz2 = 0;
    reg [26:0] ctr_500Hz = 0;


    always @(posedge clk) begin
        if (ctr_1Hz >= 49999999) begin
            clk_1Hz <= ~clk_1Hz;
            ctr_1Hz <= 0;
        end else begin
            ctr_1Hz <= ctr_1Hz + 1;
        end

        if (ctr_2Hz >= 24999999) begin
            clk_2Hz <= ~clk_2Hz;
            ctr_2Hz <= 0;
        end else begin
            ctr_2Hz <= ctr_2Hz + 1;
        end

        if (ctr_1Hz2 >= 41666666) begin
            clk_1Hz2 <= ~clk_1Hz2;
            ctr_1Hz2 <= 0;
        end else begin
            ctr_1Hz2 <= ctr_1Hz2 + 1;
        end

        if (ctr_500Hz >= 99999) begin
            clk_500Hz <= ~clk_500Hz;
            ctr_500Hz <= 0;
        end else begin
            ctr_500Hz <= ctr_500Hz + 1;
        end
    end
endmodule