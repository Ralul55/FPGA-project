library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity actuadores is
    Port ( 
        piso_actual  : IN integer range 0 to 4;
        piso_deseado  : IN integer range 0 to 4;

    
        LEDS_PISOS : OUT std_logic_vector (3 downto 0);
        LEDS_PISO_deseado: OUT std_logic_vector (3 downto 0);

        
        CNTRL_DISPLAY : OUT std_logic_vector(6 DOWNTO 0);
        LEDS_DISPLAYS : OUT std_logic_vector(6 DOWNTO 0)  --bcd
    );
end actuadores;

architecture Behavioral of actuadores is

begin
    --------------------------------------------
    
    u_decoder_display : entity work.decoder_display
        port map(
            code => piso_actual,
            led => LEDS_DISPLAYS  
        );

        ------------------------------------------------------------------------------------
    -- Aquí se programará el decodificador de la salida de los LED's de los pisos
    Leds_para_pisos: process(piso_actual)
    begin
        case piso_actual is
            when 1 =>
               LEDS_PISOS <= "0001";
            when 2 =>
               LEDS_PISOS <= "0010";
            when 3 =>
               LEDS_PISOS <= "0100";
            when 4 =>
               LEDS_PISOS <= "1000";
            when others =>
               LEDS_PISOS <= (others => '0');
        end case;
    -- Apagar todos
    
    for i in 0 to 6 loop
        CNTRL_DISPLAY(i) <= '1';
    end loop;
  
    end process;
    
    Leds_para_piso_deseado: process(piso_deseado)
    begin
        case piso_deseado is
            when 1 =>
               LEDS_PISO_deseado <= "0001";
            when 2 =>
               LEDS_PISO_deseado <= "0010";
            when 3 =>
               LEDS_PISO_deseado <= "0100";
            when 4 =>
               LEDS_PISO_deseado <= "1000";
            when others =>
               LEDS_PISO_deseado <= (others => '0');
        end case;
       
    end process;
    
    
    
end Behavioral;
