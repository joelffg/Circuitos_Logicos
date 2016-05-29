LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--   _a_     Display 7 segmentos:
--  f   b    a(0), b(1), ..., g(6)
--  |_g_|
--  e   c
--  |_d_|  

ENTITY BCD_to_7seg IS
PORT (BCD   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      d7seg : OUT STD_LOGIC_VECTOR(0 TO 6));
END BCD_to_7seg;
--------------------------------------------------
ARCHITECTURE structural OF BCD_to_7seg IS
BEGIN
  d7seg(0) <= (NOT BCD(3) AND BCD(1)) OR
              (NOT BCD(3) AND BCD(2) AND BCD(0)) OR
              (NOT BCD(2) AND NOT BCD(1) AND NOT BCD(0)) OR
              (BCD(3) AND NOT BCD(2) AND NOT BCD(1));

  d7seg(1) <= (NOT BCD(3) AND NOT BCD(2)) OR
              (NOT BCD(2) AND NOT BCD(1)) OR
              (NOT BCD(3) AND NOT BCD(1) AND NOT BCD(0)) OR
              (NOT BCD(3) AND BCD(1) AND BCD(0));

  d7seg(2) <= (NOT BCD(3) AND BCD(2)) OR
              (NOT BCD(2) AND NOT BCD(1)) OR
              (NOT BCD(3) AND BCD(0));

  d7seg(3) <= (NOT BCD(3) AND BCD(1) AND NOT BCD(0)) OR
              (NOT BCD(3) AND NOT BCD(2) AND BCD(1)) OR
              (BCD(3) AND NOT BCD(2) AND NOT BCD(1)) OR
              (NOT BCD(3) AND BCD(2) AND NOT BCD(1) AND BCD(0)) OR
              (NOT BCD(2) AND NOT BCD(1) AND NOT BCD(0));

  d7seg(4) <= (NOT BCD(3) AND BCD(1) AND NOT BCD(0)) OR
              (NOT BCD(2) AND NOT BCD(1) AND NOT BCD(0));

  d7seg(5) <= (NOT BCD(3) AND BCD(2) AND NOT BCD(0)) OR
              (NOT BCD(3) AND BCD(2) AND NOT BCD(1)) OR
              (BCD(3) AND NOT BCD(2) AND NOT BCD(1)) OR
              (NOT BCD(2) AND NOT BCD(1) AND NOT BCD(0));

  d7seg(6) <= (NOT BCD(3) AND BCD(1) AND NOT BCD(0)) OR
              (NOT BCD(3) AND NOT BCD(2) AND BCD(1)) OR
              (NOT BCD(3) AND BCD(2) AND NOT BCD(1)) OR
              (BCD(3) AND NOT BCD(2) AND NOT BCD(1));
END structural;