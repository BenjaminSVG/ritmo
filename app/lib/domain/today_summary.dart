import 'models.dart';

/// Resumen del día para widgets: título, progreso ("5/8") y hasta [maxLines]
/// líneas con lo pendiente (atrasadas y hábitos primero, luego tareas por hora).
class TodaySummary {
  const TodaySummary({required this.progress, required this.lines});
  final String progress;
  final List<String> lines;
}

TodaySummary buildTodaySummary(List<Habit> habits, List<Task> tasks, DateTime now,
    {int maxLines = 5}) {
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  final dayHabits =
      habits.where((h) => !h.archived && h.isScheduledOn(today)).toList();
  final dayTasks = tasks
      .where((t) => t.due != null && !t.due!.isBefore(today) && t.due!.isBefore(tomorrow))
      .toList();
  final overdue =
      tasks.where((t) => !t.done && t.due != null && t.due!.isBefore(today)).toList();

  final total = dayHabits.length + dayTasks.length;
  final done = dayHabits.where((h) => h.isDoneOn(today)).length +
      dayTasks.where((t) => t.done).length;

  final pending = <String>[
    for (final t in overdue) '⚠ ${t.title}',
    for (final h in dayHabits.where((h) => !h.isDoneOn(today)))
      '${h.emoji} ${h.name}${h.type == HabitType.count ? ' ${h.valueOn(today)}/${h.target}' : ''}',
    for (final t in (dayTasks.where((t) => !t.done).toList()
      ..sort((a, b) => a.due!.compareTo(b.due!))))
      '${t.kind == TaskKind.tarea ? '☐' : t.kind.emoji} ${t.hasTime ? '${_hm(t.due!)} ' : ''}${t.title}',
  ];

  var lines = pending.take(maxLines).toList();
  final extra = pending.length - lines.length;
  if (extra > 0) {
    // La última línea avisa de cuántas quedan fuera.
    lines = [...lines.take(maxLines - 1), '+${extra + 1} más'];
  }
  if (pending.isEmpty) {
    lines = [total == 0 ? 'Nada para hoy' : '¡Todo hecho por hoy! 🎉'];
  }
  return TodaySummary(progress: total == 0 ? '' : '$done/$total', lines: lines);
}

/// Una fila del widget de hábitos: nombre y estado ("✓", "3/8 vasos", "0/1").
class HabitRowSummary {
  const HabitRowSummary(this.name, this.status);
  final String name;
  final String status;
}

/// Hábitos de hoy para el widget "Hábitos": pendientes primero, luego hechos.
/// Devuelve el progreso "hechos/total" y como mucho [maxRows] filas.
(String, List<HabitRowSummary>) buildHabitsSummary(List<Habit> habits, DateTime now,
    {int maxRows = 6}) {
  final today = DateTime(now.year, now.month, now.day);
  final day = habits.where((h) => !h.archived && h.isScheduledOn(today)).toList();
  final done = day.where((h) => h.isDoneOn(today)).length;
  day.sort((a, b) => (a.isDoneOn(today) ? 1 : 0).compareTo(b.isDoneOn(today) ? 1 : 0));

  HabitRowSummary row(Habit h) {
    final v = h.valueOn(today);
    final status = h.isDoneOn(today)
        ? '✓'
        : h.type == HabitType.count
            ? '$v/${h.target}${h.unit.isEmpty ? '' : ' ${h.unit}'}'
            : '0/1';
    return HabitRowSummary('${h.emoji} ${h.name}', status);
  }

  return (day.isEmpty ? '' : '$done/${day.length}', day.take(maxRows).map(row).toList());
}

/// Hábito que mostrará el widget de racha: el de mejor racha actual entre los
/// activos (el primero si ninguno tiene racha). Null si no hay hábitos.
Habit? pickHeatmapHabit(List<Habit> habits, int Function(Habit) streakOf) {
  final active = habits.where((h) => !h.archived).toList();
  if (active.isEmpty) return null;
  var best = active.first;
  for (final h in active) {
    if (streakOf(h) > streakOf(best)) best = h;
  }
  return best;
}

String _hm(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
