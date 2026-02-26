module tone_gen #(
    parameter CLK_FREQ  = 100_000_000,
    parameter FREQ_OK   = 1000,  // 1 kHz
    parameter FREQ_FAIL = 400    // 400 Hz
)(
    input  wire clk,
    input  wire play,
    input  wire ok_not_fail, // 1 = success tone, 0 = fail tone
    output reg  audio_out
);

    localparam integer N_OK   = CLK_FREQ / (2 * FREQ_OK);
    localparam integer N_FAIL = CLK_FREQ / (2 * FREQ_FAIL);

    reg [17:0] counter = 0;
    wire [17:0] limit = ok_not_fail ? N_OK : N_FAIL;

    always @(posedge clk) begin
        if (!play) begin
            counter   <= 0;
            audio_out <= 0;
        end else begin
            if (counter == limit - 1) begin
                counter   <= 0;
                audio_out <= ~audio_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule

