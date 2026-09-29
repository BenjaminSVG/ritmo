# 7. Roadmap, testing y lanzamiento

Estimación para **1 desarrollador a tiempo parcial (~15–20 h/semana)**. Ajustar si son más personas.

## 7.1 Fases

| Fase | Semanas | Entregable |
|---|---|---|
| **0. Preparación** | 1 | Instalar Flutter/Android Studio, repositorio Git, CI básico, wireframes en Figma, nombre y marca |
| **1. Núcleo de datos** | 2–3 | Drift + esquema, repositorios, lógica de rachas/recurrencia con tests, tema y navegación adaptable |
| **2. Hábitos** | 4–5 | Crear/editar, marcar, detalle con heatmap y gráficos, recordatorios |
| **3. Tareas** | 6–7 | Bandeja/Hoy/Próximos, subtareas, repetición, parser de lenguaje natural |
| **4. Pantalla Hoy + Calendario** | 8–10 | Hoy unificada; calendario Día/Semana/Mes/Agenda con arrastrar y soltar |
| **5. Widgets + notificaciones** | 11–12 | Widgets Android (Hoy, Hábitos, +), notificaciones accionables, versión Windows con bandeja |
| **6. Pulido y beta** | 13–14 | Onboarding, accesibilidad, rendimiento, exportar/importar, beta cerrada (20–50 personas) |
| **7. Lanzamiento v1.0** | 15 | Google Play + Microsoft Store (+ instalador Windows) |
| **8. v1.x** | 16+ | Sync (Supabase/PowerSync), iOS + widgets iOS, integración calendarios, salud, Pomodoro |

Hitos de decisión: fin de fase 1 (¿el modelo de datos aguanta?), fin de fase 4 (¿Hoy se siente simple? test con usuarios), fin de fase 6 (¿listos para publicar?).

## 7.2 Testing
- **Unitarias (obligatorias)**: rachas, puntuación, recurrencia (fin de mes, años bisiestos, cambio de horario de verano, zonas horarias), parser de lenguaje natural (ES/EN).
- **Widget tests** de pantallas clave; **golden tests** para el diseño de tarjetas y widgets.
- **Integración** (`integration_test` / `patrol`): flujo crear hábito → marcar → ver racha; crear tarea con fecha → aparece en Hoy y Calendario.
- **Dispositivo real**: notificaciones exactas, ahorro de batería, widgets, reinicio, cambio de medianoche.
- **Usabilidad**: 5 usuarios con tareas cronometradas (meta: crear elemento < 10 s).
- **Accesibilidad**: TalkBack/VoiceOver, texto grande, contraste.
- CI: analizar + tests en cada PR; compilación Android/Windows en cada `main`.

## 7.3 Publicación
| Tienda | Requisitos | Costo aprox. |
|---|---|---|
| Google Play | Cuenta de desarrollador, política de privacidad, formulario Data safety, pruebas cerradas si la cuenta es personal nueva | US$ 25 (una vez) |
| App Store | Mac/CI macOS, cuenta Apple Developer, revisión de guías | US$ 99/año |
| Microsoft Store | Cuenta de desarrollador, empaquetado MSIX | ~US$ 19 (una vez, individuo) |
| Web (opcional) | Hosting estático (Firebase Hosting/Cloudflare Pages) | Gratis–bajo |

Verificar montos y requisitos vigentes en cada tienda antes de pagar.

Material de tienda: icono, 5–8 capturas (idea: pantalla Hoy, hábito con heatmap, calendario, widgets), descripción en ES/EN, vídeo corto.

## 7.4 Costos estimados (MVP local)
- Herramientas: **US$ 0** (Flutter, VS Code, Figma gratis, GitHub gratis).
- Cuentas de tiendas: ~US$ 25 (Play) + ~US$ 19 (Microsoft) inicialmente; iOS después.
- Backend Supabase: plan gratuito al inicio; escalar según usuarios.

## 7.5 Riesgos y mitigaciones
| Riesgo | Mitigación |
|---|---|
| Notificaciones poco fiables (ahorro de batería) | Probar en varias marcas; guía dentro de la app; recordatorio de "cómo mantenerlas activas" |
| Widgets consumen tiempo (código nativo) | Solo 3 widgets en MVP; plantilla reutilizable |
| Calendario con arrastrar es complejo | Empezar con lista/Agenda y Día; arrastrar como mejora; considerar paquete y personalizar |
| Sync con conflictos | Lanzar v1.0 sin sync; usar PowerSync/Supabase; modelo con UUID y `deleted_at` desde el inicio |
| iOS sin Mac | CI en la nube (Codemagic), o postergar iOS |
| Alcance excesivo | Mantener la lista "Fuera de alcance"; mirar métricas antes de añadir |
| Competencia fuerte | Diferenciarse en simplicidad, privacidad, offline y precio |

## 7.6 Primeros pasos concretos (esta semana)
1. Instalar Flutter y Android Studio; ejecutar `flutter doctor` y `flutter create ritmo`.
2. Dibujar en Figma las pantallas Hoy, Crear y Detalle de hábito.
3. Crear el esquema Drift (`habit`, `habit_log`, `task`) y escribir los tests de racha.
4. Maquetar la pantalla Hoy con datos falsos y validarla con 2–3 personas.
