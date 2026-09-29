import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get emoji => text()();
  IntColumn get colorValue => integer()();
  TextColumn get type => text()();
  IntColumn get target => integer()();
  TextColumn get unit => text()();

  /// Días activos como "1,2,3" (1 = lunes … 7 = domingo).
  TextColumn get weekdays => text()();
  BoolColumn get archived => boolean()();
  IntColumn get reminderMinutes => integer().nullable()();

  /// Añadida en el esquema v6 (nombre del enum HabitCategory).
  TextColumn get category => text().withDefault(const Constant('ninguna'))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Un registro por hábito y día local (yyyy-MM-dd).
class HabitLogs extends Table {
  TextColumn get habitId => text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get day => text()();
  IntColumn get value => integer()();

  @override
  Set<Column> get primaryKey => {habitId, day};
}

@DataClassName('TaskRow')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text()();
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get hasTime => boolean()();
  IntColumn get priority => integer()();
  BoolColumn get done => boolean()();
  DateTimeColumn get doneAt => dateTime().nullable()();
  TextColumn get repeat => text()();
  IntColumn get sortOrder => integer()();

  /// Añadida en el esquema v2. Las filas anteriores quedan con 30 min.
  IntColumn get durationMin => integer().withDefault(const Constant(30))();

  /// Añadidas en el esquema v3: tipo de tarea (nombre del enum) y color propio.
  TextColumn get kind => text().withDefault(const Constant('tarea'))();
  IntColumn get colorValue => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SubtaskRow')
class Subtasks extends Table {
  TextColumn get taskId => text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  BoolColumn get done => boolean()();

  @override
  Set<Column> get primaryKey => {taskId, position};
}

/// El personaje del usuario. Una sola fila (`id` = 1). Añadida en el esquema v4.
@DataClassName('AvatarRow')
class AvatarProfiles extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get body => text()();
  IntColumn get skin => integer()();
  IntColumn get hairColor => integer()();
  IntColumn get eyeColor => integer()();
  IntColumn get muscle => integer()();

  /// Añadida en el esquema v6: la musculatura sube sola con los hábitos de ejercicio.
  BoolColumn get autoMuscle => boolean().withDefault(const Constant(true))();

  /// Añadida en el esquema v7: objetos puestos ("ranura:id:color,…").
  TextColumn get equipped => text().withDefault(const Constant(''))();

  /// Añadida en el esquema v8: tono de la escena, 0 rosa y 1 azul.
  IntColumn get sceneTone => integer().withDefault(const Constant(1))();

  /// Añadida en el esquema v9: forma de los ojos (índice de eyeStyles).
  IntColumn get eyeStyle => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Libro de movimientos de monedas y experiencia. Solo se añade (las compras irán aquí
/// con monedas negativas). Único por (tipo, elemento, día). Añadida en el esquema v5.
@DataClassName('LedgerRow')
class CoinLedger extends Table {
  TextColumn get kind => text()();
  TextColumn get item => text()();
  TextColumn get day => text()();
  IntColumn get coins => integer()();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  IntColumn get xp => integer()();

  @override
  Set<Column> get primaryKey => {kind, item, day};
}

@DriftDatabase(tables: [Habits, HabitLogs, Tasks, Subtasks, AvatarProfiles, CoinLedger])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'ritmo',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(tasks, tasks.durationMin);
          if (from < 3) {
            await m.addColumn(tasks, tasks.kind);
            await m.addColumn(tasks, tasks.colorValue);
          }
          if (from < 4) await m.createTable(avatarProfiles);
          if (from < 5) await m.createTable(coinLedger);
          if (from < 6) await m.addColumn(habits, habits.category);
          // La tabla del personaje ya nace con estas columnas si se crea en esta migración (from < 4).
          if (from >= 4 && from < 6) await m.addColumn(avatarProfiles, avatarProfiles.autoMuscle);
          if (from >= 4 && from < 7) await m.addColumn(avatarProfiles, avatarProfiles.equipped);
          if (from >= 4 && from < 8) await m.addColumn(avatarProfiles, avatarProfiles.sceneTone);
          if (from >= 4 && from < 9) await m.addColumn(avatarProfiles, avatarProfiles.eyeStyle);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
