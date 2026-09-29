import 'models.dart';

/// Resultado de interpretar una frase de captura rápida.
class QuickParse {
  QuickParse(this.title,
      {this.due,
      this.hasTime = false,
      this.priority = 0,
      this.repeat = Repeat.none,
      this.kind = TaskKind.tarea});
  final String title;
  final DateTime? due;
  final bool hasTime;
  final int priority;
  final Repeat repeat;
  final TaskKind kind;
}

const _weekdays = {
  'lunes': 1, 'martes': 2, 'miercoles': 3, 'miércoles': 3, 'jueves': 4,
  'viernes': 5, 'sabado': 6, 'sábado': 6, 'domingo': 7,
  'monday': 1, 'tuesday': 2, 'wednesday': 3, 'thursday': 4, 'friday': 5,
  'saturday': 6, 'sunday': 7,
};


/// Interpreta "Llamar al banco mañana 4pm !alta" (ES/EN).
/// Reconoce: hoy/mañana/pasado mañana, días de la semana, horas (16:30, 4pm,
/// 4:30 pm, a las 9) y prioridad (!alta/!media/!baja, !1–!3, p1–p3).
QuickParse parseQuick(String input, DateTime now) {
  var text = ' ${input.trim()} ';
  DateTime? day;
  int? hour, minute;
  var priority = 0;

  String cut(RegExp re) {
    text = text.replaceFirst(re, ' ');
    return text;
  }

  // Prioridad
  final pr = RegExp(r'\s(?:!|p)(alta|media|baja|high|medium|low|[1-3])(?=\s)',
          caseSensitive: false)
      .firstMatch(text);
  if (pr != null) {
    final v = pr.group(1)!.toLowerCase();
    priority = switch (v) {
      'alta' || 'high' || '1' => 3,
      'media' || 'medium' || '2' => 2,
      'baja' || 'low' || '3' => 1,
      _ => 0,
    };
    // p1 = más alta, igual que Todoist
    cut(RegExp(r'\s(?:!|p)(alta|media|baja|high|medium|low|[1-3])(?=\s)',
        caseSensitive: false));
  }

  // Tipo: "#prueba", "#examen", "#actividad", "#entrega", "#reunion"…
  // Solo se consume la etiqueta si es un tipo conocido; otras "#palabras"
  // quedan en el título tal cual.
  var kind = TaskKind.tarea;
  for (final m in RegExp(r'\s#([A-Za-zÀ-ÿ]+)(?=\s)').allMatches(text)) {
    final k = TaskKind.fromTag(m.group(1)!);
    if (k != null) {
      kind = k;
      text = text.replaceFirst(m.group(0)!, ' ');
      break;
    }
  }

  final today = DateTime(now.year, now.month, now.day);

  // Repetición: "cada día", "todos los días", "cada semana", "cada mes", every day…
  var repeat = Repeat.none;
  final rep = RegExp(
          r'\s(todos los d[ií]as|cada d[ií]a|diario|every day|daily|cada semana|semanal|every week|weekly|cada mes|mensual|every month|monthly)(?=\s)',
          caseSensitive: false)
      .firstMatch(text);
  if (rep != null) {
    final v = rep.group(1)!.toLowerCase();
    repeat = (v.contains('semana') || v.contains('week'))
        ? Repeat.weekly
        : (v.contains('mes') || v.contains('month'))
            ? Repeat.monthly
            : Repeat.daily;
    text = text.replaceFirst(rep.group(0)!, ' ');
  }

  // Fecha relativa
  final rel = RegExp(r'\s(pasado mañana|pasado manana|mañana|manana|hoy|today|tomorrow)(?=\s)',
          caseSensitive: false)
      .firstMatch(text);
  if (rel != null) {
    final v = rel.group(1)!.toLowerCase();
    day = switch (v) {
      'hoy' || 'today' => today,
      'mañana' || 'manana' || 'tomorrow' => today.add(const Duration(days: 1)),
      _ => today.add(const Duration(days: 2)),
    };
    text = text.replaceFirst(rel.group(0)!, ' ');
  } else {
    final wd = RegExp(r'\s(?:el\s+|on\s+)?(' + _weekdays.keys.join('|') + r')(?=\s)',
            caseSensitive: false)
        .firstMatch(text);
    if (wd != null) {
      final target = _weekdays[wd.group(1)!.toLowerCase()]!;
      var diff = (target - today.weekday) % 7;
      if (diff == 0) diff = 7;
      day = today.add(Duration(days: diff));
      text = text.replaceFirst(wd.group(0)!, ' ');
    }
  }

  // Hora: 16:30 | 4pm | 4:30 pm | a las 9
  final t = RegExp(r'\s(?:a las |at )?(\d{1,2})(?::(\d{2}))?\s?(am|pm|h)?(?=\s)',
          caseSensitive: false)
      .allMatches(text)
      .where((m) => m.group(2) != null || m.group(3) != null || m.group(0)!.contains(RegExp(r'a las|at')))
      .firstOrNull;
  if (t != null) {
    var h = int.parse(t.group(1)!);
    final m = int.tryParse(t.group(2) ?? '0') ?? 0;
    final suffix = t.group(3)?.toLowerCase();
    if (suffix == 'pm' && h < 12) h += 12;
    if (suffix == 'am' && h == 12) h = 0;
    if (h < 24 && m < 60) {
      hour = h;
      minute = m;
      text = text.replaceFirst(t.group(0)!, ' ');
    }
  }

  final title = text.trim().replaceAll(RegExp(r'\s+'), ' ');
  DateTime? due;
  if (hour != null) {
    due = DateTime((day ?? today).year, (day ?? today).month, (day ?? today).day,
        hour, minute ?? 0);
  } else {
    due = day;
  }
  // Una tarea repetida necesita fecha de inicio: por defecto, hoy.
  if (repeat != Repeat.none && due == null) due = today;
  return QuickParse(title.isEmpty ? input.trim() : title,
      due: due,
      hasTime: hour != null,
      priority: priority,
      repeat: repeat,
      kind: kind);
}
