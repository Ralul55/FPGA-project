library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

-- EN ESTA SIMULACION SE COMPRUEBA EL CORRECTO FUNCIONAMIENTO DE:
            --RESET (Activo a nivel bajo)
            --MAQUINA DE ESTADO (DE MOMENTO NO HAY FORMA DE CAMBIAR EL PISO ASIQUE NO SE PUEDE COMPROBAR!!!!!!!!!!!)
                --cambios de estado correctos
                --espera de la puerta
            --LEDS DE SALIDA (observable en toda la simulacion)
                --LED [5]: CERRANDO   --> 20
                --LED [4]: ESPERA     --> 10
                --LED [3]: ABRIENDO   --> 8
                --LED [2]: BAJANDO    --> 4
                --LED [1]: SUBIENDO   --> 2
                --LED [0]: REPOSO     --> 1

--el timer de 5s SE RECOMIENDA QUITAR ESE TIEMPO Y PONER 20ns, tardando aprox 30ns mas ciclo extra para establecerse (4 flancos) PARA AGILIZAR LA SIMULACION
        --linea comentada en FSM.vhd

entity FSM_tb is
end FSM_tb;

architecture tb of FSM_tb is

    component FSM
        port (RESET                    : in std_logic;
              CLK                      : in std_logic;
              S_fin_carrera            : in std_logic;
              S_ini_carrera            : in std_logic;
              S_presencia              : in std_logic;
              piso_actual  : IN  integer range 0 to 4;
              piso_deseado : IN integer range 0 to 4;
              LEDS_INDICADORES_ESTADOS : out std_logic_vector (5 downto 0) );
    end component;

    signal RESET                    : std_logic:= '1';
    signal CLK                      : std_logic:= '0';
    signal S_fin_carrera            : std_logic:= '0';
    signal S_ini_carrera            : std_logic:= '0';
    signal S_presencia              : std_logic:= '0';
    signal piso_actual  : integer range 0 to 4 := 1;
    signal piso_deseado : integer range 0 to 4 := 0;
    signal LEDS_INDICADORES_ESTADOS : std_logic_vector (5 downto 0);

    -- 100 MHz -> 10 ns
    constant TbPeriod  : time := 10 ns;
    signal   TbClock   : std_logic := '0';
    signal   TbSimEnded: std_logic := '0';

    --Establece el numero de flancos que hay que esperar
    procedure flanco(n : natural) is
    begin
        for k in 1 to n loop
            wait until rising_edge(CLK);
        end loop;
    end procedure;

begin

    dut : FSM
    port map (RESET                    => RESET,
              CLK                      => CLK,
              S_fin_carrera            => S_fin_carrera,
              S_ini_carrera            => S_ini_carrera,
              S_presencia              => S_presencia,
              piso_actual              => piso_actual,
              piso_deseado             => piso_deseado,
              LEDS_INDICADORES_ESTADOS => LEDS_INDICADORES_ESTADOS);

 -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK <= TbClock;

    stimuli : process
    begin
--------------------------------------------------------------------
        -- Se inicializan variables
--------------------------------------------------------------------
        RESET <='1';
        S_fin_carrera <= '0';
        S_ini_carrera <= '1'; --la puerta esta cerrada de primeras
        S_presencia <= '0';
        piso_actual <= 1;
        piso_deseado <= 0;
        -- 1 ciclo de espera
        flanco(1);
        
--------------------------------------------------------------------
        -- RESET (Activo a nivel bajo)
--------------------------------------------------------------------    
        --se establece piso deseado distinto de 0 para cambiar de estado
        piso_deseado <= 3;
        flanco(2);
        RESET <= '0' ;
        piso_deseado <= 0; --se tiene que hacer manualmente porque es una entrada
        flanco(2);
        
        --se establece piso deseado distinto de 0 para cambiar de estado
        RESET <= '1' ;
        piso_deseado <= 1;
        flanco(2);
        RESET <= '0' ;
        piso_deseado <= 0;
        flanco(2);
        
        RESET <= '1' ;

--------------------------------------------------------------------
        -- TEMPORIZADOR DE LA PUERTA
--------------------------------------------------------------------
        --primera prueba sin tocar el sensor de presencia, ciclo normal
        --el timer de 5s SE RECOMIENDA QUITAR ESE TIEMPO Y PONER 20ns, tardando aprox 30ns mas ciclo extra para establecerse (4 flancos) PARA AGILIZAR LA SIMULACION
        --linea comentada en FSM.vhd
        
        --condicion para abrir la puerta
        piso_deseado <= 1;
        flanco(1);
        piso_deseado <= 0;
        
        --paso a espera
        flanco(1);
        S_fin_carrera <= '1';
        S_ini_carrera <= '0';
        
        --acabado el tiempo pasa a cerrado
        flanco(6);
        --despues de cerrando vuelve a reposo
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        flanco(2);
        
        --mismo ciclo, se activara sensor mientras la puerta se cierre
        piso_deseado <= 1;
        flanco(1);
        piso_deseado <= 0;
        
        flanco(1);
        S_fin_carrera <= '1';
        S_ini_carrera <= '0';
        
        flanco(6);
        --se activa sensor
        S_presencia <= '1';
        flanco(1);
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        S_presencia <= '1';
        flanco(1);
        
        --se probarara que no sale de espera si el sensor esta activado
        --despues de dos flancos se activara el sensor de presencia
        --deberia tardar 6 flancos en pasar a cerrando

        flanco(2);
        S_fin_carrera <= '1';
        S_ini_carrera <= '0';
        flanco(2);
        
        S_presencia <= '1';
        flanco(1);
        S_presencia <= '0';
        flanco(5);
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        flanco(2);
        
--------------------------------------------------------------------
        -- MAQUINA DE ESTADO
        --se probara toda la maquina, menos el funcionamiento del reloj, ya probado
--------------------------------------------------------------------

        -- la comprobacion del temposrizador tambien sirve para comprobar que la relacion entre REPOSO-ABRIENDO-ESPERA-CERRANDO, es coorecta
        --se modificara el piso actual a mano ya que es una entrada
        
        --comprobacion subir
        --se establece piso deseado mayor que 1 para subir
        piso_deseado <= 3;
        flanco(2);
        piso_actual <= 2;
        flanco(2);
        piso_actual <= 3;
        flanco(1);
        piso_deseado <= 0;
        flanco(1);
        
        --ciclo de abrir y cerrar
        S_fin_carrera <= '1';
        S_ini_carrera <= '0';
        flanco(6);
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        flanco(2);
        
        --reposo pero en piso 3
        
        --comprobacion subir
        --se establece piso deseado mayor que 1 para subir
        piso_deseado <= 1;
        flanco(2);
        piso_actual <= 2;
        flanco(2);
        piso_actual <= 1;
        flanco(1);
        piso_deseado <= 0;
        flanco(1);
        
        --ciclo de abrir y cerrar
        S_fin_carrera <= '1';
        S_ini_carrera <= '0';
        flanco(6);
        S_fin_carrera <= '0';
        S_ini_carrera <= '1';
        flanco(2);
        
        --vuelta al reposo

--------------------------------------------------------------------
        -- Final de la simulacion
--------------------------------------------------------------------    
        TbSimEnded <= '1';
        stop;      
        wait;
        end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_FSM_tb of FSM_tb is
    for tb
    end for;
end cfg_FSM_tb;