import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/data/store.dart';
import 'package:ritmo/domain/models.dart';
import 'package:ritmo/features/app_state.dart';

class MemStore implements Store {
  @override
  Future<(List<Habit>, List<Task>)> load() async => (<Habit>[], <Task>[]);
  @override
  Future<void> save(List<Habit> habits, List<Task> tasks) async {}
}

void main() {
  ProviderContainer make() => ProviderContainer(
      overrides: [storeProvider.overrideWithValue(MemStore())]);

  test('exportar e importar conserva hábitos, registros y tareas', () async {
    final a = make();
    a.read(appDataProvider);
    await Future<void>.delayed(Duration.zero);
    final n = a.read(appDataProvider.notifier);
    n.addHabit('Leer');
    n.logHabit(a.read(appDataProvider).habits.first.id, DateTime(2026, 9, 28));
    n.addTask('Comprar pan', due: DateTime(2026, 9, 29, 16), hasTime: true, priority: 3);
    final json = n.exportJson();

    final b = make();
    b.read(appDataProvider);
    await Future<void>.delayed(Duration.zero);
    b.read(appDataProvider.notifier).importJson(json);
    final d = b.read(appDataProvider);
    expect(d.habits.single.name, 'Leer');
    expect(d.habits.single.isDoneOn(DateTime(2026, 9, 28)), isTrue);
    expect(d.tasks.single.due, DateTime(2026, 9, 29, 16));
    expect(d.tasks.single.priority, 3);
  });

  test('un JSON inválido lanza error y no borra los datos', () async {
    final c = make();
    c.read(appDataProvider);
    await Future<void>.delayed(Duration.zero);
    final n = c.read(appDataProvider.notifier);
    n.addTask('Importante');
    expect(() => n.importJson('esto no es json'), throwsFormatException);
    expect(() => n.importJson('[1,2]'), throwsFormatException);
    expect(c.read(appDataProvider).tasks.length, 1);
  });
}
