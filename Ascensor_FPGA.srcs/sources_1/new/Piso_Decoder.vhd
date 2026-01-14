library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Piso_Decoder is
    port(
        RESET         : IN std_logic;
        clk           : in  std_logic;
        botones_i     : in  std_logic_vector(4 downto 1); -- [4 interiores ] (pull-down)
        botones_e     : in  std_logic_vector(4 downto 1); -- [ 4 exteriores] (pull-down)
        piso_actual   : in  integer range 0 to 4;         -- para resetear requests
        piso_deseado  : out integer range 0 to 4
    );
end Piso_Decoder;

architecture Behavioral of Piso_Decoder is
    signal request_reg : integer range 0 to 4 := 0;
    signal llegada_pend    : std_logic := '0';  -- FLAG

begin
    
    piso_deseado <= request_reg;

    process(clk, RESET)
    begin
        
        -- RESET activo a nivel bajo
        if RESET = '0' THEN 
            request_reg <= 0; 
            llegada_pend <= '0';
                 
        elsif rising_edge(clk) then
            
            -- Registrar un botón solo si no hay request pendiente
            
            if llegada_pend = '1' then
                request_reg  <= 0;
                llegada_pend <= '0';

            else
                if request_reg = 0 then
                -- Revisar exteriores
                -- Interiores (prioridad sobre exteriores)
                -- Pull-down: botón pulsado = '1'
                case botones_e(4 downto 1) is
                    when "0001" =>
                        request_reg <= 1;
                    when "0010" =>
                        request_reg <= 2;
                    when "0100" =>
                        request_reg <= 3;
                    when "1000" =>
                        request_reg <= 4;
                    when "0000" =>
                        null; -- ningún botón exterior
                    when others =>
                        null; -- combinaciones inválidas
                end case;
                
                -- Revisar botones interiores (prioridad interna, última asignación)
                case botones_i(4 downto 1) is
                    when "0001" =>
                        request_reg <= 1;
                    when "0010" =>
                        request_reg <= 2;
                    when "0100" =>
                        request_reg <= 3;
                    when "1000" =>
                        request_reg <= 4;
                    when others =>
                        null;
                end case;

            end if;
            
            -- Reset de request al llegar al piso deseado
            if piso_actual = request_reg and request_reg /= 0 then
                request_reg <= 0;
            end if;
            
        end if;
        end if;

        -- Este código permite que se ignore un botón que se pulse después de otro
        -- que establezca algún piso deseado
        -- La prioridad del botón pulsado antes permanece hasta que se llegue al piso deseado
    end process;

end Behavioral;
