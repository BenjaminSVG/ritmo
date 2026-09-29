import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/data/db/database.dart';
import 'package:ritmo/data/drift_store.dart';
import 'package:ritmo/data/store.dart';
import 'package:ritmo/domain/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('guardar y cargar conserva hábitos, registros, tareas y subtareas', () async {
    final store = DriftStore(db);
    final habit = Habit(
      id: 'h1',
      name: 'Beber agua',
      emoji: '💧',
      type: HabitType.count,
      target: 8,
      unit: 'vasos',
      weekdays: {1, 3, 5},
      logs: {'2026-09-28': 5, '2026-09-27': 8},
      reminderMinutes: 9 * 60 + 30,
    );
    final task = Task(
      id: 't1',
      title: 'Informe',
      notes: 'nota',
      due: DateTime(2026, 9, 29, 16, 30),
      hasTime: true,
      priority: 3,
      repeat: Repeat.weekly,
      durationMin: 90,
      kind: TaskKind.prueba,
      colorValue: 0xFFE53935,
      subtasks: [Subtask('a'), Subtask('b', done: true)],
    );
    await store.save([habit], [task]);

    final (habits, tasks) = await store.load();
    final h = habits.single;
    expect(h.name, 'Beber agua');
    expect(h.type, HabitType.count);
    expect(h.weekdays, {1, 3, 5});
    expect(h.logs, {'2026-09-28': 5, '2026-09-27': 8});
    expect(h.reminderMinutes, 570);
    final t = tasks.single;
    expect(t.due, DateTime(2026, 9, 29, 16, 30));
    expect(t.priority, 3);
    expect(t.repeat, Repeat.weekly);
    expect(t.durationMin, 90);
    expect(t.kind, TaskKind.prueba);
    expect(t.colorValue, 0xFFE53935);
    expect(t.effectiveColor, 0xFFE53935);
    expect(t.subtasks.map((s) => (s.title, s.done)), [('a', false), ('b', true)]);
  });

  test('guardar de nuevo reemplaza el contenido (borrados incluidos)', () async {
    final store = DriftStore(db);
    await store.save([Habit(id: 'h', name: 'x')], [Task(id: 't', title: 'y')]);
    await store.save([], []);
    final (habits, tasks) = await store.load();
    expect(habits, isEmpty);
    expect(tasks, isEmpty);
  });

  test('migra una sola vez los datos del guardado anterior', () async {
    SharedPreferences.setMockInitialValues({
      PrefsStore.key: jsonEncode({
        'habits': [Habit(id: 'h', name: 'Leer').toJson()],
        'tasks': [Task(id: 't', title: 'Vieja').toJson()],
      }),
    });
    final prefs = await SharedPreferences.getInstance();

    final (habits, tasks) = await DriftStore(db, legacyPrefs: prefs).load();
    expect(habits.single.name, 'Leer');
    expect(tasks.single.title, 'Vieja');

    // Si el usuario borra todo, no se vuelve a importar lo antiguo.
    final store = DriftStore(db, legacyPrefs: prefs);
    await store.save([], []);
    final (h2, t2) = await store.load();
    expect(h2, isEmpty);
    expect(t2, isEmpty);
  });
}
