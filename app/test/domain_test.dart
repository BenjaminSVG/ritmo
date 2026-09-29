import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/domain/models.dart';
import 'package:ritmo/domain/quick_parse.dart';
import 'package:ritmo/domain/streaks.dart';

Habit habitWith(List<DateTime> done, {Set<int>? weekdays}) => Habit(
      id: 'h',
      name: 'x',
      weekdays: weekdays,
      logs: {for (final d in done) dayKey(d): 1},
    );

void main() {
  final today = DateTime(2026, 9, 28); // lunes

  group('rachas', () {
    test('cuenta días consecutivos hasta hoy', () {
      final h = habitWith([
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      ]);
      expect(currentStreak(h, today), 3);
    });

    test('hoy sin cumplir no rompe la racha de ayer', () {
      final h = habitWith([
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      ]);
      expect(currentStreak(h, today), 2);
    });

    test('un día programado fallado la rompe', () {
      final h = habitWith([
        today,
        today.subtract(const Duration(days: 2)),
      ]);
      expect(currentStreak(h, today), 1);
    });

    test('días no programados no rompen la racha', () {
      // Solo lunes y viernes. Hoy lunes 28, viernes 25 y lunes 21 cumplidos.
      final h = habitWith([
        today,
        DateTime(2026, 9, 25),
        DateTime(2026, 9, 21),
      ], weekdays: {1, 5});
      expect(currentStreak(h, today), 3);
    });

    test('mejor racha', () {
      final h = habitWith([
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 2),
        DateTime(2026, 9, 3),
        DateTime(2026, 9, 10),
      ]);
      expect(bestStreak(h), 3);
    });

    test('la puntuación perdona un fallo (no cae a cero)', () {
      final done = [
        for (var i = 1; i <= 60; i++) today.subtract(Duration(days: i)),
      ]..remove(today.subtract(const Duration(days: 1)));
      final s = habitScore(habitWith(done), today);
      expect(s, greaterThan(0.6));
      expect(s, lessThan(1.0));
    });
  });

  group('captura rápida', () {
    final now = DateTime(2026, 9, 28, 10, 0); // lunes

    test('mañana 4pm !alta', () {
      final p = parseQuick('Llamar al banco mañana 4pm !alta', now);
      expect(p.title, 'Llamar al banco');
      expect(p.due, DateTime(2026, 9, 29, 16, 0));
      expect(p.hasTime, isTrue);
      expect(p.priority, 3);
    });

    test('hora 24h y día de la semana', () {
      final p = parseQuick('Reunión el viernes 16:30', now);
      expect(p.title, 'Reunión');
      expect(p.due, DateTime(2026, 10, 2, 16, 30));
    });

    test('solo fecha, sin hora', () {
      final p = parseQuick('Pagar renta hoy', now);
      expect(p.due, DateTime(2026, 9, 28));
      expect(p.hasTime, isFalse);
    });

    test('sin fecha va a la bandeja', () {
      final p = parseQuick('Comprar pan', now);
      expect(p.due, isNull);
      expect(p.title, 'Comprar pan');
    });

    test('números sueltos no se toman como hora', () {
      final p = parseQuick('Comprar 3 manzanas', now);
      expect(p.due, isNull);
      expect(p.title, 'Comprar 3 manzanas');
    });
  });

  group('tipo de tarea', () {
    final now = DateTime(2026, 9, 28, 10, 0);

    test('#prueba asigna el tipo y se quita del título', () {
      final p = parseQuick('Estudiar cálculo #prueba viernes 9:00', now);
      expect(p.kind, TaskKind.prueba);
      expect(p.title, 'Estudiar cálculo');
      expect(p.due, DateTime(2026, 10, 2, 9, 0));
    });

    test('#examen es sinónimo de prueba', () {
      expect(parseQuick('Álgebra #examen', now).kind, TaskKind.prueba);
    });

    test('una #etiqueta desconocida se queda en el título', () {
      final p = parseQuick('Comprar pan #casa', now);
      expect(p.kind, TaskKind.tarea);
      expect(p.title, 'Comprar pan #casa');
    });

    test('el color efectivo es el del tipo salvo que se elija otro', () {
      final t = Task(id: 't', title: 'x', kind: TaskKind.actividad);
      expect(t.effectiveColor, TaskKind.actividad.defaultColor);
      t.colorValue = 0xFF123456;
      expect(t.effectiveColor, 0xFF123456);
    });
  });
}
