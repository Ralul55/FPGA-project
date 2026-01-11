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
        CNTRL_DISPLAY : OUT std_logic_vector(6 DOWNTO 0);
        LEDS_DISPLAYS : OUT std_logic_vector(6 DOWNTO 0)  --bcd
        
    );
end Ascensor;

architecture Structural of Ascensor is

    signal boton_i_deb : std_logic_vector(4 downto 1);
    signal boton_e_deb : std_logic_vector(4 downto 1);
    signal boton_reset_deb : std_logic;
    
    signal boton_i_sinc : std_logic_vector(4 downto 1);
    signal boton_e_sinc : std_logic_vector(4 downto 1); 
    
    signal boton_i_edge : std_logic_vector(4 downto 1);
    signal boton_e_edge : std_logic_vector(4 downto 1); 
    
    signal piso_actual  : integer range 0 to 4;
    signal piso_deseado : integer range 0 to 4 ;
    signal estado_actual : std_logic_vector (5 downto 0);
     
begin

    -- debouncer --

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
      
      -- sincro --
        
     u_sin_i_vec : entity work.sincro_vect
        port map (
            CLK => CLK, 
            ASYNC_IN => boton_i_deb, 
            SYNC_OUT => boton_i_sinc
        );
        
     u_sin_e_vec : entity work.sincro_vect
        port map (
            CLK => CLK, 
            ASYNC_IN => boton_e_deb, 
            SYNC_OUT => boton_e_sinc
        );
        
      -- detector de flanco --
      
      u_edge_i_vec : entity work.edge_detector_vect
        port map (
            CLK => CLK, 
            SYNC_IN => boton_i_sinc, 
            EDGE => boton_i_edge
        );
        
      u_edge_e_vec : entity work.edge_detector_vect
        port map (
            CLK => CLK, 
            SYNC_IN => boton_e_sinc, 
            EDGE => boton_e_edge
        );
        
       -- fsm --
      u_fsm : entity work.fsm
        port map (
            RESET => boton_reset_deb,
            CLK => CLK,
    
            S_fin_carrera => S_fin_carrera,
            S_ini_carrera => S_ini_carrera,
            S_presencia => S_presencia,
            
            piso_actual =>piso_actual,
            piso_deseado=>piso_deseado,
            
            
            estado_actual => estado_actual,
            LEDS_INDICADORES_ESTADOS => LEDS_INDICADORES_ESTADOS
            
         );
         
         -- piso actual --
        u_piso_actual : entity work.piso_actual
        port map (
            RESET => boton_reset_deb,
            CLK => CLK,
    
            boton_i => boton_i_edge,
            boton_e => boton_e_edge,
            
            estado_actual=>estado_actual,
            
            piso_act =>piso_actual,
            piso_des=>piso_deseado
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
         
         
         
         
         
 

end Structural;
