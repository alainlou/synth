module tonegen
(
    input clk,
    input [7:0] data_byte,
    output reg signal
);

    reg [18:0] counter = 0;

    always @(posedge clk) begin
        if (counter == 500_000) begin
            counter <= 0;
            signal <= !signal;
        end else
            counter <= counter + 1;
    end

endmodule
