library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
    port(
        CLK     : in  std_logic;  
        BTN_IN  : in  std_logic;  
        BTN_OUT : out std_logic   
    );
end debouncer;

architecture Behavioral of debouncer is

constant CICLOS_DEBOUNCER : natural := 2_000_000;

signal debounced : std_logic := '0';  
signal entrada : std_logic := '0';  
signal contador : natural range 0 to CICLOS_DEBOUNCER -1 := 0;
  
begin

process(CLK)
  begin
    if rising_edge(CLK) then

      -- Si cambia la entrada, actualizamos dato y reiniciamos el tiempo
      if BTN_IN /= entrada then
        entrada <= BTN_IN;
        contador <= 0;

      else
        -- Si la entrada es distinta de lo aceptado, contamos estabilidad
        if debounced /= entrada then
          if contador = CICLOS_DEBOUNCER-1 then
            debounced <= entrada;  -- aceptamos el cambio tras 20 ms estables
            contador <= 0;
          else
            contador <= contador + 1;
          end if;
        else
          contador <= 0;
        end if;

      end if;
    end if;
  end process;

  BTN_OUT <= debounced;

end Behavioral;
