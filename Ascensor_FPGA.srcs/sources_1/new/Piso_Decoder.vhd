library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Piso_Decoder is
    port(
        RESET: IN std_logic;
        clk           : in  std_logic;
        botones_i     : in  std_logic_vector(4 downto 1); -- [4 interiores ]
        botones_e      : in  std_logic_vector(4 downto 1); -- [ 4 exteriores]
        piso_actual   : in  integer range 0 to 4;         -- para resetear requests
        piso_deseado  : out integer range 0 to 4
    );
end Piso_Decoder;

architecture Behavioral of Piso_Decoder is
    signal request_reg : integer range 0 to 4 := 0;
begin
    piso_deseado <= request_reg;

    process(clk, RESET)
    begin
        if RESET = '0' THEN 
                 request_reg <= 0; 
                 
        elsif rising_edge(clk) then

            -- Registrar un botón solo si no hay request pendiente
            if request_reg = 0 then
            
            -- Revisar exteriores
            -- Interiores (prioridad sobre exteriores)
            if botones_i(1) = '1' then
                request_reg <= 1;
            elsif botones_i(2) = '1' then
                request_reg <= 2;
            elsif botones_i(3) = '1' then
                request_reg <= 3;
            elsif botones_i(4) = '1' then
                request_reg <= 4;
            end if;
            
            -- Exteriores
            if botones_e(1) = '1' then
                request_reg <= 1;
            elsif botones_e(2) = '1' then
                request_reg <= 2; 
            elsif botones_e(3) = '1' then
                request_reg <= 3;
            elsif botones_e(4) = '1' then
                request_reg <= 4;
            end if;

            -- Reset de request al llegar al piso deseado
            if piso_actual = request_reg and request_reg /= 0 then
                request_reg <= 0;
            end if;
            
            end if;
            end if;
        
        -- Este código permite que se ignore un boton que se pulse despues de otro que establezca algún piso deseado
        -- La prioridad del bitin pulsado antes permanece hasta que se llegue al piso deseado
    end process;

end Behavioral;