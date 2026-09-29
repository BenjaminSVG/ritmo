# 11. Catálogo de objetos: todo lo que el personaje puede llevar

Estado: **planificación**. Complementa [09-gamificacion-personaje-pixelart.md](09-gamificacion-personaje-pixelart.md) (economía, tienda) y [10-arte-pixelart-prompts-chatgpt.md](10-arte-pixelart-prompts-chatgpt.md) (cómo se hace el arte).

## 11.1 Cómo leer este catálogo

- **Diseño** = un dibujo (por ejemplo, "campera de jean"). **Objeto** = lo que se compra: un diseño en un color (por ejemplo, "campera de jean azul"). Un diseño da **varios objetos** porque se recolorea por código.
- **Ranura** = el lugar del cuerpo donde va (torso, pies, cara…). Cada ranura tiene un **orden de dibujo** y puede **ocultar** partes de otras.
- **Sin marcas.** Nada de logos ni marcas reales: las zapatillas, remeras y camperas son de **estilos genéricos** (running, skate, bomber…). Ningún personaje ni logotipo existente.
- **Nombres en español rioplatense** en el catálogo base (remera, campera, zapatillas, anteojos, pollera…). Los nombres viven en el archivo de textos, así que se pueden traducir o adaptar a otros países (playera, chamarra, tenis, lentes…) sin tocar el código.

## 11.2 Capas y orden de dibujo (de atrás hacia adelante)

| # | Ranura | Ejemplos | Se ancla a | Variantes de arte por diseño |
|---|---|---|---|---|
| 1 | Fondo / habitación | dormitorio, playa, gimnasio | escena | 1 |
| 2 | Sombra | bajo los pies | pies | — |
| 3 | Espalda (detrás) | capa, alas, mochila, tabla de skate | torso | 2 cortes |
| 4 | **Cuerpo** | 4 cuerpos × 5 niveles de músculo | — | ya hecho |
| 5 | Rasgos del cuerpo | tatuajes temporales, marcas | cuerpo | 1 |
| 6 | Ropa interior (base) | la que trae el cuerpo | cuerpo | ya hecha |
| 7 | Medias | cortas, altas, rayadas | pies | 2 (estrecho/ancho) |
| 8 | **Calzado** | zapatillas, botas, sandalias | pies | 2 (estrecho/ancho) |
| 9 | **Piernas** | pantalón, short, pollera, calza | cintura | 6 (2 cortes × 3 tallas) |
| 10 | **Torso interior** | remera, musculosa, top, camisa | torso | 6 |
| 11 | **Torso exterior** | buzo, campera, saco, chaleco | torso | 6 |
| 12 | **Cuerpo completo** | pijama, disfraz, uniforme, traje | cuerpo | 6 |
| 13 | Cuello | collar, bufanda, corbata, moño | cuello | 1–2 |
| 14 | Cabeza estándar | piel, orejas, mejillas | cabeza | ya hecha |
| 15 | Cara | ojos, cejas, boca, pecas, maquillaje | cabeza | 1 |
| 16 | Vello facial | barba, bigote | cabeza | 1 |
| 17 | Pelo | peinados y colores | cabeza | 1 |
| 18 | Accesorios de pelo | hebillas, cintas, moños | cabeza | 1 |
| 19 | **Anteojos y máscaras** | anteojos, antifaz, gafas | cabeza | 1 |
| 20 | **Cabeza (sombreros)** | gorra, gorro, sombrero, casco, corona | cabeza | 1 |
| 21 | **Auriculares** | diadema, botones, gamer | cabeza | 1 |
| 22 | En la mano / muñeca | mancuerna, mate, libro, pulsera, guante | mano | 1–2 |
| 23 | Efectos | brillo, chispas, aura | personaje | 1 |
| 24 | Compañero | mascota | escena | 1 |

**Regla general de ocultamiento:** una prenda **borra los píxeles del cuerpo y de las capas de abajo que quedan bajo su silueta** (más 1 píxel de margen). Con eso:
- el **pantalón** tapa la ropa interior de abajo y la **remera** la de arriba;
- la **campera** va sobre la remera sin mezclarse;
- un **traje completo** oculta remera, pantalón e interior;
- una **gorra** tapa el pelo que queda debajo y deja ver el que sobresale;
- una **capucha** oculta la parte alta del pelo;
- los **anteojos** y los **auriculares** se dibujan por encima del pelo.

