
/*
 * File: rca_wrap.sv
 * ----------------------------------------
 * A simple wrapper to use the interface defined in 'rca_if.sv' 
 * instead of direct port mapping. This component also allows to
 * connect the interface to a VHDL DUT (compiled separately).
 */

module rca_wrap #(parameter N  = 4) (
    rca_if.rca_port p
);
    rca_generic #(0,0,N) rca_u (
        .Ci   (p.Ci),
        .A    (p.A),
        .B    (p.B),
        .S  (p.S),
	    .Co (p.Co)
    );
endmodule