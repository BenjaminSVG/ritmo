# 6. Widgets

Los widgets son el punto de contacto más frecuente: el usuario debería poder **ver y completar lo de hoy sin abrir la app**.

## 6.1 Catálogo de widgets

| Widget | Tamaños | Contenido | Interacción |
|---|---|---|---|
| **Hoy** | 4×2, 4×4 | Lista de hábitos + tareas de hoy, progreso "5/8" | Tocar el check completa; tocar el título abre el detalle |
| **Hábitos (cuadrícula)** | 2×2, 4×2 | Anillos/iconos de cada hábito | Un toque = marcar / +1 |
| **Racha / heatmap** | 2×2, 4×2 | Racha 🔥 y mini-heatmap de 4–8 semanas de un hábito | Abrir detalle |
| **Próximo evento** | 2×1, 4×1 | Siguiente evento o tarea con hora | Abrir |
| **Agenda** | 4×2, 4×4 | Lista de próximos 3–5 elementos con hora | Abrir |
| **Calendario mensual** | 4×4 | Mes con puntos en días con contenido | Abrir día |
| **Añadir rápido** | 1×1, 2×1 | Botón "+" | Abre hoja de creación |
| **Pantalla de bloqueo / Live Activity (iOS/Android 16)** | pequeño | Progreso del día, temporizador activo | v2 |

MVP: **Hoy**, **Hábitos**, **Añadir rápido** (3 widgets). El resto en v1.x.

## 6.2 Cómo se construyen (con Flutter)

Los widgets **no se dibujan con Flutter**: son componentes del sistema operativo. La app Flutter (Dart) actúa como fuente de datos y el widget nativo lee esos datos.

```
App Flutter (Dart) ──guarda JSON del "estado del día"──► almacenamiento compartido
                                                              │
                              Android: SharedPreferences ─────┤
                              iOS: App Group (UserDefaults) ──┘
                                                              ▼
                                        Widget nativo (Kotlin Glance / Swift WidgetKit) lo dibuja
Toque en el widget ──► acción/URI ──► Flutter (callback en segundo plano) ──► actualiza SQLite ──► refresca widgets
```

Paquete puente: **`home_widget`** (guardar datos, pedir actualización, recibir clics vía URI y callbacks en segundo plano).

> **Estado real**: el primer widget "Hoy" se implementó con el método clásico `AppWidgetProvider` + `RemoteViews` (XML), no con Glance, porque es más simple de integrar con Flutter y con el aviso de Kotlin del proyecto. Es de solo lectura. Glance sigue siendo la opción para widgets interactivos (abajo).

### Android — Jetpack Glance (Kotlin)
- Glance permite escribir el widget de forma declarativa, parecida a Compose.
- Widgets con **checkboxes/botones interactivos** vía `actionRunCallback` → llama al callback de Dart en segundo plano para marcar el hábito.
- Varios tamaños con `SizeMode.Responsive`; tema Material You (colores dinámicos).
- Actualización: al cambiar datos (la app pide refrescar) y periódica con WorkManager (mín. ~15 min); no depender de actualizaciones frecuentes.

### iOS — WidgetKit (Swift/SwiftUI)
- Target "Widget Extension" con **App Group** compartido con la app.
- **iOS 17+**: widgets interactivos con `Button(intent:)` y App Intents (completar hábito desde el widget).
- Actualización controlada por el sistema: usar *timelines* y `WidgetCenter.shared.reloadAllTimelines()` desde la app. El presupuesto de refresco es limitado.
- Requiere macOS/Xcode para compilar.

### Windows / macOS / Linux (escritorio)
- Windows: el panel de widgets de Windows 11 exige apps empaquetadas y su SDK propio → costoso para el MVP. **Alternativa recomendada**: **mini-ventana siempre visible** (frameless, "always on top") con el widget "Hoy", **icono en la bandeja del sistema** con menú rápido y **atajo global** para añadir (`window_manager`, `tray_manager`, `hotkey_manager`).
- macOS: WidgetKit real (como iOS) cuando se soporte.
- Web/PWA: sin widgets; se ofrecen notificaciones web.

## 6.3 Diseño de widgets
- Fondo translúcido/tarjeta con esquinas del sistema, tema claro/oscuro automático, colores de hábito como acento.
- Máx. 5–6 filas visibles + "+N más".
- Estado vacío ("¡Todo hecho por hoy! 🎉") y estado de error/datos antiguos.
- Ayuda contextual en Ajustes → "Cómo añadir un widget".

## 6.4 Riesgos y pruebas
- Doble fuente de verdad: el widget nunca escribe en la BD directamente; siempre pasa por Dart, o bien usa una cola simple que Dart procesa al abrirse.
- Probar: reinicio del dispositivo, ahorro de batería, cambio de día a medianoche (el widget debe pasar a "hoy nuevo" sin abrir la app), cambio de zona horaria.
- Pruebas en dispositivo real (los emuladores no reflejan el ahorro de batería).