Cada objeto del catálogo declara qué **oculta** de forma explícita (`oculta: [interior_inferior, medias]`), para los casos especiales.

**Anclajes:** lo que va en la cabeza (pelo, anteojos, sombreros, auriculares) usa el **anclaje de cabeza** ya validado. Cuello, cintura, pies y manos necesitarán su propio anclaje por cuerpo; hay que **probarlo** cuando se dibuje el primer collar, el primer par de zapatillas y el primer objeto de mano.

## 11.3 Catálogo por ranura

Cada lista muestra los **estilos** previstos. La cantidad de **diseños** por etapa está en 11.4.

### Cabeza: pelo, cara y accesorios

**Pelo (peinados):**
- Cortos: militar, degradé, con flequillo, despeinado, tipo "cepillo", rapado, con jopo, con rulos cortos, bob, pixie.
- Medios: hasta el hombro, ondulado, con capas, "shaggy".
- Largos: lacio, ondulado, con rulos, con flequillo recto, muy largo.
- Atados: colita alta, colita baja, dos colitas, rodete alto, rodete bajo, trenza simple, dos trenzas, trenza de raíz, media coleta.
- Otros: afro, rastas, mohicano, con raya al costado, con mechón, con banda.
- **Colores** (por recolor): 16 naturales (negro, castaños, rubios, pelirrojos, grises, blanco, tonos rojizos) y **8 de fantasía** (rosa, celeste, verde, lila, turquesa, naranja, rojo cereza, amarillo). Más adelante: **mechas y degradés** (raíz oscura, puntas de color) como piezas con 2 colores elegibles.
- **Accesorios de pelo:** hebillas, cintas, moños, scrunchies, broches, flores, diademas finas, pañuelo en el pelo.

**Ojos, cejas y boca:**
- Ojos: redondos brillantes, achinados, dormilones, arcos felices (cerrados), estrellados, gatunos, grandes tiernos, con pestañas. Colores: 12.
- Cejas: finas, gruesas, arqueadas, en diagonal.
- Boca/expresión: sonrisa, sonrisa grande, neutra, sorprendida, guiño, lengua afuera.
- Rasgos: pecas, lunares, cicatriz, rubor intenso, ojeras, arruguitas de sonrisa.
- **Maquillaje:** labial (varios colores), sombra de ojos, delineado, brillos.
- **Vello facial:** barba corta, barba larga, bigote, candado, patillas, perilla.
- **Perforaciones:** aritos (aro, botón), nariz, ceja.

**Anteojos y máscaras** (por recolor del marco):
redondos, cuadrados, rectangulares, gato, aviador, sin marco, de lectura, de sol, deportivos, de natación, de esquí, gafas de piloto, gafas 3D, monóculo, gafas de fiesta, gafas "pixel" tipo *deal with it*; antifaz, máscara de luchador, mascarilla de dormir en la frente, tapaojos de pirata.

**Auriculares:** de diadema (varios colores), de botón/in-ear, gamer con micrófono, vintage con cable, orejas de gato, cascos de estudio, auriculares colgados del cuello.

**Sombreros y cosas en la cabeza:**
- Gorras: con visera, invertida, de béisbol, de camionero, tipo "5 paneles".
- Gorros: de lana con pompón, beanie, gorro polar, gorro de dormir.
- Sombreros: de paja, de ala ancha, tipo vaquero, boina, bombín, fedora, de copa, sombrero de bruja, de mago.
- Cascos: de bici, de obra, de moto, de astronauta, de piloto.
- Diademas y otros: cinta deportiva, bandana, capucha (varios estilos), gorro de chef, birrete de graduación, gorro de Papá Noel, corona, tiara, halo, orejas de conejo, cuernitos, antenas.

### Cuello
Collares: cadena fina, cadena gruesa, medalla, dije de corazón, colgante de moneda, perlas, brújula, llave, dije de estrella, gargantilla, collar de flores; bufandas (tejidas, a rayas, larga), pañuelos, chalinas, corbata, moño, corbatín, cascabel, silbato de entrenador, credencial, cordón con medalla de logro.

