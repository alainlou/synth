module tonegen
(
    input clk,
    input [7:0] data,
    input data_valid,
    output signal
);
    parameter C=191_110, CSHARP=180_388, D=170_265, DSHARP=160_705, E=151_685, F=143_172,
    FSHARP=135_138, G=127_551, GSHARP=120_395, A=113_636, ASHARP=107_259, B=101_239, COCTAVE=95_557;

    reg prev_dv = 1'b0;

    reg [18:0] note_period;
    reg [18:0] counter = 0;
    reg waveform;
    reg mute = 1'b1;
    reg [24:0] mute_counter = 0;

    always @(posedge clk) begin
        if (!prev_dv && data_valid) begin
            mute = 1'b0;
            mute_counter = 0;
            case (data)
                8'h61: note_period <= C;
                8'h77: note_period <= CSHARP;
                8'h73: note_period <= D;
                8'h65: note_period <= DSHARP;
                8'h64: note_period <= E;
                8'h66: note_period <= F;
                8'h74: note_period <= FSHARP;
                8'h67: note_period <= G;
                8'h79: note_period <= GSHARP;
                8'h68: note_period <= A;
                8'h75: note_period <= ASHARP;
                8'h6A: note_period <= B;
                8'h6B: note_period <= COCTAVE;
                default: note_period <= C;
            endcase
        end
        else if (mute_counter == 12_500_000) begin
            mute = 1'b1;
            mute_counter = 0;
        end

        if (!mute) begin
            mute_counter <= mute_counter + 1;
            if (counter == note_period) begin
                counter <= 0;
                waveform <= !waveform;
            end
            else
                counter <= counter + 1;
        end

        prev_dv <= data_valid;
    end

    assign signal = !mute && waveform;

endmodule
