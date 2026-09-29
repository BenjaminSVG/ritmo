# 9. Sistema de juego: personaje pixel art, monedas y tienda

Estado: **planificación** (versión 2, con tus decisiones del 2026-09-29). Nada de esto está programado todavía. Se apoya en lo que ya existe: hábitos, tareas con tipo y color, base de datos Drift y widgets de Android.

Los textos para generar las imágenes con ChatGPT están en [10-arte-pixelart-prompts-chatgpt.md](10-arte-pixelart-prompts-chatgpt.md).

## 9.1 Decisiones confirmadas

| Tema | Decisión |
|---|---|
| Personajes | **Hombre y mujer**, cada uno con **2 siluetas**, y **8 tonos de piel** |
| Monedas por tareas | **Sí, pero menos** que por hábitos |
| Duración | Diseñado para **años** de uso: mucho contenido, contenido nuevo cada mes y metas a corto, medio y largo plazo |
| Dinero real | **No** habrá compras ni publicidad de pago dentro del juego |
| Castigos | **No** hay vidas, pérdidas ni mensajes de culpa |
| Estilo | **Pixel art tierno** (redondeado, ojos grandes, colores suaves) |

## 9.2 La idea en una frase

Cada hábito o tarea que completas da **monedas y experiencia**; tu personaje pixel art **evoluciona** (más musculoso cuanto más constante eres con el ejercicio), y con las monedas compras **ropa, fondos y compañeros** que se ven igual **dentro de la app y en un widget** de la pantalla de inicio.

## 9.3 Principios de diseño

1. **Solo cosmético.** Las monedas no desbloquean funciones de la app.
2. **Sin castigos.** Fallar un día no quita monedas ni ropa. Lo único que puede bajar, despacio, es la musculatura, y nunca por debajo del aspecto base.
3. **Sin azar que se parezca a apostar.** No hay cajas sorpresa ni "tiradas". Todo lo que se consigue es **determinista**: sabes qué compras y qué recibes. Los cofres son de "elige 1 de 3".
4. **Sin miedo a perderse algo (FOMO).** Todo objeto de temporada **vuelve** más adelante (ver 9.9).
5. **Local primero**, como el resto de Ritmo.
6. **Se puede apagar** todo el sistema, y por separado el cambio de musculatura.
7. **Transparente:** un historial muestra de dónde salió cada moneda.
8. **Sin incentivos dañinos:** topes diarios; sin plantillas de dietas restrictivas.

## 9.4 El personaje

### Creación (se puede saltar y cambiar después, gratis)

| Opción | Cantidad inicial | Cómo se hace |
|---|---|---|
| **Cuerpo** | **4**: Hombre A, Hombre B, Mujer A, Mujer B (siluetas distintas) | Arte propio (5 niveles de musculatura cada uno) |
| **Tono de piel** | **8**, de muy claro a muy oscuro | Recolor en código |
| **Peinado** | 24 | Arte propio; color por recolor |
| **Color de pelo** | 16 naturales + 8 de fantasía (se desbloquean) | Recolor en código |
| **Ojos** | 8 formas × 12 colores | Forma: arte; color: recolor |
| **Cejas** | 4 | Arte |
| **Vello facial** (opcional) | 6 | Arte |
| **Rasgos** (pecas, rubor, lunares, cicatriz…) | 10 | Arte |
| **Nombre** | libre | — |

El cuerpo y la ropa **no están atados al género**: cualquier prenda de cualquier corte se puede poner a cualquier cuerpo (la prenda tiene una versión por corte). Más adelante se puede añadir un cuerpo neutro con la misma técnica.

### Musculatura: 5 niveles (para cada uno de los 4 cuerpos)

| Nivel | Nombre | Cómo se ve (idea) |
|---|---|---|
| 0 | Principiante | Complexión suave y neutra |
| 1 | Activo | Un poco más definido |
| 2 | Atlético | Brazos y torso marcados |
| 3 | Fuerte | Claramente musculoso |
| 4 | Legendario | Muy musculoso, con un brillo especial |

