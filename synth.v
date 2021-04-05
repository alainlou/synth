module synth
(
    input FPGA_CLK,
    input UART_RXD,
    output UART_TXD,
    output SVNSEG_DIG1,
    output SVNSEG_DIG2,
    output SVNSEG_DIG3,
    output SVNSEG_DIG4,
    output SVNSEG_SEG0,
    output SVNSEG_SEG1,
    output SVNSEG_SEG2,
    output SVNSEG_SEG3,
    output SVNSEG_SEG4,
    output SVNSEG_SEG5,
    output SVNSEG_SEG6,
    output SVNSEG_SEG7,
    output BEEP
);

    wire rx = !UART_RXD;
    wire tx;
    assign UART_TXD = !tx;

    reg valid;
    reg [7:0] data_byte;

    uart_rx uart_rx_inst
    (
        .clk(FPGA_CLK),
        .uart_rxd(rx),
        .data(data_byte),
        .data_valid(valid)
    );

    uart_tx uart_tx_inst
    (
        .clk(FPGA_CLK),
        .data(data_byte),
        .data_valid(valid),
        .uart_txd(tx)
    );

    svnseg_controller controller_inst
    (
        .clk(FPGA_CLK),
        .num3(4'h0),
        .num2(4'h0),
        .num1(data_byte[7:4]),
        .num0(data_byte[3:0]),
        .dig1(SVNSEG_DIG1),
        .dig2(SVNSEG_DIG2),
        .dig3(SVNSEG_DIG3),
        .dig4(SVNSEG_DIG4),
        .seg0(SVNSEG_SEG0),
        .seg1(SVNSEG_SEG1),
        .seg2(SVNSEG_SEG2),
        .seg3(SVNSEG_SEG3),
        .seg4(SVNSEG_SEG4),
        .seg5(SVNSEG_SEG5),
        .seg6(SVNSEG_SEG6),
        .seg7(SVNSEG_SEG7)
    );

    parameter A = 11367;

    tonegen tonegen_inst
    (
        .clk(FPGA_CLK),
        .signal(BEEP)
    );

endmodule
