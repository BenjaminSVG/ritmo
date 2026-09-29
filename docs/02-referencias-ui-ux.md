# 2. Referencias de UI/UX (apps existentes)

> **Nota:** las capturas de otras aplicaciones que ilustraban este documento no se incluyen en el repositorio público, por derechos de autor de sus creadores. Los enlaces a imágenes que aparecen abajo pueden verse rotos; la descripción de cada referencia sigue siendo válida.

Las capturas son las imágenes promocionales de las fichas oficiales de Google Play, guardadas en [../referencias/capturas/](../referencias/capturas/). Son **referencia interna de estudio**; pertenecen a sus autores y no deben usarse en la app final ni en su marketing. Cada app trae 5–7 capturas (`app-01`, `app-02`, …).

## 2.1 Hábitos

### Loop Habit Tracker — el estándar de "simple y estadístico"
![Loop score](../referencias/capturas/loop-habit-tracker-02.png)
- **Copiar**: pantalla de detalle con *Overview* (puntuación %, mes, año, total), gráfico de **puntuación de hábito** (no solo racha: perdona un día fallado) e historial por semana. Una sola pregunta clara por hábito ("¿Meditaste al menos 10 min hoy?").
- **Evitar**: estética Material antigua, color de acento único muy saturado en toda la barra.
- Más capturas: [01](../referencias/capturas/loop-habit-tracker-01.png) · [03](../referencias/capturas/loop-habit-tracker-03.png) · [04](../referencias/capturas/loop-habit-tracker-04.png) · [05](../referencias/capturas/loop-habit-tracker-05.png)

### Habitify — micro-hábitos con progreso
![Habitify](../referencias/capturas/habitify-01.jpg)
- **Copiar**: lista agrupada por momento del día (*Todos / Mañana / …*), cada hábito con **anillo de progreso** e icono, y botón contextual (`Log`, `+1`) según el tipo (cantidad, tiempo). "Desafíos" en sección aparte, plegable. Integraciones de salud visibles.
- **Evitar**: mucha información por fila cuando hay muchos hábitos.
- Más capturas: [02](../referencias/capturas/habitify-02.jpg) · [03](../referencias/capturas/habitify-03.jpg) · [04](../referencias/capturas/habitify-04.jpg)

### Habitica — gamificación
![Habitica](../referencias/capturas/habitica-01.png)
- **Copiar (con moderación)**: pequeñas recompensas/animaciones al completar.
- **Evitar**: convertir todo en RPG; es divertido para un nicho, abrumador para el resto.
- Más capturas: [02](../referencias/capturas/habitica-02.png) · [03](../referencias/capturas/habitica-03.png)

## 2.2 Tareas

### Todoist — captura rápida y claridad
![Todoist](../referencias/capturas/todoist-02.png)
- **Copiar**: **lenguaje natural** que resalta en la misma caja de texto ("mañana 4 pm", "p1", "+Alex", "cada lunes") y crea chips de fecha/prioridad; Inbox / Hoy / Próximos en el menú; mucho espacio en blanco; sin ruido visual.
- **Evitar**: calendario limitado (depende de Google Calendar).
- Más capturas: [01](../referencias/capturas/todoist-01.png) · [03](../referencias/capturas/todoist-03.png) · [04](../referencias/capturas/todoist-04.png)

### TickTick — todo en uno
![TickTick lista](../referencias/capturas/ticktick-01.png)
![TickTick voz](../referencias/capturas/ticktick-04.png)
- **Copiar**: Inbox con secciones **HOY / MAÑANA** plegables y la **hora en azul a la derecha**; tarjetas redondeadas; entrada por **voz/IA** que transforma una frase en varias tareas con hora, lista y recordatorio; hábitos, Pomodoro y calendario dentro de la misma app.
- **Evitar**: densidad de funciones en menús laterales; el usuario nuevo no sabe por dónde empezar.
- Más capturas: [02](../referencias/capturas/ticktick-02.png) · [03](../referencias/capturas/ticktick-03.png) · [05](../referencias/capturas/ticktick-05.png) · [06](../referencias/capturas/ticktick-06.png)

## 2.3 Calendario

### Google Calendar — creación rápida
![Google Calendar](../referencias/capturas/google-calendar-02.png)
- **Copiar**: cabecera con mes desplegable + búsqueda + icono de **hoy** + icono de **tareas**; línea de tiempo con bloques de color; **hoja inferior (bottom sheet)** para crear un evento arrastrando en la grilla y guardar con un botón; eventos y tareas (con check) conviviendo en la misma vista.
- Más capturas: [01](../referencias/capturas/google-calendar-01.png) · [03](../referencias/capturas/google-calendar-03.png) · [04](../referencias/capturas/google-calendar-04.png)

## 2.4 Síntesis: patrones que adoptaremos

| Patrón | Origen | Dónde lo usamos |
|---|---|---|
| Score que perdona fallos + gráficos limpios | Loop | Detalle de hábito |
| Anillos de progreso + botón según tipo (+1, Log) | Habitify | Lista de hábitos en Hoy |
| Secciones plegables Hoy/Mañana, hora a la derecha | TickTick | Lista de tareas |
| Captura en lenguaje natural con chips | Todoist | Botón "+" |
| Bottom sheet de creación en grilla | Google Calendar | Calendario |
| Microrecompensa al completar | Habitica | Animación/háptico, sin RPG |

## 2.5 Cómo ampliar la investigación
Estas apps se pueden instalar y estudiar de primera mano. Para una revisión más profunda: grabar la pantalla del **onboarding** y de la **creación de un elemento** en cada una, y contar toques y segundos. Estructura, además, la app **Structured** (planificador diario en línea de tiempo) y **Streaks** (iOS) — no pude descargar sus capturas automáticamente; agrégalas manualmente a `referencias/capturas/`.
