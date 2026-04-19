
module adder_sub_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        mode, // 0 = Add, 1 = Sub
    output [7:0] sum_diff,
    output       cout_bout
);
    wire [7:0] b_processed;

   
    // Daca mode=0, b_processed = b ^ 0 = b
    // Daca mode=1, b_processed = b ^ 1 = ~b
    xor X0(b_processed[0], b[0], mode);
    xor X1(b_processed[1], b[1], mode);
    xor X2(b_processed[2], b[2], mode);
    xor X3(b_processed[3], b[3], mode);
    xor X4(b_processed[4], b[4], mode);
    xor X5(b_processed[5], b[5], mode);
    xor X6(b_processed[6], b[6], mode);
    xor X7(b_processed[7], b[7], mode);

 
    // Daca mode=1 (sub), cin primeste 1, deci avem a + ~b + 1
    adder_8bit RCA (
        .a(a),
        .b(b_processed),
        .cin(mode), 
        .sum(sum_diff),
        .cout(cout_bout)
    );

endmodule
