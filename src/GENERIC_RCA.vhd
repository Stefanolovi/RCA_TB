library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity RCA_generic is 
	generic (DRCAS : 	Time := 0 ns;
	         DRCAC : 	Time := 0 ns;
	         N: integer:= 8);           -- add parameter N. 
	Port (	A:	In	std_logic_vector(N-1 downto 0);     --N determines size of A,B and S.
		B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic);
end RCA_generic; 

-- architecture STRUCTURAL of RCA_generic is

--   signal STMP : std_logic_vector(N-1 downto 0);
--   signal CTMP : std_logic_vector(N downto 0);
  

--   component FA 
--   generic (DFAS : 	Time := 0 ns;
--            DFAC : 	Time := 0 ns);
--   Port ( A:	In	std_logic;
-- 	 B:	In	std_logic;
-- 	 Ci:	In	std_logic;
-- 	 S:	Out	std_logic;
-- 	 Co:	Out	std_logic);
--   end component; 

-- begin

--   CTMP(0) <= Ci;
--   S <= STMP;
--   Co <= CTMP(N);
  
--   ADDER1: for I in 1 to N generate                --N components needed. 
--     FAI : FA 
-- 	  generic map (DFAS => DRCAS, DFAC => DRCAC) 
-- 	  Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
--   end generate;

-- end STRUCTURAL;


architecture BEHAVIORAL of RCA_generic is

signal Atmp,Btmp,behSumTmp: std_logic_vector (N downto 0);   --signals needed for behavioural sum (they need to be of N+1 bits)

begin
  Atmp<="0" & A; 
  Btmp<="0" & B; 
  behSumTmp <=  std_logic_vector(unsigned(Atmp) + unsigned(Btmp) +1)  when (Ci='1') else 
                std_logic_vector(unsigned(Atmp) + unsigned(Btmp)); -- after DRCAS; 
  Co<=behSumTmp(N); --after DRCAC;
  S <= behSumTmp(N-1 downto 0);

end BEHAVIORAL;

-- configuration CFG_RCA_STRUCTURAL of RCA_generic is
--   for STRUCTURAL 
--     for ADDER1
--       for all : FA
--         use configuration WORK.CFG_FA_BEHAVIORAL;
--       end for;
--     end for;
--   end for;
-- end CFG_RCA_STRUCTURAL;

-- configuration CFG_RCA_BEHAVIORAL of RCA_generic is
--   for BEHAVIORAL 
--   end for;
-- end CFG_RCA_BEHAVIORAL;

