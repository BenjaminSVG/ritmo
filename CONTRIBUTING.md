# Cómo contribuir

¡Gracias por querer ayudar! Ritmo es un proyecto pequeño y abierto.

## Antes de empezar

- Abre un *issue* para contar el error o la idea antes de hacer un cambio grande.
- Ritmo es **local primero**: todo debe funcionar sin cuenta ni internet. Una sincronización futura será opcional.
- **Nada de castigos ni presión**: no se pierden monedas ni rachas por dejar de usar la app.
- Los textos de la app están en **español**.

## Cómo trabajar en el código

```bash
cd app
flutter pub get
flutter analyze   # debe salir sin problemas
flutter test      # todas las pruebas deben pasar
```

- La lógica de negocio va en `lib/domain/` (sin Flutter, con pruebas). Las pantallas van en `lib/features/`.
- Si cambias las tablas de `lib/data/db/database.dart`, sube `schemaVersion`, añade el paso de migración y ejecuta
  `dart run build_runner build --delete-conflicting-outputs`. Comprueba que una base de datos antigua se actualiza
  sin perder datos.
- Para revisar cómo quedan los conjuntos de ropa: `RITMO_PREVIEW=1 flutter test test/outfit_preview_test.dart`
  (genera imágenes en `referencias/arte/limpio/`).

## Arte

El arte es pixel art de 64×96 píxeles por personaje sobre escenas de 384×192. Cada objeto nuevo necesita:
un dibujo por nivel de musculatura (5), y para la ropa, uno por cuerpo. Mira [docs/10](docs/10-arte-pixelart-prompts-chatgpt.md)
y [docs/11](docs/11-catalogo-de-objetos.md) para la paleta, los tamaños y cómo se añaden al catálogo
(`app/lib/pixel/catalog.dart`). Las herramientas de la carpeta `tools/` limpian y colocan las imágenes.

Al enviar arte aceptas que se publique bajo [CC BY 4.0](LICENSE-ARTE.md); el código, bajo [MIT](LICENSE).
