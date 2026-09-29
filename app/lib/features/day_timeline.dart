import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import 'add_sheet.dart';
import 'app_state.dart';
import 'drag_to_move.dart';
import 'widgets.dart';

const _hourHeight = 60.0;
const _gutter = 52.0;

/// Línea de tiempo de un día: tareas con hora como bloques (30 min), tarea
/// sin hora y hábitos arriba, y marcador de la hora actual.
class DayTimeline extends ConsumerWidget {
  const DayTimeline({super.key, required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);
    final cs = Theme.of(context).colorScheme;
    final tasks = data.tasks
        .where((t) => t.due != null && DateUtils.isSameDay(t.due, day))
        .toList();
    final untimed = tasks.where((t) => !t.hasTime).toList();
    final timed = tasks.where((t) => t.hasTime).toList();
    final habits = data.habits
        .where((h) => !h.archived && h.isScheduledOn(day))
        .toList();
    final now = DateTime.now();
    final showNow = DateUtils.isSameDay(now, day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (untimed.isNotEmpty || habits.isNotEmpty) ...[
          const SectionHeader('Todo el día'),
          for (final t in untimed) TaskTile(task: t),
          for (final h in habits) HabitTile(habit: h, day: day),
          const Divider(),
        ],
        SizedBox(
          height: _hourHeight * 24,
          child: Stack(
            children: [
              // Fondo táctil: tocar una hora libre crea una tarea a esa hora.
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (d) {
                    final minutes =
                        (d.localPosition.dy / _hourHeight * 2).floor() * 30;
                    showAddSheet(
                      context,
                      initialDue: DateTime(day.year, day.month, day.day,
                          (minutes ~/ 60).clamp(0, 23), minutes % 60),
                    );
                  },
                ),
              ),
              for (var h = 0; h < 24; h++)
                Positioned(
                  top: h * _hourHeight,
                  left: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _gutter,
                        child: Text(
                          '${h.toString().padLeft(2, '0')}:00',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: cs.outline),
                        ),
                      ),
                      Expanded(
                        child: Divider(height: 1, color: cs.outlineVariant),
                      ),
                    ],
                  ),
                ),
              for (final t in timed)
                Positioned(
                  top: (t.due!.hour + t.due!.minute / 60) * _hourHeight + 1,
                  left: _gutter + 4,
                  right: 8,
                  height: (t.durationMin / 60 * _hourHeight - 2).clamp(18.0, 24 * _hourHeight),
                  child: DragToMove(
                    hourHeight: _hourHeight,
                    onMove: (days, minutes) => ref
                        .read(appDataProvider.notifier)
                        .moveTask(t.id, days, minutes),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // El color propio de la tarea (o el de su tipo).
                        color: t.done
                            ? cs.surfaceContainerHighest
                            : Color(t.effectiveColor).withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(
                            width: 4,
                            color: Color(t.effectiveColor),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${hhmm(t.due!)}  ${t.kind == TaskKind.tarea ? '' : '${t.kind.emoji} '}${t.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: t.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => ref
                                .read(appDataProvider.notifier)
                                .toggleTask(t.id),
                            child: Icon(
                              t.done
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 20,
                              color: Color(t.effectiveColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (showNow)
                Positioned(
                  top: (now.hour + now.minute / 60) * _hourHeight,
                  left: _gutter - 4,
                  right: 0,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
