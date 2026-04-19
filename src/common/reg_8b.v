// reg_8b.v - Registru pe 8 biti cu load si reset sincron
// Intrari: clk, rst (reset), load (incarca data), d[7:0] (data in)
// Iesire: q[7:0] (data out)

module reg_8b(
    input clk,
    input rst,
    input load,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else if (load)
            q <= d;
    end

endmodule
