/* Melanie Chen chenmel */

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
    wire [31:0] w_quotient [33];
    wire [31:0] w_remainder [33];
    wire [31:0] w_dividend [33];

    assign w_quotient[0] = 32'h0;
    assign w_remainder[0] = 32'h0;
    assign w_dividend[0] = i_dividend;
    genvar i;

    for (i = 0; i < 32; i++) begin
        divu_1iter d(.i_dividend(w_dividend[i]), .i_divisor(i_divisor), .i_remainder(w_remainder[i]), .i_quotient(w_quotient[i]), 
            .o_dividend(w_dividend[i+1]), .o_remainder(w_remainder[i+1]), .o_quotient(w_quotient[i+1]));
    end

    assign o_remainder = w_remainder[32];
    assign o_quotient = w_quotient[32];

endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
  /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */

    logic [31:0] w_quotient, w_remainder, w_dividend;

    always_comb begin

        w_quotient = i_quotient;
        w_dividend = i_dividend;
        
        w_remainder = (i_remainder << 1) | ((i_dividend >> 31) & 32'h1);

        if (w_remainder < i_divisor) begin
            w_quotient = i_quotient << 1;
        end else begin
            w_quotient = ((i_quotient << 1) | 32'h1);
            w_remainder = w_remainder - i_divisor;
        end

        w_dividend = i_dividend << 1;

    end

    assign o_dividend = w_dividend;
    assign o_remainder = w_remainder;
    assign o_quotient = w_quotient;

endmodule
