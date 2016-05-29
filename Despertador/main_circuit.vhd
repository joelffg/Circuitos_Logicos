LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
 
ENTITY main_circuit IS
PORT (clk                 : IN STD_LOGIC;
      key_0, key_1, key_2,
      key_3, key_4, key_5,
      key_6, key_7, key_8,
      key_9, key_S, key_A : IN STD_LOGIC;
      horas_decimal       : OUT STD_LOGIC_VECTOR(0 TO 6);
      horas_unidade       : OUT STD_LOGIC_VECTOR(0 TO 6);
      minutos_decimal     : OUT STD_LOGIC_VECTOR(0 TO 6);
      minutos_unidade     : OUT STD_LOGIC_VECTOR(0 TO 6);
      alarming            : OUT STD_LOGIC);
END main_circuit;

ARCHITECTURE behavioral OF main_circuit IS

-- Declaracao de componentes
COMPONENT key_coder
  PORT (key_0, key_1, key_2,
        key_3, key_4, key_5,
        key_6, key_7, key_8,
        key_9, key_S, key_A : IN STD_LOGIC;
        code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT main_clock
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
END COMPONENT;

COMPONENT alarm
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
END COMPONENT;

COMPONENT BCD_to_7seg
PORT (BCD   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      d7seg : OUT STD_LOGIC_VECTOR(0 TO 6));
END COMPONENT;

COMPONENT input_process
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
END COMPONENT;

-- Declaracao de sinais
SIGNAL code          : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL alarme : STD_LOGIC := '0';
SIGNAL min_d_rec,
       min_u_rec,
       hour_d_rec,
       hour_u_rec    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- BCD para setar o alarme/relogio
SIGNAL minute_d, 
       minute_u,
       hours_d,
       hours_u       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- BCD de saida do relogio
SIGNAL min_d_disp, 
       min_u_disp,
       hour_d_disp,
       hour_u_disp   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- BCD de saida para o display
SIGNAL disp_sel      : STD_LOGIC := '0';
SIGNAL set_clock     : STD_LOGIC := '0';
SIGNAL set_selection : STD_LOGIC := '0';
SIGNAL recording     : STD_LOGIC := '0';
SIGNAL set_alarme    : STD_LOGIC := '0';

BEGIN
  -- multiplexadores
  -- selecao do set alarme/relogio
  set_alarme <= recording AND  NOT set_selection;
  set_clock  <= recording AND set_selection;

  -- selecao do display relogio/inputs
  min_d_disp  <= minute_d WHEN disp_sel = '0' ELSE
                 min_d_rec;
  min_u_disp  <= minute_u WHEN disp_sel = '0' ELSE
                 min_u_rec;
  hour_d_disp <= hours_d WHEN disp_sel = '0' ELSE
                 hour_d_rec;
  hour_u_disp <= hours_u WHEN disp_sel = '0' ELSE
                 hour_u_rec;

  -- processamento pelos circuitos internos
  codificacao  : key_coder  PORT MAP(key_0, key_1, key_2, key_3, key_4, key_5, key_6, key_7, key_8, key_9, key_S, key_A, code); 
  buffer_input : input_process PORT MAP(clk, code, alarme, min_d_rec, min_u_rec, hour_d_rec, hour_u_rec, disp_sel, set_selection, recording);
  relogio      : main_clock PORT MAP(clk, set_clock, min_d_rec, min_u_rec, hour_d_rec, hour_u_rec, minute_d, minute_u, hours_d, hours_u);  
  despertador  : alarm PORT MAP(clk, minute_d, minute_u, hours_d, hours_u, set_alarme, code, min_d_rec, min_u_rec, hour_d_rec, hour_u_rec, alarme);
  display_m_d  : BCD_to_7seg PORT MAP(min_d_disp, minutos_decimal);
  display_m_u  : BCD_to_7seg PORT MAP(min_u_disp, minutos_unidade);
  display_h_d  : BCD_to_7seg PORT MAP(hour_d_disp, horas_decimal);
  display_h_u  : BCD_to_7seg PORT MAP(hour_u_disp, horas_unidade);

  -- saida alarme
  alarming <= alarme;

END behavioral;
