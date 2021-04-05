module tonegen
(
    input clk,
    input [7:0] data,
    input data_valid,
    output signal
);

    reg [18:0] counter = 0;
    reg waveform;

    parameter C=191_110;

    reg [24:0] timer = 0;
    reg mute = 1'b0;

    reg prev_dv = 1'b0;

    always @(posedge clk) begin
        if (!prev_dv && data_valid) begin
            mute <= 1'b0;
            timer <= 0;
        end
        else if (timer == 25_000_000) begin
            mute <= 1'b1;
            timer <= 0;
        end
        else if (!mute)
            timer <= timer + 1;

        if (counter == C) begin
            counter <= 0;
            waveform <= !waveform;
        end
        else
            counter <= counter + 1;

        prev_dv <= data_valid;
    end

    assign signal = !mute && waveform;

endmodule
