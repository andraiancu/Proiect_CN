//adder subtractor cu extensie de semn pt br2


module adder_sub_9bit(
    input  [7:0] a,         // Intrarea A de 8 biti (Acumulatorul)
    input  [7:0] b,         // Intrarea B de 8 biti (Multiplicandul)
    input        mode,      // 0 = Adunare, 1 = Scadere
    output [8:0] sum_diff,  // Rezultatul pe 9 biti (sum[8] este noul bit de semn)
    output       cout_bout  // Carry out final
);

    wire [8:0] a_ext;
    wire [8:0] b_ext;
    wire [8:0] b_processed;
    wire [8:0] carry;

    //ext de semn
    assign a_ext = {a[7], a};
    assign b_ext = {b[7], b};

  //pregatim b sau b complemenyat de 2
    xor X0(b_processed[0], b_ext[0], mode);
    xor X1(b_processed[1], b_ext[1], mode);
    xor X2(b_processed[2], b_ext[2], mode);
    xor X3(b_processed[3], b_ext[3], mode);
    xor X4(b_processed[4], b_ext[4], mode);
    xor X5(b_processed[5], b_ext[5], mode);
    xor X6(b_processed[6], b_ext[6], mode);
    xor X7(b_processed[7], b_ext[7], mode);
    xor X8(b_processed[8], b_ext[8], mode);


    fac FA0(.a(a_ext[0]), .b(b_processed[0]), .cin(mode),     .sum(sum_diff[0]), .cout(carry[0]));
    
 
    fac FA1(.a(a_ext[1]), .b(b_processed[1]), .cin(carry[0]), .sum(sum_diff[1]), .cout(carry[1]));
    fac FA2(.a(a_ext[2]), .b(b_processed[2]), .cin(carry[1]), .sum(sum_diff[2]), .cout(carry[2]));
    fac FA3(.a(a_ext[3]), .b(b_processed[3]), .cin(carry[2]), .sum(sum_diff[3]), .cout(carry[3]));
    fac FA4(.a(a_ext[4]), .b(b_processed[4]), .cin(carry[3]), .sum(sum_diff[4]), .cout(carry[4]));
    fac FA5(.a(a_ext[5]), .b(b_processed[5]), .cin(carry[4]), .sum(sum_diff[5]), .cout(carry[5]));
    fac FA6(.a(a_ext[6]), .b(b_processed[6]), .cin(carry[5]), .sum(sum_diff[6]), .cout(carry[6]));
    fac FA7(.a(a_ext[7]), .b(b_processed[7]), .cin(carry[6]), .sum(sum_diff[7]), .cout(carry[7]));
    
   
    fac FA8(.a(a_ext[8]), .b(b_processed[8]), .cin(carry[7]), .sum(sum_diff[8]), .cout(cout_bout));

endmodule
