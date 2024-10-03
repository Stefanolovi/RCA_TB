
/*
 * File: rca_if.sv
 * ----------------------------------------
 * Interface with the rca wrapper in 'rca_wrap.sv'.
 */



interface rca_if #(parameter N = 4);

    /* INTERFACE SIGNALS */
    
    logic          Ci;
    logic [N-1:0]  A;
    logic [N-1:0]  B;
    logic [N-1:0]  S;
    logic 	   Co;
    logic      clk; 
   

    /* INTERFACE SIGNALS MODE MAPPING */

    /* Interface port at rca side (DUT) */
    modport rca_port (
        input   Ci,
        input   A,
        input   B,
        output  S,
	output  Co 
   // input clk
    );


initial clk =1'b1; 
always #5 clk<=~clk; 

    `ifndef SYNTHESIS
    `include "rca_if_sva.svh"
    `endif /* SYNTHESIS */

endinterface // rca_if

