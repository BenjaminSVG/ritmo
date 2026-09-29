# 1. Producto y funcionalidades

## 1.1 Visión
Una app que responde a una sola pregunta: **"¿Qué tengo que hacer hoy?"** — incluyendo hábitos recurrentes, tareas puntuales y eventos con hora — sin obligar al usuario a saltar entre tres apps.

Problema que resuelve: hoy la gente usa un tracker de hábitos (Loop, Streaks), un to-do (Todoist) y un calendario (Google Calendar) por separado. TickTick es la única que los junta bien, pero se siente densa y muchas funciones están tras suscripción.

Propuesta de valor: **TickTick-completo pero tan simple como Streaks**, gratis para lo básico, privado y offline.

## 1.2 Usuarios objetivo
| Perfil | Necesidad | Qué prioriza |
|---|---|---|
| Estudiante | Estudiar a diario + entregas | Tareas con fecha, hábitos con racha, widget |
| Profesional | Reuniones + rutinas | Calendario, recordatorios, escritorio |
| Persona que crea rutinas | Constancia | Rachas, estadísticas, motivación sin culpa |

## 1.3 Funcionalidades por fase

### MVP (v0.1 – v1.0)
**Hábitos**
- Crear hábito: nombre, icono, color, frecuencia (diario / días de la semana / X veces por semana / cada N días).
- Tipos: **Sí/No**, **Cantidad** (p. ej. 8 vasos, 5 km), **Temporizador** (minutos).
- Marcar en 1 toque desde Hoy; deshacer.
- Racha actual, mejor racha, % de cumplimiento, calendario-calor (heatmap) mensual/anual.
- Recordatorios (varios por hábito) y momento del día (mañana/tarde/noche).
- Archivar en lugar de borrar (no se pierde historial).

**Tareas**
- Título, notas, fecha, hora, prioridad (4 niveles), lista/proyecto, etiquetas.
- Subtareas, repetición (diaria, semanal, personalizada).
- **Entrada rápida en lenguaje natural**: "Llamar al banco mañana 4pm !alta" → se interpreta fecha, hora y prioridad (idea tomada de Todoist).
- Bandeja de entrada (Inbox) y vistas: Hoy, Próximos, Todas.

**Calendario**
- Vistas Día, Semana (3 días en móvil), Mes, Agenda (lista).
- Muestra **eventos + tareas con hora + hábitos con hora** en una sola línea de tiempo.
- Crear/mover evento arrastrando (como Google Calendar).
- Importar calendarios del dispositivo (lectura) en v1.

**Transversal**
- Pantalla **Hoy** unificada, tema claro/oscuro, español + inglés, respaldo/exportación local (JSON/CSV).
- Widgets básicos (ver [06-widgets](06-widgets.md)).

### v1.x
- Sincronización multi-dispositivo (cuenta opcional), web/PC con la misma cuenta.
- Sincronizar con Google Calendar / CalDAV (bidireccional).
- Widgets avanzados, notificaciones accionables (marcar desde la notificación).
- Temporizador Pomodoro/enfoque ligado a una tarea o hábito.
- Estadísticas semanales/mensuales, resumen semanal.
- Integraciones de salud (Health Connect / Apple Health) para hábitos automáticos (pasos, sueño).

### v2 (ideas)
- Compartir listas / hábitos con pareja o amigos.
- Voz → tareas (dictado) e IA para planificar el día (sugerir huecos).
- Plantillas de rutinas, desafíos de 21/30 días, logros.
- Apple Watch / Wear OS.

## 1.4 Fuera de alcance del MVP (a propósito)
Gamificación tipo RPG (Habitica), redes sociales, IA, colaboración en equipo. Se agregan solo si el núcleo ya es sólido.

## 1.5 Modelo de negocio (opcional)
- **Gratis**: hábitos, tareas, calendario, widgets básicos, sin anuncios.
- **Pro** (pago único ~US$ 12–20 o suscripción baja): sync ilimitado en dispositivos, widgets extra, temas, estadísticas avanzadas, integraciones.
- Referencia de mercado: Streaks cobra un pago único de US$ 5,99; Loop es gratis y de código abierto; TickTick y Todoist usan suscripción.

## 1.6 Métricas de éxito
- Activación: % de usuarios que crean un hábito/tarea en la primera sesión (meta > 70 %).
- Retención D7 / D30, tareas y hábitos completados por usuario activo/semana.
- Tiempo para crear un elemento (meta < 10 s).
