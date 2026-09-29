import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models.dart';
import '../domain/rewards.dart';
import '../features/app_state.dart';
import '../pixel/catalog.dart';
import 'db/database.dart';

/// Saldo, experiencia y objetos comprados: todo sale del libro de movimientos.
class Wallet {
  const Wallet({
    this.coins = 0,
    this.stars = 0,
    this.xp = 0,
    this.todayCoins = 0,
    this.owned = const {},
    this.loaded = false,
  });
  final int coins, stars, xp, todayCoins;

  /// Identificadores de los objetos comprados.
  final Set<String> owned;

  /// false hasta que se lee el libro por primera vez.
  final bool loaded;

  LevelInfo get level => levelFor(xp);
}

/// Guardado del libro de movimientos.
abstract class LedgerStore {
  /// Deja el libro de [days] igual a [desired] (quita lo que ya no corresponde, añade lo
  /// nuevo) y, si nunca se dio, añade el regalo de bienvenida. Devuelve los totales.
  Future<Wallet> reconcile(List<String> days, List<Reward> desired, String today);

  /// Compra [itemId] por [price] monedas. Devuelve null si no alcanza el saldo o ya se
  /// tiene; el saldo nunca queda negativo.
  Future<Wallet?> purchase(String itemId, int price, String today);

  /// Todo el libro, para el respaldo.
  Future<List<Reward>> all();

  /// Reemplaza todo el libro (al importar un respaldo).
  Future<void> replaceAll(List<Reward> rows);
}

Wallet _totals(Iterable<Reward> rows, String today) {
  var c = 0, s = 0, x = 0, t = 0;
  // Los objetos gratuitos son de todos desde el principio.
  final owned = <String>{for (final i in catalog) if (i.price == 0) i.id};
  for (final r in rows) {
    c += r.coins;
    s += r.stars;
    x += r.xp;
    if (r.day == today && r.kind != kindBuy) t += r.coins;
    if (r.kind == kindBuy) owned.add(r.item);
  }
  return Wallet(coins: c, stars: s, xp: x, todayCoins: t, owned: owned, loaded: true);
}

class MemoryLedgerStore implements LedgerStore {
  final _rows = <String, Reward>{};

  @override
  Future<Wallet> reconcile(List<String> days, List<Reward> desired, String today) async {
    _rows.removeWhere((_, r) => days.contains(r.day) && recomputedKinds.contains(r.kind));
    for (final r in desired) {
      _rows[r.key] = r;
    }
    _rows.putIfAbsent(
        '$kindWelcome|gift|$today', () => Reward(kindWelcome, 'gift', today, Economy.welcomeGift, 0));
    return _totals(_rows.values, today);
  }

  @override
  Future<Wallet?> purchase(String itemId, int price, String today) async {
    final w = _totals(_rows.values, today);
    if (price < 0 || w.coins < price || w.owned.contains(itemId)) return null;
    _rows['$kindBuy|$itemId|$today'] = Reward(kindBuy, itemId, today, -price, 0);
    return _totals(_rows.values, today);
  }

  @override
  Future<List<Reward>> all() async => _rows.values.toList();

  @override
  Future<void> replaceAll(List<Reward> rows) async {
    _rows
      ..clear()
      ..addEntries(rows.map((r) => MapEntry(r.key, r)));
  }
}

class DriftLedgerStore implements LedgerStore {
  DriftLedgerStore(this.db);
  final AppDatabase db;

  Future<Wallet> _read(String today) async {
    final all = await db.select(db.coinLedger).get();
    return _totals(all.map((r) => Reward(r.kind, r.item, r.day, r.coins, r.xp, stars: r.stars)), today);
  }