Se mantiene el estilo tierno: siempre proporciones "chibi" simpáticas, sin exagerar.

**Qué mide.** Un **puntaje de fuerza** de 0 a 1: el promedio de la **puntuación de hábito** (la que ya calcula la app, que perdona días fallados) de los hábitos de categoría **Ejercicio**.

| Sube a nivel | Puntaje ≥ | Baja de nivel si puntaje < |
|---|---|---|
| 1 | 0,20 | 0,15 |
| 2 | 0,40 | 0,35 |
| 3 | 0,60 | 0,55 |
| 4 | 0,80 | 0,75 |

Suavizado: nunca baja más de **1 nivel por semana**; el **modo descanso** (vacaciones, enfermedad, lesión) congela nivel y rachas; sin hábitos de ejercicio se queda en el nivel 0 y la pantalla sugiere crear uno; el aspecto base es **neutro y simpático**, nunca "decaído".

### Otras categorías (mejora posterior)
Solo efectos pequeños y **no corporales**: agua → botella o brillo; mente → gafas, libro flotante o aura; sueño → animación de descanso.

### Categoría de hábito (dato nuevo)
Ejercicio, agua, alimentación, mente, sueño, estudio, social u otro. Las plantillas la asignan; se cambia al editar. Los hábitos que ya existen quedan en "otro" y la primera vez que se abre el personaje se pregunta una vez cuáles son de ejercicio.

## 9.5 Economía base

### Dos monedas

| Moneda | Cómo se gana | Para qué sirve |
|---|---|---|
| 🪙 **Monedas** | Completando hábitos y tareas, misiones semanales | Casi todo el catálogo |
| ⭐ **Estrellas** | **Solo** por logros, hitos de racha, temporadas y maestría (nunca por rutina diaria) | Objetos legendarios y míticos, exclusivos y de colección |

Las estrellas existen para que siempre haya **metas aspiracionales** aunque ya tengas montones de monedas, y para que no se pueda "comprar todo solo con rutina". **Se ganan jugando, no se compran.**

### Cuánto se gana

| Acción | 🪙 | XP | Notas |
|---|---|---|---|
| Hábito sí/no completado | **10** | 10 | Una vez por hábito y día |
| Hábito de cantidad (agua…) | **10** | 10 | Solo al **llegar a la meta**, no por cada "+1" |
| **Tarea** completada | **3** | 3 | +1 si es de prioridad alta. **Menos que un hábito, a propósito** |
| Prueba o Entrega completada **antes de vencer** | +5 | +5 | Aprovecha los tipos de tarea |
| Todos los hábitos del día | +20 | +20 | Una vez al día |
| Hito de racha por hábito: 7 / 30 / 100 / 365 días | 50 / 200 / 1000 / 3000 | igual | Una vez por hábito y hito; además da ⭐ (1 / 3 / 10 / 30) |

**Topes:** máximo **150 🪙 diarias** por acciones normales (los hitos y misiones no cuentan) y máximo **8 tareas** con premio por día.

**Ritmo típico:** 3 hábitos + 3 tareas al día ≈ 30 + 9 + 20 = **unas 60 🪙 al día ≈ 21.900 al año**.

### Reglas para que no se pueda hacer trampa fácil (y sin castigar)
- **Libro de movimientos idempotente:** cada premio se guarda con clave `(tipo, elemento, día)`; marcar, desmarcar y volver a marcar **no duplica**.
- **Desmarcar el mismo día** revierte ese premio; un día anterior no toca nada.
- **Ventana de premio:** solo **hoy y ayer**. Editar días viejos en el mapa de calor no da monedas.
- **Sin retroactividad**, pero un **regalo de bienvenida de 100 🪙** al activar el juego.
- **Reloj del teléfono:** no se persigue (juego individual y cosmético); si hay sincronización o rankings, el servidor validará.
- **Saldo** = suma del libro de movimientos; comprar es una transacción que **nunca deja saldo negativo**; el precio sale del catálogo.