### Torso interior
- **Remeras:** lisa, con estampado (corazón, estrella, animal, frase corta), a rayas, oversize, de banda (genérica), de manga larga, cuello en V, tipo polo, de fútbol (colores genéricos, con número), tie-dye, de cuadros.
- **Musculosas y tops:** musculosa deportiva, top deportivo, crop top, camiseta sin mangas de básquet, remera cruzada.
- **Camisas:** manga corta, manga larga, a cuadros (leñadora), de vestir, floreada (playera), de jean.
- **Buzos (interior):** canguro liviano, cuello redondo.

### Torso exterior
- **Camperas:** de jean, de cuero, bomber, inflable (puffer), rompevientos, impermeable, deportiva con cierre, de abrigo con capucha, polar, parka, de béisbol (varsity), poncho.
- **Buzos:** con capucha, cuello redondo, canguro, con cierre, de rugby.
- **Sacos y otros:** blazer, saco de vestir, chaleco, cárdigan, sweater tejido, chaleco inflable, bata de laboratorio, guardapolvo, kimono/gi de artes marciales, delantal.

### Piernas
- **Pantalones:** jean (clásico, ancho, rasgado), jogger, cargo, de vestir, babucha, de pijama, de jardinero (enterito), pantalón de gimnasio.
- **Shorts:** deportivo, de jean, de baño (malla), bermuda, ciclista, de básquet, de correr.
- **Polleras:** mini, midi, tableada, de tul (tutú), de jean, larga.
- **Calzas y leggings:** lisas, estampadas, de ciclista.

### Medias
Cortas, tobilleras, altas, hasta la rodilla, rayadas, de red, de lunares, calentadores.

### Calzado (zapatillas de todos los estilos y más)
- **Zapatillas:** de running, urbanas, de skate, de lona (tipo clásico), altas (botitas), de básquet, con plataforma, sin cordones (slip-on), retro, de trekking, minimalistas, de gimnasio, de fútbol (botines), de tenis, "chunky", con luces.
- **Botas:** de trabajo, de lluvia (goma), tipo vaquero, de nieve, altas, borceguíes, de montaña.
- **Zapatos:** mocasines, de vestir, náuticos, Mary Jane, ballerinas.
- **Sandalias y otros:** sandalias, ojotas (chancletas), crocs, pantuflas, tacos, patines de cuatro ruedas, patines en línea, descalzo.
- Por recolor: color del cuerpo del calzado; cordones y suela pueden llevar un **segundo color** en los diseños que lo permitan.

### Cuerpo completo (trajes y disfraces)
Pijama, pijama de una pieza (kigurumi/animal), uniforme escolar, delantal de chef, ropa de gimnasio completa, traje formal, traje de baño, superhéroe, ninja, astronauta, mago, bruja, pirata, samurái (con respeto, sin caricaturas), caballero, hada, dinosaurio, oso, robot, doctor/a, científico/a, jardinero/a, músico/a, deportista (tenista, futbolista, nadador/a), disfraces de temporada (Halloween, Navidad).

### Espalda, mano y muñeca
- **Espalda:** mochila (varios estilos), riñonera, capa, alas (hada, ángel, mariposa), guitarra a la espalda, tabla de skate, tubo de dibujo, faldón.
- **En la mano:** mancuerna, pesa rusa, pelota, botella de agua, **mate y termo**, taza de café, libro, cuaderno, paraguas, linterna, cámara, guitarra, ukelele, pincel, control de videojuego, globo, bastón, varita.
- **Muñeca:** reloj, pulsera, muñequera deportiva, banda de tela, guantes (de box, de lana, de ciclista).

### Efectos, compañeros y pose
- **Efectos:** brillo suave, chispas, corazones, notas musicales, aura de colores, fuego, nubecitas de ánimo.
- **Compañeros:** perro, gato, conejo, zorro, pájaro, pez en pecera, hámster, dragón pequeño, robot, planta, slime, tortuga. Cada uno puede llevar un sombrerito.
- **Poses y gestos** (fase posterior): saludo, festejo, flexión de bíceps, yoga, baile, dormir. Cada una exige redibujar el cuerpo en los 4 cuerpos × 5 niveles, por eso van al final.

### Escena
- **Fondos:** dormitorio, gimnasio, parque, playa, biblioteca, montaña, ciudad de noche, sala de juegos (arcade), espacio, bosque, nevado, cocina, oficina, escuela, cafetería, campo, templo, fondo del mar; versiones de **temporada**.
- **Habitación con muebles** (fase posterior): cama, escritorio, estantería, plantas, alfombra, lámparas, cuadros, bicicleta fija, tapete de yoga.
- **Marcos y temas de widget:** madera, oro, nubes, flores, neón, piedra, pixel-tech, papel.
- **Títulos e insignias:** "Madrugador/a", "Imparable", "Rata de biblioteca", "Hidratado/a" (se ganan, no se compran).

