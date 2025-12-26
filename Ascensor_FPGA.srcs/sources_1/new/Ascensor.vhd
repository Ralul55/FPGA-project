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
        RESET: IN std_logic;
        CLK: IN std_logic;
    
        S_fin_carrera: IN std_logic;
        S_ini_carrera: IN std_logic;
        S_presencia: IN std_logic;
        boton_i: IN std_logic_vector (4 downto 1);
        boton_e: IN std_logic_vector (4 downto 1);
        
        LEDS_INDICADORES_ESTADOS : OUT std_logic_vector (5 downto 0); --se usara como salida indicativa
        LEDS_PISOS : OUT std_logic_vector (3 downto 0);
        LEDS_DISPLAYS : OUT std_logic_vector(6 DOWNTO 0)  --bcd
        
    );
end Ascensor;

architecture Structural of Ascensor is

    signal boton_i_deb : std_logic_vector(4 downto 1);
    signal boton_e_deb : std_logic_vector(4 downto 1);
    signal boton_reset_deb : std_logic;
     
begin

    u_debouncer_boton_reset : entity work.debouncer
        port map(
            CLK => CLK, 
            BTN_IN  => RESET, 
            BTN_OUT => boton_reset_deb 
        );

    u_db_i_vec : entity work.debounce_vect
        port map (
            CLK => CLK, 
            BTN_IN => boton_i, 
            BTN_OUT => boton_i_deb
        );
     
     u_db_e_vec : entity work.debounce_vect
        port map (
            CLK => CLK, 
            BTN_IN => boton_e, 
            BTN_OUT => boton_e_deb
        );

end Structural;
