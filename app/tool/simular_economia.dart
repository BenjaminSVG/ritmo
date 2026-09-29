// ignore_for_file: avoid_print
// Simulador de economía: cuánto tarda cada tipo de usuario en conseguir todo el catálogo.
// Uso (desde app/):  dart run tool/simular_economia.dart
//
// Los perfiles usan las reglas reales de lib/domain/rewards.dart (valores de Economy).
import 'package:ritmo/domain/rewards.dart';
import 'package:ritmo/pixel/catalog.dart';

class Perfil {
  const Perfil(this.nombre, this.habitos, this.tareas, this.diasActivos);
  final String nombre;
  final int habitos, tareas;

  /// Fracción de días en que la persona usa la app (0–1).
  final double diasActivos;
}

/// Monedas de un día en que se completan [habitos] hábitos (de [habitos] programados) y [tareas] tareas.
int monedasDelDia(int habitos, int tareas) {
  var total = habitos * Economy.habitCoins;
  final t = tareas > Economy.maxRewardedTasksPerDay ? Economy.maxRewardedTasksPerDay : tareas;
  total += t * Economy.taskCoins;
  if (habitos > 0) total += Economy.allHabitsBonus; // todos los hábitos del día hechos
  return total > Economy.dailyCap ? Economy.dailyCap : total;
}

void main() {
  const perfiles = [
    Perfil('Casual (1 hábito, 1 tarea, 4 de cada 7 días)', 1, 1, 4 / 7),
    Perfil('Típico (3 hábitos, 3 tareas, casi todos los días)', 3, 3, 0.9),
    Perfil('Constante (6 hábitos, 5 tareas, todos los días)', 6, 5, 1.0),
  ];
  final precios = [for (final i in catalog) i.price]..sort();
  final total = precios.fold<int>(0, (a, b) => a + b) + 0;
  print('Catálogo: ${catalog.length} objetos, ${precios.where((p) => p == 0).length} gratis, '
      'precio total $total 🪙 (regalo inicial ${Economy.welcomeGift} 🪙)\n');
  for (final p in perfiles) {
    final porDia = monedasDelDia(p.habitos, p.tareas) * p.diasActivos;
    // Compra siempre lo más barato que alcanza (así se desbloquea algo cada pocos días).
    var saldo = Economy.welcomeGift.toDouble(), dias = 0;
    final pendientes = [...precios.where((x) => x > 0)];
    int? primeraCompra;
    while (pendientes.isNotEmpty && dias < 365 * 30) {
      dias++;
      saldo += porDia;
      while (pendientes.isNotEmpty && saldo >= pendientes.first) {
        saldo -= pendientes.removeAt(0);
        primeraCompra ??= dias;
      }
    }
    print('${p.nombre}\n'
        '  ${porDia.toStringAsFixed(0)} 🪙 al día de media · primera compra el día ${primeraCompra ?? "-"}'
        ' · catálogo completo en ${(dias / 365).toStringAsFixed(1)} años ($dias días)');
  }
  print('\nNota: el catálogo real de lanzamiento será mucho mayor (~250 objetos) y sigue creciendo cada mes.');
}
