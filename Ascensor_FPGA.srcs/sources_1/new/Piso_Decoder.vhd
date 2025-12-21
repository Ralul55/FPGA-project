----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2025 15:20:11
-- Design Name: 
-- Module Name: Piso_Decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Piso_Decoder is
    port(
        clk           : in  std_logic;
        botones       : in  std_logic_vector(8 downto 1); -- [4 interiores | 4 exteriores]
        piso_actual   : in  natural range 1 to 4;         -- para resetear requests
        piso_deseado  : out natural range 1 to 4
    );
end Piso_Decoder;

architecture Behavioral of Piso_Decoder is
    signal request_reg : natural range 1 to 4 := 0;
    signal prioridad   : std_logic := '0'; -- '1' = interior, '0' = exterior
begin

    piso_deseado <= request_reg;

    process(clk)
    begin
        if rising_edge(clk) then

            -- Registrar un botón solo si no hay request pendiente
            if request_reg = 0 then
                -- Revisar botones interiores (prioridad interna)
                case botones(8 downto 5) is
                    when "0001" =>
                        request_reg <= 1;
                        prioridad   <= '1';
                    when "0010" =>
                        request_reg <= 2;
                        prioridad   <= '1';
                    when "0100" =>
                        request_reg <= 3;
                        prioridad   <= '1';
                    when "1000" =>
                        request_reg <= 4;
                        prioridad   <= '1';
                    when others =>
                        null;
                end case;

                -- Si no hay botón interior activo, revisar exteriores
                if request_reg = 0 then
                    case botones(4 downto 1) is
                        when "0001" =>
                            request_reg <= 1;
                            prioridad   <= '0';
                        when "0010" =>
                            request_reg <= 2;
                            prioridad   <= '0';
                        when "0100" =>
                            request_reg <= 3;
                            prioridad   <= '0';
                        when "1000" =>
                            request_reg <= 4;
                            prioridad   <= '0';
                        when "0000" =>
                            null; -- ningún botón exterior
                        when others =>
                            null; -- combinaciones inválidas
                    end case;
                end if;
            end if;

            -- Reset de request al llegar al piso deseado
            if piso_actual = request_reg and request_reg /= 0 then
                request_reg <= 0;
                prioridad   <= '0';
            end if;

        end if;
        
        -- Este código permite que se ignore un boton que se pulse despues de otro que establezca algún piso deseado
        -- La prioridad del bitin pulsado antes permanece hasta que se llegue al piso deseado
    end process;

end Behavioral;