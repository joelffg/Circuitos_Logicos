LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY key_coder IS
PORT (key_0, key_1, key_2,
      key_3, key_4, key_5,
      key_6, key_7, key_8,
      key_9, key_S, key_A : IN STD_LOGIC;
      code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END key_coder;

ARCHITECTURE behavioral OF key_coder IS
  SIGNAL aux: STD_LOGIC_VECTOR(11 DOWNTO 0);  
  
BEGIN
  -- concatenacao:
  aux <= key_0 & key_1 & key_2 & key_3 & key_4 & key_5 &
         key_6 & key_7 & key_8 & key_9 & key_S & key_A;

  WITH aux SELECT
    code <= "0000" WHEN "100000000000", -- 0
            "0001" WHEN "010000000000", -- 1
            "0010" WHEN "001000000000", -- 2
            "0011" WHEN "000100000000", -- 3
            "0100" WHEN "000010000000", -- 4
            "0101" WHEN "000001000000", -- 5
            "0110" WHEN "000000100000", -- 6
            "0111" WHEN "000000010000", -- 7
            "1000" WHEN "000000001000", -- 8
            "1001" WHEN "000000000100", -- 9
            "1010" WHEN "000000000010", -- Set
            "1011" WHEN "000000000001", -- Alarm/Cancel
            "1111" WHEN "000000000000", -- nenhum botao
            "1110" WHEN OTHERS;

END behavioral;