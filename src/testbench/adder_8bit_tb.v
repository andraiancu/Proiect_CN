module adder_8bit_tb;
    reg  [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire cout;

    adder_8bit uut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, adder_8bit_tb);
        $display("=== TEST ADDER 8 BIT ===");
        cin = 0;

        a = 8'd5;   b = 8'd3;   #10;
        if(sum == 8'd8)   $display("PASS: 5+3=%0d", sum);
        else              $display("FAIL: 5+3=%0d (asteptat 8)", sum);

        a = 8'd15;  b = 8'd10;  #10;
        if(sum == 8'd25)  $display("PASS: 15+10=%0d", sum);
        else              $display("FAIL: 15+10=%0d (asteptat 25)", sum);

        a = 8'd100; b = 8'd28;  #10;
        if(sum == 8'd128) $display("PASS: 100+28=%0d", sum);
        else              $display("FAIL: 100+28=%0d (asteptat 128)", sum);

        a = 8'd255; b = 8'd1;   #10;
        if(cout == 1)     $display("PASS: 255+1 overflow, cout=1");
        else              $display("FAIL: 255+1 ar trebui overflow");

        $display("=== ADDER 8BIT DONE ===");
        $finish;
    end
endmodule
