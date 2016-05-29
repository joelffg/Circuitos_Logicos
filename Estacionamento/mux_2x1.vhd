LIBRARY IEEE;
use ieee.numeric_std.all;
ENTITY mux_2x1 IS 
PORT (SIGNAL a, b: IN UNSIGNED;
      SIGNAL sel : IN UNSIGNED;
      SIGNAL s   : OUT UNSIGNED);
END mux_2x1;

ARCHITECTURE structural OF mux_2x1 IS
BEGIN
	s <= (a AND NOT sel) OR (b AND SEL);
END structural;