import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/models.dart';
import 'app_state.dart';

const _durations = [15, 30, 45, 60, 90, 120, 180, 240];

/// Colores que se pueden asignar a una tarea (además del automático del tipo).
const _taskColors = [
  0xFFE53935, 0xFFEF6C00, 0xFFF9A825, 0xFF7CB342,
  0xFF26A69A, 0xFF039BE5, 0xFF4F6AF5, 0xFF8E24AA,
  0xFFD81B60, 0xFF6D4C41, 0xFF546E7A,
];

const _repeatLabels = {
  Repeat.none: 'No se repite',
  Repeat.daily: 'Cada día',
  Repeat.weekly: 'Cada semana',
  Repeat.monthly: 'Cada mes',
};

class TaskEditPage extends ConsumerStatefulWidget {
  const TaskEditPage({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends ConsumerState<TaskEditPage> {
  late final _title = TextEditingController(text: widget.task.title);
  late final _notes = TextEditingController(text: widget.task.notes);
  final _newSub = TextEditingController();
  late DateTime? _due = widget.task.due;
  late bool _hasTime = widget.task.hasTime;
  late int _priority = widget.task.priority;
  late Repeat _repeat = widget.task.repeat;
  late int _duration = widget.task.durationMin;
  late TaskKind _kind = widget.task.kind;

  /// Null = usar el color por defecto del tipo.
  late int? _color = widget.task.colorValue;
  late final List<Subtask> _subs = [
    for (final s in widget.task.subtasks) Subtask(s.title, done: s.done)
  ];

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _newSub.dispose();
    super.dispose();
  }

  void _addSub() {
    final t = _newSub.text.trim();
    if (t.isEmpty) return;
    setState(() => _subs.add(Subtask(t)));
    _newSub.clear();
  }

  void _save() {
    _addSub();
    final t = widget.task;
    final title = _title.text.trim();
    if (title.isNotEmpty) t.title = title;
    t.notes = _notes.text.trim();
    t.due = _due;
    t.hasTime = _due != null && _hasTime;
    t.priority = _priority;
    t.durationMin = _duration;
    t.kind = _kind;
    t.colorValue = _color;
    // Sin fecha no hay a partir de qué repetir.
    t.repeat = _due == null ? Repeat.none : _repeat;
    t.subtasks = _subs;
    ref.read(appDataProvider.notifier).updateTask();
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (d == null) return;
    setState(() => _due = DateTime(d.year, d.month, d.day,
        _hasTime ? _due?.hour ?? 0 : 0, _hasTime ? _due?.minute ?? 0 : 0));
  }

  Future<void> _pickTime() async {
    final base = _due ?? DateTime.now();
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hasTime ? base.hour : 9, minute: _hasTime ? base.minute : 0),
    );
    if (t == null) return;
    setState(() {
      _hasTime = true;
      _due = DateTime(base.year, base.month, base.day, t.hour, t.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar tarea'),
        actions: [
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(appDataProvider.notifier).deleteTask(widget.task.id);
              Navigator.of(context).pop();
            },
          ),
          TextButton(onPressed: _save, child: const Text('Guardar')),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notes,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notas', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        const Text('Tipo'),
        const SizedBox(height: 4),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final k in TaskKind.values)
            ChoiceChip(
              label: Text('${k.emoji} ${k.label}'),
              selected: _kind == k,
              onSelected: (_) => setState(() => _kind = k),
            ),
        ]),
        const SizedBox(height: 16),
        const Text('Color'),
        const SizedBox(height: 8),
        Wrap(spacing: 10, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          // "Automático": el color del tipo elegido.
          GestureDetector(
            onTap: () => setState(() => _color = null),
            child: Tooltip(
              message: 'Automático (color del tipo)',
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color(_kind.defaultColor),
                child: _color == null
                    ? const Icon(Icons.auto_awesome, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ),
          for (final c in _taskColors)
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
        Text('Fecha y hora límite', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ActionChip(
            avatar: const Icon(Icons.event, size: 18),
            label: Text(_due == null
                ? 'Sin fecha límite'
                : DateFormat("EEE d MMM", 'es').format(_due!)),
            onPressed: _pickDate,
          ),
          if (_due != null)
            ActionChip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text(_hasTime ? DateFormat.Hm().format(_due!) : 'Añadir hora límite'),
              onPressed: _pickTime,
            ),
          if (_due != null)
            ActionChip(
              avatar: const Icon(Icons.close, size: 18),
              label: const Text('Quitar fecha límite'),
              onPressed: () => setState(() {
                _due = null;
                _hasTime = false;
              }),
            ),
        ]),
        const SizedBox(height: 16),
        const Text('Prioridad'),
        const SizedBox(height: 4),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Ninguna')),
            ButtonSegment(value: 1, label: Text('Baja')),
            ButtonSegment(value: 2, label: Text('Media')),
            ButtonSegment(value: 3, label: Text('Alta')),
          ],
          selected: {_priority},
          onSelectionChanged: (s) => setState(() => _priority = s.first),
        ),
        if (_due != null && _hasTime) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _durations.contains(_duration) ? _duration : 30,
            decoration: const InputDecoration(
                labelText: 'Duración (en el calendario)', border: OutlineInputBorder()),
            items: [
              for (final m in _durations)
                DropdownMenuItem(
                    value: m,
                    child: Text(m < 60
                        ? '$m min'
                        : (m % 60 == 0 ? '${m ~/ 60} h' : '${m ~/ 60} h ${m % 60} min'))),
            ],
            onChanged: (v) => setState(() => _duration = v ?? 30),
          ),
        ],
        const SizedBox(height: 16),
        DropdownButtonFormField<Repeat>(
          initialValue: _due == null ? Repeat.none : _repeat,
          decoration: InputDecoration(
            labelText: 'Repetición',
            border: const OutlineInputBorder(),
            helperText: _due == null ? 'Elige una fecha para poder repetir' : null,
          ),
          items: [
            for (final e in _repeatLabels.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: _due == null ? null : (v) => setState(() => _repeat = v ?? Repeat.none),
        ),
        const SizedBox(height: 16),
        Text('Subtareas', style: Theme.of(context).textTheme.titleMedium),
        for (var i = 0; i < _subs.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
                value: _subs[i].done,
                onChanged: (v) => setState(() => _subs[i].done = v ?? false)),
            title: Text(_subs[i].title,
                style: _subs[i].done
                    ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                    : null),
            trailing: IconButton(
                icon: const Icon(Icons.close), onPressed: () => setState(() => _subs.removeAt(i))),
          ),
        TextField(
          controller: _newSub,
          onSubmitted: (_) => _addSub(),
          decoration: InputDecoration(
            hintText: 'Añadir subtarea',
            prefixIcon: const Icon(Icons.add),
            suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _addSub),
          ),
        ),
      ]),
    );
  }
}
