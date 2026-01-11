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
        
        piso_actual  : IN  integer range 0 to 4;
        piso_deseado : IN integer range 0 to 4;
        
        estado_actual: OUT std_logic_vector(5 DOWNTO 0);
        LEDS_INDICADORES_ESTADOS : OUT std_logic_vector (5 downto 0) --se usara como salida indicativa
    );  
end FSM;

architecture Behavioral of FSM is

    --signal piso_actual  : integer range 0 to 4 := 1;
    --signal piso_deseado : integer range 0 to 4 := 0;
    --signal botones_comb : std_logic_vector(8 downto 1);

    type ESTADOS is (Reposo, Subiendo, Bajando, Abriendo, Cerrando, Espera);
    signal senial_estado_actual : ESTADOS := Reposo;
    signal estado_siguiente : ESTADOS;
    
    constant CLK_FREQ      : integer := 100000000; -- 100 MHz
    
    -- temporizador puerta --
    constant TIEMPO_ESPERA : integer := 5;           -- segundos
    constant MAX_COUNT_ESPERA : integer := CLK_FREQ * TIEMPO_ESPERA;
    --constant MAX_COUNT_ESPERA : integer := 2; --SOLO PARA SIMULAR => 20ns

    signal timer_cnt_espera  : integer range 0 to MAX_COUNT_ESPERA := 0;
    signal timer_done_espera : std_logic := '0';
    
begin
 
    -- Aquí se programará la acción del botón RESET (Activo a nivel bajo)
    timer_y_registros: process (RESET, CLK)
        begin
            if RESET = '0' THEN 
                 senial_estado_actual <= Reposo;
                 timer_cnt_espera  <= 0;
                 timer_done_espera <= '0';
                 --piso_actual <= 1;
                 --timer_cnt_piso <= 0;
                 
            elsif rising_edge(CLK) THEN
                 senial_estado_actual <= estado_siguiente; -- Actualizacion Estado
                if senial_estado_actual = Espera then
                    if S_presencia = '1' then
                        timer_cnt_espera  <= 0;        -- alguien presente
                        timer_done_espera <= '0';
                    else
                        if timer_cnt_espera < MAX_COUNT_ESPERA then
                            timer_cnt_espera <= timer_cnt_espera + 1;
                            timer_done_espera <= '0';
                        else
                            timer_done_espera <= '1'; -- tiempo agotado
                        end if;
                    end if;
                else
                    timer_cnt_espera  <= 0;            -- fuera de Espera
                    timer_done_espera <= '0';
                end if;
            end if;
            
    end process;
    --------------------------------------------
  
    ------------------------------------------------------------------------------------
    -- Aquí se programará transición entre estados
    cambio_estados: process(senial_estado_actual, S_fin_carrera, S_ini_carrera, S_presencia, piso_deseado, piso_actual, timer_done_espera)
    begin
        estado_siguiente <= senial_estado_actual;
        case senial_estado_actual is
            when Reposo =>
                if piso_deseado /= 0 then

                -- De Reposo a Subiendo
                if (piso_actual < piso_deseado) then estado_siguiente <= Subiendo;
                -- De Reposo a Bajando
                elsif(piso_actual > piso_deseado) then estado_siguiente <= Bajando;
                -- De Reposo a Abriendo
                elsif(piso_actual = piso_deseado) then estado_siguiente <= Abriendo;
                end if;
                end if;
            when Subiendo =>
                -- De Subiendo a Abriendo
                if(piso_actual = piso_deseado) then estado_siguiente <= Abriendo;
                end if;
            when Bajando =>
                -- De Bajando a Abriendo
                if(piso_actual = piso_deseado) then estado_siguiente <= Abriendo;
                end if;
            when Abriendo =>
                -- De Abriendo a Espera
                if (S_fin_carrera = '1' and S_ini_carrera = '0') then estado_siguiente <= Espera;
                end if;
            when Espera =>
                -- De Espera a Espera
                if (S_presencia = '1') then estado_siguiente <= Espera;
                elsif(timer_done_espera = '1' and S_fin_carrera = '1') then estado_siguiente <= Cerrando;
                end if;
            when Cerrando =>
                -- De Cerrando a Abriendo
                if(S_presencia = '1') then estado_siguiente <= Abriendo;
                elsif(S_ini_carrera = '1') then estado_siguiente <= Reposo;
                end if;
        end case;
             
        
    
    end process;
    ------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------
    -- Aquí se programará el decodificador de la salida de los LED's de los estado
    Leds_para_estados: process(senial_estado_actual)
    begin
    case senial_estado_actual is
        when Reposo =>
                estado_actual <= "000001";
                LEDS_INDICADORES_ESTADOS <= "000001";
        when Subiendo =>
                estado_actual <= "000010";
                LEDS_INDICADORES_ESTADOS <= "000010";
        when Bajando =>
                estado_actual <= "000100";
                LEDS_INDICADORES_ESTADOS <= "000100";
        when Abriendo =>
                estado_actual <= "001000";
                LEDS_INDICADORES_ESTADOS <= "001000";
        when Espera =>
                estado_actual <= "010000";
                LEDS_INDICADORES_ESTADOS <= "010000";
        when Cerrando =>
                estado_actual <= "100000";
                LEDS_INDICADORES_ESTADOS <= "100000";
        when others =>
               LEDS_INDICADORES_ESTADOS <= (others => '0');

        end case;
    end process;
    ------------------------------------------------------------------------------------
    
end Behavioral;
