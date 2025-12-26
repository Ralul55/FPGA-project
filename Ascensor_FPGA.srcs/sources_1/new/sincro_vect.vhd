library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sincro_vect is
    port (
        CLK : in std_logic;
        ASYNC_IN : in std_logic_vector(4 downto 1);
        SYNC_OUT : out std_logic_vector(4 downto 1)
    );
end sincro_vect;

architecture Behavioral of sincro_vect is

begin
    gen : for k in ASYNC_IN' range generate
    begin
        u : entity work.sincro
            port map (
                CLK     => CLK,
                ASYNC_IN  => ASYNC_IN(k),
                SYNC_OUT => SYNC_OUT(k)
            );
    end generate;

end Behavioral;
