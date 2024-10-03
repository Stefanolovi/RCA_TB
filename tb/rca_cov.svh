
// File: rca_cov.svh
// ----------------------------------------
// Classes containig the methods and covergroup to compute the functional
// coverage of the rca.

`ifndef rca_COV_SVH_
`define rca_COV_SVH_

class rca_cov #(parameter N = 4);

    // ---------
    // VARIABLES
    // ---------
    
    // Adder interface
    local virtual interface rca_if #(N) rif;
    
    // -------------------
    // FUNCTIONAL COVERAGE
    // -------------------
    covergroup rca_cg; 
        // Operands
        a_cp: coverpoint rif.A  {
            bins corner[]   = {0, (1<<N)-1, (1<<(N-1))-1};
            bins others     = default;
        }
        b_cp: coverpoint rif.B {
            bins corner[]   = {0, (1<<N)-1, (1<<(N-1))-1};
            bins others     = default;
        }
        Ci_cp: coverpoint rif.Ci {
            bins zero[]   =  {0};
            bins uno []     = {1};
        }
    endgroup: rca_cg

    // -------
    // METHODS
    // -------

    // Constructor
    function new(virtual interface rca_if #(N) _if);
        rif         = _if;
        rca_cg      = new();

        // disable the covergroup by default
        rca_cg.stop();
    endfunction: new

    // Enable operands coverage
    function void cov_start();
        rca_cg.start();
    endfunction: cov_start

    // Disable operands coverage
    function void cov_stop();
        rca_cg.stop();
    endfunction: cov_stop

    // Sample operands coverage
    function void cov_sample();
        rca_cg.sample();
    endfunction: cov_sample

    // Return operands coverage
    function real get_cov();
        return rca_cg.get_inst_coverage();
    endfunction: get_cov
    
endclass // rca_cov

`endif /* rca_COV_SVH_ */