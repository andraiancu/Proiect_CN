module subtractor_tb;
    reg  [7:0] a, b;
    wire [7:0] diff;
    wire bout;

    subtractor uut(.a(a), .b(b), .diff(diff), .bout(bout));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, subtractor_tb);
        $display("=== TEST SUBTRACTOR ===");

        a = 8'd10;  b = 8'd3;   #10;
        if(diff == 8'd7)  $display("PASS: 10-3=%0d", diff);
        else              $display("FAIL: 10-3=%0d (asteptat 7)", diff);

        a = 8'd20;  b = 8'd5;   #10;
        if(diff == 8'd15) $display("PASS: 20-5=%0d", diff);
        else              $display("FAIL: 20-5=%0d (asteptat 15)", diff);

        a = 8'd100; b = 8'd50;  #10;
        if(diff == 8'd50) $display("PASS: 100-50=%0d", diff);
        else              $display("FAIL: 100-50=%0d (asteptat 50)", diff);

        a = 8'd5;   b = 8'd10;  #10;
        if(bout == 0) $display("PASS: 5-10 underflow detectat");
        else          $display("FAIL: 5-10 underflow nedetectat");

        $display("=== SUBTRACTOR DONE ===");
        $finish;
    end
endmodule
