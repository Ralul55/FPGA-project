library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_vect is
  port(
    CLK     : in  std_logic;
    BTN_IN  : in  std_logic_vector(4 downto 1);
    BTN_OUT : out std_logic_vector(4 downto 1)
  );
end debounce_vect;

architecture Behavioral of debounce_vect is

begin
  gen : for k in BTN_IN'range generate
  begin
    u : entity work.debouncer
      port map (
        CLK     => CLK,
        BTN_IN  => BTN_IN(k),
        BTN_OUT => BTN_OUT(k)
      );
  end generate;

end Behavioral;
