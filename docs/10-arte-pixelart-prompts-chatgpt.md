# 10. Arte pixel art tierno: textos para ChatGPT y método de trabajo

Complementa [09-gamificacion-personaje-pixelart.md](09-gamificacion-personaje-pixelart.md) (versión 2). Aquí está **qué imágenes hacen falta**, **el texto exacto para pedírselas a ChatGPT** y **cómo dejarlas listas** para la app.

> **Nota importante.** Yo no puedo acceder a ChatGPT: los textos de abajo los pegas tú. Además, un generador de imágenes **no dibuja píxeles perfectos**: produce imágenes grandes que *parecen* pixel art. Por eso el método incluye un paso de limpieza. Es normal necesitar 2–5 intentos por imagen.

## 10.1 Método de trabajo (5 pasos)

1. **Hoja de estilo** (10.5): es la referencia de todo. Guarda la que más te guste.
2. **Cuerpos base** (10.6): los 4 cuerpos, cada uno con sus 5 niveles de musculatura **en una sola imagen**, para que sean el mismo personaje.
3. **Prendas, peinados y rasgos**: sube al chat la imagen del cuerpo base y pide que **no cambie nada** salvo lo nuevo (10.7). "Edita esta imagen" da más coherencia que "dibuja otra".
4. **Limpieza** en un editor de pixel art gratuito (*Piskel*, en el navegador, o *LibreSprite*/*Aseprite*):
   - reduce al lienzo final con **vecino más cercano** (nearest neighbor), nunca con suavizado;
   - **cuantiza** a la paleta común (10.2);
   - superpón con "papel cebolla" sobre el cuerpo base para comprobar que **encaja en el mismo punto**;
   - borra el fondo para dejarlo **transparente**.
5. **Guarda** con el nombre y en la carpeta de 10.4.

**Truco de fondo:** pide siempre fondo **liso magenta `#FF00FF`** (no "transparente"): se borra fácil con la varita mágica y evita bordes sucios. Los fondos de escena son la excepción.

**Truco para ahorrar trabajo (importante):** **dibuja cada prenda UNA sola vez, en su color base**. La app crea las demás **variantes de color** por código. No pidas a ChatGPT la misma camiseta en ocho colores.

## 10.2 Reglas de estilo: pixel art tierno

- **Lienzo del personaje: 64×96 píxeles.** **Fondo de escena: 384×192.**
- **Estilo tierno ("kawaii")**: cabeza grande (casi la mitad de la altura), cuerpo pequeño y redondeado, **ojos grandes y brillantes**, **mejillas sonrosadas**, formas suaves sin ángulos duros.
- **Contorno de 1 píxel en morado oscuro** (`#2B2340`), no negro puro: se ve más suave.
- Sombreado plano de **2 tonos** (color base y sombra), **sin degradados ni suavizado**.
- Personaje **de frente**, brazos ligeramente separados, pies en la parte baja del lienzo.
- Colores **suaves/pastel**.

### Paleta propia de 24 colores ("Paleta Ritmo")

| Nombre | Hex | | Nombre | Hex |
|---|---|---|---|---|
| Tinta (contorno) | `#2B2340` | | Verde oscuro | `#2F8F6B` |
| Sombra | `#4A3F6B` | | Turquesa | `#6ED3D0` |
| Gris lavanda | `#8C84A8` | | Cielo | `#7EC8F5` |
| Gris claro | `#C9C4DB` | | Azul marca | `#4F6AF5` |
| Crema | `#FFF8F0` | | Azul oscuro | `#3446B8` |
| Rosa | `#FF8FAB` | | Lila | `#B69CF2` |
| Rosa oscuro | `#D65A7E` | | Lila oscuro | `#7C5FCF` |
| Coral | `#F0686A` | | Marrón | `#A9714B` |
| Naranja | `#FFAA6B` | | Marrón oscuro | `#6E4530` |
| Amarillo | `#FFD866` | | Oro | `#FFC533` |
| Lima | `#B8E986` | | Oro oscuro | `#C98A1E` |
| Verde | `#5CC28A` | | Rubor (mejillas) | `#FFA3A3` |

Esta paleta es propia de Ritmo, así que no depende de la licencia de nadie.

### 8 tonos de piel (cada uno con luz, base y sombra)

| # | Nombre | Luz | Base | Sombra |
|---|---|---|---|---|
| 1 | Marfil | `#FFE3CF` | `#F6CDB1` | `#D9A585` |
| 2 | Claro | `#FBD5B5` | `#EDB98F` | `#C98F68` |
| 3 | Beige | `#F2C79C` | `#E2AA7B` | `#B98058` |
| 4 | **Dorado (el de dibujo)** | `#E8B77F` | `#D39A62` | `#A87445` |
| 5 | Canela | `#D39A6A` | `#B87B4D` | `#8F5B36` |
| 6 | Caramelo | `#B87B50` | `#9A6035` | `#744423` |
| 7 | Moreno | `#8D5A3B` | `#734529` | `#54301C` |
| 8 | Ébano | `#6A4030` | `#52301F` | `#3A2015` |

**Se dibuja siempre con el tono 4 (Dorado)**: la app lo cambia por cualquiera de los otros 7 por código.

### Colores que se dibujan para recolorear
| Elemento | Color base | Sombra | Se recolorea a |
|---|---|---|---|
| Pelo | Marrón `#A9714B` | Marrón oscuro `#6E4530` | 16 naturales + 8 de fantasía |
| Iris de los ojos | Azul marca `#4F6AF5` | Azul oscuro `#3446B8` | 12 colores |
| Ropa (parte principal) | Rosa `#FF8FAB` | Rosa oscuro `#D65A7E` | los demás pares de la paleta |
| Detalles fijos de la ropa (botones, logos) | Crema `#FFF8F0`, Oro `#FFC533` | — | **no** se recolorean |

## 10.3 Cuerpos y tallas

| Cuerpo | Descripción | Archivo |
|---|---|---|
| **Hombre A** | Complexión media | `body_ha_0` … `_4` |
| **Hombre B** | Más ancho de hombros, más robusto | `body_hb_0` … `_4` |
| **Mujer A** | Complexión media | `body_ma_0` … `_4` |
| **Mujer B** | Más curvilínea y redondeada | `body_mb_0` … `_4` |

Cada cuerpo tiene **5 niveles de musculatura** (0 a 4) = **20 imágenes**. Las prendas de torso llevan **2 cortes** (`h` masculino / `m` femenino) y **3 tallas** (`s` para los niveles 0–1, `m` para 2–3, `l` para 4).

## 10.4 Lista de archivos y carpetas

Todo va en `app/assets/pixel/`, con nombres `{tipo}_{id}_{variante}.png`.

| Carpeta | Contenido | Versión mínima | Lanzamiento | Lienzo |
|---|---|---|---|---|
| `body/` | 4 cuerpos × 5 niveles | 20 | 20 | 64×96 |
| `eyes/` | formas de ojos (color por recolor) | 8 | 8 | 64×96 |
| `brows/` | cejas | 4 | 4 | 64×96 |
| `beard/` | vello facial | 6 | 6 | 64×96 |
| `trait/` | pecas, rubor, lunares, cicatriz… | 10 | 10 | 64×96 |
| `hair/` | peinados (color por recolor) | 12 | 24 | 64×96 |
| `top/` | diseños × 2 cortes × 3 tallas = **6 imágenes por diseño** | 12 diseños = 72 | 30 diseños = 180 | 64×96 |
| `bottom/` | diseños × 2 cortes | 8 → 16 | 20 → 40 | 64×96 |
| `shoes/` | una versión | 6 | 15 | 64×96 |
| `hat/` | una versión | 8 | 20 | 64×96 |
| `acc/` | una versión | 6 | 15 | 64×96 |
| `suit/` | trajes completos: 2 cortes × 3 tallas | — | 4 trajes = 24 | 64×96 |
| `bg/` | fondos de escena | 8 | 20 | 384×192 |
| `frame/` | marcos del widget | 4 | 8 | 384×192 |
| `ui/` | moneda, estrella, llama, cofre, insignias… | ~20 | ~30 | 16×16 / 32×32 |
| icono de la app | `app_icon.png` | 1 | 1 | 512×512 |
| **Total de imágenes** | | **≈ 200** | **≈ 400** | |

> Cada diseño de ropa da **muchos objetos de tienda** (uno por color). Con los diseños de lanzamiento salen unos **250 objetos** con solo unas 400 imágenes.

Todas las capas del personaje **comparten lienzo y punto de anclaje** (pies centrados abajo).

## 10.5 Texto 1: hoja de estilo (primero)

```text
Create a pixel art style sheet for a cute habit-tracking mobile game. Kawaii chibi human
characters, front view, standing, arms slightly away from the body, head almost half of
the total height, big shiny eyes, small rosy cheeks, soft rounded shapes.
Show 4 characters side by side: a man with medium build, a broader sturdy man, a woman
with medium build, and a curvier woman, each with a DIFFERENT skin tone.
Pixel art with a hard 1-pixel dark purple outline (#2B2340), flat shading with 2 tones
only (base + shadow), NO gradients, NO anti-aliasing, NO blur. Soft pastel look.
Use ONLY this palette: #2B2340 #4A3F6B #8C84A8 #C9C4DB #FFF8F0 #FF8FAB #D65A7E #F0686A
#FFAA6B #FFD866 #B8E986 #5CC28A #2F8F6B #6ED3D0 #7EC8F5 #4F6AF5 #3446B8 #B69CF2
#7C5FCF #A9714B #6E4530 #FFC533 #C98A1E #FFA3A3 plus warm skin tones.
Outfits: simple white t-shirt and shorts. Solid magenta #FF00FF background, no text,
no ground shadow. Friendly, clean, readable at small sizes.
```

## 10.6 Texto 2: cuerpos base con 5 niveles de musculatura

Una imagen por cuerpo (cuatro veces), cambiando la línea **[CUERPO]**.

```text
Pixel art sprite sheet: 5 versions of the SAME kawaii chibi character in one row, all
identical in size, pose, face (big shiny eyes, rosy cheeks) and hairstyle, front view,
standing, arms slightly away from the body, feet on the same baseline.
Body: [CUERPO].
Wearing only plain gray shorts (and a plain gray sports top for the woman versions).
Only the muscle build changes from left to right:
1) beginner: soft, neutral build
2) active: slightly more defined
3) athletic: clearly defined arms and torso
4) strong: visibly muscular
5) legendary: very muscular with a small golden glow outline
Keep it cute, friendly and cartoonish, never unhealthy or negative-looking.
Pixel art, hard 1-pixel dark purple outline #2B2340, flat shading with 2 tones,
NO gradients, NO anti-aliasing. Skin: use exactly #E8B77F (light), #D39A62 (base),
#A87445 (shadow). Solid magenta #FF00FF background, no text, no ground shadow.
Each character must fit a 64x96 pixel grid.
```

**[CUERPO]**, uno por vez:
- `man, medium build, short neck`
- `man, broader shoulders, sturdier and rounder frame`
- `woman, medium build, soft rounded shapes`
- `woman, curvier and rounder frame`

## 10.7 Texto 3: ojos, cejas, peinados, ropa y accesorios (editando la imagen base)

Sube la imagen del cuerpo base y pega:

```text
Using this exact character image, KEEP the character, pose, size, outline style and
palette exactly the same. Change ONLY [CAMBIO]. Do not change anything else. Same pixel
grid (64x96), same feet position, hard 1-pixel dark purple outline, flat shading with
2 tones, no gradients, no anti-aliasing. Solid magenta #FF00FF background.
Give me the result for the 5 muscle builds side by side.
```

**[CAMBIO]** según lo que quieras:

| Tipo | Ejemplo de [CAMBIO] |
|---|---|
| **Ropa de torso** | `add a sleeveless gym tank top. Draw it ONLY in pink #FF8FAB (main) and dark pink #D65A7E (shade), plus dark purple outline. Details in cream #FFF8F0 or gold #FFC533 if any` |
| Ropa de torso (ideas) | hoodie, camiseta con rayas, chaqueta, kimono de artes marciales, impermeable, camiseta de fútbol con el número 7, suéter, camisa |
| **Pantalones** | `add jogger pants` (mismas reglas de color rosa/rosa oscuro) — vaqueros, falda, shorts deportivos, leggings |
| **Zapatos** | `add sneakers` (color base rosa) — botas, sandalias, zapatillas altas |
| **Gorros** | `add a baseball cap` — gorro de lana, sombrero de paja, diadema, corona |
| **Accesorios** | `add a small backpack` — gafas redondas, bufanda, capa, medalla, auriculares |
| **Peinados** | `replace ONLY the hair with a [short spiky / long straight / low bun / curly afro / mohawk / twin tails / bob cut]. Draw the hair ONLY in brown #A9714B with dark brown #6E4530 shading` |
| **Ojos** | `replace ONLY the eyes with [round sparkling / sleepy / happy closed arches / wide starry / cat-like]. Iris in blue #4F6AF5 with #3446B8 shade, white highlight #FFF8F0` |
| **Vello facial** | `add ONLY a [short stubble / full beard / mustache / goatee] in brown #A9714B and #6E4530` |
| **Rasgos** | `add ONLY [freckles / a beauty mark / a small scar / stronger rosy blush]` |

**Ropa que va a cuerpos masculinos y femeninos:** pide la prenda **dos veces**, una sobre un cuerpo masculino y otra sobre uno femenino (dos cortes). De cada salida, reagrupa en **3 tallas**: S (niveles 0–1, usa el nivel 0), M (niveles 2–3, usa el 2) y L (nivel 4).

**Trajes completos (personajes temáticos):** *"Using this exact character image… add a complete [ninja / astronaut / chef / superhero / wizard] outfit including [hat, top, pants and shoes]…"* — también dibujados en colores base.

## 10.8 Texto 4: fondos de escena (384×192), estilo tierno

```text
Cute pixel art background scene, 384x192 pixels, 2:1 horizontal format, soft pastel
colors, for a kawaii chibi character standing in the lower center. Hard pixel edges,
NO gradients, NO anti-aliasing, limited palette (#2B2340 #4A3F6B #8C84A8 #C9C4DB
#FFF8F0 #FF8FAB #D65A7E #F0686A #FFAA6B #FFD866 #B8E986 #5CC28A #2F8F6B #6ED3D0
#7EC8F5 #4F6AF5 #3446B8 #B69CF2 #7C5FCF #A9714B #6E4530 #FFC533 #C98A1E #FFA3A3).
Leave the lower center clear so the character stays readable.
Scene: [ESCENA]. No text, no characters.
```

**[ESCENA]** para los 8 primeros: `cozy pastel bedroom with a window and plants` · `home gym with dumbbells, a yoga mat and a mirror` · `sunny park with round trees and a path` · `beach at sunset with tiny waves` · `night city rooftop with stars and string lights` · `library with tall bookshelves` · `mountain trail at dawn` · `plain pastel background with a subtle checker pattern` (gratis y el primero que se desbloquea).

Temporadas y eventos: primavera con flores, verano con playa, otoño con hojas, invierno con nieve, Halloween tierno, Navidad, aniversario.

## 10.9 Texto 5: interfaz, moneda, estrella y marcos

```text
Cute pixel art UI icon set on a solid magenta #FF00FF background, each icon on a 16x16
pixel grid, hard 1-pixel dark purple outline #2B2340, flat shading with 2 tones, NO
gradients, NO anti-aliasing, soft pastel palette only from: #2B2340 #FFC533 #C98A1E
#FF8FAB #D65A7E #F0686A #B8E986 #5CC28A #7EC8F5 #4F6AF5 #B69CF2 #FFF8F0.
Icons in a row: (1) gold coin with a tiny sparkle, (2) star for premium currency,
(3) XP star, (4) flame for streak, (5) treasure chest closed, (6) treasure chest open,
(7) heart, (8) lock, (9) check-mark badge, (10) small trophy. No text.
```

Marcos del widget (384×192): *"Cute pixel art decorative frame border, 384x192, center filled with solid magenta #FF00FF, 4-pixel ornamental edge in [wooden / gold / pastel clouds / flowers] style, hard pixel edges, limited palette, no text."*

## 10.10 Texto 6: icono de la app (Ritmo)

```text
App icon for a habit tracker called "Ritmo", cute pixel art style, square 512x512 with
large crisp pixels (each visible pixel about 16x16), hard pixel edges, no gradients, no
anti-aliasing, soft palette (#4F6AF5 #B69CF2 #FFF8F0 #FFC533 #2B2340 #FF8FAB).
Concept: [IDEA]. Rounded-square safe area, centered subject, high contrast, readable at
48x48 pixels, no text, no letters.
```

**[IDEA]** (elige una y pide 4 variantes): 
1. `a kawaii chibi character doing a happy jump with a tiny flame behind it`
2. `a big white check mark in a blue circle with a small smiling flame at the top right`
3. `a heartbeat rhythm line ending in a check mark, on a soft blue background`

Cuando elijas un icono, avísame y lo aplico como icono de la app en Android, Windows y web.

## 10.11 Lista de comprobación antes de aceptar una imagen

- [ ] Tamaño exacto (64×96, 384×192, 16×16), sin escalar con suavizado.
- [ ] Solo colores de la paleta y **fondo transparente**.
- [ ] Contorno de 1 píxel; sin degradados ni píxeles "sucios".
- [ ] La ropa y el pelo están dibujados en **su color base** (rosa, marrón…), listos para recolorear.
- [ ] **Encaja con el cuerpo base:** con papel cebolla coinciden pies y hombros.
- [ ] La cara y el pelo no se mueven entre niveles de musculatura.
- [ ] Estilo **tierno**: ojos grandes, formas redondeadas.
- [ ] Nombre y carpeta correctos (10.4).
- [ ] No pediste ni aparece ningún personaje, marca o logotipo existente.

## 10.12 Producir contenido cada mes (para años)

1. Cada mes, elige **6–10 diseños nuevos** (tema o temporada).
2. Genéralos en **lotes de 5–8** con el mismo cuerpo base.
3. Limpia, encaja y guarda; añade sus filas al `catalog.json` (precio, rareza, colores).
4. Anota en `docs/arte/prompts-usados.md` el texto, la fecha y el resultado aceptado.
5. Mantén **siempre la misma hoja de estilo y paleta**; si cambias de estilo, todo lo antiguo desentona.

## 10.13 Derechos y registro

- **Antes de publicar la app**, revisa en los términos de uso de ChatGPT/OpenAI qué derechos tienes sobre las imágenes generadas y si permiten uso comercial. No lo doy por sabido.
- La **fuente pixel** que uses para los números también tiene licencia (por ejemplo, *Silkscreen* o *Press Start 2P* usan la licencia OFL; compruébalo antes de publicar).
- La paleta de 24 colores y los 8 tonos de piel son propios del proyecto.

## 10.14 Orden recomendado para no atascarte

1. **Hoja de estilo** (10.5) → elegir el aspecto.
2. **Un cuerpo** (por ejemplo Mujer A) con sus 5 niveles (10.6).
3. **Un torso, un pantalón, un peinado, unos ojos y un fondo** (10.7 y 10.8) para probar todo el proceso.
4. **Envíame esos archivos.** Con ellos pruebo el dibujado de capas y el recolor en la app antes de que pidas el catálogo entero.
5. Resto de cuerpos, y luego el catálogo, por lotes.

## 10.15 Revisión de los primeros resultados y ajustes al método

Se revisaron la hoja de estilo y los 4 cuerpos con 5 niveles (ver `referencias/arte/originales/`).

**Lo que salió bien:** estilo tierno consistente; misma cara y peinado entre los 5 niveles de cada cuerpo; progresión de musculatura clara; fondo magenta; los 4 cuerpos se distinguen (dos masculinos y dos femeninos).

**Ajustes necesarios:**
1. **Tamaño real: 64×96, no 48×64.** Ver la prueba en `referencias/arte/prueba/`. Las imágenes generadas miden ~2000×800 px y no están en una cuadrícula exacta; hay que reducirlas (10.16).
2. **Falta la versión "calva y sin rasgos"** de cada cuerpo (texto 7 más abajo): las capas de pelo, cejas y ojos se dibujan aparte. Los cuerpos actuales sirven como **referencia de estilo**, no como capa final.
3. **Nivel 4: quitar el aura dorada** del dibujo. Se dibuja en código como capa aparte; dentro de la imagen queda con puntitos amarillos sucios al reducir.
4. **Nivel 0 (Hombre B, Mujer A y Mujer B): más neutro.** Sale con barriga marcada, y el principio del juego es que el aspecto base sea neutro y simpático, sin verse "por debajo" de nada. Conviene repetir el nivel 0 pidiendo *"average build, flat and neutral belly, not overweight, not underweight"*.
5. **Ojos:** salieron marrones. Para el recolor los ojos irán en una capa aparte dibujados con iris azul `#4F6AF5`.

### Texto 7: cuerpo base "calvo y sin rasgos" (uno por cada hoja de cuerpo)
Sube la hoja del cuerpo y pega:

```text
Using this exact image, keep EVERYTHING identical (character, pose, size, body build,
outline, colors, magenta background, the 5 versions in the same row) EXCEPT: remove
the hair completely (bald head), remove the eyebrows, remove the eyes and the mouth,
leaving a smooth plain skin face with only the ears and the rosy cheeks. Also remove
the golden glow outline from the 5th version. Keep the same pixel art style, no
gradients, no anti-aliasing, hard 1-pixel dark purple outline #2B2340.
```

## 10.16 Herramienta de limpieza: `tools/limpiar_sprites.ps1`

Ya está hecha: automatiza el paso 4 del método (limpieza) para que no tengas que hacerlo a mano en un editor.

```text
powershell -File tools\limpiar_sprites.ps1 -In hoja.png -Frames 5 -W 64 -H 96 -Out salida -Prefix hombre_a
```

Qué hace: quita el fondo magenta; reduce cada personaje **con la misma escala** y lo **alinea por los pies y el centro** (así las capas encajan entre niveles); ajusta los colores a la paleta Ritmo; guarda un PNG por personaje (`hombre_a_0.png` …) y una tira de vista previa ampliada. Con `-NoPalette` conserva los colores originales.

**Límites:** es un primer paso automático. El resultado tiene bordes algo irregulares y colores cambiados por la paleta (los ojos y el sombreado de la piel se aplanan), así que las piezas finales conviene retocarlas a mano en Piskel. Sirve para comprobar rápido si una imagen es utilizable.

### Texto 7b: los 4 cuerpos calvos de una sola vez
Si ya tienes las 4 hojas en un mismo chat, usa `referencias/arte/prompts/calvos-los-4-a-la-vez.txt` en lugar del texto 7. Pide las 4 versiones (calvo y sin rasgos, sin aura, nivel 0 neutro) en imágenes separadas y en orden. Si ChatGPT solo entrega una imagen por respuesta, escribe "next" para las siguientes. Si **no** quieres cambiar el nivel 0, borra la línea 4 del texto.

## 10.17 Estado del arte (2026-09-29)

**Hecho:** hoja de estilo, 4 cuerpos con 5 niveles, y sus **4 versiones "calvo y sin rasgos"**. Originales en `referencias/arte/originales/`; limpios a 64×96 en `referencias/arte/limpio/` (un PNG por nivel y una tira de vista previa por cuerpo). La herramienta ya separa los personajes por los huecos de fondo (antes cortaba brazos anchos).

**Observaciones sobre lo limpio:**
- La piel quedó en los tres colores de dibujo previstos (`#E8B77F`, `#D39A62`, `#A87445`), lista para recolorear.
- El definido de músculos se aplana un poco al reducir, sobre todo en las mujeres y el Hombre B; los niveles siguen distinguiéndose. Si se quiere más marcado, se retoca a mano en Piskel.
- El color de las mejillas cambió a naranja en algunos cuerpos por el ajuste a la paleta. Las mejillas pasarán a ser un rasgo aparte, así que no importa.
- La ropa interior gris quedó gris-lavanda (color de la paleta): sirve.

**Riesgo importante: las cabezas.** Las capas de pelo, ojos y cejas encajan sobre una cabeza concreta, y las 4 cabezas miden distinto (unos 3 píxeles de ancho de diferencia entre Hombre B y Mujer B). Hay tres salidas, a decidir tras la prueba de capas:
1. **Cabeza estándar única:** que las 4 cabezas sean idénticas (mismo tamaño y posición) y solo cambie el cuerpo desde el cuello. Un solo juego de pelo y ojos para todos. Es lo mejor para producir contenido durante años.
2. **Dos familias de cabeza** (masculina y femenina): el doble de peinados.
3. **Una versión de cada peinado por cuerpo:** cuatro veces el trabajo.

Recomendación: la 1. Si se elige, hay que unificar la cabeza en los 4 cuerpos (se puede hacer con la herramienta, pegando una misma cabeza estándar en cada cuerpo).

### Prueba de capas con el Hombre A
Antes de pedir el catálogo se pide **una sola pieza de cada tipo** sobre el Hombre A, como **capas aisladas** (solo la pieza, el resto magenta), para comprobar que encajan: `referencias/arte/prompts/prueba-capas-hombre-a.txt` (pelo, ojos y cejas, camiseta, pantalón y un fondo).

## 10.18 Resultado de la prueba de capas (Hombre A)

Se pidieron 5 piezas aisladas (pelo, ojos, camiseta, pantalón, fondo) y se superpusieron sobre el cuerpo base calvo. Resultado: **el método funciona**, con matices. Imágenes: `referencias/arte/limpio/look_A/` (los 5 niveles vestidos) y `referencias/arte/limpio/escena_A/` (el personaje en el fondo).

**Funciona bien:**
- ChatGPT entrega las capas **aisladas y en la posición correcta** de los 5 niveles.
- El **pelo y los ojos encajan** en la cabeza; la **camiseta sigue** cada nivel de músculo.
- Con solo los colores de cada pieza (por ejemplo rosa, rosa oscuro y contorno para la ropa) la pieza queda **plana de 2 tonos y lista para recolorear**.
- **Escala de la escena validada:** personaje 64×96 sobre fondo **384×192** (2:1). El fondo anterior de 192×96 quedaba demasiado pequeño para el personaje.

**Cambios que salen de la prueba (ya aplicados en la herramienta y los documentos):**
1. **Espacio arriba de la cabeza: 12 px** (`-Headroom 12`) para pelo alto, gorros y coronas. Sin él, las puntas del pelo se cortaban. Debe usarse el **mismo valor** en el cuerpo y en todas las capas.
2. **Cada pieza se limpia con sus propios colores** (`-Colors`), no con toda la paleta: evita el moteado.
3. **Fondos de escena: 384×192** y **con colores propios más amplios** (`-SinPaleta` en `escena_prueba.ps1`, o una paleta ampliada). Al forzar los 24 colores las plantas verdes salen ocres.

**Problemas que quedan (y su solución en el juego):**
- **Se ve la ropa interior del cuerpo** por el hueco del pantalón y asoma un borde de piel donde la prenda es algo más estrecha. Solución: cada prenda declarará en el catálogo qué **oculta** del cuerpo (el pantalón oculta la ropa interior inferior), y la app borrará esos píxeles del cuerpo bajo la silueta de la prenda antes de dibujarla.
- **Encaje imperfecto:** las capas generadas por IA no encajan al píxel. Conviene **retocar cada prenda a mano en Piskel**. Hay que contarlo como coste real: **unos 20–40 minutos por diseño** (ya con sus tallas y cortes) es una estimación mía, sin medir.

**Herramientas nuevas:** `tools/limpiar_sprites.ps1` (ahora con `-RefSheet`, `-Headroom` y `-Colors`), `tools/componer_capas.ps1` (superpone capas y genera la vista previa) y `tools/escena_prueba.ps1` (coloca un personaje en un fondo).

**Ejemplo de flujo completo:**
```text
# 1) cuerpo base (mismos -W -H -Headroom en todo)
limpiar_sprites.ps1 -In base.png -Frames 5 -W 64 -H 96 -Headroom 12 -Colors "2B2340,4A3F6B,8C84A8,C9C4DB,FFF8F0,E8B77F,D39A62,A87445,FFA3A3" -Out out\base -Prefix base
# 2) cada capa alineada con el cuerpo
limpiar_sprites.ps1 -In camiseta.png -RefSheet base.png -Frames 5 -W 64 -H 96 -Headroom 12 -Colors "2B2340,FF8FAB,D65A7E" -Out out\camiseta -Prefix camiseta
# 3) superponer
componer_capas.ps1 -Layers "out\base\base","out\pantalon\pantalon","out\camiseta\camiseta","out\pelo\pelo","out\ojos\ojos" -Frames 5 -Out out\look -Prefix look
```

## 10.19 Cabeza estándar y anclajes (validado)

Se separó cada cuerpo en **cuello para abajo** y se tomó la **cabeza del Hombre A** como estándar. El pelo y los ojos generados para esa cabeza se colocaron sobre los 4 cuerpos con un desplazamiento por cuerpo y nivel. Resultado en `referencias/arte/limpio/modular/`:

- `prueba_modular.png`: los 4 cuerpos × 5 niveles con la misma cabeza, ojos y pelo.
- `cabeza_estandar_0..4.png` y `{cuerpo}/{cuerpo}_cuerpo_0..4.png`: las piezas separadas.
- `anclajes_cabeza.json`: el desplazamiento (`dx`, `dy`) de la cabeza en cada cuerpo y nivel.

**Datos medidos (64×96):** el cuello queda en la fila 42 (Hombre A), 40 (Hombre B) y 39 (las dos mujeres); el ancho de la cabeza va de 29 px (mujeres) a 36 px (Hombre B), de ahí la necesidad del anclaje.

**Consecuencia para los textos de ChatGPT:** las capas de pelo, ojos, cejas, gorros y vello facial se piden **siempre sobre la cabeza estándar (Hombre A)**, nunca sobre otro cuerpo. Las prendas de torso, pantalón y zapatos sí se piden por cuerpo (o por corte).

**Herramienta:** `tools/modular_cabeza.ps1` (separa cabeza y cuerpo, calcula los anclajes y compone la prueba).
```text
powershell -File tools\modular_cabeza.ps1 -Limpio referencias\arte\limpio -Cuerpos base_hombre_a,base_hombre_b,base_mujer_a,base_mujer_b -CapasA referencias\arte\limpio\capas_A -Out referencias\arte\limpio\modular
```
