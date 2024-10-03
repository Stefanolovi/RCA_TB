// File: rca_verbose_tester.svh
// ----------------------------
// Class extended from rca_tester.svh to print additional information about
// the test progress.

`ifndef rca_VERBOSE_TESTER_SVH_
`define rca_VERBOSE_TESTER_SVH_

`include "rca_tester.svh"

/* rca verbose tester class */
class rca_verbose_tester #(
    parameter N = 4
) extends rca_tester #(N);    // inherits methods and variables from rca_tester

    // Operands queue: creates a queue of elements whose datatype are A, B and Cin
    op_t    opq[$];
    
    // 
    function new(virtual interface rca_if #(N) _if);
        super.new(_if);     //given an interface call the constructor of tester
        opq = {};           //initializes the queue as empty    
    endfunction // new()

    // Test body
    task run_test(int unsigned num_cycles);

        // Start measuring coverage
        acov.cov_start();

        fork
            // Monitor operations
            print_op();

            // Issue num_cycles random rca operations
            repeat (num_cycles) begin: driver
                @(posedge test_rca_if.clk);
                rand_rca_op();              // function from tester that generates random stimuli and feeds it to the if instance
                opq.push_front({rca_op});   // test elements are pushed in the queue 
            end
        join

        // Stop measuring coverage
        acov.cov_stop();
    endtask // run_test()
    
    // Print current operation
    task print_op();
        op_t prev_op;  

        repeat (2) 
        @(negedge test_rca_if.clk);    // skip the first result after reset
        while (opq.size() > 0) begin
            @(negedge test_rca_if.clk); // sample on negative edge to avoid race conditions
            prev_op = opq.pop_back();   
            $display("[%07t] | a: %b (%d) | b: %b (%d) | res: %b (%d)", $time, test_rca_if.A, test_rca_if.A, test_rca_if.B, test_rca_if.B, test_rca_if.S, test_rca_if.S);
        end
        @(negedge test_rca_if.clk);
    endtask // op2str()

endclass // rca_verbose_tester

`endif /* rca_VERBOSE_TESTER_SVH_ */
