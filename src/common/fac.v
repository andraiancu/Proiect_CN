// fac.v - Full Adder pe 1 bit
// Intrari: a, b, cin
// Iesiri:  sum, cout 

module fac(

    input  a,
    input  b,
    input  cin,
    output sum,
    output cout

);

    wire w1, w2, w3;
    xor G1(w1, a, b);
    xor G2(sum, w1, cin);
    and G3(w2, a, b);
    and G4(w3, w1, cin);
    or  G5(cout, w2, w3);

endmodule