## 9.6 Diseñado para durar años

Un juego cosmético se abandona cuando **se acaba el contenido** o **ya no hay nada que desear**. Este diseño ataca las dos cosas con cinco capas de metas.

### Capa 1 · Cada día
Completar lo del día (monedas, XP), racha, todo hecho (+20). **Nunca hay una cuenta atrás.**

### Capa 2 · Cada semana
- **3 misiones semanales personalizadas** con *tus* hábitos, por ejemplo "Haz ejercicio 4 días esta semana" o "Completa 10 tareas". Dan 🪙 y a veces ⭐. Si no las cumples, **no pasa nada**: la semana siguiente hay otras.
- **Cofre semanal "elige 1 de 3":** ofrece tres objetos que **aún no tienes**; la rareza depende de cuántas semanas llevas activo (nunca de una racha que se rompe).

### Capa 3 · Cada temporada (3 meses)
- **4 temporadas al año** con tema (primavera, verano, otoño, invierno) y una **vía de 30 hitos** que avanza con tus **días activos** (no con gasto). Da objetos exclusivos de temporada.
- Eventos de calendario ligeros (Halloween, Navidad, aniversario de la app, **cumpleaños del usuario**).
- **Sin FOMO:** todo lo de una temporada pasa al **Archivo**, que vuelve a la tienda al año siguiente.

### Capa 4 · Colección
- **Sets** de 5–6 piezas con **bonus al completarlos** (una insignia y ⭐).
- **Álbum** que muestra el porcentaje coleccionado por categoría.
- Los **logros** (200+ al lanzar y creciendo) dan ⭐, insignias y títulos, por ejemplo "Primera semana", "30 días seguidos", "100 tareas", "10 pruebas entregadas a tiempo".

### Capa 5 · Toda la vida
- **Nivel de cuenta 1–100:** el XP para pasar del nivel *n* al siguiente es `100 + 30·n` (a ~60 XP/día se llega al 100 en unos **7 años**). Desbloquea objetos y da monedas.
- **Después del 100: rangos de maestría** infinitos (cada 5.000 XP), que dan ⭐ y marcos exclusivos.
- **Insignias de veteranía:** 1, 2, 3… años usando la app.

### Contenido: mucho y siempre creciendo

| Categoría | Ejemplos |
|---|---|
| **Ropa** en 7 ranuras | cabeza, cara, torso, piernas, pies, accesorio de espalda/mano, cuerpo completo |
| **Trajes completos** (personajes) | ninja, astronauta, chef, superhéroe, mago… |
| **Pelo, vello facial, rasgos** | más peinados y colores de fantasía |
| **Fondos de escena** | de 8 al inicio a decenas |
| **Habitación** (fase posterior) | el fondo se vuelve un cuarto con **muebles** colocables: una fuente enorme de contenido |
| **Compañeros** | mascotas que evolucionan con tus hábitos |
| **Marcos y temas de widget** | bordes pixel y temas para los widgets |
| **Poses y emotes**, **títulos e insignias** | reconocimiento sin valor de mercado |

**Truco para producir mucho arte con poco trabajo:** cada prenda se dibuja **una vez** y se vende en **variantes de color** (por recolor en código). Un diseño de camiseta × 8 colores = **8 objetos** con el arte de uno.

### Cuánto contenido y cuándo

| Momento | Diseños nuevos | Objetos en catálogo (con colores) |
|---|---|---|
| Versión mínima jugable (G3) | ~40 | ~120 |
| Lanzamiento | ~80 | **~250** |
| Cada mes después | +6 a +10 diseños | +40 a +60 |
| Fin del año 1 | ~180 | ~800 |
| Año 2 | ~280 | ~1.300 |
| Año 3 | ~380 | ~1.800 |

