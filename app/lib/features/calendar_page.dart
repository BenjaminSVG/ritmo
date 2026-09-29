import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'app_state.dart';
import 'day_timeline.dart';
import 'week_timeline.dart';
import 'widgets.dart';

enum _CalView { month, week, day }

/// Calendario con vistas Mes (puntos en días con tareas + agenda del día
/// elegido), Semana (3 o 7 columnas) y Día (línea de tiempo). Arrastrar
/// bloques para mover tareas queda pendiente.
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _month;
  late DateTime _selected;
  _CalView _view = _CalView.month;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _selected = DateTime(n.year, n.month, n.day);
    _month = DateTime(n.year, n.month);
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(appDataProvider);
    final first = _month;
    final daysInMonth = DateUtils.getDaysInMonth(first.year, first.month);
    final offset = first.weekday - 1; // lunes = 0
    final cs = Theme.of(context).colorScheme;

    bool hasTask(DateTime d) => data.tasks.any((t) =>
        t.due != null && DateUtils.isSameDay(t.due, d));

    final dayTasks = data.tasks
        .where((t) => t.due != null && DateUtils.isSameDay(t.due, _selected))
        .toList()
      ..sort((a, b) => a.due!.compareTo(b.due!));
    final dayHabits =
        data.habits.where((h) => !h.archived && h.isScheduledOn(_selected)).toList();

    final toggle = Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SegmentedButton<_CalView>(
        segments: const [
          ButtonSegment(value: _CalView.month, label: Text('Mes'), icon: Icon(Icons.calendar_view_month)),
          ButtonSegment(value: _CalView.week, label: Text('Semana'), icon: Icon(Icons.calendar_view_week)),
          ButtonSegment(value: _CalView.day, label: Text('Día'), icon: Icon(Icons.view_day_outlined)),
        ],
        selected: {_view},
        onSelectionChanged: (s) => setState(() => _view = s.first),
      ),
    );

    if (_view != _CalView.month) {
      final isWeek = _view == _CalView.week;
      // Semana: 7 días (lunes a domingo) en pantallas anchas, 3 días desde la
      // fecha elegida en móvil.
      final wide = MediaQuery.sizeOf(context).width >= 600;
      final count = isWeek ? (wide ? 7 : 3) : 1;
      final start = (isWeek && wide)
          ? DateTime(_selected.year, _selected.month, _selected.day - (_selected.weekday - 1))
          : _selected;
      final days = [
        for (var i = 0; i < count; i++) DateTime(start.year, start.month, start.day + i)
      ];
      final title = count == 1
          ? DateFormat("EEEE d 'de' MMMM", 'es').format(_selected)
          : '${DateFormat("d MMM", 'es').format(days.first)} – ${DateFormat("d MMM", 'es').format(days.last)}';
      void shift(int dir) => setState(() => _selected =
          DateTime(_selected.year, _selected.month, _selected.day + dir * count));

      return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
        toggle,
        Row(children: [
          IconButton(onPressed: () => shift(-1), icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () {
                  final n = DateTime.now();
                  setState(() => _selected = DateTime(n.year, n.month, n.day));
                },
                child: Text(toBeginningOfSentenceCase(title)!,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ),
          IconButton(onPressed: () => shift(1), icon: const Icon(Icons.chevron_right)),
        ]),
        if (isWeek) WeekTimeline(days: days) else DayTimeline(day: _selected),
      ]);
    }

    return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
      toggle,
      Row(children: [
        IconButton(
            onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
            icon: const Icon(Icons.chevron_left)),
        Expanded(
          child: Center(
            child: Text(toBeginningOfSentenceCase(DateFormat.yMMMM('es').format(_month))!,
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        IconButton(
            onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
            icon: const Icon(Icons.chevron_right)),
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [
          for (final l in ['L', 'M', 'X', 'J', 'V', 'S', 'D'])
            Expanded(child: Center(child: Text(l, style: TextStyle(color: cs.outline)))),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < offset; i++) const SizedBox.shrink(),
            for (var d = 1; d <= daysInMonth; d++)
              Builder(builder: (_) {
                final date = DateTime(first.year, first.month, d);
                final sel = DateUtils.isSameDay(date, _selected);
                final isToday = DateUtils.isSameDay(date, DateTime.now());
                return InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () => setState(() => _selected = date),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sel ? cs.primary : null,
                      border: isToday && !sel ? Border.all(color: cs.primary) : null,
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('$d', style: TextStyle(color: sel ? cs.onPrimary : null)),
                      if (hasTask(date))
                        Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: sel ? cs.onPrimary : cs.primary)),
                    ]),
                  ),
                );
              }),
          ],
        ),
      ),
      const Divider(),
      SectionHeader(toBeginningOfSentenceCase(DateFormat("EEEE d 'de' MMMM", 'es').format(_selected))!),
      if (dayTasks.isEmpty && dayHabits.isEmpty)
        const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Día libre'))),
      for (final t in dayTasks) TaskTile(task: t),
      for (final h in dayHabits) HabitTile(habit: h, day: _selected),
    ]);
  }
}
