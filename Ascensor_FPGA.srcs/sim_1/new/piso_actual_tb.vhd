library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;
-- =========================================================
--  EN ESTE ARCHIVO SE COMPROBORA EL CORRECTO FUNCIONAMIENTO DE PISO ACTUAL
--el timer de 2s SE RECOMIENDA QUITAR ESE TIEMPO Y PONER 20ns, tardando aprox 30ns mas ciclo extra para establecerse (4 flancos) PARA AGILIZAR LA SIMULACION
--linea comentada en FSM.vhd
-- ================================
-- =========================================================
--                   TESTBENCH
-- =========================================================
entity piso_actual_tb is
end piso_actual_tb;

architecture tb of piso_actual_tb is
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
    signal   TbClock   : std_logic := '0';
    signal   TbSimEnded: std_logic := '0';

    -- =====================================================
    -- Ajusta esto según quieras:
    -- REAL: 200_000_000 (2 s * 100 MHz)
    -- RÁPIDO: 20, 50, 200... para validar lógica
    -- =====================================================
    constant CICLOS_POR_PISO_TB : natural := 4;

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
    --CLK_tb <= not CLK_tb after TbPeriod/2;
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK_tb <= TbClock;

    stim: process
    begin
       RESET_tb <= '1';
       boton_i_tb <= "1111"; 
       wait_rising(2);
       RESET_tb <= '0';
       wait_rising(2);
        RESET_tb <= '1';
        
       estado_actual_tb <= "000001";
       wait_rising(1);
        --------------------------------------------------------
        -- 1) Subida: de 1 a 4, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero subimos rapido a 4
        boton_e_tb <= "0111"; -- destino 4
        wait_rising(5);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        estado_actual_tb <= "000010";
        espera_un_piso; espera_un_piso; espera_un_piso;
        

        --------------------------------------------------------
        -- 2) Bajada: de 4 a 1, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero bajamos rápido a 1 otra vez (sin checks)
        boton_e_tb <= "1110"; -- destino 1
        wait_rising(5);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        estado_actual_tb <= "000100";
        espera_un_piso; espera_un_piso; espera_un_piso;
        
        --------------------------------------------------------
        -- 3) Subida: de 1 a 3, comprobando tiempo por piso
        --------------------------------------------------------
        -- Primero subimos rapido a 3
        boton_e_tb <= "1011"; -- destino 3
        wait_rising(5);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        estado_actual_tb <= "000010";
        espera_un_piso; espera_un_piso;
        
--------------------------------------------------------------------
        -- RESET (Activo a nivel bajo)
--------------------------------------------------------------------    

        --------------------------------------------------------
        --mismas prubas que antes pero pulsamos reset
        --------------------------------------------------------
        
        -- Primero bajamos rápido a 1 otra vez (sin checks)
        boton_e_tb <= "1110"; -- destino 1
        wait_rising(2);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        estado_actual_tb <= "000100";
        wait_rising(1);
        RESET_tb <= '0';
        wait_rising(2);
        RESET_tb <= '1';
        
        espera_un_piso; espera_un_piso; espera_un_piso;
        --se fuerza estado de espera tras comprobar que funciona
        estado_actual_tb <= "000001";
        
        --------------------------------------------------------
         --  subimos rapido a 4
        boton_e_tb <= "0111"; -- destino 4
        wait_rising(5);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        estado_actual_tb <= "000010";
        wait_rising(4);
        RESET_tb <= '0';
        wait_rising(2);
        RESET_tb <= '1';

        espera_un_piso; 


--------------------------------------------------------------------
        -- PRIORIDAD
--------------------------------------------------------------------    

        --------------------------------------------------------
        --mismas prubas que antes pero pulsamos varios botones
        --tambien se comprueba que ante pulsacion simultanea se hace caso a i
        --prueba corta ya que la funcionalidad ya queda demostrada en piso_decoder_tb
        --------------------------------------------------------

        -- Primero subimos rapido a 4
        estado_actual_tb <= "000001";
        wait_rising(4);

        boton_e_tb <= "0111"; -- destino 4
        wait_rising(5);
        boton_e_tb <= "1101"; -- destino 2        
        estado_actual_tb <= "000010";
        wait_rising(2);
        boton_e_tb <= (others => '1');
        wait_rising(2);
        espera_un_piso; espera_un_piso; espera_un_piso;
        

        --------------------------------------------------------
        -- Primero bajamos rápido a 1 otra vez (sin checks)
        estado_actual_tb <= "000001";
        wait_rising(4);
        
        boton_e_tb <= "1101"; -- destino 2, EXTERIOR
        boton_i_tb <= "1110"; -- destino 1, INTERIOR
        wait_rising(5);
        estado_actual_tb <= "000100";
        wait_rising(2);
        boton_e_tb <= (others => '1');       
        boton_i_tb <= (others => '1');        

        espera_un_piso; espera_un_piso; espera_un_piso;
        wait_rising(1);
        
--------------------------------------------------------------------
        -- Final de la simulacion
--------------------------------------------------------------------    
        TbSimEnded <= '1';
        stop;      
        wait;
        end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_piso_actual_tb of piso_actual_tb is
    for tb
    end for;
end cfg_piso_actual_tb;
