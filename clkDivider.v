module clockDivider (
    input clk,
    output reg clk_1kHz = 0,
    output reg clk_400Hz = 0,
    output reg clk_500Hz = 0
);
    reg [26:0] ctr_1kHz = 0;
    reg [26:0] ctr_400Hz = 0;
    reg [26:0] ctr_500Hz = 0;


    always @(posedge clk) begin
        //1 Hz timer for tone length
        if (ctr_1Hz >= 49999999) begin
            clk_1Hz <= ~clk_1Hz;
            ctr_1Hz <= 0;
        end else begin
            ctr_1Hz <= ctr_1Hz + 1;
        end
        //1kHz clock for tone
        if(ctr_1kHz >= 49999) begin
            clk_1kHz <= ~clk_1kHz;
            ctr_1kHz <= 0;
        end else begin
            ctr_1kHz <= ctr_1kHz + 1;
        //400 Hz clk for tone
        end if (ctr_400Hz >= 124999) begin
            clk_400Hz <= ~clk_400Hz;
            ctr_400Hz <= 0;
        end else begin
            ctr_400Hz <= ctr_400Hz + 1;
        //500 Hz clk for display/buttons
        end if (ctr_500Hz >= 99999) begin
            clk_500Hz <= ~clk_500Hz;
            ctr_500Hz <= 0;
        end else begin
            ctr_500Hz <= ctr_500Hz + 1;
        end
    end
endmodule