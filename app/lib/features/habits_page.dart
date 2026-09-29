import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_sheet.dart';
import 'app_state.dart';
import 'habit_detail_page.dart';
import 'widgets.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits =
        ref.watch(appDataProvider.select((d) => d.habits)).where((h) => !h.archived).toList();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (habits.isEmpty) {
      return EmptyState(
        icon: Icons.local_fire_department_outlined,
        text: 'Aún no tienes hábitos.\nEmpieza con uno pequeño.',
        action: FilledButton(
            onPressed: () => showAddSheet(context, initial: AddKind.habit),
            child: const Text('Crear hábito')),
      );
    }
    return ListView(padding: const EdgeInsets.only(top: 12, bottom: 96), children: [
      for (final h in habits)
        HabitTile(
          habit: h,
          day: today,
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => HabitDetailPage(habitId: h.id))),
        ),
    ]);
  }
}
