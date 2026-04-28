module mux4to1_16bit(
    input [15:0] in0,    // Rezultat Adunare 
    input [15:0] in1,    // Rezultat Scadere 
    input [15:0] in2,    // Rezultat Inmultire
    input [15:0] in3,    // Rezultat Impartire 
  input [1:0]  sel,    // selectia
    output reg [15:0] out
);

    always @(*) begin
        case (sel)
            2'b00:   out = in0; //daca sel e 00 iesirea primeste in0
            2'b01:   out = in1; // tot asa
            2'b10:   out = in2; 
            2'b11:   out = in3; 
            default: out = 16'b0;// in caz ca ceva nu merge si intrarea e z sau ceva
        endcase
    end

endmodule
