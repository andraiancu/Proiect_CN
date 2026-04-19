module fac_tb;
    reg a, b, cin;
    wire sum, cout;

    fac uut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, fac_tb);
        $display("=== TEST FULL ADDER ===");

        a=0; b=0; cin=0; #10;
        if(sum==0 && cout==0) $display("PASS: 0+0+0=0");
        else $display("FAIL: 0+0+0");

        a=0; b=1; cin=0; #10;
        if(sum==1 && cout==0) $display("PASS: 0+1+0=1");
        else $display("FAIL: 0+1+0");

        a=1; b=1; cin=0; #10;
        if(sum==0 && cout==1) $display("PASS: 1+1+0=2");
        else $display("FAIL: 1+1+0");

        a=1; b=1; cin=1; #10;
        if(sum==1 && cout==1) $display("PASS: 1+1+1=3");
        else $display("FAIL: 1+1+1");

        $display("=== FULL ADDER DONE ===");
        $finish;
    end
endmodule
