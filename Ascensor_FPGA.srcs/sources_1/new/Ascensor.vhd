library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Esta será la entidad TOP

entity Ascensor is
    Port ( 
        RESET: IN std_logic;
        CLK: IN std_logic;
    
        S_fin_carrera: IN std_logic; -- Implementado con los switches de la FPGA
        S_ini_carrera: IN std_logic;
        S_presencia: IN std_logic;
        
        boton_i: IN std_logic_vector (4 downto 1);
        boton_e: IN std_logic_vector (4 downto 1);
        
        LEDS_INDICADORES_ESTADOS : OUT std_logic_vector (5 downto 0); --se usara como salida indicativa
        
        LEDS_PISOS : OUT std_logic_vector (3 downto 0);
        LEDS_PISO_deseado: OUT std_logic_vector (3 downto 0);
        LEDS_control : OUT std_logic_vector (3 downto 0);
        CNTRL_DISPLAY : OUT std_logic_vector(6 DOWNTO 0);
        LEDS_DISPLAYS : OUT std_logic_vector(6 DOWNTO 0)  --bcd
        
    );
end Ascensor;

architecture Behavoiral of Ascensor is
    
    signal piso_actual  : integer range 0 to 4;
    signal piso_deseado : integer range 0 to 4 ;
    signal estado_actual : std_logic_vector (5 downto 0);
     
begin
  
         -- piso actual --
        u_piso_actual : entity work.piso_actual
        generic map(
            MAX_COUNT_ESPERA => 200000000 --5S*100MHz 
        )
        port map (
            RESET => RESET,
            CLK => CLK,
            
            boton_i => boton_i,
            boton_e => boton_e,
           
            estado_actual=>estado_actual,
            
            piso_act =>piso_actual,
            piso_des=>piso_deseado
         );
     
       -- fsm --
      u_fsm : entity work.fsm
      generic map(
            MAX_COUNT_ESPERA => 500000000 --5S*100MHz   
        )
        port map (
            RESET => RESET,
            CLK => CLK,
    
            S_fin_carrera => S_fin_carrera,
            S_ini_carrera => S_ini_carrera,
            S_presencia => S_presencia,
            
            piso_actual =>piso_actual,
            piso_deseado=>piso_deseado,
            
            
            estado_actual => estado_actual,
            LEDS_control=>LEDS_control,
            LEDS_INDICADORES_ESTADOS => LEDS_INDICADORES_ESTADOS
            
         );
         
         -- actuadores del piso  --
      u_actuadores : entity work.actuadores
        port map (
            piso_actual=>piso_actual,
            piso_deseado=>piso_deseado,
            
            LEDS_PISOS => LEDS_PISOS,
            LEDS_PISO_deseado => LEDS_PISO_deseado,
            CNTRL_DISPLAY => CNTRL_DISPLAY,
            LEDS_DISPLAYS => LEDS_DISPLAYS
         );
 

end Behavoiral;