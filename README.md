# FPGA-project (Ascensor)

Proyecto de Vivado correspondiente a la parte de FPGA del trabajo de SED: **control de un ascensor**.

---

El diseño implementa la lógica típica de un ascensor:

- Lectura de **sensores** (final de carrera superior/inferior, presencia, etc.).
- Lectura de **botoneras** (botones interiores/exteriores por piso).
- **Máquina de estados (FSM)** que decide:
  - si el ascensor sube, baja o se detiene
  - control de las puertas
  - en que piso nos encontramos, y cual es el piso objetivo
- Salidas a **LEDs/Display** para indicar estado, piso actual, piso destino y gestión de los actuadores.

---

Aunque el detalle exacto depende de los ficheros HDL dentro de `Ascensor_FPGA.srcs`, por los nombres del proyecto y las configuraciones de prueba, el diseño se divide en:

### 1) Entrada de botones y sensores
- Decodificación de botoneras (pulsadores por piso).

### 2) Gestión de pisos
- Cálculo/registro del piso actual.
- Lógica para seleccionar piso deseado (prioridades, cola simple, etc.).

### 3) FSM principal (control del ascensor)
- Estados típicos:
  - `REPOSO`
  - `SUBIENDO` /  `BAJANDO`
  - `ABRIENDO` / `CERRANDO`  / `ESPERA` (puerta)
- Transiciones gobernadas por sensores (puerta) + psio deseado (botones) .

### 4) Salidas de usuario
- LEDs de estado (reposo, subiendo , bajando, etc).
- Display (7 segmentos) mostrando piso actual.
- Señales de control (motor, puerta) si están modeladas.
- LEDs que muestran piso actual y deseado.

---

## 🧪 Simulación y pruebas

El repositorio incluye configuraciones `.wcfg` para verificar partes del diseño (FSM, piso actual, decoder de piso, etc.).

Modo de funcionamiento:
1. `Run Simulation > Run Behavioral Simulation`
2. Carga el waveform (`.wcfg`) correspondiente para ver señales relevantes.
3. Comprueba correcto funcionamiento del testbench, fuerza entradas (botones/sensores) y se comprueba:
   - Transiciones de la FSM
   - Actualización de piso actual
   - Selección correcta de piso objetivo
   - Señales a LEDs/Display
  
