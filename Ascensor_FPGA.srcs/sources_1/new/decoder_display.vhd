----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2025 22:05:33
-- Design Name: 
-- Module Name: decoder_display - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_display is
    PORT (
            code : IN integer range 1 to 4;
            led : OUT std_logic_vector(6 DOWNTO 0)
    );
end decoder_display;

architecture dataflow of decoder_display is

begin
        WITH code SELECT
                led <= --"0000001" WHEN "0000",
                       --"1001111" WHEN 1,
                       
                       "1111001" when 1,
                       "0100100" when 2,
                       "0110000" when 3,
                       "0011001" when 4,
                       "1111111" when others;
                       
                       --"0100100" WHEN "0101",
                       --"0100000" WHEN "0110",
                       --"0001111" WHEN "0111",
                       --"0000000" WHEN "1000",
                       --"0000100" WHEN "1001",
end architecture dataflow;
