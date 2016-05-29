library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY estacionamento IS 
PORT (SIGNAL entrou, saiu: UNSIGNED(0 to 0);
      SIGNAL numero  : UNSIGNED (5 DOWNTO 0);
      SIGNAL display1: OUT STD_LOGIC_VECTOR(0 to 6);
      SIGNAL display2: OUT STD_LOGIC_VECTOR(0 to 6));
END estacionamento;

ARCHITECTURE structural OF estacionamento IS

COMPONENT mux_4x1
 PORT (SIGNAL a, b, c, d: IN UNSIGNED(0 to 0);
       SIGNAL sel1, sel2: IN UNSIGNED(0 to 0);
       SIGNAL s : OUT UNSIGNED(0 to 0));
 END COMPONENT;

COMPONENT bin_7seg
 PORT (NUM_BINARIO : IN UNSIGNED(3 DOWNTO 0);
      A, B, C, D, E, F, G : OUT STD_LOGIC);
END COMPONENT;

SIGNAL dezena : UNSIGNED (3 DOWNTO 0);
SIGNAL unidade : UNSIGNED (3 DOWNTO 0);
SIGNAL entrou_saiu, sum, sub: UNSIGNED(0 to 0);
SIGNAL igual_z, igual_c: UNSIGNED(0 to 0);
SIGNAL num1, num2: UNSIGNED (5 DOWNTO 0) ; 

BEGIN
 comando_1: mux_4x1 PORT MAP("0", "1", "1", "0", entrou, saiu, entrou_saiu);
 comando_2: igual_c <= "1" WHEN numero = "110010" ELSE
	               "0";
 comando_3: igual_z <= "1" WHEN numero = "000000" ELSE
	               "0";
 comando_4: sub <= entrou AND entrou_saiu AND NOT igual_z;
 comando_5: sum <= saiu AND entrou_saiu AND NOT igual_c;
 comando_6: num1 <= numero + sum;
 comando_7: num2 <= numero - sub;
 comando_8: dezena  <= RESIZE((num1 / 10), 4) WHEN sum = "1" ELSE
                       RESIZE((num2 / 10),4) WHEN sub = "1" ELSE
                       RESIZE((numero / 10), 4);

 comando_9: unidade <= RESIZE((num1 MOD 10),4) WHEN sum = "1" ELSE
                       RESIZE((num2 MOD 10),4) WHEN sub = "1" ELSE
                       RESIZE((numero MOD 10),4);
 comando_10: bin_7seg PORT MAP(dezena, display1(0), display1(1), display1(2), display1(3), display1(4), display1(5), display1(6));
 comando_11: bin_7seg PORT MAP(unidade, display2(0), display2(1), display2(2), display2(3), display2(4), display2(5), display2(6));
END structural;
