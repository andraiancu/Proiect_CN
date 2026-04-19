// subtractor.v - Subtractor pe 8 biti
// Scaderea se face prin: a + (~b) + 1 (complement fata de 2)
// Intrari: a[7:0], b[7:0]
// Iesiri:  diff[7:0] (rezultatul), bout(borrow out)

module subtractor(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] diff,
    output       bout
);
    wire [7:0] b_inv;

    // Inversam toti bitii lui b (complement fata de 1)
    not N0(b_inv[0], b[0]);
    not N1(b_inv[1], b[1]);
    not N2(b_inv[2], b[2]);
    not N3(b_inv[3], b[3]);
    not N4(b_inv[4], b[4]);
    not N5(b_inv[5], b[5]);
    not N6(b_inv[6], b[6]);
    not N7(b_inv[7], b[7]);

    // Adaugam 1 prin cin=1 => obtinem complementul fata de 2
    adder_8bit ADD(
        .a(a),
        .b(b_inv),
        .cin(1'b1),
        .sum(diff),
        .cout(bout)
    );

endmodule
