# 3. Diseño UI/UX y cómo mantenerlo simple

## 3.1 Principios
1. **Hoy primero**: la app abre en lo que toca hacer ahora, no en menús.
2. **Un toque para lo frecuente**: completar > crear > editar > configurar.
3. **Nada obligatorio salvo el nombre**; todo lo demás con valores por defecto sensatos.
4. **Divulgación progresiva**: opciones avanzadas ocultas tras "Más opciones".
5. **Sin culpa**: fallar un día no borra el progreso (puntuación tipo Loop, "días de gracia").
6. **Mismo lenguaje visual** en móvil, tablet y PC; solo cambia el layout.

## 3.2 Navegación

**Móvil** — barra inferior con 4 destinos + botón flotante central "+":

```
[ Hoy ]  [ Calendario ]  ( + )  [ Hábitos ]  [ Tareas ]
                  Ajustes → icono en cabecera de Hoy
```

**Tablet / PC** — panel lateral fijo (Hoy, Calendario, Hábitos, Tareas, Listas, Ajustes) + contenido + panel de detalle a la derecha (estilo TickTick/Todoist escritorio). Atajos: `N` nueva, `Ctrl+K` buscar, `Espacio` completar.

## 3.3 Pantallas

### A. Hoy (pantalla principal)
```
┌──────────────────────────┐
│ Lunes 28 sep      ⚙  🔍   │
│ ▓▓▓▓▓░░ 5/8 completado    │  ← progreso del día
│──────────────────────────│
│ ☀ MAÑANA                  │
│ ◯ Meditar 10 min   [ ✓ ]  │  ← hábito (anillo)
│ ◯ 💧 Agua  3/8     [ +1 ] │  ← hábito cantidad
│ ☐ Enviar informe   09:00  │  ← tarea
│ ▌Reunión equipo 10:00–11  │  ← evento (solo lectura aquí)
│ 🌙 NOCHE                  │
│ ◯ Leer 20 min      [ ▶ ]  │  ← hábito temporizador
│ ▸ Completadas (3)         │
└──────────────────────────┘
```
- Una sola lista ordenada por hora / momento del día; iconos distintos para hábito (círculo), tarea (cuadro), evento (barra de color).
- Deslizar → derecha completa, ← pospone (mañana / elegir fecha).
- Toque largo = editar rápido.

### B. Crear (botón +) — bottom sheet en 1 paso
```
┌──────────────────────────┐
│ "Llamar al banco mañana   │
│  4pm !alta"               │
│ [mañana 16:00] [Alta]     │  ← chips detectados
│ ( Tarea | Hábito | Evento)│
│ 📥 Bandeja   🏷   ⏰   ➤  │
└──────────────────────────┘
```
El usuario escribe una frase; la app detecta fecha/hora/prioridad; selector de tipo arriba. "Hábito" abre un mini-formulario de 3 campos (nombre, frecuencia, recordatorio) con **plantillas sugeridas** (Beber agua, Leer, Ejercicio, Meditar…).

### C. Hábitos
- Lista con anillo, racha 🔥 y mini-semana (7 puntos).
- **Detalle**: Overview (score, racha, total), heatmap mensual/anual, gráfico semanal/mensual, editar día pasado con un toque, notas.

### D. Tareas
- Vistas: Bandeja, Hoy, Próximos, Listas, Etiquetas. Agrupar por fecha/prioridad/lista.
- Detalle en hoja deslizable: título, notas, subtareas, fecha/hora/repetición, prioridad, lista.

### E. Calendario
- Cambio Día / 3 días / Semana / Mes / Agenda desde el título desplegable (patrón Google Calendar).
- Bloques de tres tipos: evento (color sólido), tarea con hora (con check), hábito con hora (anillo pequeño).
- Crear arrastrando en grilla; mover/redimensionar; **"tareas sin hora" en una bandeja lateral** para arrastrarlas al calendario (planificación por bloques).

### F. Estadísticas, Ajustes, Onboarding
- Estadísticas dentro del detalle de hábito + un resumen semanal (tarjeta en Hoy los domingos).
- Ajustes: tema, primer día de la semana, hora de resumen diario, notificaciones, sincronización, exportar/importar, widgets.

## 3.4 Cómo hacerlo simple para el usuario (checklist)
- **Onboarding de 3 pantallas máx.** y sin registro: "¿Qué quieres mejorar?" → elegir 1–3 plantillas de hábito → listo (pantalla Hoy ya con contenido). Pedir permiso de notificaciones **en contexto** (al crear el primer recordatorio), no al abrir.
- **Estado vacío que enseña**: ilustración + un botón ("Crea tu primer hábito").
- **Valores por defecto**: hábito diario, tarea sin fecha → Bandeja, recordatorio a la hora elegida.
- **Deshacer** (snackbar) en vez de diálogos de confirmación.
- **Máx. 5 destinos** en la navegación principal; nada de menús de 3 niveles.
- **Complejidad opcional**: modos "Simple" (solo Hoy + hábitos + tareas) y "Completo" (calendario, etiquetas, listas) activables en Ajustes.
- **Accesibilidad**: contraste AA, tamaño de fuente del sistema, objetivos táctiles ≥ 48 dp, lector de pantalla, no depender solo del color.
- **Prueba de 5 usuarios** con prototipo antes de programar (ver roadmap).

## 3.5 Sistema de diseño (propuesta)
- **Material 3** como base (Flutter lo trae) con personalización propia; esquinas 16–20 dp; mucho espacio en blanco.
- **Color**: neutro claro/oscuro + un color de acento (p. ej. azul-índigo, como TickTick, o verde-menta para "progreso"). Cada hábito/lista tiene su color; usar paleta de 12 colores accesibles.
- **Tipografía**: Inter o la de Material (Roboto/Google Sans); 4 tamaños (título 24, subtítulo 18, cuerpo 16, detalle 13).
- **Iconos**: Material Symbols redondeados + emoji opcional por hábito.
- **Movimiento**: 150–250 ms; anillo que se llena, check con háptico suave; sin animaciones que retrasen.
- **Layout adaptable**: `<600 dp` móvil (1 columna), `600–1024` tablet (2 paneles), `>1024` escritorio (3 paneles).

## 3.6 Prototipado
1. Wireframes en **Figma** (gratis) de las 6 pantallas anteriores, móvil y escritorio.
2. Prototipo clicable → test con 5 personas: "crea un hábito", "agrega una tarea para mañana", "marca lo de hoy".
3. Recién entonces, programar. (Alternativa rápida: maquetar directamente con Flutter, que permite hot-reload.)
