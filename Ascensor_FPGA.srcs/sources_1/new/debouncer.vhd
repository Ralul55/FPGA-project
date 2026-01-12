library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    port (
        CLK      : in  std_logic;
        BTN_IN   : in  std_logic;
        BTN_OUT  : out std_logic
    );
end debounce;

architecture Behavioral of debounce is
    constant MAX_COUNT : unsigned(19 downto 0) := to_unsigned(999999, 20); -- ~10 ms a 100 MHz
    signal count       : unsigned(19 downto 0) := (others => '0');
    signal state       : std_logic := '1';
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if BTN_IN /= state then                 -- ha cambiado el botón
                count <= count + 1;                 -- esperamos que se mantenga
                if count = MAX_COUNT then           -- estable suficiente tiempo
                    state <= BTN_IN;                -- aceptamos el nuevo estado
                    count <= (others => '0');
                end if;
            else                                    -- igual que antes
                count <= (others => '0');
            end if;
        end if;
    end process;

    BTN_OUT <= state;

end Behavioral;