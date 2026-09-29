import 'dart:math' as math;

import 'models.dart';

/// Racha actual: días programados consecutivos cumplidos hasta hoy.
/// Los días no programados no rompen ni suman a la racha. Si hoy aún no se
/// cumple, la racha no se pierde: se cuenta desde ayer.
int currentStreak(Habit h, DateTime today) {
  var d = DateTime(today.year, today.month, today.day);
  var streak = 0;
  var first = true;
  // Límite de seguridad: 10 años.
  for (var i = 0; i < 3650; i++) {
    if (h.isScheduledOn(d)) {
      if (h.isDoneOn(d)) {
        streak++;
      } else if (!(first && d == DateTime(today.year, today.month, today.day))) {
        break;
      }
      first = false;
    }
    d = DateTime(d.year, d.month, d.day - 1);
  }
  return streak;
}

int bestStreak(Habit h) {
  if (h.logs.isEmpty) return 0;
  final days = h.logs.keys.map(parseDayKey).toList()..sort();
  var d = days.first;
  final end = days.last;
  var best = 0, run = 0;
  while (!d.isAfter(end)) {
    if (h.isScheduledOn(d)) {
      if (h.isDoneOn(d)) {
        run++;
        best = math.max(best, run);
      } else {
        run = 0;
      }
    }
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return best;
}

/// Puntuación 0–1 tipo Loop Habit Tracker: media móvil exponencial que
/// perdona un día fallado en lugar de reiniciarse a cero.
double habitScore(Habit h, DateTime today, {int days = 365}) {
  const decay = 0.95;
  var score = 0.0;
  var d = DateTime(today.year, today.month, today.day - days);
  final end = DateTime(today.year, today.month, today.day);
  while (!d.isAfter(end)) {
    if (h.isScheduledOn(d)) {
      score = score * decay + (h.isDoneOn(d) ? 1 - decay : 0);
    }
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return score.clamp(0.0, 1.0);
}

/// Porcentaje de días programados cumplidos en los últimos [days] días.
double completionRate(Habit h, DateTime today, {int days = 30}) {
  var scheduled = 0, done = 0;
  for (var i = 0; i < days; i++) {
    final d = DateTime(today.year, today.month, today.day - i);
    if (h.isScheduledOn(d)) {
      scheduled++;
      if (h.isDoneOn(d)) done++;
    }
  }
  return scheduled == 0 ? 0 : done / scheduled;
}
