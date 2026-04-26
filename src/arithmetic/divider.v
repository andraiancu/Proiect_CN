module divider_restoring(
    input [7:0] dividend,   // Q_in sau deimpartitul
    input [7:0] divisor,    // M_in sau impartitorul
    input clk, rst, start,
    output [7:0] quotient,  // Catul (Q)
    output [7:0] remainder, // Restul (A)
    output reg done         // anunta finalizarea a 8 pasi
);
    reg [7:0] A, Q, M; // acumulator, cat/deimpartit si divizor
    reg [3:0] count;   // evidenta pt cele 8 iteratii

    // A shiftat stanga cu bitul Q[7] introdus in LSB
    // Shiftarea se face INAINTE de scadere, ca in algoritmul Restoring
    wire [7:0] A_shifted;
    assign A_shifted = {A[6:0], Q[7]};

    // Fire pentru legatura cu sumatorul
    wire [8:0] sub_out; // Rezultatul scaderii (A_shifted - M)

    // Instantiem unitatea de calcul (mode=1 inseamna scadere)
    adder_sub_9bit SUB_UNIT (
        .a(A_shifted),
        .b(M),
        .mode(1'b1),
        .sum_diff(sub_out),
        .cout_bout()
    );

    // Iesirile modulului se conecteaza la registrele interne
    assign quotient  = Q;
    assign remainder = A;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0; Q <= 0; M <= 0;
            count <= 0; done <= 0; // resetare
        end else if (start) begin
            A <= 8'b0;
            Q <= dividend;
            M <= divisor;
            count <= 0;
            done <= 0;
        end else if (count < 8) begin

            // PASUL 1: Shiftare la stanga combinata [A, Q]
            // A_shifted = {A[6:0], Q[7]} - calculat combinational mai sus

            // PASUL 2 & 3: Scadere si decizie
            if (sub_out[8] == 1) begin
                // REZULTAT NEGATIV: Nu am putut scadea
                // Restauram: A primeste valoarea shiftata (fara scadere), Q[0] primeste 0
                A <= A_shifted;
                Q <= {Q[6:0], 1'b0};
            end else begin
                // REZULTAT POZITIV: Scaderea a reusit
                // A primeste rezultatul scaderii, Q[0] primeste 1
                A <= sub_out[7:0];
                Q <= {Q[6:0], 1'b1};
            end

            // Trecem la urm bit
            count <= count + 1;
        end else begin
            done <= 1; // semnalul done
        end
    end
endmodule            
            // PASUL 1: Shiftare la stanga combinata [A, Q]
            // Luam A shiftat, dar introducem in A[0] bitul Q[7]
            // Q[0] ramane liber momentan (punem 0)
            
            // PASUL 2 & 3
            if (sub_out[8] == 1) begin
                // REZULTAT NEGATIV: Nu am putut scadea
                // Restauram: A ramane cel vechi (shiftat), Q[0] primeste 0
                {A, Q} <= { {A[6:0], Q[7]}, {Q[6:0], 1'b0} };
            end else begin
                // REZULTAT POZITIV: Scaderea a reusit
                // A primeste rezultatul scaderii, Q[0] primeste 1
                {A, Q} <= { sub_out[7:0], {Q[6:0], 1'b1} };
            end
           //trecem la urm bit
            count <= count + 1;
        end else begin
            done <= 1;
        end
    end
endmodule
