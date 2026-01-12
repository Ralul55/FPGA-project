library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =========================================================
--  STUB del Piso_Decoder para poder simular piso_actual
--  (si ya tienes Piso_Decoder real y quieres usarlo,
--   borra este bloque)
-- ================================
-- =========================================================
--                   TESTBENCH
-- =========================================================
entity piso_actual_tb is
end piso_actual_tb;

architecture Behavioral of piso_actual_tb is

    component piso_actual
        Port (
            RESET         : IN std_logic;
            CLK           : IN std_logic;
            boton_i       : IN std_logic_vector (4 downto 1);
            boton_e       : IN std_logic_vector (4 downto 1);
            estado_actual : IN std_logic_vector (5 downto 0);
            piso_act      : OUT integer range 0 to 4;
            piso_des      : OUT integer range 0 to 4
        );
    end component;

    -- Señales TB
    signal RESET_tb         : std_logic := '1';
    signal CLK_tb           : std_logic := '0';
    signal boton_i_tb       : std_logic_vector(4 downto 1) := (others => '1');
    signal boton_e_tb       : std_logic_vector(4 downto 1) := (others => '1');
    signal estado_actual_tb : std_logic_vector(5 downto 0) := (others => '0');
    signal piso_act_tb      : integer range 0 to 4;
    signal piso_des_tb      : integer range 0 to 4;

    -- Reloj
    constant TbPeriod : time := 10 ns; -- 100 MHz

    -- =====================================================
    -- Ajusta esto según quieras:
    -- REAL: 200_000_000 (2 s * 100 MHz)
    -- RÁPIDO: 20, 50, 200... para validar lógica
    -- =====================================================
    constant CICLOS_POR_PISO_TB : natural := 100;

    procedure wait_rising(n : natural) is
    begin
        for k in 1 to n loop
            wait until rising_edge(CLK_tb);
        end loop;
    end procedure;

    -- Espera "un piso" según el tiempo previsto (en ciclos TB)
    procedure espera_un_piso is
    begin
        wait_rising(CICLOS_POR_PISO_TB);
    end procedure;

begin

    -- DUT
    dut: piso_actual
        port map(
            RESET         => RESET_tb,
            CLK           => CLK_tb,
            boton_i       => boton_i_tb,
            boton_e       => boton_e_tb,
            estado_actual => estado_actual_tb,
            piso_act      => piso_act_tb,
            piso_des      => piso_des_tb
        );

    -- Clock gen
    CLK_tb <= not CLK_tb after TbPeriod/2;
    
    stim: process
    begin
       estado_actual_tb <= "000001";
       wait_rising(1);
        --------------------------------------------------------
        -- 1) Bajada: de 1 a 4, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero bajamos rapido a 1
        boton_e_tb <= "0111"; -- destino 1
        wait_rising(1);
        boton_e_tb <= (others => '1');
        estado_actual_tb <= "000010";
        espera_un_piso; espera_un_piso; espera_un_piso;
        

        --------------------------------------------------------
        -- 2) Subida: de 1 a 4, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero subimos rápido a 4 otra vez (sin checks)
        boton_e_tb <= "1110"; -- destino 4
        wait_rising(1);
        boton_e_tb <= (others => '1');
        estado_actual_tb <= "000100";
        espera_un_piso; espera_un_piso; espera_un_piso;
        
        --------------------------------------------------------
        -- 3) Bajada: de 1 a 4, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero bajamos rapido a 1
        boton_e_tb <= "1011"; -- destino 1
        wait_rising(1);
        boton_e_tb <= (others => '1');
        estado_actual_tb <= "000010";
        espera_un_piso; espera_un_piso;


        wait;
    end process;

end Behavioral;
