import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/models.dart';
import '../domain/streaks.dart';
import 'app_state.dart';
import 'task_edit_page.dart';

String hhmm(DateTime d) => DateFormat.Hm().format(d);

/// Fila de hábito con anillo de progreso y botón según tipo (✓ / +1).
class HabitTile extends ConsumerWidget {
  const HabitTile({super.key, required this.habit, required this.day, this.onTap});
  final Habit habit;
  final DateTime day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(habit.colorValue);
    final value = habit.valueOn(day);
    final progress = (value / habit.target).clamp(0.0, 1.0);
    final done = habit.isDoneOn(day);
    final notifier = ref.read(appDataProvider.notifier);
    final streak = currentStreak(habit, day);

    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 44,
        height: 44,
        child: Stack(alignment: Alignment.center, children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            color: color,
            backgroundColor: color.withValues(alpha: 0.18),
          ),
          Text(habit.emoji, style: const TextStyle(fontSize: 18)),
        ]),
      ),
      title: Text(habit.name,
          style: done
              ? TextStyle(color: Theme.of(context).disabledColor)
              : null),
      subtitle: Text(habit.type == HabitType.count
          ? '$value/${habit.target} ${habit.unit}${streak > 0 ? '  ·  🔥 $streak' : ''}'
          : (streak > 0 ? '🔥 $streak ${streak == 1 ? 'día' : 'días'}' : 'Sin racha aún')),
      trailing: habit.type == HabitType.count
          ? FilledButton.tonal(
              onPressed: () => notifier.logHabit(habit.id, day, delta: 1),
              child: const Text('+1'))
          : Checkbox(
              value: done,
              shape: const CircleBorder(),
              activeColor: color,
              onChanged: (_) => notifier.logHabit(habit.id, day)),
    );
  }
}

/// Fila de tarea con check, hora y prioridad. Deslizar → completar.
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});
  final Task task;

  static const _prioColors = [null, Colors.blue, Colors.orange, Colors.red];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appDataProvider.notifier);
    final color = task.effectiveColor;
    final now = DateTime.now();
    final due = task.due;
    // Con hora: vence a esa hora; sin hora: vence al terminar ese día.
    final overdue = !task.done &&
        due != null &&
        (task.hasTime
            ? due.isBefore(now)
            : DateTime(due.year, due.month, due.day + 1).isBefore(now));
    return Dismissible(
      key: ValueKey('task-${task.id}'),
      background: Container(
          color: Colors.green.withValues(alpha: 0.3),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          child: const Icon(Icons.check)),
      secondaryBackground: Container(
          color: Colors.blue.withValues(alpha: 0.3),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(Icons.schedule)),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          notifier.toggleTask(task.id);
        } else {
          final now = DateTime.now();
          notifier.postponeTask(task.id, DateTime(now.year, now.month, now.day + 1));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pospuesta para mañana')));
          }
        }
        return false;
      },
      child: ListTile(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => TaskEditPage(task: task))),
        subtitle: (task.subtasks.isEmpty &&
                task.repeat == Repeat.none &&
                task.priority == 0 &&
                task.kind == TaskKind.tarea)
            ? null
            : Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
                if (task.kind != TaskKind.tarea)
                  Text(task.kind.label,
                      style: TextStyle(
                          fontSize: 12, color: Color(color), fontWeight: FontWeight.w600)),
                if (task.priority > 0)
                  Icon(Icons.flag, size: 14, color: _prioColors[task.priority]),
                if (task.repeat != Repeat.none) const Icon(Icons.repeat, size: 14),
                if (task.subtasks.isNotEmpty)
                  Text('${task.subtasks.where((s) => s.done).length}/${task.subtasks.length} subtareas',
                      style: const TextStyle(fontSize: 12)),
              ]),
        // El color de la tarea (propio o el de su tipo) tiñe la casilla.
        leading: Checkbox(
          value: task.done,
          activeColor: Color(color),
          side: BorderSide(width: 2, color: Color(color)),
          onChanged: (_) => notifier.toggleTask(task.id),
        ),
        title: Text('${task.kind == TaskKind.tarea ? '' : '${task.kind.emoji} '}${task.title}',
            style: task.done
                ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                : null),
        trailing: task.due == null
            ? null
            : Text(_dueLabel(task.due!, task.hasTime),
                style: TextStyle(
                    // Vencida y sin completar: en rojo.
                    color: overdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    fontWeight: overdue ? FontWeight.w600 : null)),
      ),
    );
  }
}

/// "16:30" si vence hoy con hora; "30 sep 16:30" o "30 sep" en otros casos.
String _dueLabel(DateTime due, bool hasTime) {
  final now = DateTime.now();
  final isToday = due.year == now.year && due.month == now.month && due.day == now.day;
  if (hasTime && isToday) return hhmm(due);
  final date = DateFormat.MMMd('es').format(due);
  return hasTime ? '$date ${hhmm(due)}' : date;
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.count});
  final String text;
  final int? count;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(count == null ? text.toUpperCase() : '${text.toUpperCase()}  ($count)',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(letterSpacing: 1, color: Theme.of(context).colorScheme.outline)),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.text, this.action});
  final IconData icon;
  final String text;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ]),
        ),
      );
}
