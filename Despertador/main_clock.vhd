LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
 
ENTITY main_clock IS
PORT (clk       : IN STD_LOGIC;
      set       : IN STD_LOGIC;
      min_d_in  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      min_u_in  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      hour_d_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      hour_u_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      minute_d  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      minute_u  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      hours_d   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      hours_u   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END main_clock;
 
ARCHITECTURE behavioral OF main_clock IS
  SIGNAL sec: STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0'); -- 6 bits convencionais
  SIGNAL min_d,
         min_u,
         hour_d,
         hour_u : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- BCD

BEGIN
  minute_d <= min_d;
  minute_u <= min_u;
  hours_d   <= hour_d;
  hours_u   <= hour_u;

  PROCESS(clk, set)
  BEGIN
    IF(set='1') THEN -- ajuste da hora
      sec  <= (OTHERS => '0');
      min_d  <= min_d_in;
      min_u  <= min_u_in;
      hour_d <= hour_d_in;
      hour_u <= hour_u_in;

    ELSIF(clk'EVENT AND clk='1') THEN -- o periodo de clk eh 1 segundo.
      sec <= sec + 1;
      IF(sec = 59) THEN
        sec <= (OTHERS => '0');
        min_u <= min_u + 1;
        IF(min_u = 9) THEN    
          min_u <= (OTHERS => '0');
          min_d <= min_d + 1;
          IF (min_d = 5) THEN
            min_d <= (OTHERS => '0');
            hour_u <= hour_u + 1;
            IF (hour_u = 9) THEN
              hour_u <= (OTHERS => '0');
              hour_d <= hour_d + 1;
            ELSIF (hour_u = 3 AND hour_d = 2) THEN
              hour_u <= (OTHERS => '0');
              hour_d <= (OTHERS => '0');
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END behavioral;
