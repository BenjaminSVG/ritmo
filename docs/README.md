# Ritmo — documentación de diseño y estado del código

Plataformas objetivo: Android, iOS, Windows (y opcionalmente macOS/Linux/Web) con **un solo código**.

## Índice

| # | Documento | Contenido |
|---|-----------|-----------|
| 1 | [docs/01-producto-y-funcionalidades.md](01-producto-y-funcionalidades.md) | Visión, usuarios, funciones MVP / v1 / v2, modelo de negocio |
| 2 | [docs/02-referencias-ui-ux.md](02-referencias-ui-ux.md) | Capturas de apps existentes y qué copiar / evitar de cada una |
| 3 | [docs/03-diseno-ui-ux-y-simplicidad.md](03-diseno-ui-ux-y-simplicidad.md) | Pantallas, navegación, wireframes, sistema de diseño, cómo mantenerlo simple |
| 4 | [docs/04-tecnologias-y-lenguajes.md](04-tecnologias-y-lenguajes.md) | Comparativa Flutter / React Native / KMP / nativo y decisión |
| 5 | [docs/05-arquitectura-datos-y-sync.md](05-arquitectura-datos-y-sync.md) | Arquitectura, modelo de datos, offline-first, sincronización, notificaciones |
| 6 | [docs/06-widgets.md](06-widgets.md) | Widgets Android / iOS / escritorio, cómo se construyen con Flutter |
| 7 | [docs/07-roadmap-testing-lanzamiento.md](07-roadmap-testing-lanzamiento.md) | Fases, calendario, testing, publicación, costos, riesgos |
| 8 | [docs/08-referencias-widgets.md](08-referencias-widgets.md) | Capturas de widgets de otras apps y de los nuestros en el emulador |
| 9 | [docs/09-gamificacion-personaje-pixelart.md](09-gamificacion-personaje-pixelart.md) | **Planificación (v2)** del personaje pixel art: hombre y mujer, 8 tonos de piel, monedas y estrellas, metas a años, tienda, widget |
| 10 | [docs/10-arte-pixelart-prompts-chatgpt.md](10-arte-pixelart-prompts-chatgpt.md) | Pixel art tierno: paleta propia, tamaños, textos para ChatGPT y método para las imágenes |
| 11 | [docs/11-catalogo-de-objetos.md](11-catalogo-de-objetos.md) | **Catálogo completo** de ropa, calzado, anteojos, auriculares, pelo, collares, fondos y más, con capas, cantidades y etapas |
| — | [docs/fuentes.md](fuentes.md) | Enlaces consultados |


## Estado del código (carpeta [app/](../app/))

Flutter 3.47 instalado en `C:\src\flutter`; Android Studio y SDK de Android instalados.

**Implementado**: hábitos y tareas (crear, editar, subtareas, repetición, fecha y hora límite, tipos —Tarea, Actividad, Prueba, Entrega, Reunión, Recordatorio— y color propio por tarea), rachas y puntuación, captura rápida en lenguaje natural (ES/EN), pantallas Hoy / Calendario (mes, semana y día, con tareas movibles arrastrando, creables tocando una hora libre y con duración) / Hábitos (mapa de calor) / Tareas / Ajustes (exportar-importar), navegación adaptable, recordatorios locales en Android (tareas con hora y hábitos), cuatro widgets de Android, todos de solo lectura (Hoy con botón "+", Hábitos, Racha y calendario de calor, Añadir rápido). Referencias de widgets de otras apps en [docs/08-referencias-widgets.md](08-referencias-widgets.md).

**Personaje pixel art (primer tramo de la fase G2)**: pestaña "Personaje" con la escena (fondo de dormitorio 384×192 y personaje 64×96 por capas, con leve balanceo) y controles para elegir **cuerpo** (Hombre A/B, Mujer A/B), **musculatura** (5 niveles, manual por ahora), **piel** (8 tonos), **pelo** (24 colores) y **ojos** (12 colores). Se guarda en la base de datos (esquema v4). Probado en el emulador, incluido que se conserva al reabrir la app. **Monedas y experiencia (fase G1, primer tramo)**: libro de movimientos en la base de datos (esquema v5). Hábito hecho +10 🪙, tarea +3 (+1 si es de prioridad alta), Prueba/Entrega a tiempo +5, todos los hábitos del día +20, tope de 150 🪙 y 8 tareas premiadas por día, solo hoy y ayer, sin duplicar al marcar y desmarcar, regalo de bienvenida de 100 🪙, nivel de cuenta por XP. Se muestra en la pestaña Personaje. Cada hábito tiene ahora una **categoría** (esquema v6) y la **musculatura sube sola** según los días de ejercicio de los últimos 365 días (20 → nivel 1, 70 → 2, 150 → 3, 260 → 4; baja despacio, sin castigo); se puede pasar a manual. Todavía sin: hitos de racha y ⭐, respaldo del libro, simulador de economía. Todavía **sin**: ropa y accesorios, tienda, musculatura automática por hábitos, widget del personaje, más peinados y formas de ojos (solo hay 1 de cada). Planificación en [docs/09](09-gamificacion-personaje-pixelart.md), [docs/10](10-arte-pixelart-prompts-chatgpt.md) y [docs/11](11-catalogo-de-objetos.md).

**Ropa y widget del personaje**: ropa de torso (camiseta, buzo), piernas (pantalón, short, pollera), pies (zapatillas) y traje (vestido) dibujada por cuerpo y nivel de musculatura, con la regla de ocultamiento (un pantalón, short, pollera o vestido oculta la ropa interior del cuerpo; un vestido tapa torso y piernas) y las zapatillas realineadas por código a los pies de cada cuerpo (`tools/alinear_calzado.ps1`). La tienda muestra una vista previa de cada objeto puesto sobre TU personaje, y hay un cuarto widget de Android, "Mi personaje", con la escena completa, el nombre, las monedas y el nivel (se redibuja cuando cambia el personaje o el saldo). Vista previa de conjuntos: `RITMO_PREVIEW=1 flutter test test/outfit_preview_test.dart`.

