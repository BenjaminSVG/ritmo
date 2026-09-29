import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models.dart';

/// Persistencia local. Implementación provisional sobre shared_preferences
/// (JSON). Se reemplazará por Drift/SQLite manteniendo esta interfaz.
abstract class Store {
  Future<(List<Habit>, List<Task>)> load();
  Future<void> save(List<Habit> habits, List<Task> tasks);
}

class PrefsStore implements Store {
  static const key = 'ritmo.data.v1';

  @override
  Future<(List<Habit>, List<Task>)> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return (<Habit>[], <Task>[]);
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return (
      ((j['habits'] as List?) ?? [])
          .map((e) => Habit.fromJson(e as Map<String, dynamic>))
          .toList(),
      ((j['tasks'] as List?) ?? [])
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<void> save(List<Habit> habits, List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        key,
        jsonEncode({
          'habits': habits.map((h) => h.toJson()).toList(),
          'tasks': tasks.map((t) => t.toJson()).toList(),
        }));
  }
}
