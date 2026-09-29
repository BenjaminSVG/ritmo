import 'models.dart';

/// Días de la ventana que se miran para la musculatura: un año.
const muscleWindowDays = 365;

/// Días de ejercicio que piden los niveles 1 a 4. El máximo equivale a un año entero
/// entrenando 5 días por semana (260).
const muscleThresholds = [20, 70, 150, 260];

/// Días distintos, en los últimos [muscleWindowDays] hasta [today], en que se completó
/// algún hábito de ejercicio.
int exerciseDays(List<Habit> habits, DateTime today) {
  final ex = habits.where((h) => !h.archived && h.category == HabitCategory.ejercicio);
  var n = 0;
  for (var i = 0; i < muscleWindowDays; i++) {
    final d = DateTime(today.year, today.month, today.day - i);
    if (ex.any((h) => h.isDoneOn(d))) n++;
  }
  return n;
}

/// Nivel 0–4. Sube con la constancia y baja despacio si se deja (la ventana de un año
/// se va vaciando); nunca hay un cambio brusco ni castigo.
int muscleLevelFor(int days) {
  var level = 0;
  for (final t in muscleThresholds) {
    if (days >= t) level++;
  }
  return level;
}
