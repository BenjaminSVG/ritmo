import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';
import 'db/database.dart';
import 'store.dart';

/// Persistencia en SQLite (Drift). Guarda el estado completo dentro de una
/// transacción: si algo falla no queda una escritura a medias.
///
/// Limitación conocida: reescribe todas las filas en cada cambio. Es correcto
/// y simple para el volumen actual; cuando haga falta (sync, miles de
/// registros) se pasará a escrituras incrementales por fila.
class DriftStore implements Store {
  DriftStore(this.db, {SharedPreferences? legacyPrefs}) : _prefs = legacyPrefs;

  final AppDatabase db;
  final SharedPreferences? _prefs;

  static const _migratedFlag = 'ritmo.migrated_to_drift.v1';

  @override
  Future<(List<Habit>, List<Task>)> load() async {
    await _migrateLegacyOnce();
    return _read();
  }

  Future<(List<Habit>, List<Task>)> _read() async {
    final habitRows = await (db.select(db.habits)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final logRows = await db.select(db.habitLogs).get();
    final taskRows = await (db.select(db.tasks)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final subRows = await (db.select(db.subtasks)
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();

    final logsByHabit = <String, Map<String, int>>{};
    for (final l in logRows) {
      (logsByHabit[l.habitId] ??= {})[l.day] = l.value;
    }
    final subsByTask = <String, List<Subtask>>{};
    for (final s in subRows) {
      (subsByTask[s.taskId] ??= []).add(Subtask(s.title, done: s.done));
    }

    final habits = [
      for (final r in habitRows)
        Habit(
          id: r.id,
          name: r.name,
          emoji: r.emoji,
          colorValue: r.colorValue,
          type: HabitType.values.byName(r.type),
          target: r.target,
          unit: r.unit,
          weekdays: r.weekdays.isEmpty
              ? <int>{}
              : r.weekdays.split(',').map(int.parse).toSet(),
          logs: logsByHabit[r.id] ?? {},
          archived: r.archived,
          reminderMinutes: r.reminderMinutes,
          category: HabitCategory.values.asNameMap()[r.category] ?? HabitCategory.ninguna,
        ),
    ];
    final tasks = [
      for (final r in taskRows)
        Task(
          id: r.id,
          title: r.title,
          notes: r.notes,
          due: r.due,
          hasTime: r.hasTime,
          priority: r.priority,
          done: r.done,
          doneAt: r.doneAt,
          repeat: Repeat.values.byName(r.repeat),
          durationMin: r.durationMin,
          kind: TaskKind.values.asNameMap()[r.kind] ?? TaskKind.tarea,
          colorValue: r.colorValue,
          subtasks: subsByTask[r.id] ?? [],
        ),
    ];
    return (habits, tasks);
  }

  @override
  Future<void> save(List<Habit> habits, List<Task> tasks) {
    return db.transaction(() async {
      await db.delete(db.subtasks).go();
      await db.delete(db.tasks).go();
      await db.delete(db.habitLogs).go();
      await db.delete(db.habits).go();

      await db.batch((b) {
        for (var i = 0; i < habits.length; i++) {
          final h = habits[i];
          b.insert(
              db.habits,
              HabitsCompanion.insert(
                id: h.id,
                name: h.name,
                emoji: h.emoji,
                colorValue: h.colorValue,
                type: h.type.name,
                target: h.target,
                unit: h.unit,
                weekdays: (h.weekdays.toList()..sort()).join(','),
                archived: h.archived,
                reminderMinutes: Value(h.reminderMinutes),
                category: Value(h.category.name),
                sortOrder: i,
              ));
          for (final e in h.logs.entries) {
            b.insert(db.habitLogs,
                HabitLogsCompanion.insert(habitId: h.id, day: e.key, value: e.value));
          }
        }
        for (var i = 0; i < tasks.length; i++) {
          final t = tasks[i];
          b.insert(
              db.tasks,
              TasksCompanion.insert(
                id: t.id,
                title: t.title,
                notes: t.notes,
                due: Value(t.due),
                hasTime: t.hasTime,
                priority: t.priority,
                done: t.done,
                doneAt: Value(t.doneAt),
                repeat: t.repeat.name,
                durationMin: Value(t.durationMin),
                kind: Value(t.kind.name),
                colorValue: Value(t.colorValue),
                sortOrder: i,
              ));
          for (var p = 0; p < t.subtasks.length; p++) {
            b.insert(
                db.subtasks,
                SubtasksCompanion.insert(
                  taskId: t.id,
                  position: p,
                  title: t.subtasks[p].title,
                  done: t.subtasks[p].done,
                ));
          }
        }
      });
    });
  }

  /// Importa una sola vez los datos del guardado anterior (JSON en
  /// shared_preferences). No borra el original: queda como copia de seguridad.
  Future<void> _migrateLegacyOnce() async {
    final prefs = _prefs;
    if (prefs == null || prefs.getBool(_migratedFlag) == true) return;
    final dbEmpty = (await db.select(db.habits).get()).isEmpty &&
        (await db.select(db.tasks).get()).isEmpty;
    if (dbEmpty && prefs.getString(PrefsStore.key) != null) {
      final (h, t) = await PrefsStore().load();
      await save(h, t);
    }
    await prefs.setBool(_migratedFlag, true);
  }
}
