import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import 'app_state.dart';

const _colors = [0xFF4F6AF5, 0xFF26A69A, 0xFFEF6C00, 0xFFD81B60, 0xFF7CB342, 0xFF8E24AA];
const _dayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

class HabitEditPage extends ConsumerStatefulWidget {
  const HabitEditPage({super.key, required this.habit});
  final Habit habit;

  @override
  ConsumerState<HabitEditPage> createState() => _HabitEditPageState();
}

class _HabitEditPageState extends ConsumerState<HabitEditPage> {
  late final _name = TextEditingController(text: widget.habit.name);
  late final _emoji = TextEditingController(text: widget.habit.emoji);
  late final _unit = TextEditingController(text: widget.habit.unit);
  late int _color = widget.habit.colorValue;
  late int _target = widget.habit.target;
  late HabitType _type = widget.habit.type;
  late final Set<int> _days = {...widget.habit.weekdays};
  late int? _reminder = widget.habit.reminderMinutes;
  late HabitCategory _category = widget.habit.category;

  Future<void> _pickReminder() async {
    final m = _reminder ?? 9 * 60;
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: m ~/ 60, minute: m % 60));
    if (t != null) setState(() => _reminder = t.hour * 60 + t.minute);
  }

  @override
  void dispose() {
    _name.dispose();
    _emoji.dispose();
    _unit.dispose();
    super.dispose();
  }

  void _save() {
    final h = widget.habit;
    final name = _name.text.trim();
    if (name.isNotEmpty) h.name = name;
    final e = _emoji.text.trim();
    if (e.isNotEmpty) h.emoji = e;
    h.colorValue = _color;
    h.type = _type;
    h.target = _type == HabitType.check ? 1 : _target;
    h.unit = _type == HabitType.check ? '' : _unit.text.trim();
    // Al menos un día activo; si no, se conserva el horario anterior.
    if (_days.isNotEmpty) h.weekdays = _days;
    h.reminderMinutes = _reminder;
    h.category = _category;
    ref.read(appDataProvider.notifier).updateHabit();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar hábito'),
        actions: [TextButton(onPressed: _save, child: const Text('Guardar'))],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          SizedBox(
            width: 72,
            child: TextField(
              controller: _emoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        const Text('Color'),
        const SizedBox(height: 8),
        Wrap(spacing: 10, children: [
          for (final c in _colors)
            GestureDetector(
              onTap: () => setState(() => _color = c),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color(c),
                child: _color == c ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
              ),
            ),
        ]),
        const SizedBox(height: 16),
        const Text('Categoría'),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final c in HabitCategory.values)
            ChoiceChip(
              label: Text('${c.emoji} ${c.label}'),
              selected: _category == c,
              onSelected: (_) => setState(() => _category = c),
            ),
        ]),
        if (_category == HabitCategory.ejercicio)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Hace crecer la musculatura de tu personaje.',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        const SizedBox(height: 16),
        const Text('Días'),
        const SizedBox(height: 8),
        Wrap(spacing: 6, children: [
          for (var i = 0; i < 7; i++)
            FilterChip(
              label: Text(_dayLabels[i]),
              selected: _days.contains(i + 1),
              onSelected: (v) => setState(() => v ? _days.add(i + 1) : _days.remove(i + 1)),
            ),
        ]),
        if (_days.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Elige al menos un día',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        const SizedBox(height: 16),
        Wrap(spacing: 8, children: [
          ActionChip(
            avatar: const Icon(Icons.notifications_outlined, size: 18),
            label: Text(_reminder == null
                ? 'Sin recordatorio'
                : 'Recordar a las ${(_reminder! ~/ 60).toString().padLeft(2, '0')}:${(_reminder! % 60).toString().padLeft(2, '0')}'),
            onPressed: _pickReminder,
          ),
          if (_reminder != null)
            ActionChip(
              avatar: const Icon(Icons.close, size: 18),
              label: const Text('Quitar'),
              onPressed: () => setState(() => _reminder = null),
            ),
        ]),
        const SizedBox(height: 16),
        SegmentedButton<HabitType>(
          segments: const [
            ButtonSegment(value: HabitType.check, label: Text('Sí / No')),
            ButtonSegment(value: HabitType.count, label: Text('Cantidad')),
          ],
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
        ),
        if (_type == HabitType.count) ...[
          const SizedBox(height: 12),
          Row(children: [
            IconButton(
                onPressed: _target > 1 ? () => setState(() => _target--) : null,
                icon: const Icon(Icons.remove_circle_outline)),
            Text('Meta diaria: $_target', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
                onPressed: () => setState(() => _target++),
                icon: const Icon(Icons.add_circle_outline)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _unit,
                decoration: const InputDecoration(labelText: 'Unidad', border: OutlineInputBorder()),
              ),
            ),
          ]),
        ],
      ]),
    );
  }
}
