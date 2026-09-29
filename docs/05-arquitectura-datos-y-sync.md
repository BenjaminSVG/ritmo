# 5. Arquitectura, datos y sincronización

## 5.1 Arquitectura (capas limpias, por funcionalidad)

```
lib/
 ├─ main.dart
 ├─ app/                 # tema, rutas (go_router), l10n, layout adaptable
 ├─ core/                # utilidades: fechas/zonas horarias, recurrencia, parser NL, errores
 ├─ data/
 │   ├─ db/              # Drift: tablas, DAOs, migraciones
 │   ├─ repositories/    # implementaciones (Habit, Task, Event, Settings)
 │   └─ sync/            # cola de cambios, cliente Supabase (fase 2)
 ├─ domain/              # entidades y casos de uso (sin dependencias de Flutter)
 ├─ features/
 │   ├─ today/  habits/  tasks/  calendar/  stats/  settings/  onboarding/
 │   └─ (cada una: presentation/ + providers/)
 └─ platform/            # notificaciones, home_widget, escritorio (bandeja, atajos)
android/…/glance/        # widgets Kotlin
ios/HabitWidgets/        # widgets Swift
test/  integration_test/
```

Reglas: la UI solo habla con *providers* (Riverpod) → casos de uso → repositorios. La lógica de **rachas, recurrencia y estadísticas vive en `domain/` y se prueba con tests unitarios** (es donde están los errores sutiles).

## 5.2 Modelo de datos (SQLite / luego Postgres)

Convenciones: `id` = UUID v7 (permite crear offline sin colisiones), `created_at`, `updated_at`, `deleted_at` (borrado lógico para sync), `device_id`.

| Tabla | Campos principales |
|---|---|
| `habit` | id, name, icon, color, type (`check`/`count`/`timer`), target_value, unit, schedule_rrule, start_date, end_date, time_of_day, reminder_times[], archived_at, sort_order |
| `habit_log` | id, habit_id, **local_date** (yyyy-mm-dd), value, status (`done`/`skipped`/`failed`), note, logged_at |
| `task` | id, title, notes, list_id, priority (0–3), due_date, due_time, all_day, duration_min, rrule, parent_id, completed_at, sort_order |
| `task_list` | id, name, color, icon, sort_order |
| `tag` / `task_tag` | id, name, color / task_id, tag_id |
| `event` | id, title, start_at (UTC), end_at (UTC), tz, all_day, rrule, color, location, notes, external_id, calendar_id |
| `reminder` | id, owner_type, owner_id, offset/at, channel |
| `setting` | key, value |
| `sync_change` | id, table, row_id, op, payload, ts (cola de sincronización) |

Decisiones importantes:
- **Días de hábito como `local_date`** (texto de fecha), no como instante: "hoy" debe ser el día del usuario aunque viaje de zona horaria. Eventos sí en UTC + zona.
- **Recurrencia en RRULE (RFC 5545)**: compatible con Google Calendar/CalDAV; las excepciones ("solo este día") en tabla aparte o EXDATE.
- **Racha y puntuación se calculan** a partir de `habit_log` (no se guardan) o se cachean; así editar el pasado no rompe nada.
- **Puntuación tipo Loop**: media móvil exponencial que perdona un día perdido (por ejemplo factor 0,95^√frecuencia) — a definir y testear.
- Días de gracia / "congelar racha" como campo en ajustes del hábito.

## 5.3 Offline-first y sincronización (fase 2)

1. La app **siempre lee/escribe en SQLite**. La red es un detalle en segundo plano.
2. Cada escritura añade una fila en `sync_change`.
3. Sincronizador: *push* de cambios pendientes → *pull* de cambios del servidor desde `last_synced_at`.
4. **Resolución de conflictos**: *last-write-wins por campo* con reloj híbrido (HLC) o `updated_at` del servidor; para logs de hábitos, unión (un log por hábito y día). Borrados con `deleted_at`.
5. Seguridad: Supabase Auth (email, Google, Apple), **Row Level Security** (`user_id = auth.uid()`), HTTPS, datos sensibles opcionalmente cifrados en el cliente.
6. Alternativas para no reinventar: **PowerSync** o **ElectricSQL** (sincronizan Postgres ↔ SQLite); evaluar en un spike de 2–3 días antes de construir el propio.

## 5.4 Notificaciones y recordatorios
- **Locales programadas** (no dependen de servidor): `flutter_local_notifications` con zona horaria; reprogramar tras reinicio, cambio de zona horaria y actualización.
- **Android**: permisos `POST_NOTIFICATIONS` (Android 13+) y alarmas exactas (`SCHEDULE_EXACT_ALARM`/`USE_EXACT_ALARM` según caso) — justificar en Play Console; canales por tipo; ahorro de batería puede retrasar → guiar al usuario.
- **iOS**: límite de 64 notificaciones locales pendientes → programar en ventana móvil (próximos ~7 días) y rellenar al abrir la app / tarea de fondo.
- **Acciones en la notificación**: "Hecho", "Posponer 10 min" (procesadas sin abrir la app).
- **Escritorio**: notificaciones del sistema (Windows toast) mientras la app esté abierta o en bandeja.

## 5.5 Integración con calendarios externos
1. **Lectura de calendarios del dispositivo** (Android CalendarProvider / iOS EventKit) con `device_calendar`: simple, sin OAuth.
2. **Google Calendar API** (OAuth) o **CalDAV** para bidireccional en v1.x.
3. Los eventos externos se muestran con color atenuado y solo lectura al principio.

## 5.6 Calidad y rendimiento
- Índices por `(due_date)`, `(habit_id, local_date)`, `(start_at)`.
- Listas con `ListView.builder`; calendario con ventana de fechas cargada por demanda.
- Arranque en frío < 2 s; Hoy visible con datos de la caché local.
- Errores: Sentry/Crashlytics; migraciones de BD con tests.

## 5.7 Privacidad
- Sin cuenta por defecto; datos en el dispositivo. Exportar/borrar todo desde Ajustes.
- Política de privacidad y formulario de "Data safety" (Play) / "Privacy nutrition labels" (App Store) coherentes con lo anterior.
- Analítica solo con consentimiento y sin contenido de usuario.
