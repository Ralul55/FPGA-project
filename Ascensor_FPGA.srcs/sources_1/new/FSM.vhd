----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2025 16:12:00
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    port(
        RESET: IN std_logic;
        CLK: IN std_logic;
    
        S_fin_carrera: IN std_logic;
        S_ini_carrera: IN std_logic;
        S_presencia: IN std_logic;
        boton_i: IN std_logic_vector (4 downto 1);
        boton_e: IN std_logic_vector (4 downto 1);
        
        LEDS_INDICADORES_ESTADOS : OUT std_logic_vector (5 downto 0)
    );  
end FSM;

architecture Behavioral of FSM is

    signal piso_actual  : natural range 1 to 4 := 1;
    signal piso_deseado : natural range 1 to 4 := 1;
    signal botones_comb : std_logic_vector(8 downto 1);

    type ESTADOS is (Reposo, Subiendo, Bajando, Abriendo, Cerrando, Espera);
    signal estado_actual, estado_siguiente : ESTADOS;

begin
    --------------------------------------------
    botones_comb <= boton_i & boton_e;
    u_piso_decoder : entity work.Piso_Decoder
        port map(
            clk          => CLK,
            botones      => botones_comb,
            piso_actual  => piso_actual,
            piso_deseado => piso_deseado
        );
    --------------------------------------------


    --------------------------------------------
    -- Aquí se programará la acción del botón RESET (Activo a nivel bajo CREO)
    registro_estados: process (RESET, CLK)
        begin
            if RESET = '0' THEN 
                 estado_actual <= Reposo;
            elsif rising_edge(CLK) THEN
                 estado_actual <= estado_siguiente;
            end if;
    end process;
    --------------------------------------------
    
  
    ------------------------------------------------------------------------------------
    -- Aquí se programará transición entre estados
    cambio_estados: process(S_fin_carrera, S_ini_carrera, S_presencia, piso_deseado)
    begin
        
        
    
    end process;
    ------------------------------------------------------------------------------------
    
    
    ------------------------------------------------------------------------------------
    -- Aquí se programará el decodificador de la salida de los LED's
    Leds_para_pisos: process(estado_actual)
    begin
    
    end process;
    ------------------------------------------------------------------------------------


end Behavioral;
