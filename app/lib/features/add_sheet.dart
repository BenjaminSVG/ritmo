import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/models.dart';
import '../domain/quick_parse.dart';
import 'app_state.dart';

enum AddKind { task, habit }

Future<void> showAddSheet(BuildContext context,
        {AddKind initial = AddKind.task, DateTime? initialDue}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddSheet(initial: initial, initialDue: initialDue),
    );

const _templates = [
  ('💧', 'Beber agua', HabitType.count, 8, 'vasos'),
  ('📖', 'Leer', HabitType.check, 1, ''),
  ('🏃', 'Ejercicio', HabitType.check, 1, ''),
  ('🧘', 'Meditar', HabitType.check, 1, ''),
];

const _colors = [0xFF4F6AF5, 0xFF26A69A, 0xFFEF6C00, 0xFFD81B60, 0xFF7CB342, 0xFF8E24AA];

class AddSheet extends ConsumerStatefulWidget {
  const AddSheet({super.key, required this.initial, this.initialDue});
  final AddKind initial;

  /// Fecha y hora sugeridas (p. ej. al tocar una hora libre del calendario).
  final DateTime? initialDue;

  @override
  ConsumerState<AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends ConsumerState<AddSheet> {
  final _ctrl = TextEditingController();
  late AddKind _kind = widget.initial;
  TaskKind _taskKind = TaskKind.tarea;
  int _color = _colors.first;
  String _emoji = '✅';
  HabitType _type = HabitType.check;
  int _target = 1;
  String _unit = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Aplica la hora sugerida si lo escrito no trae hora propia. Si trae fecha
  /// pero no hora ("yoga mañana"), se usa esa fecha con la hora sugerida.
  QuickParse _parse(String text) {
    final parsed = parseQuick(text, DateTime.now());
    // Una etiqueta "#prueba" escrita en el texto manda sobre la ficha elegida.
    final kind = parsed.kind != TaskKind.tarea ? parsed.kind : _taskKind;
    final s = widget.initialDue;
    if (s == null || parsed.hasTime) {
      return QuickParse(parsed.title,
          due: parsed.due,
          hasTime: parsed.hasTime,
          priority: parsed.priority,
          repeat: parsed.repeat,
          kind: kind);
    }
    final base = parsed.due ?? s;
    return QuickParse(parsed.title,
        due: DateTime(base.year, base.month, base.day, s.hour, s.minute),
        hasTime: true,
        priority: parsed.priority,
        repeat: parsed.repeat,
        kind: kind);
  }

  void _submit() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final n = ref.read(appDataProvider.notifier);
    if (_kind == AddKind.task) {
      final p = _parse(text);
      n.addTask(p.title,
          due: p.due,
          hasTime: p.hasTime,
          priority: p.priority,
          repeat: p.repeat,
          kind: p.kind);
    } else {
      n.addHabit(text,
          emoji: _emoji, color: _color, type: _type, target: _target, unit: _unit);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = _kind == AddKind.task &&
            (_ctrl.text.trim().isNotEmpty || widget.initialDue != null)
        ? _parse(_ctrl.text)
        : null;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        SegmentedButton<AddKind>(
          segments: const [
            ButtonSegment(value: AddKind.task, label: Text('Tarea'), icon: Icon(Icons.check_circle_outline)),
            ButtonSegment(value: AddKind.habit, label: Text('Hábito'), icon: Icon(Icons.local_fire_department_outlined)),
          ],
          selected: {_kind},
          onSelectionChanged: (s) => setState(() => _kind = s.first),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            hintText: _kind == AddKind.task
                ? 'Llamar al banco mañana 4pm !alta'
                : 'Nombre del hábito',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _submit),
          ),
        ),
        if (_kind == AddKind.task) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final k in TaskKind.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${k.emoji} ${k.label}'),
                    selected: (parsed?.kind ?? _taskKind) == k,
                    onSelected: (_) => setState(() => _taskKind = k),
                  ),
                ),
            ]),
          ),
        ],
        const SizedBox(height: 8),
        if (parsed != null)
          Wrap(spacing: 8, children: [
            if (parsed.due != null)
              Chip(
                avatar: const Icon(Icons.event, size: 18),
                label: Text(parsed.hasTime
                    ? DateFormat("EEE d MMM HH:mm", 'es').format(parsed.due!)
                    : DateFormat("EEE d MMM", 'es').format(parsed.due!)),
              ),
            if (parsed.repeat != Repeat.none)
              Chip(
                avatar: const Icon(Icons.repeat, size: 18),
                label: Text(switch (parsed.repeat) {
                  Repeat.daily => 'Cada día',
                  Repeat.weekly => 'Cada semana',
                  _ => 'Cada mes',
                }),
              ),
            if (parsed.priority > 0)
              Chip(
                avatar: const Icon(Icons.flag, size: 18),
                label: Text(['', 'Baja', 'Media', 'Alta'][parsed.priority]),
              ),
          ]),
        if (_kind == AddKind.habit) ...[
          const Text('Plantillas'),
          Wrap(spacing: 8, children: [
            for (final t in _templates)
              ActionChip(
                label: Text('${t.$1} ${t.$2}'),
                onPressed: () => setState(() {
                  _ctrl.text = t.$2;
                  _emoji = t.$1;
                  _type = t.$3;
                  _target = t.$4;
                  _unit = t.$5;
                }),
              ),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final c in _colors)
              GestureDetector(
                onTap: () => setState(() => _color = c),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(c),
                  child: _color == c ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              ),
          ]),
        ],
      ]),
    );
  }
}
