import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/data/db/database.dart';
import 'package:ritmo/data/wallet.dart';
import 'package:ritmo/domain/models.dart';
import 'package:ritmo/domain/muscle.dart';
import 'package:ritmo/domain/rewards.dart';
import 'package:ritmo/pixel/avatar_profile.dart';

void main() {
  backupTests();
  shopTests();
  muscleTests();
  final today = DateTime(2026, 9, 29);
  final yesterday = DateTime(2026, 9, 28);
  final days = [today, yesterday];

  Habit habit(String id, {Map<String, int>? logs}) => Habit(id: id, name: id, logs: logs);
  int coins(List<Reward> r) => r.fold(0, (a, e) => a + e.coins);

  group('recompensas', () {
    test('hábito hecho da 10; con todos los hábitos hechos suma +20', () {
      final h = habit('a', logs: {dayKey(today): 1});
      expect(coins(computeRewards([h], [], [today])), 10 + 20);
      final h2 = habit('b');
      expect(coins(computeRewards([h, h2], [], [today])), 10, reason: 'falta uno: sin bonus');
    });

    test('tarea da 3, +1 si es de prioridad alta; solo cuenta el día en que se completó', () {
      final t = Task(id: 't', title: 't', done: true, doneAt: today, priority: 3);
      expect(coins(computeRewards([], [t], [today])), 4);
      expect(computeRewards([], [t], [yesterday]), isEmpty);
    });

    test('prueba a tiempo da +5; fuera de plazo no', () {
      Task prueba(DateTime doneAt) => Task(
          id: 'p', title: 'p', kind: TaskKind.prueba, due: DateTime(2026, 9, 29, 10, 0),
          hasTime: true, done: true, doneAt: doneAt);
      expect(coins(computeRewards([], [prueba(DateTime(2026, 9, 29, 9, 0))], [today])), 8);
      expect(coins(computeRewards([], [prueba(DateTime(2026, 9, 29, 11, 0))], [today])), 3);
    });

    test('máximo 8 tareas con premio por día', () {
      final ts = [
        for (var i = 0; i < 12; i++)
          Task(id: 't$i', title: 't', done: true, doneAt: today.add(Duration(minutes: i)))
      ];
      expect(computeRewards([], ts, [today]).length, 8);
    });

    test('tope de 150 monedas por día', () {
      final hs = [for (var i = 0; i < 20; i++) habit('h$i', logs: {dayKey(today): 1})];
      expect(coins(computeRewards(hs, [], [today])), Economy.dailyCap);
    });

    test('hábitos archivados o de otro día de la semana no premian', () {
      final h = habit('a', logs: {dayKey(today): 1})..archived = true;
      expect(computeRewards([h], [], [today]), isEmpty);
      final other = habit('b', logs: {dayKey(today): 1})..weekdays = {(today.weekday % 7) + 1};
      expect(computeRewards([other], [], [today]), isEmpty);
    });
  });

  group('nivel', () {
    test('sube con 100 + 30·n de experiencia por nivel', () {
      expect(levelFor(0).level, 1);
      expect(levelFor(129).level, 1);
      expect(levelFor(130).level, 2);
      expect(levelFor(130 + 160).level, 3);
      expect(levelFor(999999999).level, greaterThan(100));
    });
  });

  group('libro de movimientos', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('regalo de bienvenida una sola vez y premios sin duplicar', () async {
      final store = DriftLedgerStore(db);
      final key = days.map(dayKey).toList();
      final h = habit('a', logs: {dayKey(today): 1});
      var w = await store.reconcile(key, computeRewards([h], [], days), dayKey(today));
      expect(w.coins, 100 + 30);
      w = await store.reconcile(key, computeRewards([h], [], days), dayKey(today));
      expect(w.coins, 130, reason: 'repetir no duplica');
      w = await store.reconcile(key, computeRewards([habit('a')], [], days), dayKey(today));
      expect(w.coins, 100, reason: 'desmarcar el mismo día revierte el premio');
      expect(w.todayCoins, 100 - 100 + 0 + 100, reason: 'el regalo se anota hoy');
    });

    test('un día fuera de la ventana no se toca', () async {
      final store = DriftLedgerStore(db);
      final old = DateTime(2026, 9, 1);
      final h = habit('a', logs: {dayKey(old): 1});
      await store.reconcile([dayKey(old)], computeRewards([h], [], [old]), dayKey(old));
      final w = await store.reconcile(
          days.map(dayKey).toList(), computeRewards([habit('a')], [], days), dayKey(today));
      expect(w.coins, 100 + 30);
    });
  });
}

