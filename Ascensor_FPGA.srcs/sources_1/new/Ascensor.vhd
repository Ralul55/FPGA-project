----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2025 14:13:24
-- Design Name: 
-- Module Name: Ascensor - Structural
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

-- Esta será la entidad TOP

entity Ascensor is
    Port ( 
        boton_i: IN std_logic_vector(4 downto 1); -- El rango raro de esto es debido a que los botones exteriores del fichero de ctes cuentan 
        boton_e: IN std_logic_vector(4 downto 1)  -- desde el 1 (mirar fichero de ctes)
        
    );
end Ascensor;

architecture Structural of Ascensor is

begin


end Structural;