## 11.4 Cantidades por etapa

**Diseños** (dibujos) acumulados. Los objetos comprables salen de multiplicar por los colores disponibles (ver la última columna). Las cifras siguen la tabla de crecimiento de 9.6.

| Ranura | P1 mínimo jugable | P2 lanzamiento | P3 fin del año 1 | Colores por diseño (media) |
|---|---|---|---|---|
| Peinados (gratis) | 12 | 24 | 60 | 24 |
| Ojos, cejas, boca, rasgos, vello (gratis) | 16 | 34 | 60 | 12 (ojos) |
| Accesorios de pelo | 2 | 4 | 12 | 3 |
| Anteojos y máscaras | 4 | 10 | 20 | 3 |
| Auriculares | 2 | 5 | 10 | 3 |
| Sombreros y gorras | 4 | 12 | 30 | 3 |
| Cuello | 3 | 8 | 16 | 2 |
| Remeras, musculosas, tops, camisas | 8 | 20 | 40 | 4 |
| Buzos, camperas, sacos | 4 | 18 | 36 | 4 |
| Pantalones, shorts, polleras, calzas | 6 | 18 | 36 | 4 |
| Medias | 0 | 4 | 10 | 4 |
| Calzado | 4 | 22 | 44 | 4 |
| Trajes completos | 0 | 6 | 16 | 1–2 |
| Espalda, mano y muñeca | 2 | 10 | 24 | 2 |
| Efectos | 0 | 3 | 8 | — |
| Compañeros | 0 | 3 | 8 | — |
| Fondos | 4 | 12 | 24 | — |
| Marcos de widget | 2 | 6 | 12 | — |
| **Diseños comprables** (sin las opciones gratuitas) | **~45** | **~120** | **~220** | |
| **Objetos comprables (con colores)** | **~120** | **~250** | **~800** | |

**Imágenes a producir** (diseño × variantes de la tabla 11.2), aproximado: P1 ≈ 170, P2 ≈ 420, P3 ≈ 630. Es un cálculo mío: se verifica al planificar cada lote.

**Tiempo estimado de producción:** unos 20 a 40 minutos por diseño con los retoques (estimación sin medir). P2 son ~120 diseños comprables más los gratuitos: del orden de **100 a 150 horas**. Con 15 a 20 horas por semana, son varios meses; por eso el contenido se produce **en lotes mensuales** y el lanzamiento no espera al catálogo completo.

## 11.5 Qué se dibuja primero (P1: el mínimo jugable)

Orden recomendado, elegido para probar **todos los tipos de anclaje** con pocas piezas:

1. **Cabeza:** 1 gorra, 1 par de anteojos redondos, 1 auricular de diadema. *(Prueban el anclaje de cabeza, ya validado.)*
2. **Torso interior:** remera lisa, musculosa, remera a rayas. *(Prueban tallas por nivel de músculo.)*
3. **Torso exterior:** 1 buzo con capucha, 1 campera bomber. *(Prueban capas sobre capas.)*
4. **Piernas:** 1 pantalón jogger, 1 short deportivo, 1 jean. *(Prueban el ocultamiento de la ropa interior.)*
5. **Calzado:** 1 zapatilla de running, 1 urbana, 1 bota. *(Prueban el anclaje de pies.)*
6. **Cuello:** 1 collar de cadena. *(Prueba el anclaje de cuello.)*
7. **Mano/espalda:** 1 mancuerna, 1 mochila.
8. **Fondos:** dormitorio, gimnasio, parque, fondo liso (gratis).

## 11.6 Cómo se consiguen (además de comprarlos)