### Precios y por qué esto dura años
Los precios se derivan del ingreso típico (60 🪙/día), no al revés:

| Rareza | Precio | Tiempo típico para conseguirlo |
|---|---|---|
| Común | 60–120 🪙 | 1–2 días |
| Raro | 300–480 🪙 | 5–8 días |
| Épico | ~1.300 🪙 | ~3 semanas |
| Legendario | ~3.600 🪙 + ⭐ | ~2 meses |
| Mítico | ~11.000 🪙 + ⭐⭐ | ~6 meses |

**Presupuesto del catálogo de lanzamiento** (250 objetos): 100 comunes × 90 + 60 raros × 400 + 30 épicos × 1.300 + 8 legendarios × 3.600 + 2 míticos × 11.000 ≈ **122.800 🪙**. A ritmo típico son **unos 5,6 años** para completarlo todo, y **el catálogo sigue creciendo**. Un usuario muy constante (tope de 150 🪙/día ≈ 54.700 al año) tardaría unos 2,2 años, y aun así las ⭐ y las colecciones siempre le dejan metas.

**Se ajusta con datos:** en la fase G1 se escribe un **simulador de economía** (un script con perfiles casual, típico y constante) para afinar precios antes de fijarlos, y los precios viven en el catálogo (se pueden corregir sin tocar el código).

### Volver tras una pausa (sin culpa)
Si pasan 7 o más días sin abrir la app, al volver aparece un **regalo de bienvenida** (un cofre "elige 1 de 3" y algunas monedas), sin ningún mensaje del tipo "perdiste tu racha".

## 9.7 Tienda, armario y catálogo

**Ranuras:** cabeza, cara, torso, piernas, pies, accesorio, cuerpo completo (traje), fondo, marco de widget y compañero.

**Estados de un objeto:** bloqueado (requiere nivel, logro o temporada) · comprable · poseído · equipado.

**Catálogo:** un archivo versionado (`assets/catalog.json`) con identificador estable, nombre, precio, moneda, rareza, ranura, corte(s), imagen, colores disponibles, conjunto al que pertenece, requisito y temporada. Añadir contenido = añadir filas y arte.

**Estabilidad a largo plazo:** los identificadores **nunca se reutilizan ni cambian**, para que el inventario de años atrás siga funcionando. Un objeto retirado se marca como "archivado", no se borra.

**Arte de la ropa y la musculatura:** una prenda de torso tiene **3 tallas** (S para los niveles 0–1, M para 2–3, L para el 4) en **2 cortes** (masculino y femenino) = 6 imágenes por diseño; pantalones, 2 cortes; pies, gorros, accesorios: una versión (los gorros llevan una marca para ocultar el pelo).

## 9.8 Datos (Drift, esquema v4)

| Tabla | Contenido |
|---|---|
| `avatar_profile` | nombre, cuerpo, piel, peinado, color de pelo, ojos, color de ojos, cejas, vello facial, rasgos |
| `coin_ledger` | `id`, tipo, elemento, día, monedas, estrellas, xp, nota, fecha. **Único** en (tipo, elemento, día) |
| `inventory` | objeto, variante de color, fecha, precio pagado |
| `equipped` | ranura → objeto |
| `achievement` | logro y fecha |
| `mission` | misión semanal, semana, progreso, cobrada |
| `season_progress` | temporada y hito alcanzado |
| columna `habit.category` | categoría del hábito |
| ajustes | juego activado, cambio corporal, modo descanso |

- El **saldo y la experiencia se derivan** del libro de movimientos (con una caché).
- **Sincronización futura:** libro e inventario son solo-añadir (se unen sin conflicto); lo equipado se resuelve por ranura.
- **Migraciones:** el catálogo crece cada mes, pero los datos del usuario solo guardan identificadores, así que **actualizar la app no rompe nada**.
- El **respaldo** (exportar/importar) debe incluir todo lo anterior.

