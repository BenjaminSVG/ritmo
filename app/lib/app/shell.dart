import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../features/add_sheet.dart';
import '../features/calendar_page.dart';
import '../features/character_page.dart';
import '../features/habits_page.dart';
import '../features/tasks_page.dart';
import '../features/today_page.dart';

/// Navegación adaptable: barra inferior en móvil, riel lateral en tablet/PC.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;
  StreamSubscription<Uri?>? _widgetClicks;

  @override
  void initState() {
    super.initState();
    // Los widgets de Android abren la app con "ritmo://add" o "ritmo://open".
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      HomeWidget.initiallyLaunchedFromHomeWidget().then(_onWidgetUri).catchError((Object e) {
        debugPrint('No se pudo leer el widget de arranque: $e');
      });
      _widgetClicks = HomeWidget.widgetClicked.listen(_onWidgetUri);
    }
  }

  @override
  void dispose() {
    _widgetClicks?.cancel();
    super.dispose();
  }

  void _onWidgetUri(Uri? uri) {
    if (uri == null || uri.host != 'add') return;
    // Espera al primer frame: al arrancar en frío aún no hay navegador listo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showAddSheet(context);
    });
  }

  static const _destinations = [
    (Icons.today_outlined, Icons.today, 'Hoy'),
    (Icons.calendar_month_outlined, Icons.calendar_month, 'Calendario'),
    (Icons.local_fire_department_outlined, Icons.local_fire_department, 'Hábitos'),
    (Icons.check_circle_outline, Icons.check_circle, 'Tareas'),
    (Icons.face_outlined, Icons.face, 'Personaje'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = const [TodayPage(), CalendarPage(), HabitsPage(), TasksPage(), CharacterPage()];
    final wide = MediaQuery.sizeOf(context).width >= 600;
    final body = IndexedStack(index: _index, children: pages);
    final fab = FloatingActionButton(
      onPressed: () => showAddSheet(context),
      tooltip: 'Nuevo',
      child: const Icon(Icons.add),
    );

    if (wide) {
      return Scaffold(
        floatingActionButton: fab,
        body: Row(children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                    icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900), child: body),
            ),
          ),
        ]),
      );
    }
    return Scaffold(
      body: SafeArea(child: body),
      floatingActionButton: fab,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
                icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
        ],
      ),
    );
  }
}
