/*
 * File: rca_tb.sv
 * ----------------------------------------
 * Testbench for the rca in 'rca.sv'. It provides to the
 * tester objects a connection point to the DUT using the
 * rca interface described in 'rca_if.sv').
 */

/* Include the rca tester classes */
`include "rca_tester.svh"
`include "rca_verbose_tester.svh"


/* Testbench code */
module rca_tb;

    /* Define data width */
    localparam N = 32;

    /* Instantiate rca interface */
    rca_if #(N)    rif();

    /* Instantiate rca wrapper */
    rca_wrap #(N)  aw(rif.rca_port);

    /* Declare a quiet tester object */
    rca_tester #(N) tst;

    /* Declare a verbose tester object */
    rca_verbose_tester #(N) vtst;
  

    /* Number of test cycles */
    int unsigned    num_cycles = 10;
    int unsigned    err_num = 0;

    /* Run the test */
    initial begin
        /* Instantiate the tester objects */
        tst = new(rif);
        vtst = new(rif);

        if (0 != $value$plusargs("n%d", num_cycles))
            $display("[CONFIG] Number of test cycles set to %0d", num_cycles);

        // Set the number of cycles to test
        //if (0 != $vrcae$plusargs("n%d", num_cycles))
            $display("[CONFIG] Number of test cycles set to %0d", num_cycles);

        /* Run the quiet test */
        $display("\nTEST #1 - Launching rca quiet test...");
        tst.run_test(num_cycles);
        $display("TEST #1 - Test completed!");
        $display("TEST #1 - Functional coverage: %.2f%%", tst.get_cov());

        /* Run the verbose test */
        $display("\nTEST #2 - Launching rca verbose test...");
        vtst.run_test(num_cycles);
        $display("TEST #2 - Test completed!");
        $display("TEST #2 - Functional coverage: %.2f%%", tst.get_cov());


        // Print functional coverage
        $display("\nTOTAL FUNCTIONAL COVERAGE: %.2f%%", tst.get_cov());

        // Print the number of errors
        err_num = rif.get_err_num();
        $display("");
        if (err_num > 0) begin
            $error("### TEST FAILED with %0d errors", err_num);
        end else $display("### TEST PASSED!");

        /* Terminate the simulation */
        $display("");
        $stop;
    end
endmodule
