library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

-- EN ESTA SIMULACION SE COMPRUEBA EL CORRECTO FUNCIONAMIENTO DE:
            --RESET (Activo a nivel bajo)
            --MAQUINA DE ESTADO (DE MOMENTO NO HAY FORMA DE CAMBIAR EL PISO ASIQUE NO SE PUEDE COMPROBAR!!!!!!!!!!!)
                --cambios de estado correctos
                --espera de la puerta
            --CAMBIOS DE PISOS (FALTA POR ACTUALIZAR!!!!!!!!!!!!!!!!!!!!!!!!!)
            --LEDS DE SALIDA (observable en toda la simulacion)

entity FSM_tb is
end FSM_tb;

architecture tb of FSM_tb is

    component FSM
        port (RESET                    : in std_logic;
              CLK                      : in std_logic;
              S_fin_carrera            : in std_logic;
              S_ini_carrera            : in std_logic;
              S_presencia              : in std_logic;
              boton_i                  : in std_logic_vector (4 downto 1);
              boton_e                  : in std_logic_vector (4 downto 1);
              LEDS_INDICADORES_ESTADOS : out std_logic_vector (5 downto 0);
              LEDS_PISOS               : out std_logic_vector (3 downto 0));
    end component;

    signal RESET                    : std_logic:= '1';
    signal CLK                      : std_logic:= '0';
    signal S_fin_carrera            : std_logic:= '0';
    signal S_ini_carrera            : std_logic:= '0';
    signal S_presencia              : std_logic:= '0';
    signal boton_i                  : std_logic_vector (4 downto 1) := (others => '0');
    signal boton_e                  : std_logic_vector (4 downto 1) := (others => '0');
    signal LEDS_INDICADORES_ESTADOS : std_logic_vector (5 downto 0);
    signal LEDS_PISOS               : std_logic_vector (3 downto 0);

    -- 100 MHz -> 10 ns
    constant TbPeriod  : time := 10 ns;
    signal   TbClock   : std_logic := '0';
    signal   TbSimEnded: std_logic := '0';

    --Establece el numero de flancos que hay que esperar
    procedure flanco(n : natural) is
    begin
        for k in 1 to n loop
            wait until rising_edge(CLK);
        end loop;
    end procedure;

begin

    dut : FSM
    port map (RESET                    => RESET,
              CLK                      => CLK,
              S_fin_carrera            => S_fin_carrera,
              S_ini_carrera            => S_ini_carrera,
              S_presencia              => S_presencia,
              boton_i                  => boton_i,
              boton_e                  => boton_e,
              LEDS_INDICADORES_ESTADOS => LEDS_INDICADORES_ESTADOS,
              LEDS_PISOS               => LEDS_PISOS);

 -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK <= TbClock;

    stimuli : process
    begin
--------------------------------------------------------------------
        -- Se inicializan variables
--------------------------------------------------------------------
        RESET <='1';
        S_fin_carrera <= '0';
        S_ini_carrera <= '0';
        S_presencia <= '0';
        boton_i <= (others => '0');
        boton_e <= (others => '0');

        -- 1 ciclo de espera
        flanco(1);
        
--------------------------------------------------------------------
        -- RESET (Activo a nivel bajo)
--------------------------------------------------------------------    
        
        --se pulsa el boton 1, para pasar a estado abriendo 
        boton_e <= "0001";
        flanco(1);
        boton_e <= (others => '0');
        
        --se pulsa reset 

        flanco(2);
        RESET <= '0';
        flanco(1);
        RESET <= '1';
        
        
        --se pulsa el boton 4, para pasar a estado subiendo 
        flanco(2);
        boton_e <= "1000";
        flanco(1);
        boton_e <= (others => '0');
        
        --se pulsa reset 

        flanco(2);
        RESET <= '0';
        
        
        --se pulsa el boton 4, manteniendo la señal de reset
        flanco(2);
        boton_e <= "1000";
        flanco(1);
        boton_e <= (others => '0');
        
        flanco(2);
        RESET <= '1';
        
--------------------------------------------------------------------
        -- MAQUINA DE ESTADO
--------------------------------------------------------------------
        
        
--------------------------------------------------------------------
        -- Final de la simulacion
--------------------------------------------------------------------    
        TbSimEnded <= '1';
        stop;      
        wait;
        end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_FSM_tb of FSM_tb is
    for tb
    end for;
end cfg_FSM_tb;