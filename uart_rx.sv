/*
 * Note to self: we are using CLKS_PER_BIT-1 because it took one clock period to transition to the new state
 */

module uart_rx(
    input clk,
    input uart_rxd,
    output reg data_valid,
    output reg [7:0] data);

    parameter CLKS_PER_BIT = 433; // 50 MHz clock, 115 200 baud rate, 433 is experimental
    parameter IDLE = 0, START_BIT = 1, SAMPLING = 2, STOP_BIT = 3;

    reg [1:0] state = IDLE;
    reg [3:0] bit_index = 0;
    reg [9:0] counter = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                data_valid <= 1'b0;
                if (uart_rxd == 1'b0) begin
                    state <= START_BIT;
                end
            end
            START_BIT: begin
                if (counter < CLKS_PER_BIT/2)
                    counter <= counter + 1;
                else begin
                    counter <= 0;
                    if (uart_rxd == 1'b0) begin
                        state <= SAMPLING;
                    end else
                        state <= IDLE;
                end
            end
            SAMPLING: begin
                if (counter < CLKS_PER_BIT-1)
                    counter <= counter + 1;
                else begin
                    data[bit_index] <= uart_rxd;
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
                if (counter < CLKS_PER_BIT + CLKS_PER_BIT/2)
                    counter <= counter + 1;
                else begin
                    counter <= 0;
                    data_valid <= 1'b1;
                    state <= IDLE;
                end
            end
            default:
                state <= IDLE;
        endcase
    end

endmodule
