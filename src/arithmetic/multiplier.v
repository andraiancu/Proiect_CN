module multiplier_br2(
    input  [7:0] multiplicand, // M (Deinmultitul)
    input  [7:0] multiplier,   // Q (Inmultitorul)
    input        clk,
    input        rst,
    input        start,
  output [15:0] product,     // rex 16 biti A si Q
    output reg   done
);

  
    reg [7:0] A;      // Acumulatorul 
    reg [7:0] Q;      // Multiplicatorul 
    reg [7:0] M;      // Multiplicandul
    reg       q_m1;   // Bitul Q-1 
  reg [3:0] count;  // Numaratorul de iteratii de la 1 la 8


  wire [8:0] sum_diff; // iesirea de 9 biti s
    wire mode;           // 0 sau 1 pt adunare sau scadere
    
   //01 adunare 10 scadere 
    assign mode = (Q[0] == 1 && q_m1 == 0);

    
    adder_subtractor_9bit CALC_UNIT (
        .a(A),
        .b(M),
        .mode(mode),
        .sum_diff(sum_diff),
      .cout_bout() // bit de depasire, pt carry sau imprumut
    );

    // rez final s, A si Q concatenate
    assign product = {A, Q};

   //automatul de stari, operatie si stare
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 8'b0;
            Q <= 8'b0;
            M <= 8'b0;
            q_m1 <= 1'b0;
            count <= 4'b0;
            done <= 1'b0;
        end 
        else if (start) begin
          
            M <= multiplicand;
            Q <= multiplier;
            A <= 8'b0;
            q_m1 <= 1'b0;
            count <= 4'b0;
            done <= 1'b0;
        end 
        else if (count < 8) begin
            
            
            if (Q[0] ^ q_m1) begin
                // CAZUL 01 sau 10: Calcul + Shiftare Aritmetica
                // Sshift la dreapta
                // bitul de semn sum_diff[8] se multiplica pentru shiftare aritmetica
                {A, Q, q_m1} <= {sum_diff[8], sum_diff[8:0], Q};
            end 
            else begin
                // CAZUL 00 sau 11: Doar Shiftare Aritmetica 
                // Pastram bitul de semn A[7]
                {A, Q, q_m1} <= {A[7], A, Q};
            end
            
            count <= count + 1;
        end 
        else begin
            done <= 1'b1; // semnanul done
        end
    end

endmodule
