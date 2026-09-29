import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/store.dart';
import '../domain/models.dart';
import '../platform/notifications.dart';
import '../platform/widget_sync.dart';

class AppData {
  const AppData({this.habits = const [], this.tasks = const [], this.loaded = false});
  final List<Habit> habits;
  final List<Task> tasks;
  final bool loaded;

  AppData copy({List<Habit>? habits, List<Task>? tasks, bool? loaded}) => AppData(
        habits: habits ?? this.habits,
        tasks: tasks ?? this.tasks,
        loaded: loaded ?? this.loaded,
      );
}

final storeProvider = Provider<Store>((_) => PrefsStore());

final appDataProvider =
    NotifierProvider<AppDataNotifier, AppData>(AppDataNotifier.new);

class AppDataNotifier extends Notifier<AppData> {
  @override
  AppData build() {
    _load();
    return const AppData();
  }

  Future<void> _load() async {
    final (h, t) = await ref.read(storeProvider).load();
    state = AppData(habits: h, tasks: t, loaded: true);
    _syncReminders(h, t);
  }

  void _commit(List<Habit> habits, List<Task> tasks) {
    state = state.copy(habits: habits, tasks: tasks);
    ref.read(storeProvider).save(habits, tasks);
    _syncReminders(habits, tasks);
  }

  // Un fallo al programar recordatorios o actualizar el widget no debe romper
  // la app ni perder datos.
  void _syncReminders(List<Habit> habits, List<Task> tasks) {
    NotificationService.instance.sync(habits, tasks).catchError((Object e) {
      debugPrint('No se pudieron programar recordatorios: $e');
    });
    WidgetSync.update(habits, tasks).catchError((Object e) {
      debugPrint('No se pudo actualizar el widget: $e');
    });
  }

  String _id() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);

  // ---- Respaldo ----
  String exportJson() => jsonEncode({
        'version': 1,
        'habits': state.habits.map((h) => h.toJson()).toList(),
        'tasks': state.tasks.map((t) => t.toJson()).toList(),
      });

  /// Reemplaza todos los datos. Lanza [FormatException] si el JSON no es válido.
  void importJson(String raw) {
    final j = jsonDecode(raw);
    if (j is! Map<String, dynamic>) throw const FormatException('Formato inválido');
    final habits = ((j['habits'] as List?) ?? [])
        .map((e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList();
    final tasks = ((j['tasks'] as List?) ?? [])
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
    _commit(habits, tasks);
  }

  // ---- Hábitos ----
  void addHabit(String name,
      {String emoji = '✅',
      int color = 0xFF5C6BC0,
      HabitType type = HabitType.check,
      int target = 1,
      String unit = '',
      Set<int>? weekdays}) {
    final h = Habit(
        id: _id(),
        name: name,
        emoji: emoji,
        colorValue: color,
        type: type,
        target: target,
        unit: unit,
        weekdays: weekdays);
    _commit([...state.habits, h], state.tasks);
  }

  /// Marca/desmarca un hábito sí/no, o suma [delta] a uno de cantidad.
  void logHabit(String id, DateTime day, {int? delta}) {
    for (final h in state.habits) {
      if (h.id != id) continue;
      final k = dayKey(day);
      final cur = h.logs[k] ?? 0;
      final next = h.type == HabitType.check
          ? (cur >= h.target ? 0 : h.target)
          : (cur + (delta ?? 1)).clamp(0, 9999);
      if (next == 0) {
        h.logs.remove(k);
      } else {
        h.logs[k] = next;
      }
    }
    _commit([...state.habits], state.tasks);
  }

  void archiveHabit(String id) {
    for (final h in state.habits) {
      if (h.id == id) h.archived = true;
    }
    _commit([...state.habits], state.tasks);
  }

  // ---- Tareas ----
  void addTask(String title,
      {DateTime? due,
      bool hasTime = false,
      int priority = 0,
      Repeat repeat = Repeat.none,
      TaskKind kind = TaskKind.tarea,
      int? colorValue}) {
    final t = Task(
        id: _id(),
        title: title,
        due: due,
        hasTime: hasTime,
        priority: priority,
        repeat: repeat,
        kind: kind,
        colorValue: colorValue);
    _commit(state.habits, [...state.tasks, t]);
  }

  /// Completa/reabre una tarea. Al completar una tarea repetida se crea la
  /// siguiente ocurrencia (con subtareas reiniciadas).
  void toggleTask(String id) {
    final extra = <Task>[];
    for (final t in state.tasks) {
      if (t.id != id) continue;
      t.done = !t.done;
      t.doneAt = t.done ? DateTime.now() : null;
      final next = t.nextDue();
      if (t.done && next != null) {
        extra.add(Task(
          id: _id(),
          title: t.title,
          notes: t.notes,
          due: next,
          hasTime: t.hasTime,
          priority: t.priority,
          repeat: t.repeat,
          kind: t.kind,
          colorValue: t.colorValue,
          durationMin: t.durationMin,
          subtasks: [for (final s in t.subtasks) Subtask(s.title)],
        ));
        // La ocurrencia completada deja de repetirse para no duplicar.
        t.repeat = Repeat.none;
      }
    }
    _commit(state.habits, [...state.tasks, ...extra]);
  }

  /// Mueve una tarea con hora [dayDelta] días y [minuteDelta] minutos. La hora
  /// resultante se limita al día de destino (00:00–23:45) para que arrastrar
  /// hacia abajo no salte al día siguiente sin querer.
  void moveTask(String id, int dayDelta, int minuteDelta) {
    for (final t in state.tasks) {
      if (t.id != id || t.due == null) continue;
      final old = t.due!;
      final day = DateTime(old.year, old.month, old.day + dayDelta);
      final minutes = (old.hour * 60 + old.minute + minuteDelta).clamp(0, 24 * 60 - 15);
      t.due = DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);
    }
    _commit(state.habits, [...state.tasks]);
  }

  /// Aplica cambios hechos in situ sobre una tarea y guarda.
  void updateTask() => _commit(state.habits, [...state.tasks]);

  void updateHabit() => _commit([...state.habits], state.tasks);

  void deleteTask(String id) =>
      _commit(state.habits, state.tasks.where((t) => t.id != id).toList());

  void postponeTask(String id, DateTime to) {
    for (final t in state.tasks) {
      if (t.id != id) continue;
      final old = t.due;
      t.due = (t.hasTime && old != null)
          ? DateTime(to.year, to.month, to.day, old.hour, old.minute)
          : DateTime(to.year, to.month, to.day);
    }
    _commit(state.habits, [...state.tasks]);
  }
}
