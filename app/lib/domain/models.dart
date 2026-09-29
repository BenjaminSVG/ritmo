/// Fecha local sin hora, formato yyyy-MM-dd. Los hábitos se registran por día
/// local (no por instante) para que "hoy" sea siempre el día del usuario.
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime parseDayKey(String k) {
  final p = k.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

enum HabitType { check, count }

/// Categoría de un hábito. `ejercicio` es la que hace crecer la musculatura del personaje.
enum HabitCategory {
  ninguna('Sin categoría', '➖'),
  ejercicio('Ejercicio', '💪'),
  salud('Salud', '💧'),
  mente('Mente', '🧘'),
  estudio('Estudio', '📚'),
  hogar('Hogar', '🏠'),
  social('Social', '👥');

  const HabitCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

class Habit {
  Habit({
    required this.id,
    required this.name,
    this.emoji = '✅',
    this.colorValue = 0xFF5C6BC0,
    this.type = HabitType.check,
    this.target = 1,
    this.unit = '',
    Set<int>? weekdays,
    Map<String, int>? logs,
    this.archived = false,
    this.reminderMinutes,
    this.category = HabitCategory.ninguna,
  })  : weekdays = weekdays ?? {1, 2, 3, 4, 5, 6, 7},
        logs = logs ?? {};

  final String id;
  String name;
  String emoji;
  int colorValue;
  HabitType type;

  /// Meta diaria (1 para hábitos sí/no; p. ej. 8 para "8 vasos").
  int target;
  String unit;

  /// Días activos, 1 = lunes … 7 = domingo (DateTime.weekday).
  Set<int> weekdays;

  /// dayKey -> valor registrado ese día.
  Map<String, int> logs;
  bool archived;

  /// Hora del recordatorio diario, en minutos desde medianoche (null = sin).
  int? reminderMinutes;

  HabitCategory category;

  bool isScheduledOn(DateTime d) => weekdays.contains(d.weekday);
  int valueOn(DateTime d) => logs[dayKey(d)] ?? 0;
  bool isDoneOn(DateTime d) => valueOn(d) >= target;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': colorValue,
        'type': type.name,
        'target': target,
        'unit': unit,
        'weekdays': weekdays.toList()..sort(),
        'logs': logs,
        'archived': archived,
        'reminderMinutes': reminderMinutes,
        'category': category.name,
      };

  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
        id: j['id'] as String,
        name: j['name'] as String,
        emoji: j['emoji'] as String? ?? '✅',
        colorValue: j['color'] as int? ?? 0xFF5C6BC0,
        type: HabitType.values.byName(j['type'] as String? ?? 'check'),
        target: j['target'] as int? ?? 1,
        unit: j['unit'] as String? ?? '',
        weekdays: ((j['weekdays'] as List?) ?? [1, 2, 3, 4, 5, 6, 7])
            .map((e) => e as int)
            .toSet(),
        logs: ((j['logs'] as Map?) ?? {})
            .map((k, v) => MapEntry(k as String, v as int)),
        archived: j['archived'] as bool? ?? false,
        reminderMinutes: j['reminderMinutes'] as int?,
        category: HabitCategory.values.asNameMap()[j['category'] as String? ?? ''] ??
            HabitCategory.ninguna,
      );
}

enum Repeat { none, daily, weekly, monthly }

class Subtask {
  Subtask(this.title, {this.done = false});
  String title;
  bool done;

  Map<String, dynamic> toJson() => {'title': title, 'done': done};
  factory Subtask.fromJson(Map<String, dynamic> j) =>
      Subtask(j['title'] as String, done: j['done'] as bool? ?? false);
}

/// Tipo de tarea. Da un icono y un color por defecto; el color se puede
/// cambiar por tarea con [Task.colorValue].
enum TaskKind {
  tarea('Tarea', '✅', 0xFF4F6AF5),
  actividad('Actividad', '🎯', 0xFF26A69A),
  prueba('Prueba', '📝', 0xFFD81B60),
  entrega('Entrega', '📦', 0xFFEF6C00),
  reunion('Reunión', '👥', 0xFF8E24AA),
  recordatorio('Recordatorio', '⏰', 0xFF7CB342);

