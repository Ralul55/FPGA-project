library ieee;
use ieee.std_logic_1164.all;

entity piso_decoder_tb is
end piso_decoder_tb;

architecture tb of piso_decoder_tb is

    component Piso_Decoder
        port (
            clk          : in  std_logic;
            botones_i    : in  std_logic_vector (4 downto 1);
            botones_e    : in  std_logic_vector (4 downto 1);
            piso_actual  : in  integer range 1 to 4;
            piso_deseado : out integer range 1 to 4
        );
    end component;

    signal clk_sim          : std_logic := '0';
    signal botones_i_sim    : std_logic_vector (4 downto 1) := (others => '0');
    signal botones_e_sim    : std_logic_vector (4 downto 1) := (others => '0');
    signal piso_actual_sim  : integer range 1 to 4 := 1;
    signal piso_deseado_sim : integer range 1 to 4;

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
        --se comprobara que ante peticion simultanea se escuha al boton interior
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
        piso_actual_sim <= 1; 
        
        TbSimEnded <= '1';
        assert false report "FIN DE LA SIMULACION" severity failure;
          
        end process;
       
end tb;
configuration cfg_piso_decoder_tb of piso_decoder_tb is
    for tb
    end for;
end cfg_piso_decoder_tb;