  @override
  Future<Wallet> reconcile(List<String> days, List<Reward> desired, String today) =>
      db.transaction(() async {
        final keep = desired.map((r) => r.key).toSet();
        final inWindow = await (db.select(db.coinLedger)
              ..where((t) => t.day.isIn(days) & t.kind.isIn(recomputedKinds)))
            .get();
        for (final r in inWindow) {
          if (!keep.contains('${r.kind}|${r.item}|${r.day}')) {
            await (db.delete(db.coinLedger)
                  ..where((t) => t.kind.equals(r.kind) & t.item.equals(r.item) & t.day.equals(r.day)))
                .go();
          }
        }
        for (final r in desired) {
          await db.into(db.coinLedger).insertOnConflictUpdate(CoinLedgerCompanion.insert(
              kind: r.kind, item: r.item, day: r.day, coins: r.coins, stars: Value(r.stars), xp: r.xp));
        }
        final gift = await (db.select(db.coinLedger)..where((t) => t.kind.equals(kindWelcome))).get();
        if (gift.isEmpty) {
          await db.into(db.coinLedger).insert(CoinLedgerCompanion.insert(
              kind: kindWelcome, item: 'gift', day: today, coins: Economy.welcomeGift, xp: 0));
        }
        return _read(today);
      });

  @override
  Future<Wallet?> purchase(String itemId, int price, String today) => db.transaction(() async {
        final w = await _read(today);
        if (price < 0 || w.coins < price || w.owned.contains(itemId)) return null;
        await db.into(db.coinLedger).insert(CoinLedgerCompanion.insert(
            kind: kindBuy, item: itemId, day: today, coins: -price, xp: 0));
        return _read(today);
      });

  @override
  Future<List<Reward>> all() async => (await db.select(db.coinLedger).get())
      .map((r) => Reward(r.kind, r.item, r.day, r.coins, r.xp, stars: r.stars))
      .toList();

  @override
  Future<void> replaceAll(List<Reward> rows) => db.transaction(() async {
        await db.delete(db.coinLedger).go();
        for (final r in rows) {
          await db.into(db.coinLedger).insertOnConflictUpdate(CoinLedgerCompanion.insert(
              kind: r.kind, item: r.item, day: r.day, coins: r.coins, stars: Value(r.stars), xp: r.xp));
        }
      });
}

final ledgerStoreProvider = Provider<LedgerStore>((_) => MemoryLedgerStore());

final walletProvider = NotifierProvider<WalletNotifier, Wallet>(WalletNotifier.new);

/// Mantiene el libro al día: cada vez que cambian hábitos o tareas recalcula los premios
/// de hoy y ayer y actualiza el saldo. También hace las compras.
class WalletNotifier extends Notifier<Wallet> {
  Future<void> _last = Future.value();

  @override
  Wallet build() {
    ref.listen(appDataProvider, (_, d) {
      if (d.loaded) _sync(d);
    }, fireImmediately: true);
    return const Wallet();
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<Wallet> _reconcile(AppData d) {
    final today = _today();
    final days = [today, DateTime(today.year, today.month, today.day - 1)];
    return ref
        .read(ledgerStoreProvider)
        .reconcile(days.map(dayKey).toList(), computeRewards(d.habits, d.tasks, days), dayKey(today));
  }

  /// Todo el libro, para el respaldo.
  Future<List<Reward>> exportRows() async {
    await _last;
    return ref.read(ledgerStoreProvider).all();
  }

  /// Reemplaza el libro con el de un respaldo y lo pone al día con los datos actuales.
  Future<void> restore(List<Reward> rows) {
    _last = _last.then((_) async {
      await ref.read(ledgerStoreProvider).replaceAll(rows);
      state = await _reconcile(ref.read(appDataProvider));
    }).catchError((Object _) {});
    return _last;
  }

  // En cola, para que dos cambios seguidos no se pisen.
  void _sync(AppData d) {
    final today = _today();
    final days = [today, DateTime(today.year, today.month, today.day - 1)];
    final desired = computeRewards(d.habits, d.tasks, days);
    _last = _last.then((_) async {
      state = await ref
          .read(ledgerStoreProvider)
          .reconcile(days.map(dayKey).toList(), desired, dayKey(today));
    }).catchError((Object _) {});
  }

  /// Compra un objeto del catálogo. Devuelve true si se compró.
  Future<bool> buy(Item item) async {
    var ok = false;
    _last = _last.then((_) async {
      final w = await ref.read(ledgerStoreProvider).purchase(item.id, item.price, dayKey(_today()));
      if (w != null) {
        state = w;
        ok = true;
      }
    }).catchError((Object _) {});
    await _last;
    return ok;
  }
}
