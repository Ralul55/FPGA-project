library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

-- EN ESTA SIMULACION SE COMPRUEBA EL CORRECTO FUNCIONAMIENTO DE:
            --ESTABLECIMIENTO DE PISO DESEADO
            --QUE NO SE PUEDA ESCOGER OTRO PISO MIENTRAS SE LLEGA AL DESEADO
            --PRIORIDAD DE BOTONES INTERIORES

entity piso_decoder_tb is
end piso_decoder_tb;

architecture tb of piso_decoder_tb is

    component Piso_Decoder
        port (
            RESET        : in  std_logic;
            clk          : in  std_logic;
            botones_i    : in  std_logic_vector (4 downto 1);
            botones_e    : in  std_logic_vector (4 downto 1);
            piso_actual  : in  integer range 0 to 4;
            piso_deseado : out integer range 0 to 4
        );
    end component;
    signal RESET          : std_logic := '1';
    signal clk_sim          : std_logic := '0';
    signal botones_i_sim    : std_logic_vector (4 downto 1) := (others => '0');
    signal botones_e_sim    : std_logic_vector (4 downto 1) := (others => '0');
    signal piso_actual_sim  : integer range 0 to 4 := 1;
    signal piso_deseado_sim : integer range 0 to 4;

    -- 100 MHz -> 10 ns
    constant TbPeriod  : time := 10 ns;
    signal   TbClock   : std_logic := '0';
    signal   TbSimEnded: std_logic := '0';

    --Establece el numero de flancos que hay que esperar
    procedure flanco(n : natural) is
    begin
        for k in 1 to n loop
            wait until rising_edge(clk_sim);
        end loop;
    end procedure;

begin

    dut : Piso_Decoder
        port map (
            RESET       =>RESET,
            clk          => clk_sim,
            botones_i    => botones_i_sim,
            botones_e    => botones_e_sim,
            piso_actual  => piso_actual_sim,
            piso_deseado => piso_deseado_sim
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk_sim     <= TbClock;

    stimuli : process
    begin
        --------------------------------------------------------------------
        -- Se inicializan variables
        --------------------------------------------------------------------
        botones_i_sim   <= (others => '0');
        botones_e_sim   <= (others => '0');
        piso_actual_sim <= 1; --siempre establecido a 1 por defecto

        -- 1 ciclo de espera
        flanco(1);
--------------------------------------------------------------------
        -- RESET (Activo a nivel bajo)
--------------------------------------------------------------------    
        
        --se pulsa el boton 1, para pasar a estado abriendo 
        botones_e_sim <= "0001";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        --se pulsa reset 

        flanco(2);
        RESET <= '0';
        flanco(1);
        RESET <= '1';
        
        
        --se pulsa el boton 4, para pasar a estado subiendo 
        flanco(2);
        botones_e_sim <= "1000";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        
        --se pulsa reset 

        flanco(2);
        RESET <= '0';
        
 
        --se pulsa el boton 4, manteniendo la señal de reset
        flanco(2);
        botones_e_sim <= "1000";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        flanco(2);
        RESET <= '1';
--------------------------------------------------------------------
        -- ESTABLECIMIENTO DE PISO DESEADO
--------------------------------------------------------------------

        --se pide el boton 2
        botones_i_sim <= "0010";
        flanco(1);
        botones_i_sim <= (others => '0');
        
        --el piso_actual se modificara de forma artificial cada 2 flancos para comrpobar simulacion
        
        --sube un piso
        flanco(2);
        piso_actual_sim <= 2; 
        
        --se pide el boton 4
        flanco(2);
        botones_e_sim <= "1000";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        --sube dos pisos
        flanco(2);
        piso_actual_sim <= 3; 
        flanco(2);
        piso_actual_sim <= 4; 
        
        
        --se pide el boton 1
        flanco(2);
        botones_e_sim <= "0001";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        --sube tres pisos
        flanco(2);
        piso_actual_sim <= 3; 
        flanco(2);
        piso_actual_sim <= 2; 
        flanco(2);
        piso_actual_sim <= 1; 
        
        
 -------------------------------------------------------
        --QUE NO SE PUEDA ESCOGER OTRO PISO MIENTRAS SE LLEGA AL DESEADO
        
        --se realizara secuencia similar ahora pulsando botones para comprobar que no afecta en el piso deseado
        --siempre se respetan los tiempos establecidos (1 flanco para boton, 2 flancos para modificar el piso)
 --------------------------------------------------------
        
        --se pide el boton 1
        flanco(2);
        botones_e_sim <= "0001";
        flanco(1);
        botones_e_sim <= (others => '0');
        --se pide otro boton 
        botones_i_sim <= "0010";
        flanco(1);
        botones_i_sim <= (others => '0');
        --NO SE DEBERIA MOVER YA QUE POR SER LLAMADO EL BOTON PASA 2 FLANCOS EN EL PISO 1, AUNQUE YA ESTE AHI
        
        
         --se pide el boton 3
        flanco(2);
        botones_e_sim <= "0100";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        
        --sube dos pisos
        flanco(1);
        --se pide otro boton 
        botones_i_sim <= "0010";
        flanco(1);
        botones_i_sim <= (others => '0');
        
        piso_actual_sim <= 2; 
        flanco(1);
        --se pide otro boton 
        botones_i_sim <= "0001";
        flanco(1);
        botones_i_sim <= (others => '0');
        
        piso_actual_sim <= 3; 
        
        --se pide el boton 2
        flanco(2);
        botones_e_sim <= "0010";
        flanco(1);
        botones_e_sim <= (others => '0');
        
        --baja un piso
        flanco(1);
         --se pide otro boton 
        botones_e_sim <= "0001";
        flanco(1);
        botones_e_sim <= (others => '0');
        piso_actual_sim <= 2; 
        flanco(2);
        piso_actual_sim <= 1; 
        
-------------------------------------------------------
        --PRIORIDAD DE BOTONES INTERIORES
 --------------------------------------------------------
        
        --se pide el boton 2 interior y el 3 exterior
        flanco(2);
        botones_i_sim <= "0010";
        botones_e_sim <= "0100";

        flanco(1);
        botones_e_sim <= (others => '0');
        botones_i_sim <= (others => '0');
        
        flanco(2);
        piso_actual_sim <= 2; 
        
        
        --se pide el boton 1 interior y el 3 exterior
        flanco(2);
        botones_i_sim <= "0001";
        botones_e_sim <= "1000";

        flanco(1);
        botones_i_sim <= (others => '0');
        botones_e_sim <= (others => '0');
        
        flanco(2);
        piso_actual_sim <= 1; --no se llega a mostrar en la simulacion, necesitaria un flanco de espera
        
--------------------------------------------------------------------
        -- Final de la simulacion
--------------------------------------------------------------------  
        TbSimEnded <= '1';
        stop;      
        wait;

        end process;
       
end tb;
configuration cfg_piso_decoder_tb of piso_decoder_tb is
    for tb
    end for;
end cfg_piso_decoder_tb;
