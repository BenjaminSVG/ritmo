# 4. Tecnologías y lenguajes

Logos de referencia: [../referencias/logos-tecnologias/](../referencias/logos-tecnologias/) (flutter, dart, kotlin, react, typescript, swift, android, sqlite, supabase, firebase).

## 4.1 Requisito que decide todo
Una app para **Android + iOS + PC**, con **widgets** de pantalla de inicio, notificaciones locales fiables, calendario con interacción táctil compleja (arrastrar bloques) y funcionamiento offline.

## 4.2 Opciones comparadas

| Criterio | **Flutter (Dart)** | React Native + Expo (TypeScript) | Kotlin Multiplatform (+ Compose MP) | Nativo (Kotlin + Swift + C#) |
|---|---|---|---|---|
| Código compartido | UI + lógica (~95 %) | UI + lógica en móvil; escritorio menos maduro | Lógica; UI compartida con Compose Multiplatform (estable desde mayo 2025) o nativa | 0 % |
| Android / iOS | ✔ | ✔ | ✔ | ✔ |
| **Windows / macOS / Linux** | ✔ soporte oficial | Parcial (proyectos aparte: RN Windows/macOS) | ✔ (Compose Desktop, JVM) | Tres apps distintas |
| Web | ✔ | ✔ (RN Web) | En evolución (Wasm) | — |
| UI propia y consistente | ✔ dibuja sus píxeles (idéntica en todas partes) | Usa componentes nativos | Compose (dibuja propio) | Máxima fidelidad nativa |
| Widgets pantalla inicio | Requiere código nativo (Kotlin/Swift) + `home_widget` | Igual, código nativo + librerías | Android fácil (mismo Kotlin), iOS en Swift | Nativo directo |
| Curva de aprendizaje | Media (Dart es simple) | Baja si sabes JS/TS | Alta (Kotlin + KMP + Swift) | Muy alta |
| Ecosistema | Muy grande (pub.dev) | El mayor (npm) | Creciendo | — |
| Cuota entre desarrolladores (2026) | ~46 % | ~35–42 % | ~23 % (creció rápido) | — |

Cifras de cuota y estado de madurez según los análisis 2026 enlazados en [fuentes.md](fuentes.md).

## 4.3 Decisión: **Flutter + Dart**

**Por qué**
- Es la única opción con **soporte oficial y maduro de Android, iOS, Windows, macOS, Linux y Web** desde un solo proyecto → cumple "que pueda soportar hasta en PC".
- UI idéntica en todas las plataformas: ideal para un calendario/agenda con diseño propio.
- Dart es fácil de aprender; hot-reload acelera el trabajo de UI.
- Buen soporte de bases locales, notificaciones y layouts adaptables.
- Los análisis 2026 recomiendan Flutter para "UI pulida de marca" y cuando hay ambiciones de escritorio/web.

**Costos/limitaciones aceptadas**
- **Widgets**: se escriben en código nativo (Kotlin y Swift). Es una porción pequeña del proyecto (ver [06-widgets](06-widgets.md)).
- Tamaño de app algo mayor que una nativa.
- **iOS**: compilar y publicar requiere macOS. Con un PC Windows: usar un servicio de CI en la nube (Codemagic, GitHub Actions macOS) o una Mac más adelante. Plan: **Android + Windows primero**.

**Cuándo reconsiderar**
- Si ya dominas TypeScript y el escritorio no importa → React Native + Expo.
- Si el equipo es de Kotlin y quieres UI nativa en iOS → KMP.

## 4.4 Lenguajes que se usarán
| Lenguaje | Dónde | Proporción aprox. |
|---|---|---|
| **Dart** | App completa (UI, lógica, datos, sync) | ~90 % |
| **Kotlin** | Widgets Android (Jetpack Glance), canales de notificación si hacen falta | ~4 % |
| **Swift** | Widgets iOS (WidgetKit/SwiftUI), App Intents | ~4 % |
| **SQL** (SQLite/Postgres) | Esquema y consultas, políticas RLS en el servidor | ~2 % |
| TypeScript/SQL (opcional) | Funciones de servidor (Supabase Edge Functions) si se necesitan | — |

## 4.5 Librerías recomendadas (Flutter)

| Necesidad | Paquete | Nota |
|---|---|---|
| Estado / DI | **Riverpod** | Testeable, escalable |
| Navegación | **go_router** | Rutas profundas (abrir tarea desde widget/notificación) |
| Base local | **Drift** (SQLite tipado) | Consultas reactivas, migraciones |
| Modelos | **freezed** + **json_serializable** | Inmutabilidad |
| Notificaciones locales | **flutter_local_notifications** + **timezone** | Recordatorios programados |
| Widgets | **home_widget** | Puente Flutter ↔ widgets nativos |
| Calendario UI | **calendar_view** o **syncfusion_flutter_calendar** (revisar licencia) o custom | Probablemente custom para arrastrar bloques |
| Recurrencia | **rrule** | Formato RFC 5545 (compatible con Google/CalDAV) |
| Lenguaje natural de fechas | Parser propio + tests (o `any_date`) | Español/inglés |
| Gráficos | **fl_chart** | Heatmap propio con `CustomPainter` |
| Sync/Auth | **supabase_flutter** | Fase 2 |
| Escritorio | **window_manager**, **tray_manager**, **hotkey_manager** | Bandeja del sistema, atajos globales |
| Salud | **health** | Health Connect / HealthKit |
| Pruebas | flutter_test, **mocktail**, integration_test, **patrol** | |
| Análisis | flutter_lints, **very_good_analysis** | |

## 4.6 Backend (fase 2)
| Opción | Pros | Contras |
|---|---|---|
| **Supabase** (Postgres + Auth + Realtime + Storage) — *recomendada* | SQL estándar, RLS, plan gratuito, código abierto/auto-hospedable | Sync offline hay que diseñarlo |
| Firebase (Firestore) | Offline integrado, muy conocido | Modelo NoSQL menos cómodo para agenda/consultas; dependencia de Google |
| Servidor propio (Dart/Go/Node + Postgres) | Control total | Más mantenimiento |

Empezar **sin backend** (MVP local) reduce costo y riesgo.

## 4.7 Herramientas de desarrollo
- **Flutter SDK** + Android Studio (emulador) + VS Code; Git + GitHub; GitHub Actions o Codemagic para CI/CD.
- Figma para diseño; Sentry/Crashlytics para errores; PostHog (opcional, con consentimiento) para métricas.
- Requisitos actuales de tu PC: no hay Flutter instalado todavía (verificado: `flutter` no está en el PATH), hay Node.js, Python y VS Code.
