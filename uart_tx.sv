/*
 * Note to self: we are using CLKS_PER_BIT-1 because it took one clock period to transition to the new state
 */

module uart_tx(
    input clk,
    input data_valid,
    input [7:0] data,
    output reg uart_txd);

    parameter CLKS_PER_BIT = 433; // 50 MHz clock, 115 200 baud rate, 433 is experimental
    parameter IDLE = 0, START_BIT = 1, TRANSMIT = 2, STOP_BIT = 3;

    reg [2:0] state = IDLE;
    reg [3:0] bit_index = 0;
    reg [8:0] counter = 0;

    reg [7:0] data_byte;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                uart_txd <= 1'b1;
                if (data_valid) begin
                    state <= START_BIT;
                    data_byte <= data;
                end
            end
            START_BIT: begin
                uart_txd <= 1'b0;
                if (counter < CLKS_PER_BIT-1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    state <= TRANSMIT;
                end
            end
            TRANSMIT: begin
                if (counter < CLKS_PER_BIT-1) begin
                    counter <= counter + 1;
                    uart_txd <= data_byte[bit_index];
                end else begin
                    counter <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end
            STOP_BIT: begin
                uart_txd <= 1'b1;
                if (counter < CLKS_PER_BIT-1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end

endmodule