| Vía | Qué da | Ejemplo |
|---|---|---|
| **Tienda** | Casi todo, por 🪙 | remera lisa, zapatillas |
| **Cofre semanal "elige 1 de 3"** | 1 objeto que aún no tienes | una campera |
| **Misiones semanales** | 🪙 y a veces ⭐ | "haz ejercicio 4 días" |
| **Logros** | ⭐, insignias y objetos únicos | "30 días seguidos" |
| **Temporadas** | Objetos exclusivos de la temporada, que **vuelven** después | bufanda de invierno |
| **Nivel de cuenta** | Desbloquean objetos para comprar | nivel 10 → campera de cuero |
| **Colecciones (sets)** | Bonus al completar 5–6 piezas | set "Gimnasio" |
| **Regalos** | Bienvenida, regreso tras una pausa, cumpleaños del usuario | un gorro de fiesta |

### Objetos ligados a hábitos reales (recompensas temáticas)
Se desbloquean por constancia en una categoría de hábito, y refuerzan el hábito:

| Categoría | Ejemplos de objetos |
|---|---|
| **Ejercicio** | mancuernas, muñequeras, cinta en la frente, musculosa de entrenamiento, zapatillas de running |
| **Agua** | botella de agua, gorro de natación, gafas de natación, capa "gota" |
| **Mente** (leer, meditar) | libro, anteojos de lectura, gorro de sabio, halo de calma |
| **Sueño** | pijama, antifaz, pantuflas, gorro de dormir |
| **Alimentación** | delantal de chef, gorro de chef, cuchara de madera |
| **Estudio / tareas** | birrete, mochila, cuaderno, auriculares de estudio |

## 11.7 Precios por tipo de objeto (orientativos)

Siguen las franjas de 9.6 (común 60–120 🪙, raro 300–480, épico ~1.300, legendario ~3.600 + ⭐, mítico ~11.000 + ⭐⭐).

| Tipo | Rareza típica | Ejemplos |
|---|---|---|
| Básicos lisos | Común | remera lisa, short, zapatillas simples, gorra lisa |
| Estampados y de estilo | Raro | remera de rayas, campera bomber, anteojos de gato |
| Conjuntos y prendas elaboradas | Épico | traje de superhéroe, campera de cuero con detalles |
| Trajes completos y accesorios especiales | Legendario | traje de astronauta, alas de hada |
| Coleccionables de gran ritmo | Mítico | aura arcoíris, dragón pequeño |
| **Variantes de color de algo que ya tienes** | **Común, con descuento** | mismo diseño en otro color |

**Descuento por colección:** al poseer un diseño, sus otros colores cuestan menos (por ejemplo, un 50 %), para animar a completar sin hacerlo obligatorio.

## 11.8 Ficha de un objeto en el catálogo

```json
{
  "id": "torso_int_remera_lisa",
  "nombre": "Remera lisa",
  "ranura": "torso_interior",
  "capa": 10,
  "oculta": ["interior_superior"],
  "cortes": ["h", "m"],
  "tallas": ["s", "m", "l"],
  "colores": ["rosa", "celeste", "verde", "amarillo"],
  "rareza": "comun",
  "precio": 90,
  "moneda": "monedas",
  "conjunto": "basicos",
  "requisito": null,
  "temporada": null,
  "imagen": "assets/pixel/top/remera_lisa_{corte}_{talla}.png"
}
```

Reglas: el `id` **nunca cambia ni se reutiliza**; el color no se guarda en el diseño sino en el **inventario** del usuario; un objeto retirado se marca como archivado, no se borra.

## 11.9 Cómo se prueba

- Una prueba automática recorre el catálogo: identificadores únicos, imágenes existentes, colores válidos, precios y rarezas coherentes.
- **Pruebas de imagen (golden)** del personaje con combinaciones difíciles (capucha + auriculares + anteojos; campera sobre buzo; traje completo con zapatillas) en los 4 cuerpos y 5 niveles.
- Una **prueba de ocultamiento** por cada prenda nueva, para comprobar que no queda ropa interior a la vista.

## 11.10 Decisiones que quedan por tomar

1. **Calzado con anclaje por cuerpo:** ¿dibujar 2 variantes (estrecho y ancho) o 4 (una por cuerpo)? Con el primer par de zapatillas se prueba y se decide.
2. **Poses y gestos:** ¿los quieres antes del año 1? Son costosos (redibujar todo el cuerpo).
3. **Perforaciones, tatuajes temporales y maquillaje:** ¿se incluyen, o prefieres dejarlos fuera?
4. **Trajes tradicionales de países:** se pueden hacer, pero con cuidado de no caer en estereotipos; ¿te interesa?
5. **Colores de fantasía del pelo:** ¿libres desde el principio o desbloqueables?
