
/*
 * File: rca_tester.svh
 * ----------------------------------------
 * Class containig the methods and variables to test the
 * rca described in 'rca.sv' using the interface in 
 * 'rca_if.sv'.
 */

`ifndef rca_TESTER_SVH_
`define rca_TESTER_SVH_

`include "rca_cov.svh"


/* rca tester class */
class rca_tester #(
    parameter N  =  4
);
    // PROPERTIES
    // ----------

    // rca interface
    /*
     * NOTE: the interface is declared as virtual, meaning that the
     * user will provide a proper implementation. In this case, the 
     * handle to a proper interface object is passed to the 
     * constructor (see below) by the TB in 'rca_tb.sv'.
     */
    virtual interface rca_if #(N) test_rca_if;
   

    // Random rca input operators (updated by the 'randomize()' method)
    typedef struct packed {
        logic          Ci;
        logic [N-1:0]  A;
        logic [N-1:0]  B;
    } op_t;

    protected rand op_t     rca_op;

    // Constraint to prefer corner cases for operands /10x more likely)
    constraint ab_dist_c {
        rca_op.A dist {
            0                   :=10, 
            (1<<N)-1       :=10,
            (1<<(N-1))-1   :=10, 
            [1:(1<<N)-2]   :=1
        };
        rca_op.B dist {
            0                   :=10, 
            (1<<N)-1       :=10,
            (1<<(N-1))-1   :=10, 
            [1:(1<<N)-2]   :=1
        };
    };

    // rca coverage
    // NOTE: declared as static so it's shared among multiple class
    // instances.
    protected static rca_cov #(N)  acov;

    // METHODS
    // -------

    // Constructor
    function new(virtual interface rca_if #(N) _if);
        test_rca_if = _if;   // get the handle to the rca interface from the TB
        acov = new(_if);
    endfunction // new()

    // Test body
    /*
     * NOTE: tasks can contain "time-consuming" code, while functions
     * are always executed within a single simulation step.
     */
    task run_test(int unsigned num_cycles);
        // Reset the DUT
        init();

        // Start measuring coverage
        acov.cov_start();

        // Issue num_cycles random rca operations
        repeat (num_cycles) begin: driver
            @(posedge test_rca_if.clk);
            rand_rca_op();

            @(negedge test_rca_if.clk);
            $display("expected: %0h, actual: %0h", test_rca_if.res [N-1:0], test_rca_if.S); 
        end

        // Wait for the last operation to complete
        @(posedge test_rca_if.clk);

        // Stop measuring coverage
        acov.cov_stop();
    endtask // run_test()
    
    protected task init();
        // Reset driver signals
        
        test_rca_if.A      = '0;
        test_rca_if.B      = '0;
        test_rca_if.Ci     = '0;

        @(posedge test_rca_if.clk);
    endtask: init
    
    // Prepare a new rca operation
    function void rand_rca_op();
        // Obtain random operations and operands
        assert (this.randomize())   // check the method's return value
        else   $error("ERROR while calling 'randomize()' method");

        // Set the rca interface signals
        test_rca_if.Ci   = rca_op.Ci;
        test_rca_if.A    = rca_op.A;
        test_rca_if.B    = rca_op.B;

        // Update coverage
        acov.cov_sample();
    endfunction

    // Get the rca coverage
    function real get_cov();
        return acov.get_cov();
    endfunction: get_cov

endclass // rca_tester

`endif /* rca_TESTER_SVH_ */
