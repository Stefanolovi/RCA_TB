// Assertions to verify that the RCA is producing the correct result.

// I need to create a property that defines the validity of S and Co. If the property is false return error message

`ifndef rca_IF_SVA_SVH_
`define rca_IF_SVA_SVH_

// Print operation
`define PRINT_OP(A, B, S) \
    $sformatf( "A: %08b (%d) | B: %08b (%d) | S: %08b (%d)",  A, A, B, B, S, S)

// Wrong results
int unsigned    err_num = 0;

// Get the number of errors 
function int unsigned get_err_num();
    automatic int unsigned n_err = err_num;
    err_num = 0;
    return n_err;
endfunction: get_err_num


// RCA result
logic [N:0] res ; 
always_comb res = A + B + Ci; 


property p_sum; 
@(negedge clk)
 (res[N-1:0] == S);  
endproperty

// property p_Cout; 
// Co == res [N]; 
// endproperty

RCA_result: assert property (p_sum) 
else begin
    err_num++;
    $error("%s", `PRINT_OP(A, B ,S));
end

`endif /* rca_IF_SVA_SVH_ */