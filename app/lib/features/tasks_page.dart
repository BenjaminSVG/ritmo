import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_sheet.dart';
import 'app_state.dart';
import 'widgets.dart';

/// Tareas agrupadas: Bandeja (sin fecha), Atrasadas, Hoy, Próximas, Hechas.
class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(appDataProvider.select((d) => d.tasks));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final open = tasks.where((t) => !t.done).toList();
    final inbox = open.where((t) => t.due == null).toList();
    final overdue = open.where((t) => t.due != null && t.due!.isBefore(today)).toList();
    final todayL = open
        .where((t) => t.due != null && !t.due!.isBefore(today) && t.due!.isBefore(tomorrow))
        .toList();
    final upcoming = open.where((t) => t.due != null && !t.due!.isBefore(tomorrow)).toList()
      ..sort((a, b) => a.due!.compareTo(b.due!));
    final done = tasks.where((t) => t.done).toList()
      ..sort((a, b) => (b.doneAt ?? today).compareTo(a.doneAt ?? today));

    if (tasks.isEmpty) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        text: 'Sin tareas.\nEscribe una frase como\n“Llamar al banco mañana 4pm !alta”.',
        action: FilledButton(
            onPressed: () => showAddSheet(context, initial: AddKind.task),
            child: const Text('Nueva tarea')),
      );
    }

    Widget group(String title, List l) => l.isEmpty
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionHeader(title, count: l.length),
            for (final t in l) TaskTile(task: t),
          ]);

    return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
      group('Atrasadas', overdue),
      group('Hoy', todayL),
      group('Próximas', upcoming),
      group('Bandeja de entrada', inbox),
      group('Completadas', done.take(20).toList()),
    ]);
  }
}
