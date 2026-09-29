import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app/shell.dart';
import 'data/db/database.dart';
import 'data/drift_store.dart';
import 'data/wallet.dart';
import 'features/app_state.dart';
import 'pixel/avatar_store.dart';
import 'platform/notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  await NotificationService.instance.init();
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();
  runApp(ProviderScope(
    overrides: [
      storeProvider.overrideWithValue(DriftStore(db, legacyPrefs: prefs)),
      avatarStoreProvider.overrideWithValue(DriftAvatarStore(db)),
      ledgerStoreProvider.overrideWithValue(DriftLedgerStore(db)),
    ],
    child: const RitmoApp(),
  ));
}

class RitmoApp extends StatelessWidget {
  const RitmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme(Brightness b) => ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF4F6AF5),
          brightness: b,
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
    return MaterialApp(
      title: 'Ritmo',
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      // Mantiene vivo el libro de monedas aunque no se abra la pestaña Personaje.
      builder: (context, child) => Consumer(builder: (_, ref, _) {
        ref.watch(walletProvider);
        ref.watch(characterWidgetSyncProvider);
        return child!;
      }),
      home: const Shell(),
    );
  }
}
