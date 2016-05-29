LIBRARY IEEE;
use ieee.numeric_std.all;
ENTITY mux_4x1 IS 
PORT (SIGNAL a, b, c, d: IN UNSIGNED;
      SIGNAL sel1, sel2 : IN UNSIGNED;
      SIGNAL s   : OUT UNSIGNED);
END mux_4x1;

ARCHITECTURE structural OF mux_4x1 IS
COMPONENT mux_2x1
  PORT (SIGNAL a, b: IN UNSIGNED;
        SIGNAL sel : IN UNSIGNED;
        SIGNAL s   : OUT UNSIGNED);
  END COMPONENT;
SIGNAL x, y : UNSIGNED(0 to 0);
BEGIN
 u0 : mux_2x1 PORT MAP(a, b, sel1, x);
 u1 : mux_2x1 PORT MAP(c, d, sel1, y);
 u2 : mux_2x1 PORT MAP(x, y, sel2, s);
END structural;