  const TaskKind(this.label, this.emoji, this.defaultColor);
  final String label;
  final String emoji;
  final int defaultColor;

  /// Etiqueta para escribir en la captura rápida: "#prueba".
  String get tag => name;

  static TaskKind? fromTag(String t) {
    final n = t.toLowerCase();
    // Sinónimos habituales, con y sin tilde.
    const aliases = {
      'examen': prueba,
      'exam': prueba,
      'test': prueba,
      'reunión': reunion,
      'meeting': reunion,
      'task': tarea,
      'activity': actividad,
      'reminder': recordatorio,
    };
    if (aliases.containsKey(n)) return aliases[n];
    for (final k in values) {
      if (k.name == n) return k;
    }
    return null;
  }
}

/// Prioridad 0 = ninguna … 3 = alta.
class Task {
  Task({
    required this.id,
    required this.title,
    this.notes = '',
    this.due,
    this.hasTime = false,
    this.priority = 0,
    this.done = false,
    this.doneAt,
    this.repeat = Repeat.none,
    this.durationMin = 30,
    this.kind = TaskKind.tarea,
    this.colorValue,
    List<Subtask>? subtasks,
  }) : subtasks = subtasks ?? [];

  /// Duración en minutos; solo se usa para dibujar el bloque en el calendario.
  int durationMin;

  TaskKind kind;

  /// Color elegido por el usuario; null = el color por defecto del [kind].
  int? colorValue;

  int get effectiveColor => colorValue ?? kind.defaultColor;

  final String id;
  String title;
  String notes;
  Repeat repeat;
  List<Subtask> subtasks;

  /// Fecha (y hora si [hasTime]) límite. Null = Bandeja de entrada.
  DateTime? due;
  bool hasTime;
  int priority;
  bool done;
  DateTime? doneAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'notes': notes,
        'due': due?.toIso8601String(),
        'hasTime': hasTime,
        'priority': priority,
        'done': done,
        'doneAt': doneAt?.toIso8601String(),
        'repeat': repeat.name,
        'durationMin': durationMin,
        'kind': kind.name,
        'color': colorValue,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
      };

  /// Siguiente fecha de una tarea repetida (mantiene la hora).
  DateTime? nextDue() {
    final d = due;
    if (d == null || repeat == Repeat.none) return null;
    return switch (repeat) {
      Repeat.daily => DateTime(d.year, d.month, d.day + 1, d.hour, d.minute),
      Repeat.weekly => DateTime(d.year, d.month, d.day + 7, d.hour, d.minute),
      // Si el mes siguiente es más corto (31 → 30/28), usa su último día.
      Repeat.monthly => () {
          final last = daysInMonth(d.year, d.month + 1);
          return DateTime(d.year, d.month + 1, d.day > last ? last : d.day,
              d.hour, d.minute);
        }(),
      Repeat.none => null,
    };
  }

  factory Task.fromJson(Map<String, dynamic> j) => Task(
        id: j['id'] as String,
        title: j['title'] as String,
        notes: j['notes'] as String? ?? '',
        due: j['due'] == null ? null : DateTime.parse(j['due'] as String),
        hasTime: j['hasTime'] as bool? ?? false,
        priority: j['priority'] as int? ?? 0,
        done: j['done'] as bool? ?? false,
        doneAt:
            j['doneAt'] == null ? null : DateTime.parse(j['doneAt'] as String),
        repeat: Repeat.values.byName(j['repeat'] as String? ?? 'none'),
        durationMin: j['durationMin'] as int? ?? 30,
        // Un tipo desconocido (p. ej. de una versión futura) cae en "tarea".
        kind: TaskKind.values.asNameMap()[j['kind'] as String? ?? 'tarea'] ??
            TaskKind.tarea,
        colorValue: j['color'] as int?,
        subtasks: ((j['subtasks'] as List?) ?? [])
            .map((e) => Subtask.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Días del mes (month puede desbordar: 13 = enero del año siguiente).
int daysInMonth(int year, int month) =>
    DateTime(year, month + 1, 0).day;