**Fondos y tono (esquema v8)**: 13 fondos de escena (dormitorio y parque gratis) elegibles desde el armario, y un interruptor Rosa/Azul (azul por defecto) que cambia el color de la escena por código y con qué color se estrenan las prendas. Nueve accesorios de cabeza nuevos y cuatro anteojos más entraron al catálogo. **Armario y tienda**: en la pestaña Personaje, un armario con 3 ranuras de cabeza (Sombrero, Cara, Auriculares) y 3 objetos (gorra que oculta el pelo, anteojos redondos, auriculares), con 12 colores para teñir la gorra y los auriculares; guardado en la base de datos (esquema v7). Botón "Tienda": los objetos se compran con monedas según su rareza (común 90, raro 400, épico 1.300); lo comprado sale del libro de movimientos, no se compra dos veces ni deja saldo negativo, y el armario solo muestra lo que tienes. Probado en el emulador. Falta la ropa de torso, piernas y pies (arte pendiente de ChatGPT).

**Verificado en un emulador de Android (Pixel 7, Android 35), no en un teléfono real**: la app arranca; captura rápida con fecha, hora y prioridad; permiso de notificaciones al crear el primer recordatorio; una alarma del sistema queda programada para la tarea con hora; los widgets Hoy, Hábitos y Racha y calendario se dibujan con datos reales (capturas en `referencias/widgets/ritmo-widget-*-emulador.png`); el botón "+" abre "Nueva tarea".

**Sin verificar todavía**: que la notificación llegue y se vea a su hora, el widget "Añadir rápido", que los widgets se actualicen al cambiar datos con la app abierta, el cambio de día a medianoche, el comportamiento con ahorro de batería y cualquier prueba en un teléfono físico.

**Logo**: un brote con un check amarillo (cada hábito cumplido te hace crecer) en píxeles, blanco sobre el azul de la app. Iconos de Android (adaptable, redondo y de notificaciones), Windows (.ico) y web generados con `tools/hacer_iconos.ps1`; el logo elegido y el nombre "Ritmo" en letras pixel están en `referencias/logo/`.

**Detalles a pulir**: las vistas previas del selector de widgets siguen siendo las de Flutter por defecto, y el icono no está verificado todavía en un teléfono o emulador.

**Guardado**: SQLite con Drift (web, Windows y Android). Los datos del guardado anterior (shared_preferences) se importan solos una sola vez. Cada cambio reescribe todas las filas; se pasará a escrituras por fila cuando se sincronice.

**Pendiente**: sincronización (necesita cuenta de Supabase), widgets con interacción (completar desde el widget), iOS, y repetir las pruebas en un teléfono Android real.

Comandos (desde `app/`): `flutter test` · `flutter analyze` · `flutter run -d edge` (web).

Compilar por plataforma (el proyecto vive en `C:\dev\ritmo`, ruta corta: la de OneDrive superaba los 260 caracteres de MSBuild):
- **Android**: `JAVA_HOME` = `C:\Program Files\Android\Android Studio\jbr`, luego `flutter build apk --debug`.
- **Windows**: `flutter build windows --debug` (necesita el Modo desarrollador de Windows y Visual Studio Build Tools con C++ y ATL).
- **Web**: `flutter build web`. Tras cambiar las tablas de Drift: `dart run build_runner build`.

## Decisiones clave (resumen de una página)

1. **Local-first**: todo funciona sin internet y sin cuenta. La nube (sync) es opcional.
2. **Una sola app, tres pilares** unidos por una pantalla **Hoy**: hábitos + tareas + eventos del día en una sola lista/línea de tiempo.
3. **Stack**: **Flutter + Dart**, base de datos local **SQLite (Drift)**, sync con **Supabase** (Postgres) en fase 2. Widgets nativos: **Kotlin (Jetpack Glance)** en Android y **Swift (WidgetKit)** en iOS, conectados con el paquete `home_widget`.
4. **Simplicidad**: crear un hábito o tarea en ≤ 3 toques / 1 frase; marcar en 1 toque; nada obligatorio salvo el nombre.
5. **Orden de construcción**: Android + Windows primero (se puede hacer desde tu PC Windows), iOS después (requiere una Mac o compilación en la nube).
6. **MVP** en ~10–12 semanas trabajando a tiempo parcial (ver roadmap).

## Novedades más recientes

- **Formas de ojos** (esquema v9): 9 estilos (clásicos, grandes, dulces, brillantes, almendrados, soñolientos, felices, decididos y puntitos) elegibles en la pestaña Personaje. La sonrisa ahora es una capa aparte (`assets/pixel/mouth/`), para poder sumar más bocas; herramienta `tools/procesar_ojos.ps1`.
- **Simulador de economía**: `dart run tool/simular_economia.dart` (desde `app/`). Con el catálogo actual (35 objetos, 9.920 🪙 en total) un usuario típico lo completa en unos 6 meses, y uno casual en 1,4 años; por eso el catálogo de lanzamiento debe rondar los 250 objetos (ver docs/09 §9.6).
- **Sombrero de mago**: `headCutRow` oculta las filas de la cabeza que asomaban por los lados de la copa.
- **Pendiente de arte** (textos ya preparados en `referencias/arte/prompts/rostro-y-pelo.txt`): narices, bocas y 23 imágenes de pelo (con capa trasera para los peinados largos).