## 9.9 Cómo se dibuja (Flutter)

- **Lienzo del personaje: 64×96 píxeles.** **Fondo de escena: 384×192** (proporción 2:1: encaja en un widget 4×2 y como cabecera). Para 2×2 se recorta el centro.
  - *Por qué 64×96 y no 48×64:* se probó reduciendo un cuerpo real generado por IA a los dos tamaños. A 48×64 los niveles de musculatura 1–3 casi no se distinguen y los ojos se pierden; a 64×96 se marcan los abdominales y los ojos se leen. La comparación está en `referencias/arte/prueba/`.
  - **El cuerpo base es "calvo y sin rasgos":** cabeza sin pelo, sin cejas y sin ojos ni boca. Todo eso son capas aparte (pelo, cejas, ojos), si no, las capas se superpondrían a lo ya dibujado.
- **Escalado con números enteros y sin suavizado** (`FilterQuality.none`).
- **Capas** con el mismo lienzo y **punto de anclaje** (centro de los pies): fondo → sombra → cuerpo → rasgos → ojos → cejas → pantalón → zapatos → torso → vello facial → pelo → gorro → accesorio → compañero.
- Un widget **`PixelAvatar`** compone las capas y guarda el resultado en caché.
- **Recolor en código** (piel, pelo, ojos y variantes de color de la ropa): al cargar una imagen se sustituyen colores exactos de la paleta base por los nuevos.
- **Animación en código:** balanceo de 1 píxel y parpadeo de 2 fotogramas; no hacen falta hojas de sprites animados.
- **Paleta propia de 24 colores** más 8 rampas de piel (ver documento de arte) y una **fuente pixel** de licencia abierta para los números.
- **Contenido descargable (posterior):** para no depender de actualizar la app cada mes, se puede publicar el catálogo y las imágenes nuevas como **paquetes de contenido** descargables (solo datos e imágenes, sin código). Requiere alojamiento y revisar las reglas de las tiendas; se decide cuando el ritmo mensual lo pida.

## 9.10 Widget del personaje

- **Widget nuevo "Personaje"**, 4×2 y 2×2: fondo + personaje + 🪙 + ⭐ + 🔥 racha + barra de nivel.
- Flutter dibuja la escena completa como imagen (con texto en fuente pixel) y el widget nativo solo la muestra: **idéntico a la app**.
- **Fondo de widget comprable** y, en una segunda etapa, **marcos y temas** pixel para Hoy y Hábitos.
- **Solo lectura**; tocarlo abre la pantalla del personaje.
- **Limitaciones:** no se anima; se actualiza cuando la app está abierta y cambia algo (si un día se completan hábitos desde otros widgets habrá que redibujar en segundo plano); a medianoche puede mostrar datos del día anterior hasta la siguiente actualización programada.

## 9.11 Experiencia dentro de la app

- **Quinta pestaña "Personaje"** (Hoy, Calendario, Hábitos, Tareas, Personaje); en tablet y PC va en el riel lateral.
- **Pantallas:** Personaje (escena, nivel, XP, 🪙, ⭐, racha) · Creador · Armario · Tienda · Misiones y temporada · Álbum y logros · Historial de monedas · Ajustes de juego (apagar, congelar el cuerpo, modo descanso, reiniciar).
- **Recompensas breves:** monedas "+10" que vuelan al contador con un háptico suave; mini personaje y monedas en la cabecera de **Hoy**; tarjeta de celebración al subir de nivel (se puede cerrar).
- **Sin presión:** ni cuentas atrás, ni "¡pierdes tu racha!", ni notificaciones de culpa.

## 9.12 Integración con lo que ya existe

