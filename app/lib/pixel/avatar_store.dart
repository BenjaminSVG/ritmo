import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../domain/muscle.dart';
import '../data/wallet.dart';
import '../features/app_state.dart';
import '../platform/widget_sync.dart';
import 'avatar_profile.dart';
import 'catalog.dart';

/// Guardado del personaje. La implementación por defecto no guarda nada (sirve para
/// pruebas); en la app real se sustituye por [DriftAvatarStore].
abstract class AvatarStore {
  Future<AvatarProfile?> load();
  Future<void> save(AvatarProfile profile);
}

class MemoryAvatarStore implements AvatarStore {
  AvatarProfile? _p;
  @override
  Future<AvatarProfile?> load() async => _p;
  @override
  Future<void> save(AvatarProfile profile) async => _p = profile;
}

class DriftAvatarStore implements AvatarStore {
  DriftAvatarStore(this.db);
  final AppDatabase db;

  @override
  Future<AvatarProfile?> load() async {
    final r = await (db.select(db.avatarProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (r == null) return null;
    // Valores fuera de rango (por un archivo dañado o de una versión futura) se corrigen.
    int fit(int v, int len) => v.clamp(0, len - 1);
    return AvatarProfile(
      name: r.name,
      body: BodyId.values.firstWhere((b) => b.id == r.body, orElse: () => BodyId.hombreA),
      skin: fit(r.skin, skinTones.length),
      hairColor: fit(r.hairColor, hairColors.length),
      eyeColor: fit(r.eyeColor, eyeColors.length),
      muscle: fit(r.muscle, muscleNames.length),
      autoMuscle: r.autoMuscle,
      sceneTone: fit(r.sceneTone, 2),
      eyeStyle: fit(r.eyeStyle, eyeStyles.length),
      // Un objeto que ya no está en el catálogo simplemente no se dibuja.
      equipped: decodeEquipped(r.equipped)..removeWhere((_, e) => itemById(e.id) == null),
    );
  }

  @override
  Future<void> save(AvatarProfile p) => db.into(db.avatarProfiles).insertOnConflictUpdate(
        AvatarProfilesCompanion.insert(
          id: const Value(1),
          name: p.name,
          body: p.body.id,
          skin: p.skin,
          hairColor: p.hairColor,
          eyeColor: p.eyeColor,
          muscle: p.muscle,
          autoMuscle: Value(p.autoMuscle),
          sceneTone: Value(p.sceneTone),
          eyeStyle: Value(p.eyeStyle),
          equipped: Value(encodeEquipped(p.equipped)),
        ),
      );
}

final avatarStoreProvider = Provider<AvatarStore>((_) => MemoryAvatarStore());

/// Días con ejercicio en la ventana de musculatura (ver domain/muscle.dart).
final exerciseDaysProvider = Provider<int>((ref) {
  final now = DateTime.now();
  return exerciseDays(ref.watch(appDataProvider).habits, DateTime(now.year, now.month, now.day));
});

/// El personaje tal como se dibuja: con la musculatura automática ya aplicada.
final effectiveAvatarProvider = Provider<AvatarProfile>((ref) {
  final p = ref.watch(avatarProvider);
  final w = ref.watch(walletProvider);
  // Solo se dibuja lo que se tiene (una vez leído el libro, para no parpadear al abrir).
  final shown = w.loaded ? (Map.of(p.equipped)..removeWhere((_, e) => !w.owned.contains(e.id))) : p.equipped;
  final q = p.copyWith(equipped: shown);
  return q.autoMuscle ? q.copyWith(muscle: muscleLevelFor(ref.watch(exerciseDaysProvider))) : q;
});

final avatarProvider =NotifierProvider<AvatarNotifier, AvatarProfile>(AvatarNotifier.new);

class AvatarNotifier extends Notifier<AvatarProfile> {
  @override
  AvatarProfile build() {
    _load();
    return const AvatarProfile();
  }

  Future<void> _load() async {
    final p = await ref.read(avatarStoreProvider).load();
    if (p != null) state = p;
  }

  void update(AvatarProfile Function(AvatarProfile) change) {
    state = change(state);
    ref.read(avatarStoreProvider).save(state);
  }
}

/// Mantiene al día el widget del personaje: se redibuja cuando cambia lo que se ve (o el saldo/nivel
/// que muestra). Un fallo no debe romper la app.
final characterWidgetSyncProvider = Provider<void>((ref) {
  Future<void>? running;
  void sync() {
    final w = ref.read(walletProvider);
    if (!w.loaded) return;
    final p = ref.read(effectiveAvatarProvider);
    running = (running ?? Future.value()).then((_) => CharacterWidgetSync.update(
          profile: p,
          subtitle: '🪙 ${w.coins} · Nivel ${w.level.level}',
        )).catchError((Object e) {
      debugPrint('No se pudo actualizar el widget del personaje: $e');
    });
  }

  ref.listen(effectiveAvatarProvider, (_, _) => sync(), fireImmediately: true);
  ref.listen(walletProvider.select((w) => (w.loaded, w.coins, w.level.level)), (_, _) => sync());
});
