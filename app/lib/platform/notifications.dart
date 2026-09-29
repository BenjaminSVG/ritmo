import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/models.dart';

/// Recordatorios locales (sin servidor). Solo Android por ahora; en otras
/// plataformas todas las operaciones son no-ops.
///
/// Estrategia: tras cada cambio de datos se cancelan todas las notificaciones
/// y se reprograman desde cero. Es simple y evita estados desincronizados; con
/// cientos de elementos el coste es despreciable.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _permissionAsked = false;

  bool get _supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> init() async {
    if (!_supported || _ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Si falla, timezone usa UTC: los recordatorios saldrían desfasados.
      debugPrint('No se pudo detectar la zona horaria; se usa UTC');
    }
    // Un fallo aquí (por ejemplo, un icono que falta) no debe impedir que la app abra.
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_ritmo'),
        ),
      );
      _ready = true;
    } catch (e) {
      debugPrint('No se pudieron iniciar las notificaciones: $e');
    }
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Recordatorios',
      channelDescription: 'Recordatorios de tareas y hábitos',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  int _hash(String s) {
    var h = 0;
    for (final c in s.codeUnits) {
      h = (h * 31 + c) & 0x3FFFFF; // 22 bits: deja hueco para el día (×8)
    }
    return h;
  }

  /// Reprograma todos los recordatorios según el estado actual.
  Future<void> sync(List<Habit> habits, List<Task> tasks) async {
    if (!_supported) return;
    await init();
    final now = tz.TZDateTime.now(tz.local);

    final taskItems = tasks
        .where((t) => !t.done && t.hasTime && t.due != null && t.due!.isAfter(DateTime.now()))
        .toList();
    final habitItems =
        habits.where((h) => !h.archived && h.reminderMinutes != null).toList();

    await _plugin.cancelAll();
    if (taskItems.isEmpty && habitItems.isEmpty) return;

    if (!_permissionAsked) {
      _permissionAsked = true;
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    for (final t in taskItems) {
      final d = t.due!;
      await _plugin.zonedSchedule(
        id: _hash(t.id) * 8,
        title: 'Tarea',
        body: t.title,
        scheduledDate: tz.TZDateTime(tz.local, d.year, d.month, d.day, d.hour, d.minute),
        notificationDetails: _details,
        // Inexacto: evita el permiso de alarmas exactas; puede llegar con
        // algunos minutos de retraso en modo de ahorro de batería.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }

    for (final h in habitItems) {
      final m = h.reminderMinutes!;
      for (final wd in h.weekdays) {
        var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, m ~/ 60, m % 60);
        while (when.weekday != wd || !when.isAfter(now)) {
          when = when.add(const Duration(days: 1));
        }
        await _plugin.zonedSchedule(
          id: _hash(h.id) * 8 + wd, // wd 1–7 → ids únicos por día
          title: '${h.emoji} ${h.name}',
          body: 'Es hora de tu hábito',
          scheduledDate: when,
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }
}
