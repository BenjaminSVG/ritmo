import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import '../domain/streaks.dart';
import 'app_state.dart';
import 'habit_edit_page.dart';

/// Detalle: puntuación, rachas y mapa de calor de las últimas 12 semanas.
class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({super.key, required this.habitId});
  final String habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = ref
        .watch(appDataProvider.select((d) => d.habits))
        .where((h) => h.id == habitId)
        .firstOrNull;
    if (habit == null) return const Scaffold();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final color = Color(habit.colorValue);

    Widget stat(String label, String value) => Expanded(
          child: Column(children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ]),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('${habit.emoji} ${habit.name}'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => HabitEditPage(habit: habit))),
          ),
          IconButton(
            tooltip: 'Archivar',
            icon: const Icon(Icons.archive_outlined),
            onPressed: () {
              ref.read(appDataProvider.notifier).archiveHabit(habit.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          color: color.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(children: [
              stat('Puntuación', '${(habitScore(habit, today) * 100).round()}%'),
              stat('Racha', '🔥 ${currentStreak(habit, today)}'),
              stat('Mejor', '${bestStreak(habit)}'),
              stat('30 días', '${(completionRate(habit, today) * 100).round()}%'),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Text('Últimas 12 semanas', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _Heatmap(habit: habit, today: today, color: color),
        const SizedBox(height: 8),
        Text('Toca un día para marcarlo o desmarcarlo.',
            style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}

class _Heatmap extends ConsumerWidget {
  const _Heatmap({required this.habit, required this.today, required this.color});
  final Habit habit;
  final DateTime today;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const weeks = 12;
    // Columnas = semanas (lunes→domingo), la última contiene hoy.
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day - 7 * (weeks - 1));
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (var w = 0; w < weeks; w++)
        Column(children: [
          for (var d = 0; d < 7; d++)
            Builder(builder: (_) {
              final day = DateTime(start.year, start.month, start.day + w * 7 + d);
              final future = day.isAfter(today);
              final done = habit.isDoneOn(day);
              final partial = !done && habit.valueOn(day) > 0;
              return GestureDetector(
                onTap: future
                    ? null
                    : () => ref.read(appDataProvider.notifier).logHabit(habit.id, day),
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: future
                        ? Colors.transparent
                        : done
                            ? color
                            : partial
                                ? color.withValues(alpha: 0.4)
                                : Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: day == today
                        ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.5)
                        : null,
                  ),
                ),
              );
            }),
        ]),
    ]);
  }
}
