import 'models.dart';

/// Un premio ganado. La clave `(kind, item, day)` es única: marcar, desmarcar y volver
/// a marcar no duplica nada.
class Reward {
  const Reward(this.kind, this.item, this.day, this.coins, this.xp, {this.stars = 0});
  final String kind, item, day;
  final int coins, xp, stars;

  String get key => '$kind|$item|$day';
}

/// Valores de la economía (doc 09, §9.5).
class Economy {
  Economy._();
  static const habitCoins = 10;
  static const taskCoins = 3;
  static const highPriorityBonus = 1;
  static const onTimeBonus = 5; // Prueba o Entrega antes de vencer
  static const allHabitsBonus = 20;
  static const dailyCap = 150;
  static const maxRewardedTasksPerDay = 8;
  static const welcomeGift = 100;
}

const kindHabit = 'habit', kindTask = 'task', kindAll = 'all', kindWelcome = 'welcome', kindBuy = 'buy';

/// Tipos de premio que se recalculan cada vez; el resto (regalo, compras) es permanente.
const recomputedKinds = [kindHabit, kindTask, kindAll];

/// Premios que corresponden a [days] según el estado actual de hábitos y tareas.
///
/// Solo mira los días pedidos (la app pasa hoy y ayer): editar días viejos no da nada.
/// Los topes diarios se aplican en orden hábitos → tareas → bonus del día.
List<Reward> computeRewards(List<Habit> habits, List<Task> tasks, List<DateTime> days) {
  final out = <Reward>[];
  for (final d in days) {
    final k = dayKey(d);
    var total = 0;
    void add(Reward r) {
      final room = Economy.dailyCap - total;
      if (room <= 0) return;
      final coins = r.coins > room ? room : r.coins;
      total += coins;
      out.add(Reward(r.kind, r.item, r.day, coins, r.xp));
    }

    final scheduled = habits.where((h) => !h.archived && h.isScheduledOn(d)).toList();
    for (final h in scheduled) {
      if (h.isDoneOn(d)) add(Reward(kindHabit, h.id, k, Economy.habitCoins, Economy.habitCoins));
    }

    final doneToday = tasks.where((t) {
      final at = t.doneAt;
      return t.done && at != null && dayKey(at) == k;
    }).toList()
      ..sort((a, b) => a.doneAt!.compareTo(b.doneAt!));
    for (final t in doneToday.take(Economy.maxRewardedTasksPerDay)) {
      var c = Economy.taskCoins + (t.priority >= 3 ? Economy.highPriorityBonus : 0);
      if (_countsOnTime(t)) c += Economy.onTimeBonus;
      add(Reward(kindTask, t.id, k, c, c));
    }

    if (scheduled.isNotEmpty && scheduled.every((h) => h.isDoneOn(d))) {
      add(Reward(kindAll, '-', k, Economy.allHabitsBonus, Economy.allHabitsBonus));
    }
  }
  return out;
}

/// Prueba o Entrega terminada antes de su límite. Sin hora, el límite es el fin del día.
bool _countsOnTime(Task t) {
  if (t.kind != TaskKind.prueba && t.kind != TaskKind.entrega) return false;
  final due = t.due, at = t.doneAt;
  if (due == null || at == null) return false;
  final limit = t.hasTime ? due : DateTime(due.year, due.month, due.day + 1);
  return t.hasTime ? !at.isAfter(limit) : at.isBefore(limit);
}

/// Nivel de cuenta a partir de la experiencia total. Pasar del nivel n al n+1 cuesta
/// `100 + 30·n` (doc 09, §9.6). Después del 100 el nivel sigue subiendo cada 5.000 XP.
class LevelInfo {
  const LevelInfo(this.level, this.into, this.needed);
  final int level;

  /// XP acumulada dentro del nivel actual y XP que pide el siguiente.
  final int into, needed;
}

LevelInfo levelFor(int xp) {
  var level = 1, left = xp < 0 ? 0 : xp;
  while (level < 100) {
    final need = 100 + 30 * level;
    if (left < need) return LevelInfo(level, left, need);
    left -= need;
    level++;
  }
  return LevelInfo(level + left ~/ 5000, left % 5000, 5000);
}

extension RewardJson on Reward {
  Map<String, dynamic> toJson() =>
      {'kind': kind, 'item': item, 'day': day, 'coins': coins, 'stars': stars, 'xp': xp};

  static Reward fromJson(Map<String, dynamic> j) => Reward(
      j['kind'] as String, j['item'] as String, j['day'] as String, j['coins'] as int, j['xp'] as int,
      stars: j['stars'] as int? ?? 0);
}
