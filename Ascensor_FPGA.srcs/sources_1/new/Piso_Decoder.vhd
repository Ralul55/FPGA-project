library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Piso_Decoder is
    port(
        clk           : in  std_logic;
        botones_i     : in  std_logic_vector(4 downto 1); -- [4 interiores ]
        botones_e      : in  std_logic_vector(4 downto 1); -- [ 4 exteriores]
        piso_actual   : in  integer range 1 to 4;         -- para resetear requests
        piso_deseado  : out integer range 1 to 4
    );
end Piso_Decoder;

architecture Behavioral of Piso_Decoder is
    signal request_reg : integer range 0 to 4 := 0;
begin
    piso_deseado <= piso_actual when request_reg = 0 else request_reg;

    process(clk)
    begin
        if rising_edge(clk) then

            -- Registrar un botón solo si no hay request pendiente
            if request_reg = 0 then
                -- Revisar botones interiores (prioridad interna)
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

                -- Si no hay botón interior activo, revisar exteriores
                if request_reg = 0 then
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
                end if;
            end if;

            -- Reset de request al llegar al piso deseado
            if piso_actual = request_reg and request_reg /= 0 then
                request_reg <= 0;
            end if;

        end if;
        
        -- Este código permite que se ignore un boton que se pulse despues de otro que establezca algún piso deseado
        -- La prioridad del bitin pulsado antes permanece hasta que se llegue al piso deseado
    end process;

end Behavioral;