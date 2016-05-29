library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY bin_7seg IS
PORT (NUM_BINARIO : IN UNSIGNED(3 DOWNTO 0);
      A, B, C, D, E, F, G : OUT STD_LOGIC);
END bin_7seg;

ARCHITECTURE decodificador of bin_7seg IS
	SIGNAL S : UNSIGNED(0 to 6);
	BEGIN
	WITH NUM_BINARIO SELECT
	    S <= "0000001" WHEN "0000", -- '0'
		 "1001111" WHEN "0001", -- '1'
	 	 "0010010" WHEN "0010", -- '2'
	 	 "0000110" WHEN "0011", -- '3'
	 	 "1001100" WHEN "0100", -- '4'
	 	 "0100100" WHEN "0101", -- '5'
	 	 "0100000" WHEN "0110", -- '6'
	 	 "0001111" WHEN "0111", -- '7'
	 	 "0000000" WHEN "1000", -- '8'
	 	 "0000100" WHEN "1001", -- '9'
	 	 "1111111" WHEN OTHERS; 
	A <= S(0);
	B <= S(1);
	C <= S(2);
	D <= S(3);
	E <= S(4);
	F <= S(5);
	G <= S(6);
END;
