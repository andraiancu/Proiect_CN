module reg_8b_tb;
    reg clk, rst, load;
    reg [7:0] d;
    wire [7:0] q;

    reg_8b uut(.clk(clk), .rst(rst), .load(load), .d(d), .q(q));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, reg_8b_tb);
        $display("=== TEST REGISTRU 8 BIT ===");

        clk = 0; rst = 1; load = 0; d = 0;
        #10 rst = 0;

        // Test 1: incarca valoarea 42
        d = 8'd42; load = 1; #10;
        if(q == 8'd42) $display("PASS: load 42, q=%0d", q);
        else           $display("FAIL: load 42, q=%0d (asteptat 42)", q);

        // Test 2: fara load, valoarea ramane
        load = 0; d = 8'd99; #10;
        if(q == 8'd42) $display("PASS: fara load, q ramane %0d", q);
        else           $display("FAIL: q s-a schimbat la %0d", q);

        // Test 3: incarca 200
        d = 8'd200; load = 1; #10;
        if(q == 8'd200) $display("PASS: load 200, q=%0d", q);
        else            $display("FAIL: load 200, q=%0d (asteptat 200)", q);

        // Test 4: reset
        rst = 1; load = 0; #10;
        if(q == 8'd0) $display("PASS: reset, q=%0d", q);
        else          $display("FAIL: reset, q=%0d (asteptat 0)", q);

        $display("=== REGISTRU DONE ===");
        $finish;
    end
endmodule
