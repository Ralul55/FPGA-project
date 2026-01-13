library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

-- EN ESTA SIMULACION SE COMPRUEBA EL CORRECTO FUNCIONAMIENTO DE:
            --EL ASCENSOR COMO COJUNTO


entity ascensor_tb is
end ascensor_tb;

architecture tb of ascensor_tb is

    component Ascensor
        port (
            RESET : in std_logic;
            CLK   : in std_logic;

            S_fin_carrera : in std_logic;
            S_ini_carrera : in std_logic;
            S_presencia   : in std_logic;

            boton_i : in std_logic_vector (4 downto 1);
            boton_e : in std_logic_vector (4 downto 1);

            LEDS_INDICADORES_ESTADOS : out std_logic_vector (5 downto 0);

            LEDS_PISOS        : out std_logic_vector (3 downto 0);
            LEDS_PISO_deseado : out std_logic_vector (3 downto 0);
            CNTRL_DISPLAY     : out std_logic_vector (6 downto 0);
            LEDS_DISPLAYS     : out std_logic_vector (6 downto 0)
        );
    end component;

    signal RESET   : std_logic := '1';
    signal clk_sim : std_logic := '0';

    signal S_fin_carrera : std_logic := '0';
    signal S_ini_carrera : std_logic := '1';
    signal S_presencia   : std_logic := '0';

    signal botones_i_sim : std_logic_vector (4 downto 1) := (others => '1');
    signal botones_e_sim : std_logic_vector (4 downto 1) := (others => '1');

    signal LEDS_INDICADORES_ESTADOS : std_logic_vector (5 downto 0);
    signal LEDS_PISOS               : std_logic_vector (3 downto 0);
    signal LEDS_PISO_deseado        : std_logic_vector (3 downto 0);
    signal CNTRL_DISPLAY            : std_logic_vector (6 downto 0);
    signal LEDS_DISPLAYS            : std_logic_vector (6 downto 0);

    constant TbPeriod   : time := 10 ns;
    signal   TbClock    : std_logic := '0';
    signal   TbSimEnded : std_logic := '0';

    procedure flanco(n : natural) is
    begin
        for k in 1 to n loop
           wait until rising_edge(clk_sim);
        end loop;
    end procedure;

begin

    dut : Ascensor
        port map (
            RESET => RESET,
            CLK   => clk_sim,

            S_fin_carrera => S_fin_carrera,
            S_ini_carrera => S_ini_carrera,
            S_presencia   => S_presencia,

            boton_i => botones_i_sim,
            boton_e => botones_e_sim,

            LEDS_INDICADORES_ESTADOS => LEDS_INDICADORES_ESTADOS,
            LEDS_PISOS               => LEDS_PISOS,
            LEDS_PISO_deseado        => LEDS_PISO_deseado,
            CNTRL_DISPLAY            => CNTRL_DISPLAY,
            LEDS_DISPLAYS            => LEDS_DISPLAYS
        );

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk_sim <= TbClock;

    stimuli : process
    begin
    
        --------------------------------------------------------------------
        -- Se inicializan variables
        --------------------------------------------------------------------
        
        botones_i_sim <= (others => '1');
        botones_e_sim <= (others => '1');

        RESET         <= '1';
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        S_presencia   <= '0';

        flanco(1);

        botones_e_sim <= "1110";
        flanco(1);
        botones_e_sim <= (others => '1');
        
--------------------------------------------------------------------
        -- RESET (Activo a nivel bajo)
--------------------------------------------------------------------    

        flanco(5);
        RESET <= '0';
        flanco(5);
        RESET <= '1';

        flanco(10);
        botones_e_sim <= "0111";
        flanco(5);
        botones_e_sim <= (others => '1');

        flanco(5);
        RESET <= '0';

        flanco(5);
        botones_e_sim <= "0111";
        flanco(5);
        botones_e_sim <= (others => '1');

        flanco(5);
        RESET <= '1';
        flanco(5);
        botones_e_sim <= "0111";
        flanco(5);
        botones_e_sim <= "1111";
        flanco(5);
        flanco(5);

        

--------------------------------------------------------------------
        -- Final de la simulacion
--------------------------------------------------------------------  


        TbSimEnded <= '1';
        stop;
        wait;
    end process;

end tb;

configuration cfg_ascensor_tb of ascensor_tb is
    for tb
    end for;
end cfg_ascensor_tb;
