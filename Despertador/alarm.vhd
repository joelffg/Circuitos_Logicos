LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
 
ENTITY alarm IS
PORT (clk           : IN STD_LOGIC;
      min_d_in      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      min_u_in      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      hour_d_in     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      hour_u_in     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      set_alarme    : IN STD_LOGIC;
      input_code    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      set_min_d_al  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      set_min_u_al  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      set_hour_d_al : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      set_hour_u_al : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      alarming      : OUT STD_LOGIC);
END alarm;
 
ARCHITECTURE behavioral OF alarm IS
  TYPE state IS (idle, off, sleep, actived);
  SIGNAL current_state : state := idle;
  SIGNAL alarm, locked : STD_LOGIC := '0';
  SIGNAL sec           : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- 4 bits (para 10s)
  SIGNAL soneca        : STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0'); -- 9 bits (para 300s)
  

  -- Registro do alarme:
  SIGNAL hours_d_al : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- Alarme 12:00 padrao
  SIGNAL hours_u_al : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  SIGNAL minute_d_al, minute_u_al : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

BEGIN
  alarming <= alarm;

  clock_alarm: PROCESS(clk)
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      CASE (current_state) IS
        WHEN sleep => -- soneca ativada
          IF(soneca > 0) THEN
            soneca <= soneca - 1;
            IF(soneca = 1) THEN
              alarm <= '1';
              sec <= "1010";
            END IF;
          ELSE
            soneca <= "100101100" - (11 - sec);
            alarm <= '0';
          END IF;
        WHEN actived => -- tocando
          locked <= '1';
          IF(sec > 0) THEN
            sec <= sec - 1;
            IF(sec = 1) THEN 
              alarm <= '0';
            END IF;
          END IF;
        WHEN idle => -- ocioso
          soneca <= (OTHERS => '0');
          IF(minute_d_al = min_d_in AND minute_u_al = min_u_in AND
             hours_d_al = hour_d_in AND hours_u_al = hour_u_in) THEN
            alarm <= '1';
            sec <= "1010";
          END IF;
        WHEN off => -- deligado pelos botoes
          alarm <= '0';
          IF(minute_d_al /= min_d_in OR minute_u_al /= min_u_in OR
             hours_d_al /= hour_d_in OR hours_u_al /= hour_u_in) THEN
             locked <= '0';
          END IF;
      END CASE;
    END IF;
  END PROCESS;

  inputs: PROCESS(input_code, alarm, locked, set_alarme)
  BEGIN  
    IF(set_alarme = '1') THEN
      minute_d_al <= set_min_d_al;
      minute_u_al <= set_min_u_al;
      hours_d_al <= set_hour_d_al;
      hours_u_al <= set_hour_u_al;
    END IF;

    IF (alarm = '1') THEN
      IF(input_code < 15) THEN -- "1111" Nenhum botao apertado
        IF(input_code = "1011") THEN -- "1011" botao alarme
          current_state <= sleep;
        ELSE
          current_state <= off;
        END IF;
      ELSE
        current_state <= actived;
      END IF;
    ELSE
      IF(soneca > 0) THEN
        current_state <= sleep;
      ELSIF (locked = '0') THEN
        current_state <= idle;
      ELSIF (locked = '1') THEN
        current_state <= off; 
      END IF;
    END IF;
  END PROCESS;
END behavioral;