| Ya existe | Cómo se usa |
|---|---|
| Puntuación de hábito (tipo Loop) | Base del puntaje de fuerza |
| Rachas | Hitos con premio |
| **Tipos de tarea (Prueba, Entrega…)** | Bonus por entregar a tiempo y logros específicos |
| Prioridad de tarea | +1 moneda en las de prioridad alta |
| Plantillas de hábito | Asignan la categoría |
| `WidgetSync` y `renderFlutterWidget` | Mismo mecanismo que el calendario de calor para el widget Personaje |
| Drift (v3 → v4) | Tablas nuevas y columna de categoría |
| Exportar/importar respaldo | Debe incluir personaje, monedas, inventario y equipado |

## 9.13 Pruebas

- **Economía:** libro idempotente; desmarcar revierte; días viejos no dan; topes; ventana hoy/ayer; tareas dan menos que hábitos.
- **Simulador de economía** con tres perfiles (casual, típico, constante) para validar los tiempos de la tabla de precios.
- **Musculatura:** umbrales con histéresis, bajada máxima semanal, modo descanso, sin hábitos de ejercicio.
- **Tienda:** compra transaccional, sin saldo negativo, sin duplicados, lo bloqueado no se compra.
- **Catálogo:** todos los identificadores son únicos y cada imagen existe (una prueba automática que recorre `catalog.json`).
- **Migración** de la base de datos y **respaldo** completo.
- **Golden tests** del personaje compuesto en los 4 cuerpos × 5 niveles: las capas deben encajar.
- **Widget** en emulador y, después, en teléfono real.

## 9.14 Fases y estimación

Para una persona a tiempo parcial (~15–20 h/semana). El arte avanza en paralelo desde el principio.

| Fase | Contenido | Semanas |
|---|---|---|
| **G0** | Paleta, plantillas de los 4 cuerpos, catálogo inicial; primeras imágenes | 2 |
| **G1** | Categoría de hábito; libro de 🪙/⭐/XP; reglas; **simulador de economía**; tests | 2 |
| **G2** | `PixelAvatar` (capas, recolor, animación); pantalla Personaje; creador con 4 cuerpos y 8 pieles | 3 |
| **G3** | Catálogo, tienda, armario, compras (~120 objetos) | 2 |
| **G4** | Widget "Personaje" (4×2 y 2×2) | 1 |
| **G5** | Misiones semanales, cofre "elige 1 de 3", logros | 2 |
| **G6** | Temporadas, Archivo, álbum y sets; ajustes de juego; pulido | 2 |
| **Total** | | **14–16** |

**Después** (ya con la app en uso): habitación con muebles, compañeros, paquetes de contenido descargables, y **+6 a +10 diseños al mes**.

Cada fase deja algo utilizable: tras G1 se acumulan monedas; tras G2 se ve el personaje; tras G3 se compra; tras G4 aparece en la pantalla de inicio.

## 9.15 Riesgos

| Riesgo | Mitigación |
|---|---|
| **Producir arte cada mes durante años** | Diseño una vez + variantes de color por código; lotes de 5–8 prendas; catálogo en datos; guía de arte fija |
| Mucho arte al inicio (4 cuerpos × 5 niveles × 2 cortes) | Empezar con 12 tops y 8 pantalones; ampliar por meses |
| Las imágenes de IA no salen coherentes | Plantillas fijas, paleta común, corrección manual (ver documento de arte) |
| Se agota lo deseable | Estrellas, colecciones, temporadas, habitación, compañeros y rangos de maestría |
| Inflación de monedas | Precios altos en los tramos superiores, ⭐ como segunda moneda, catálogo que crece |
| Farmear monedas | Topes, ventana hoy/ayer, libro idempotente |
| Que el juego estorbe | Se apaga; sin castigos ni notificaciones de culpa |
| Imagen corporal | Cambio de musculatura opcional; estilo tierno; aspecto base siempre neutro y simpático; 4 cuerpos |
| Pixel art borroso | Escalado entero y sin suavizado |
| Widget desactualizado | Actualizar al cambiar datos y de forma programada; probar en dispositivo |
| Derechos de las imágenes | Revisar los términos del generador antes de publicar; no pedir personajes ni estilos de marcas concretas |
| Contenido descargable y reglas de las tiendas | Decidir más tarde; empezar con contenido dentro de la app |

