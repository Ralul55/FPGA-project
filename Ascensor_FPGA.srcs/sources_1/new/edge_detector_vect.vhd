library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_vect is
    port (
        CLK : in std_logic;
        SYNC_IN : in std_logic_vector(4 downto 1);
        EDGE : out std_logic_vector(4 downto 1)
    );
end edge_detector_vect;

architecture Behavioral of edge_detector_vect is

begin
    gen : for k in SYNC_IN' range generate
    begin
        u : entity work.edge_detector
            port map (
                CLK     => CLK,
                SYNC_IN  => SYNC_IN(k),
                EDGE => EDGE(k)
            );
    end generate;

end Behavioral;
