import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wallet.dart';
import '../domain/rewards.dart';
import '../pixel/avatar_profile.dart';
import '../pixel/avatar_store.dart';
import 'app_state.dart';

/// Respaldo completo: hábitos y tareas, más monedas, compras y personaje.
Future<String> buildBackup(WidgetRef ref) async {
  final base = jsonDecode(ref.read(appDataProvider.notifier).exportJson()) as Map<String, dynamic>;
  final rows = await ref.read(walletProvider.notifier).exportRows();
  return jsonEncode({
    ...base,
    'version': 2,
    'ledger': rows.map((r) => r.toJson()).toList(),
    'avatar': ref.read(avatarProvider).toJson(),
  });
}

/// Restaura un respaldo. Lanza [FormatException] si no es válido, sin cambiar nada.
/// Un respaldo antiguo (sin monedas ni personaje) deja intactos esos datos.
Future<void> restoreBackup(WidgetRef ref, String raw) async {
  final j = jsonDecode(raw);
  if (j is! Map<String, dynamic>) throw const FormatException('Formato inválido');
  // Se valida todo antes de tocar nada.
  final ledger = j['ledger'] == null
      ? null
      : [for (final e in j['ledger'] as List) RewardJson.fromJson(e as Map<String, dynamic>)];
  final avatar = j['avatar'] == null
      ? null
      : AvatarProfileJson.fromJson(j['avatar'] as Map<String, dynamic>);

  ref.read(appDataProvider.notifier).importJson(raw);
  if (avatar != null) ref.read(avatarProvider.notifier).update((_) => avatar);
  if (ledger != null) await ref.read(walletProvider.notifier).restore(ledger);
}
