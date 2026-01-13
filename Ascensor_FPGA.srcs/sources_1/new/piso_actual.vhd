library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso_actual is
    Port (
        RESET: IN std_logic;
        CLK: IN std_logic;
        
        boton_i: IN std_logic_vector (4 downto 1);
        boton_e: IN std_logic_vector (4 downto 1);
        
        estado_actual : IN std_logic_vector (5 downto 0);
    
        piso_act  : OUT  integer range 0 to 4;
        piso_des : OUT integer range 0 to 4
        
    );
end piso_actual;

architecture Behavioral of piso_actual is

    signal piso_actual  : integer range 0 to 4 := 1;
    signal piso_deseado : integer range 0 to 4 := 0;
    
    constant CLK_FREQ      : integer := 100000000; -- 100 MHz
    
    -- temporizador pisos --
    constant TIEMPO_POR_PISO : integer := 2;      -- segundos
    constant MAX_COUNT_ESPERA : integer := CLK_FREQ * TIEMPO_POR_PISO;
    --constant MAX_COUNT_ESPERA : integer := 2; --SOLO PARA SIMULAR => 20ns

    signal timer_cnt_piso  : integer range 0 to MAX_COUNT_ESPERA := 0;
    
begin
    piso_act<=piso_actual;
    piso_des<=piso_deseado;
   --------------------------------------------
    u_piso_decoder : entity work.Piso_Decoder
        port map(
            RESET        =>RESET,
            clk          => CLK,
            botones_i    => boton_i,
            botones_e    => boton_e,
            piso_actual  => piso_actual,
            piso_deseado => piso_deseado
        );
    
    --------------------------------------------
    
     ------------------------------------------------------------------------------------
    -- Aquí se programará el decodificador de la salida de los LED's de los pisos    
    cambio_piso: process(CLK, RESET)
        begin
            if (RESET = '0') then
                piso_actual <= 1;
                timer_cnt_piso <= 0;
            elsif rising_edge(CLK) then
                
                case estado_actual is
                    when "000010" => --subiendo
                        if piso_actual < piso_deseado then 
                            if timer_cnt_piso = MAX_COUNT_ESPERA -1 then 
                                timer_cnt_piso <= 0;
                                piso_actual <= piso_actual +1;
                            else 
                                timer_cnt_piso <=  timer_cnt_piso +1;
                            end if;
                        else
                            timer_cnt_piso <= 0;
                        end if;
                
                    when "000100" => --bajando
                        if piso_actual > piso_deseado and (piso_actual > 1)then 
                            if timer_cnt_piso = MAX_COUNT_ESPERA -1 then 
                                timer_cnt_piso <= 0;
                                piso_actual <= piso_actual -1;
                            else 
                                timer_cnt_piso <=  timer_cnt_piso +1;
                            end if;
                        else
                            timer_cnt_piso <= 0;
                        end if;                
                        
                     when others =>
                        timer_cnt_piso <= 0;
                end case;
            end if;    
     end process;

    ------------------------------------------------------------------------------------   


end Behavioral;