void muscleTests() {
  group('musculatura automática', () {
    test('sube con los días de ejercicio y solo cuenta hábitos de ejercicio', () {
      final today = DateTime(2026, 9, 29);
      final logs = {
        for (var i = 0; i < 25; i++) dayKey(DateTime(2026, 9, 29 - i)): 1,
      };
      final run = Habit(id: 'r', name: 'correr', category: HabitCategory.ejercicio, logs: logs);
      final read = Habit(id: 'l', name: 'leer', category: HabitCategory.estudio, logs: logs);
      expect(exerciseDays([read], today), 0);
      expect(exerciseDays([run, read], today), 25);
      expect(muscleLevelFor(25), 1);
      expect(muscleLevelFor(19), 0);
      expect(muscleLevelFor(70), 2);
      expect(muscleLevelFor(260), 4);
    });
  });
}

void shopTests() {
  group('tienda', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());
    const today = '2026-09-29';

    test('compra descuenta, no se repite y no deja saldo negativo', () async {
      final s = DriftLedgerStore(db);
      await s.reconcile([today], [], today); // regalo: 100
      expect(await s.purchase('auriculares', 400, today), isNull, reason: 'no alcanza');
      expect((await s.reconcile([today], [], today)).owned, contains('anteojos'), reason: 'gratis');
      final w = await s.purchase('gorra', 90, today);
      expect(w!.coins, 10);
      expect(w.owned, containsAll(['gorra', 'anteojos', 'dormitorio']));
      expect(w.todayCoins, 100, reason: 'la compra no cuenta como ganancia negativa');
      expect(await s.purchase('gorra', 90, today), isNull, reason: 'ya lo tiene');
    });

    test('recalcular premios no borra las compras', () async {
      final s = DriftLedgerStore(db);
      await s.reconcile([today], [], today);
      await s.purchase('gorra', 90, today);
      final w = await s.reconcile([today], [], today);
      expect(w.owned, containsAll(['gorra', 'anteojos', 'dormitorio']));
      expect(w.coins, 10);
    });
  });
}

void backupTests() {
  group('respaldo del juego', () {
    test('el libro se exporta, se reemplaza y conserva compras y saldo', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final a = DriftLedgerStore(db);
      await a.reconcile(['2026-09-29'], [], '2026-09-29');
      await a.purchase('gorra', 90, '2026-09-29');
      final json = (await a.all()).map((r) => r.toJson()).toList();

      final db2 = AppDatabase(NativeDatabase.memory());
      addTearDown(db2.close);
      final b = DriftLedgerStore(db2);
      await b.replaceAll([for (final e in json) RewardJson.fromJson(e)]);
      final w = await b.reconcile(['2026-09-29'], [], '2026-09-29');
      expect(w.coins, 10);
      expect(w.owned, containsAll(['gorra', 'anteojos', 'dormitorio']));
    });

    test('el personaje se exporta con sus objetos y corrige valores raros', () {
      const p = AvatarProfile(
          name: 'Luna', body: BodyId.mujerA, skin: 5, autoMuscle: false, muscle: 2,
          equipped: {ItemSlot.sombrero: Equipped('gorra', 4)});
      expect(AvatarProfileJson.fromJson(p.toJson()), p);
      final raro = AvatarProfileJson.fromJson({'skin': 99, 'body': 'no_existe', 'name': ' '});
      expect(raro.skin, skinTones.length - 1);
      expect(raro.body, BodyId.hombreA);
      expect(raro.name, 'Ritmo');
    });
  });
}
