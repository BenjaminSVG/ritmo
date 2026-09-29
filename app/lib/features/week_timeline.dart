import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/models.dart';
import 'add_sheet.dart';
import 'app_state.dart';
import 'drag_to_move.dart';
import 'task_edit_page.dart';

const _hourHeight = 52.0;
const _gutter = 44.0;

/// Varios días en columnas con eje de horas común. Las tareas con hora son
/// bloques; las tareas sin hora y los hábitos programados van en la cabecera
/// como contadores compactos.
class WeekTimeline extends ConsumerWidget {
  const WeekTimeline({super.key, required this.days});
  final List<DateTime> days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();

    List<Task> tasksOf(DateTime d) => data.tasks
        .where((t) => t.due != null && DateUtils.isSameDay(t.due, d))
        .toList();

    return Column(
      children: [
        // Cabecera: día y resumen
        Row(
          children: [
            const SizedBox(width: _gutter),
            for (final d in days)
              Expanded(
                child: Builder(
                  builder: (_) {
                    final isToday = DateUtils.isSameDay(d, now);
                    final untimed = tasksOf(d).where((t) => !t.hasTime).length;
                    final habits = data.habits.where(
                      (h) => !h.archived && h.isScheduledOn(d),
                    );
                    final habitsDone = habits
                        .where((h) => h.isDoneOn(d))
                        .length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            DateFormat.E('es').format(d).toUpperCase(),
                            style: TextStyle(fontSize: 11, color: cs.outline),
                          ),
                          const SizedBox(height: 2),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: isToday
                                ? cs.primary
                                : Colors.transparent,
                            child: Text(
                              '${d.day}',
                              style: TextStyle(
                                color: isToday ? cs.onPrimary : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (habits.isNotEmpty)
                                '🔥$habitsDone/${habits.length}',
                              if (untimed > 0) '☐$untimed',
                            ].join(' '),
                            style: TextStyle(fontSize: 10, color: cs.outline),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        const Divider(height: 1),
        SizedBox(
          height: _hourHeight * 24,
          child: LayoutBuilder(
            builder: (context, box) {
              final colW = (box.maxWidth - _gutter) / days.length;
              return Stack(
                children: [
                  // Fondo táctil: tocar una hora libre crea una tarea ese día y hora.
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (d) {
                        if (d.localPosition.dx < _gutter) return;
                        final col = ((d.localPosition.dx - _gutter) / colW)
                            .floor()
                            .clamp(0, days.length - 1);
                        final minutes =
                            (d.localPosition.dy / _hourHeight * 2).floor() * 30;
                        final day = days[col];
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
                              style: TextStyle(fontSize: 11, color: cs.outline),
                            ),
                          ),
                          Expanded(
                            child: Divider(height: 1, color: cs.outlineVariant),
                          ),
                        ],
                      ),
                    ),
                  for (var i = 1; i < days.length; i++)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: _gutter + colW * i,
                      child: VerticalDivider(
                        width: 1,
                        color: cs.outlineVariant,
                      ),
                    ),
                  for (var i = 0; i < days.length; i++)
                    for (final t in tasksOf(days[i]).where((t) => t.hasTime))
                      Positioned(
                        top:
                            (t.due!.hour + t.due!.minute / 60) * _hourHeight +
                            1,
                        left: _gutter + colW * i + 2,
                        width: colW - 4,
                        height: (t.durationMin / 60 * _hourHeight - 2).clamp(18.0, 24 * _hourHeight),
                        child: DragToMove(
                          hourHeight: _hourHeight,
                          dayWidth: colW,
                          onMove: (dayShift, minutes) {
                            // No sacar la tarea de las columnas visibles.
                            final target =
                                (i + dayShift).clamp(0, days.length - 1) - i;
                            ref
                                .read(appDataProvider.notifier)
                                .moveTask(t.id, target, minutes);
                          },
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TaskEditPage(task: t),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: t.done
                                    ? cs.surfaceContainerHighest
                                    : Color(t.effectiveColor).withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(6),
                                border: Border(
                                  left: BorderSide(
                                    width: 3,
                                    color: Color(t.effectiveColor),
                                  ),
                                ),
                              ),
                              child: Text(
                                '${t.kind == TaskKind.tarea ? '' : '${t.kind.emoji} '}${t.title}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: t.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  for (var i = 0; i < days.length; i++)
                    if (DateUtils.isSameDay(days[i], now))
                      Positioned(
                        top: (now.hour + now.minute / 60) * _hourHeight,
                        left: _gutter + colW * i,
                        width: colW,
                        child: const Divider(
                          height: 1,
                          thickness: 2,
                          color: Colors.red,
                        ),
                      ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
