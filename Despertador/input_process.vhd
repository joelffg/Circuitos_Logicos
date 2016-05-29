LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY input_process IS
PORT (clk       : IN STD_LOGIC; -- clock
      input     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      alarming  : IN STD_LOGIC; -- trava para quando estiver alarmando
      minute_d  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      minute_u  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      hours_d   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      hours_u   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      disp_sel  : OUT STD_LOGIC; 
      out_sel   : OUT STD_LOGIC; -- alarm (0) / ajuste hora (1)
      recording : OUT STD_LOGIC); -- gatilho para gravar
END input_process;

ARCHITECTURE behavioral OF input_process IS
  TYPE state IS (idle, h_d, h_u, m_d, m_u);
  SIGNAL state_reg : state := idle;
  SIGNAL next_state: state := idle;
  SIGNAL min_d, min_u, hour_d, hour_u : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL on_disp, rec, sel, lock, cancel: STD_LOGIC := '0';

BEGIN
  minute_d <= min_d;
  minute_u <= min_u;
  hours_d <= hour_d;
  hours_u <= hour_u;
  disp_sel <= on_disp;
  recording <= rec;
  out_sel <= sel; 

  State_process: PROCESS(clk)
  BEGIN
    IF (clk'EVENT AND clk='1') THEN
    state_reg <= next_state;
    END IF;
  END PROCESS;

  Input_process: PROCESS(state_reg, input)
  BEGIN
    IF (rec = '1' OR cancel = '1') THEN
      rec <= '0';
      cancel <= '0';
      on_disp <= '0';
    END IF;
      
    IF (alarming = '1' OR lock = '1') THEN 
      next_state <= state_reg;
    ELSE
      CASE (state_reg) IS
        WHEN idle => hour_d <= "1010";
                     hour_u <= "1010";
                     min_d <= "1010";
                     min_u <= "1010";
                     rec <= '0';
                     IF (input = "1010") THEN
                       on_disp <= '1';
                       sel <= '1';
                       next_state <= h_d;
                     ELSIF (input = "1011") THEN
                       on_disp <= '1';
                       sel <= '0';
                       next_state <= h_d;
                     ELSE
                       on_disp <= '0';
                       next_state <= idle;
                     END IF;
        WHEN h_d =>  IF (input < 3) THEN
                       hour_d <= input;
                       next_state <= h_u;
                     ELSIF (input = "1011") THEN
                       next_state <= idle;
                       cancel <= '1';
                     ELSE
                       next_state <= h_d;
                     END IF;
        WHEN h_u =>  IF (input < 10) THEN
                       hour_u <= input;
                       next_state <= m_d;
                     ELSIF (input = "1011") THEN
                       next_state <= idle;
                       cancel <= '1';
                     ELSE
                       next_state <= h_u;
                     END IF;
        WHEN m_d =>  IF (input < 6) THEN
                       min_d <= input;
                       next_state <= m_u;
                     ELSIF (input = "1011") THEN
                       next_state <= idle;
                       cancel <= '1';
                     ELSE
                       next_state <= m_d;
                     END IF;
        WHEN m_u =>  IF (input < 10) THEN
                       min_u <= input;
                       rec <= '1';
                       next_state <= idle;
                     ELSIF (input = "1011") THEN
                       next_state <= idle;
                       cancel <= '1';
                     ELSE
                       next_state <= m_u;
                     END IF;
        WHEN OTHERS=> next_state <= idle;
      END CASE;
    END IF;

    -- trava do input, para nao amarrar na mesma entrada
    IF (input = "1111") THEN
      lock <= '0';
    ELSE
      lock <= '1';
    END IF;
  END PROCESS;
END behavioral;