## 9.16 Cosas que quedan por decidir

0. ~~Cabezas: se elige cabeza estándar con anclajes (ver 9.17).~~
1. **Cuerpo neutro** (además de hombre y mujer): ¿más adelante o nunca?
2. **Compañeros** (mascotas): ¿quieres que sea la primera gran ampliación tras el lanzamiento?
3. **Habitación con muebles:** ¿te gusta la idea de convertir el fondo en un cuarto decorable?
4. **Cumpleaños del usuario** como evento: exige pedir la fecha (opcional). ¿Lo incluimos?
5. **Catálogo descargable** (paquetes de contenido): ¿lo pensamos desde el principio o solo cuando haga falta?

## 9.17 Personalización total: el usuario elige todo (decisión del 2026-09-29)

**Principio:** nada está bloqueado por género ni por cuerpo. Cualquier cuerpo, cabeza, peinado, ojos, prenda o fondo se puede combinar con cualquier otro. El aspecto **básico** (cuerpo, piel, ojos, peinados iniciales) se cambia **gratis y sin límite**; solo lo del catálogo se compra.

### Qué puede elegir el usuario

| Grupo | Opciones |
|---|---|
| **Cuerpo** | 4 cuerpos (Hombre A/B, Mujer A/B) × 8 tonos de piel |
| **Cara** | 8 formas de ojos × 12 colores, 4 cejas, boca/expresión, mejillas, pecas y otros rasgos |
| **Pelo** | 24 peinados iniciales × 24 colores; vello facial; el catálogo añade más |
| **Ropa** | Cabeza, cara, torso, piernas, pies, accesorio y trajes completos, en cualquier combinación y color |
| **Escena** | Fondo (y más tarde habitación con muebles), marco del widget |
| **Extras** | Compañero, pose, título e insignia |
| **Musculatura** | Automática por hábitos de ejercicio, o **fija a elección** ("mantener cuerpo constante") |

### Cómo se consigue: cabeza y cuerpo separados con anclajes (validado con arte real)
- Cada cuerpo se guarda **del cuello para abajo**, y hay **una sola cabeza estándar**.
- Cada cuerpo lleva un **anclaje** de cabeza (`dx`, `dy` por nivel de musculatura), guardado en `anclajes_cabeza.json`. Los elementos de la cabeza (cabeza, ojos, pelo, gorros) se dibujan desplazados por ese anclaje.
- **Resultado:** un solo juego de peinados, ojos y gorros sirve a los 4 cuerpos, y a los que se añadan después. Es la única opción con la que "elegir todo" no multiplica el arte por 2 o por 4.
- **Prueba realizada:** la misma cabeza con pelo y ojos sobre los 4 cuerpos × 5 niveles (`referencias/arte/limpio/modular/prueba_modular.png`). Encaja bien; en el Hombre B la cabeza queda algo pequeña respecto a sus hombros anchos, y es aceptable.
- **Límite:** al haber una sola forma de cabeza, la variedad facial viene de ojos, cejas, boca, rasgos y pelo, no de la forma del cráneo. Si se quiere elegir también la **forma de la cabeza** (redonda, ovalada, cuadrada) hay que dibujar los peinados para cada forma: **×3 de trabajo en peinados y gorros**. Queda como ampliación posterior, si se desea.

### Consecuencias de arte y de código
- El catálogo indica por cada pieza su **ranura**, su **capa** (orden de dibujo) y qué **oculta** del cuerpo (por ejemplo, el pantalón oculta la ropa interior inferior).
- Los cuerpos se entregan en dos archivos por nivel: `cuerpo` (del cuello para abajo) y la `cabeza_estandar`.
- El arte de ropa, pelo y gorros se dibuja **una vez** para la cabeza y el cuerpo estándar, con tallas por nivel de musculatura solo en el torso.
