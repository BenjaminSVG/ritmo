import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'add_sheet.dart';
import 'app_state.dart';
import 'habit_detail_page.dart';
import 'settings_page.dart';
import 'widgets.dart';

/// Pantalla principal: hábitos + tareas de hoy en una sola lista.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final habits =
        data.habits.where((h) => !h.archived && h.isScheduledOn(today)).toList();
    final overdue = data.tasks
        .where((t) => !t.done && t.due != null && t.due!.isBefore(today))
        .toList();
    final todayTasks = data.tasks
        .where((t) =>
            t.due != null && !t.due!.isBefore(today) && t.due!.isBefore(tomorrow))
        .toList()
      ..sort((a, b) => a.due!.compareTo(b.due!));
    final pending = todayTasks.where((t) => !t.done).toList();
    final completed = todayTasks.where((t) => t.done).toList();

    final total = habits.length + todayTasks.length;
    final doneCount = habits.where((h) => h.isDoneOn(today)).length + completed.length;

    if (!data.loaded) return const Center(child: CircularProgressIndicator());

    return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(
                  toBeginningOfSentenceCase(DateFormat("EEEE d 'de' MMMM", 'es').format(now))!,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            IconButton(
              tooltip: 'Ajustes',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
            ),
          ]),
          const SizedBox(height: 12),
          if (total > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: doneCount / total, minHeight: 10),
            ),
            const SizedBox(height: 6),
            Text('$doneCount/$total completado'),
          ],
        ]),
      ),
      if (total == 0 && overdue.isEmpty)
        SizedBox(
          height: 360,
          child: EmptyState(
            icon: Icons.wb_sunny_outlined,
            text: 'Nada para hoy.\nCrea tu primer hábito o tarea.',
            action: FilledButton.icon(
                onPressed: () => showAddSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Añadir')),
          ),
        ),
      if (overdue.isNotEmpty) ...[
        SectionHeader('Atrasadas', count: overdue.length),
        for (final t in overdue) TaskTile(task: t),
      ],
      if (habits.isNotEmpty) ...[
        const SectionHeader('Hábitos'),
        for (final h in habits)
          HabitTile(
            habit: h,
            day: today,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => HabitDetailPage(habitId: h.id))),
          ),
      ],
      if (pending.isNotEmpty) ...[
        SectionHeader('Tareas de hoy', count: pending.length),
        for (final t in pending) TaskTile(task: t),
      ],
      if (completed.isNotEmpty) ...[
        SectionHeader('Completadas', count: completed.length),
        for (final t in completed) TaskTile(task: t),
      ],
    ]);
  }
}
