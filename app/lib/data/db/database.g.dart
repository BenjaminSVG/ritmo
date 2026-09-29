// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ninguna'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    emoji,
    colorValue,
    type,
    target,
    unit,
    weekdays,
    archived,
    reminderMinutes,
    category,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdaysMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    } else if (isInserting) {
      context.missing(_archivedMeta);
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekdays'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final String id;
  final String name;
  final String emoji;
  final int colorValue;
  final String type;
  final int target;
  final String unit;

  /// Días activos como "1,2,3" (1 = lunes … 7 = domingo).
  final String weekdays;
  final bool archived;
  final int? reminderMinutes;

  /// Añadida en el esquema v6 (nombre del enum HabitCategory).
  final String category;
  final int sortOrder;
  const HabitRow({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
    required this.type,
    required this.target,
    required this.unit,
    required this.weekdays,
    required this.archived,
    this.reminderMinutes,
    required this.category,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['color_value'] = Variable<int>(colorValue);
    map['type'] = Variable<String>(type);
    map['target'] = Variable<int>(target);
    map['unit'] = Variable<String>(unit);
    map['weekdays'] = Variable<String>(weekdays);
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || reminderMinutes != null) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes);
    }
    map['category'] = Variable<String>(category);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      emoji: Value(emoji),
      colorValue: Value(colorValue),
      type: Value(type),
      target: Value(target),
      unit: Value(unit),
      weekdays: Value(weekdays),
      archived: Value(archived),
      reminderMinutes: reminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderMinutes),
      category: Value(category),
      sortOrder: Value(sortOrder),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<int>(json['target']),
      unit: serializer.fromJson<String>(json['unit']),
      weekdays: serializer.fromJson<String>(json['weekdays']),
      archived: serializer.fromJson<bool>(json['archived']),
      reminderMinutes: serializer.fromJson<int?>(json['reminderMinutes']),
      category: serializer.fromJson<String>(json['category']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'colorValue': serializer.toJson<int>(colorValue),
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<int>(target),
      'unit': serializer.toJson<String>(unit),
      'weekdays': serializer.toJson<String>(weekdays),
      'archived': serializer.toJson<bool>(archived),
      'reminderMinutes': serializer.toJson<int?>(reminderMinutes),
      'category': serializer.toJson<String>(category),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  HabitRow copyWith({
    String? id,
    String? name,
    String? emoji,
    int? colorValue,
    String? type,
    int? target,
    String? unit,
    String? weekdays,
    bool? archived,
    Value<int?> reminderMinutes = const Value.absent(),
    String? category,
    int? sortOrder,
  }) => HabitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    colorValue: colorValue ?? this.colorValue,
    type: type ?? this.type,
    target: target ?? this.target,
    unit: unit ?? this.unit,
    weekdays: weekdays ?? this.weekdays,
    archived: archived ?? this.archived,
    reminderMinutes: reminderMinutes.present
        ? reminderMinutes.value
        : this.reminderMinutes,
    category: category ?? this.category,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      type: data.type.present ? data.type.value : this.type,
      target: data.target.present ? data.target.value : this.target,
      unit: data.unit.present ? data.unit.value : this.unit,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      archived: data.archived.present ? data.archived.value : this.archived,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      category: data.category.present ? data.category.value : this.category,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('colorValue: $colorValue, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('unit: $unit, ')
          ..write('weekdays: $weekdays, ')
          ..write('archived: $archived, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('category: $category, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    emoji,
    colorValue,
    type,
    target,
    unit,
    weekdays,
    archived,
    reminderMinutes,
    category,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.colorValue == this.colorValue &&
          other.type == this.type &&
          other.target == this.target &&
          other.unit == this.unit &&
          other.weekdays == this.weekdays &&
          other.archived == this.archived &&
          other.reminderMinutes == this.reminderMinutes &&
          other.category == this.category &&
          other.sortOrder == this.sortOrder);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> emoji;
  final Value<int> colorValue;
  final Value<String> type;
  final Value<int> target;
  final Value<String> unit;
  final Value<String> weekdays;
  final Value<bool> archived;
  final Value<int?> reminderMinutes;
  final Value<String> category;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.unit = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.archived = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.category = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    required String emoji,
    required int colorValue,
    required String type,
    required int target,
    required String unit,
    required String weekdays,
    required bool archived,
    this.reminderMinutes = const Value.absent(),
    this.category = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       emoji = Value(emoji),
       colorValue = Value(colorValue),
       type = Value(type),
       target = Value(target),
       unit = Value(unit),
       weekdays = Value(weekdays),
       archived = Value(archived),
       sortOrder = Value(sortOrder);
  static Insertable<HabitRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<int>? colorValue,
    Expression<String>? type,
    Expression<int>? target,
    Expression<String>? unit,
    Expression<String>? weekdays,
    Expression<bool>? archived,
    Expression<int>? reminderMinutes,
    Expression<String>? category,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (colorValue != null) 'color_value': colorValue,
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (unit != null) 'unit': unit,
      if (weekdays != null) 'weekdays': weekdays,
      if (archived != null) 'archived': archived,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (category != null) 'category': category,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? emoji,
    Value<int>? colorValue,
    Value<String>? type,
    Value<int>? target,
    Value<String>? unit,
    Value<String>? weekdays,
    Value<bool>? archived,
    Value<int?>? reminderMinutes,
    Value<String>? category,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      target: target ?? this.target,
      unit: unit ?? this.unit,
      weekdays: weekdays ?? this.weekdays,
      archived: archived ?? this.archived,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      category: category ?? this.category,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('colorValue: $colorValue, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('unit: $unit, ')
          ..write('weekdays: $weekdays, ')
          ..write('archived: $archived, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('category: $category, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitLogsTable extends HabitLogs
    with TableInfo<$HabitLogsTable, HabitLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [habitId, day, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, day};
  @override
  HabitLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLog(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $HabitLogsTable createAlias(String alias) {
    return $HabitLogsTable(attachedDatabase, alias);
  }
}

class HabitLog extends DataClass implements Insertable<HabitLog> {
  final String habitId;
  final String day;
  final int value;
  const HabitLog({
    required this.habitId,
    required this.day,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['day'] = Variable<String>(day);
    map['value'] = Variable<int>(value);
    return map;
  }

  HabitLogsCompanion toCompanion(bool nullToAbsent) {
    return HabitLogsCompanion(
      habitId: Value(habitId),
      day: Value(day),
      value: Value(value),
    );
  }

  factory HabitLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLog(
      habitId: serializer.fromJson<String>(json['habitId']),
      day: serializer.fromJson<String>(json['day']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'day': serializer.toJson<String>(day),
      'value': serializer.toJson<int>(value),
    };
  }

  HabitLog copyWith({String? habitId, String? day, int? value}) => HabitLog(
    habitId: habitId ?? this.habitId,
    day: day ?? this.day,
    value: value ?? this.value,
  );
  HabitLog copyWithCompanion(HabitLogsCompanion data) {
    return HabitLog(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      day: data.day.present ? data.day.value : this.day,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLog(')
          ..write('habitId: $habitId, ')
          ..write('day: $day, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(habitId, day, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLog &&
          other.habitId == this.habitId &&
          other.day == this.day &&
          other.value == this.value);
}

class HabitLogsCompanion extends UpdateCompanion<HabitLog> {
  final Value<String> habitId;
  final Value<String> day;
  final Value<int> value;
  final Value<int> rowid;
  const HabitLogsCompanion({
    this.habitId = const Value.absent(),
    this.day = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitLogsCompanion.insert({
    required String habitId,
    required String day,
    required int value,
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       day = Value(day),
       value = Value(value);
  static Insertable<HabitLog> custom({
    Expression<String>? habitId,
    Expression<String>? day,
    Expression<int>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (day != null) 'day': day,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitLogsCompanion copyWith({
    Value<String>? habitId,
    Value<String>? day,
    Value<int>? value,
    Value<int>? rowid,
  }) {
    return HabitLogsCompanion(
      habitId: habitId ?? this.habitId,
      day: day ?? this.day,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('day: $day, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasTimeMeta = const VerificationMeta(
    'hasTime',
  );
  @override
  late final GeneratedColumn<bool> hasTime = GeneratedColumn<bool>(
    'has_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_time" IN (0, 1))',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
    'repeat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tarea'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    due,
    hasTime,
    priority,
    done,
    doneAt,
    repeat,
    sortOrder,
    durationMin,
    kind,
    colorValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('has_time')) {
      context.handle(
        _hasTimeMeta,
        hasTime.isAcceptableOrUnknown(data['has_time']!, _hasTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_hasTimeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    } else if (isInserting) {
      context.missing(_doneMeta);
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    if (data.containsKey('repeat')) {
      context.handle(
        _repeatMeta,
        repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
      hasTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_time'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
      repeat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String notes;
  final DateTime? due;
  final bool hasTime;
  final int priority;
  final bool done;
  final DateTime? doneAt;
  final String repeat;
  final int sortOrder;

  /// Añadida en el esquema v2. Las filas anteriores quedan con 30 min.
  final int durationMin;

  /// Añadidas en el esquema v3: tipo de tarea (nombre del enum) y color propio.
  final String kind;
  final int? colorValue;
  const TaskRow({
    required this.id,
    required this.title,
    required this.notes,
    this.due,
    required this.hasTime,
    required this.priority,
    required this.done,
    this.doneAt,
    required this.repeat,
    required this.sortOrder,
    required this.durationMin,
    required this.kind,
    this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    map['has_time'] = Variable<bool>(hasTime);
    map['priority'] = Variable<int>(priority);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    map['repeat'] = Variable<String>(repeat);
    map['sort_order'] = Variable<int>(sortOrder);
    map['duration_min'] = Variable<int>(durationMin);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      notes: Value(notes),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      hasTime: Value(hasTime),
      priority: Value(priority),
      done: Value(done),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      repeat: Value(repeat),
      sortOrder: Value(sortOrder),
      durationMin: Value(durationMin),
      kind: Value(kind),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      due: serializer.fromJson<DateTime?>(json['due']),
      hasTime: serializer.fromJson<bool>(json['hasTime']),
      priority: serializer.fromJson<int>(json['priority']),
      done: serializer.fromJson<bool>(json['done']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
      repeat: serializer.fromJson<String>(json['repeat']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      durationMin: serializer.fromJson<int>(json['durationMin']),
      kind: serializer.fromJson<String>(json['kind']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'due': serializer.toJson<DateTime?>(due),
      'hasTime': serializer.toJson<bool>(hasTime),
      'priority': serializer.toJson<int>(priority),
      'done': serializer.toJson<bool>(done),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
      'repeat': serializer.toJson<String>(repeat),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'durationMin': serializer.toJson<int>(durationMin),
      'kind': serializer.toJson<String>(kind),
      'colorValue': serializer.toJson<int?>(colorValue),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    String? notes,
    Value<DateTime?> due = const Value.absent(),
    bool? hasTime,
    int? priority,
    bool? done,
    Value<DateTime?> doneAt = const Value.absent(),
    String? repeat,
    int? sortOrder,
    int? durationMin,
    String? kind,
    Value<int?> colorValue = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    due: due.present ? due.value : this.due,
    hasTime: hasTime ?? this.hasTime,
    priority: priority ?? this.priority,
    done: done ?? this.done,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    repeat: repeat ?? this.repeat,
    sortOrder: sortOrder ?? this.sortOrder,
    durationMin: durationMin ?? this.durationMin,
    kind: kind ?? this.kind,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      due: data.due.present ? data.due.value : this.due,
      hasTime: data.hasTime.present ? data.hasTime.value : this.hasTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      done: data.done.present ? data.done.value : this.done,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      kind: data.kind.present ? data.kind.value : this.kind,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('due: $due, ')
          ..write('hasTime: $hasTime, ')
          ..write('priority: $priority, ')
          ..write('done: $done, ')
          ..write('doneAt: $doneAt, ')
          ..write('repeat: $repeat, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('durationMin: $durationMin, ')
          ..write('kind: $kind, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    notes,
    due,
    hasTime,
    priority,
    done,
    doneAt,
    repeat,
    sortOrder,
    durationMin,
    kind,
    colorValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.due == this.due &&
          other.hasTime == this.hasTime &&
          other.priority == this.priority &&
          other.done == this.done &&
          other.doneAt == this.doneAt &&
          other.repeat == this.repeat &&
          other.sortOrder == this.sortOrder &&
          other.durationMin == this.durationMin &&
          other.kind == this.kind &&
          other.colorValue == this.colorValue);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> notes;
  final Value<DateTime?> due;
  final Value<bool> hasTime;
  final Value<int> priority;
  final Value<bool> done;
  final Value<DateTime?> doneAt;
  final Value<String> repeat;
  final Value<int> sortOrder;
  final Value<int> durationMin;
  final Value<String> kind;
  final Value<int?> colorValue;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.due = const Value.absent(),
    this.hasTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.done = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.repeat = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.kind = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    required String notes,
    this.due = const Value.absent(),
    required bool hasTime,
    required int priority,
    required bool done,
    this.doneAt = const Value.absent(),
    required String repeat,
    required int sortOrder,
    this.durationMin = const Value.absent(),
    this.kind = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       notes = Value(notes),
       hasTime = Value(hasTime),
       priority = Value(priority),
       done = Value(done),
       repeat = Value(repeat),
       sortOrder = Value(sortOrder);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? due,
    Expression<bool>? hasTime,
    Expression<int>? priority,
    Expression<bool>? done,
    Expression<DateTime>? doneAt,
    Expression<String>? repeat,
    Expression<int>? sortOrder,
    Expression<int>? durationMin,
    Expression<String>? kind,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (due != null) 'due': due,
      if (hasTime != null) 'has_time': hasTime,
      if (priority != null) 'priority': priority,
      if (done != null) 'done': done,
      if (doneAt != null) 'done_at': doneAt,
      if (repeat != null) 'repeat': repeat,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (durationMin != null) 'duration_min': durationMin,
      if (kind != null) 'kind': kind,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? notes,
    Value<DateTime?>? due,
    Value<bool>? hasTime,
    Value<int>? priority,
    Value<bool>? done,
    Value<DateTime?>? doneAt,
    Value<String>? repeat,
    Value<int>? sortOrder,
    Value<int>? durationMin,
    Value<String>? kind,
    Value<int?>? colorValue,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      due: due ?? this.due,
      hasTime: hasTime ?? this.hasTime,
      priority: priority ?? this.priority,
      done: done ?? this.done,
      doneAt: doneAt ?? this.doneAt,
      repeat: repeat ?? this.repeat,
      sortOrder: sortOrder ?? this.sortOrder,
      durationMin: durationMin ?? this.durationMin,
      kind: kind ?? this.kind,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (hasTime.present) {
      map['has_time'] = Variable<bool>(hasTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('due: $due, ')
          ..write('hasTime: $hasTime, ')
          ..write('priority: $priority, ')
          ..write('done: $done, ')
          ..write('doneAt: $doneAt, ')
          ..write('repeat: $repeat, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('durationMin: $durationMin, ')
          ..write('kind: $kind, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks
    with TableInfo<$SubtasksTable, SubtaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, position, title, done];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubtaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    } else if (isInserting) {
      context.missing(_doneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, position};
  @override
  SubtaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtaskRow(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class SubtaskRow extends DataClass implements Insertable<SubtaskRow> {
  final String taskId;
  final int position;
  final String title;
  final bool done;
  const SubtaskRow({
    required this.taskId,
    required this.position,
    required this.title,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      taskId: Value(taskId),
      position: Value(position),
      title: Value(title),
      done: Value(done),
    );
  }

  factory SubtaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtaskRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
    };
  }

  SubtaskRow copyWith({
    String? taskId,
    int? position,
    String? title,
    bool? done,
  }) => SubtaskRow(
    taskId: taskId ?? this.taskId,
    position: position ?? this.position,
    title: title ?? this.title,
    done: done ?? this.done,
  );
  SubtaskRow copyWithCompanion(SubtasksCompanion data) {
    return SubtaskRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtaskRow(')
          ..write('taskId: $taskId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, position, title, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtaskRow &&
          other.taskId == this.taskId &&
          other.position == this.position &&
          other.title == this.title &&
          other.done == this.done);
}

class SubtasksCompanion extends UpdateCompanion<SubtaskRow> {
  final Value<String> taskId;
  final Value<int> position;
  final Value<String> title;
  final Value<bool> done;
  final Value<int> rowid;
  const SubtasksCompanion({
    this.taskId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    required String taskId,
    required int position,
    required String title,
    required bool done,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       position = Value(position),
       title = Value(title),
       done = Value(done);
  static Insertable<SubtaskRow> custom({
    Expression<String>? taskId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (done != null) 'done': done,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith({
    Value<String>? taskId,
    Value<int>? position,
    Value<String>? title,
    Value<bool>? done,
    Value<int>? rowid,
  }) {
    return SubtasksCompanion(
      taskId: taskId ?? this.taskId,
      position: position ?? this.position,
      title: title ?? this.title,
      done: done ?? this.done,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('taskId: $taskId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvatarProfilesTable extends AvatarProfiles
    with TableInfo<$AvatarProfilesTable, AvatarRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvatarProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skinMeta = const VerificationMeta('skin');
  @override
  late final GeneratedColumn<int> skin = GeneratedColumn<int>(
    'skin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hairColorMeta = const VerificationMeta(
    'hairColor',
  );
  @override
  late final GeneratedColumn<int> hairColor = GeneratedColumn<int>(
    'hair_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eyeColorMeta = const VerificationMeta(
    'eyeColor',
  );
  @override
  late final GeneratedColumn<int> eyeColor = GeneratedColumn<int>(
    'eye_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleMeta = const VerificationMeta('muscle');
  @override
  late final GeneratedColumn<int> muscle = GeneratedColumn<int>(
    'muscle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoMuscleMeta = const VerificationMeta(
    'autoMuscle',
  );
  @override
  late final GeneratedColumn<bool> autoMuscle = GeneratedColumn<bool>(
    'auto_muscle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_muscle" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _equippedMeta = const VerificationMeta(
    'equipped',
  );
  @override
  late final GeneratedColumn<String> equipped = GeneratedColumn<String>(
    'equipped',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sceneToneMeta = const VerificationMeta(
    'sceneTone',
  );
  @override
  late final GeneratedColumn<int> sceneTone = GeneratedColumn<int>(
    'scene_tone',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _eyeStyleMeta = const VerificationMeta(
    'eyeStyle',
  );
  @override
  late final GeneratedColumn<int> eyeStyle = GeneratedColumn<int>(
    'eye_style',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    body,
    skin,
    hairColor,
    eyeColor,
    muscle,
    autoMuscle,
    equipped,
    sceneTone,
    eyeStyle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'avatar_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AvatarRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('skin')) {
      context.handle(
        _skinMeta,
        skin.isAcceptableOrUnknown(data['skin']!, _skinMeta),
      );
    } else if (isInserting) {
      context.missing(_skinMeta);
    }
    if (data.containsKey('hair_color')) {
      context.handle(
        _hairColorMeta,
        hairColor.isAcceptableOrUnknown(data['hair_color']!, _hairColorMeta),
      );
    } else if (isInserting) {
      context.missing(_hairColorMeta);
    }
    if (data.containsKey('eye_color')) {
      context.handle(
        _eyeColorMeta,
        eyeColor.isAcceptableOrUnknown(data['eye_color']!, _eyeColorMeta),
      );
    } else if (isInserting) {
      context.missing(_eyeColorMeta);
    }
    if (data.containsKey('muscle')) {
      context.handle(
        _muscleMeta,
        muscle.isAcceptableOrUnknown(data['muscle']!, _muscleMeta),
      );
    } else if (isInserting) {
      context.missing(_muscleMeta);
    }
    if (data.containsKey('auto_muscle')) {
      context.handle(
        _autoMuscleMeta,
        autoMuscle.isAcceptableOrUnknown(data['auto_muscle']!, _autoMuscleMeta),
      );
    }
    if (data.containsKey('equipped')) {
      context.handle(
        _equippedMeta,
        equipped.isAcceptableOrUnknown(data['equipped']!, _equippedMeta),
      );
    }
    if (data.containsKey('scene_tone')) {
      context.handle(
        _sceneToneMeta,
        sceneTone.isAcceptableOrUnknown(data['scene_tone']!, _sceneToneMeta),
      );
    }
    if (data.containsKey('eye_style')) {
      context.handle(
        _eyeStyleMeta,
        eyeStyle.isAcceptableOrUnknown(data['eye_style']!, _eyeStyleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AvatarRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvatarRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      skin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skin'],
      )!,
      hairColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hair_color'],
      )!,
      eyeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eye_color'],
      )!,
      muscle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}muscle'],
      )!,
      autoMuscle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_muscle'],
      )!,
      equipped: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped'],
      )!,
      sceneTone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scene_tone'],
      )!,
      eyeStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eye_style'],
      )!,
    );
  }

  @override
  $AvatarProfilesTable createAlias(String alias) {
    return $AvatarProfilesTable(attachedDatabase, alias);
  }
}

class AvatarRow extends DataClass implements Insertable<AvatarRow> {
  final int id;
  final String name;
  final String body;
  final int skin;
  final int hairColor;
  final int eyeColor;
  final int muscle;

  /// Añadida en el esquema v6: la musculatura sube sola con los hábitos de ejercicio.
  final bool autoMuscle;

  /// Añadida en el esquema v7: objetos puestos ("ranura:id:color,…").
  final String equipped;

  /// Añadida en el esquema v8: tono de la escena, 0 rosa y 1 azul.
  final int sceneTone;

  /// Añadida en el esquema v9: forma de los ojos (índice de eyeStyles).
  final int eyeStyle;
  const AvatarRow({
    required this.id,
    required this.name,
    required this.body,
    required this.skin,
    required this.hairColor,
    required this.eyeColor,
    required this.muscle,
    required this.autoMuscle,
    required this.equipped,
    required this.sceneTone,
    required this.eyeStyle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['body'] = Variable<String>(body);
    map['skin'] = Variable<int>(skin);
    map['hair_color'] = Variable<int>(hairColor);
    map['eye_color'] = Variable<int>(eyeColor);
    map['muscle'] = Variable<int>(muscle);
    map['auto_muscle'] = Variable<bool>(autoMuscle);
    map['equipped'] = Variable<String>(equipped);
    map['scene_tone'] = Variable<int>(sceneTone);
    map['eye_style'] = Variable<int>(eyeStyle);
    return map;
  }

  AvatarProfilesCompanion toCompanion(bool nullToAbsent) {
    return AvatarProfilesCompanion(
      id: Value(id),
      name: Value(name),
      body: Value(body),
      skin: Value(skin),
      hairColor: Value(hairColor),
      eyeColor: Value(eyeColor),
      muscle: Value(muscle),
      autoMuscle: Value(autoMuscle),
      equipped: Value(equipped),
      sceneTone: Value(sceneTone),
      eyeStyle: Value(eyeStyle),
    );
  }

  factory AvatarRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvatarRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      body: serializer.fromJson<String>(json['body']),
      skin: serializer.fromJson<int>(json['skin']),
      hairColor: serializer.fromJson<int>(json['hairColor']),
      eyeColor: serializer.fromJson<int>(json['eyeColor']),
      muscle: serializer.fromJson<int>(json['muscle']),
      autoMuscle: serializer.fromJson<bool>(json['autoMuscle']),
      equipped: serializer.fromJson<String>(json['equipped']),
      sceneTone: serializer.fromJson<int>(json['sceneTone']),
      eyeStyle: serializer.fromJson<int>(json['eyeStyle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'body': serializer.toJson<String>(body),
      'skin': serializer.toJson<int>(skin),
      'hairColor': serializer.toJson<int>(hairColor),
      'eyeColor': serializer.toJson<int>(eyeColor),
      'muscle': serializer.toJson<int>(muscle),
      'autoMuscle': serializer.toJson<bool>(autoMuscle),
      'equipped': serializer.toJson<String>(equipped),
      'sceneTone': serializer.toJson<int>(sceneTone),
      'eyeStyle': serializer.toJson<int>(eyeStyle),
    };
  }

  AvatarRow copyWith({
    int? id,
    String? name,
    String? body,
    int? skin,
    int? hairColor,
    int? eyeColor,
    int? muscle,
    bool? autoMuscle,
    String? equipped,
    int? sceneTone,
    int? eyeStyle,
  }) => AvatarRow(
    id: id ?? this.id,
    name: name ?? this.name,
    body: body ?? this.body,
    skin: skin ?? this.skin,
    hairColor: hairColor ?? this.hairColor,
    eyeColor: eyeColor ?? this.eyeColor,
    muscle: muscle ?? this.muscle,
    autoMuscle: autoMuscle ?? this.autoMuscle,
    equipped: equipped ?? this.equipped,
    sceneTone: sceneTone ?? this.sceneTone,
    eyeStyle: eyeStyle ?? this.eyeStyle,
  );
  AvatarRow copyWithCompanion(AvatarProfilesCompanion data) {
    return AvatarRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      body: data.body.present ? data.body.value : this.body,
      skin: data.skin.present ? data.skin.value : this.skin,
      hairColor: data.hairColor.present ? data.hairColor.value : this.hairColor,
      eyeColor: data.eyeColor.present ? data.eyeColor.value : this.eyeColor,
      muscle: data.muscle.present ? data.muscle.value : this.muscle,
      autoMuscle: data.autoMuscle.present
          ? data.autoMuscle.value
          : this.autoMuscle,
      equipped: data.equipped.present ? data.equipped.value : this.equipped,
      sceneTone: data.sceneTone.present ? data.sceneTone.value : this.sceneTone,
      eyeStyle: data.eyeStyle.present ? data.eyeStyle.value : this.eyeStyle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvatarRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('skin: $skin, ')
          ..write('hairColor: $hairColor, ')
          ..write('eyeColor: $eyeColor, ')
          ..write('muscle: $muscle, ')
          ..write('autoMuscle: $autoMuscle, ')
          ..write('equipped: $equipped, ')
          ..write('sceneTone: $sceneTone, ')
          ..write('eyeStyle: $eyeStyle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    body,
    skin,
    hairColor,
    eyeColor,
    muscle,
    autoMuscle,
    equipped,
    sceneTone,
    eyeStyle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvatarRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.body == this.body &&
          other.skin == this.skin &&
          other.hairColor == this.hairColor &&
          other.eyeColor == this.eyeColor &&
          other.muscle == this.muscle &&
          other.autoMuscle == this.autoMuscle &&
          other.equipped == this.equipped &&
          other.sceneTone == this.sceneTone &&
          other.eyeStyle == this.eyeStyle);
}

class AvatarProfilesCompanion extends UpdateCompanion<AvatarRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> body;
  final Value<int> skin;
  final Value<int> hairColor;
  final Value<int> eyeColor;
  final Value<int> muscle;
  final Value<bool> autoMuscle;
  final Value<String> equipped;
  final Value<int> sceneTone;
  final Value<int> eyeStyle;
  const AvatarProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.body = const Value.absent(),
    this.skin = const Value.absent(),
    this.hairColor = const Value.absent(),
    this.eyeColor = const Value.absent(),
    this.muscle = const Value.absent(),
    this.autoMuscle = const Value.absent(),
    this.equipped = const Value.absent(),
    this.sceneTone = const Value.absent(),
    this.eyeStyle = const Value.absent(),
  });
  AvatarProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String body,
    required int skin,
    required int hairColor,
    required int eyeColor,
    required int muscle,
    this.autoMuscle = const Value.absent(),
    this.equipped = const Value.absent(),
    this.sceneTone = const Value.absent(),
    this.eyeStyle = const Value.absent(),
  }) : name = Value(name),
       body = Value(body),
       skin = Value(skin),
       hairColor = Value(hairColor),
       eyeColor = Value(eyeColor),
       muscle = Value(muscle);
  static Insertable<AvatarRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? body,
    Expression<int>? skin,
    Expression<int>? hairColor,
    Expression<int>? eyeColor,
    Expression<int>? muscle,
    Expression<bool>? autoMuscle,
    Expression<String>? equipped,
    Expression<int>? sceneTone,
    Expression<int>? eyeStyle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (body != null) 'body': body,
      if (skin != null) 'skin': skin,
      if (hairColor != null) 'hair_color': hairColor,
      if (eyeColor != null) 'eye_color': eyeColor,
      if (muscle != null) 'muscle': muscle,
      if (autoMuscle != null) 'auto_muscle': autoMuscle,
      if (equipped != null) 'equipped': equipped,
      if (sceneTone != null) 'scene_tone': sceneTone,
      if (eyeStyle != null) 'eye_style': eyeStyle,
    });
  }

  AvatarProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? body,
    Value<int>? skin,
    Value<int>? hairColor,
    Value<int>? eyeColor,
    Value<int>? muscle,
    Value<bool>? autoMuscle,
    Value<String>? equipped,
    Value<int>? sceneTone,
    Value<int>? eyeStyle,
  }) {
    return AvatarProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      body: body ?? this.body,
      skin: skin ?? this.skin,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      muscle: muscle ?? this.muscle,
      autoMuscle: autoMuscle ?? this.autoMuscle,
      equipped: equipped ?? this.equipped,
      sceneTone: sceneTone ?? this.sceneTone,
      eyeStyle: eyeStyle ?? this.eyeStyle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (skin.present) {
      map['skin'] = Variable<int>(skin.value);
    }
    if (hairColor.present) {
      map['hair_color'] = Variable<int>(hairColor.value);
    }
    if (eyeColor.present) {
      map['eye_color'] = Variable<int>(eyeColor.value);
    }
    if (muscle.present) {
      map['muscle'] = Variable<int>(muscle.value);
    }
    if (autoMuscle.present) {
      map['auto_muscle'] = Variable<bool>(autoMuscle.value);
    }
    if (equipped.present) {
      map['equipped'] = Variable<String>(equipped.value);
    }
    if (sceneTone.present) {
      map['scene_tone'] = Variable<int>(sceneTone.value);
    }
    if (eyeStyle.present) {
      map['eye_style'] = Variable<int>(eyeStyle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvatarProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('skin: $skin, ')
          ..write('hairColor: $hairColor, ')
          ..write('eyeColor: $eyeColor, ')
          ..write('muscle: $muscle, ')
          ..write('autoMuscle: $autoMuscle, ')
          ..write('equipped: $equipped, ')
          ..write('sceneTone: $sceneTone, ')
          ..write('eyeStyle: $eyeStyle')
          ..write(')'))
        .toString();
  }
}

class $CoinLedgerTable extends CoinLedger
    with TableInfo<$CoinLedgerTable, LedgerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoinLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kind, item, day, coins, stars, xp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coin_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    } else if (isInserting) {
      context.missing(_itemMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    } else if (isInserting) {
      context.missing(_coinsMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind, item, day};
  @override
  LedgerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
    );
  }

  @override
  $CoinLedgerTable createAlias(String alias) {
    return $CoinLedgerTable(attachedDatabase, alias);
  }
}

class LedgerRow extends DataClass implements Insertable<LedgerRow> {
  final String kind;
  final String item;
  final String day;
  final int coins;
  final int stars;
  final int xp;
  const LedgerRow({
    required this.kind,
    required this.item,
    required this.day,
    required this.coins,
    required this.stars,
    required this.xp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['item'] = Variable<String>(item);
    map['day'] = Variable<String>(day);
    map['coins'] = Variable<int>(coins);
    map['stars'] = Variable<int>(stars);
    map['xp'] = Variable<int>(xp);
    return map;
  }

  CoinLedgerCompanion toCompanion(bool nullToAbsent) {
    return CoinLedgerCompanion(
      kind: Value(kind),
      item: Value(item),
      day: Value(day),
      coins: Value(coins),
      stars: Value(stars),
      xp: Value(xp),
    );
  }

  factory LedgerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerRow(
      kind: serializer.fromJson<String>(json['kind']),
      item: serializer.fromJson<String>(json['item']),
      day: serializer.fromJson<String>(json['day']),
      coins: serializer.fromJson<int>(json['coins']),
      stars: serializer.fromJson<int>(json['stars']),
      xp: serializer.fromJson<int>(json['xp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'item': serializer.toJson<String>(item),
      'day': serializer.toJson<String>(day),
      'coins': serializer.toJson<int>(coins),
      'stars': serializer.toJson<int>(stars),
      'xp': serializer.toJson<int>(xp),
    };
  }

  LedgerRow copyWith({
    String? kind,
    String? item,
    String? day,
    int? coins,
    int? stars,
    int? xp,
  }) => LedgerRow(
    kind: kind ?? this.kind,
    item: item ?? this.item,
    day: day ?? this.day,
    coins: coins ?? this.coins,
    stars: stars ?? this.stars,
    xp: xp ?? this.xp,
  );
  LedgerRow copyWithCompanion(CoinLedgerCompanion data) {
    return LedgerRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      item: data.item.present ? data.item.value : this.item,
      day: data.day.present ? data.day.value : this.day,
      coins: data.coins.present ? data.coins.value : this.coins,
      stars: data.stars.present ? data.stars.value : this.stars,
      xp: data.xp.present ? data.xp.value : this.xp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerRow(')
          ..write('kind: $kind, ')
          ..write('item: $item, ')
          ..write('day: $day, ')
          ..write('coins: $coins, ')
          ..write('stars: $stars, ')
          ..write('xp: $xp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, item, day, coins, stars, xp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerRow &&
          other.kind == this.kind &&
          other.item == this.item &&
          other.day == this.day &&
          other.coins == this.coins &&
          other.stars == this.stars &&
          other.xp == this.xp);
}

class CoinLedgerCompanion extends UpdateCompanion<LedgerRow> {
  final Value<String> kind;
  final Value<String> item;
  final Value<String> day;
  final Value<int> coins;
  final Value<int> stars;
  final Value<int> xp;
  final Value<int> rowid;
  const CoinLedgerCompanion({
    this.kind = const Value.absent(),
    this.item = const Value.absent(),
    this.day = const Value.absent(),
    this.coins = const Value.absent(),
    this.stars = const Value.absent(),
    this.xp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoinLedgerCompanion.insert({
    required String kind,
    required String item,
    required String day,
    required int coins,
    this.stars = const Value.absent(),
    required int xp,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       item = Value(item),
       day = Value(day),
       coins = Value(coins),
       xp = Value(xp);
  static Insertable<LedgerRow> custom({
    Expression<String>? kind,
    Expression<String>? item,
    Expression<String>? day,
    Expression<int>? coins,
    Expression<int>? stars,
    Expression<int>? xp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (item != null) 'item': item,
      if (day != null) 'day': day,
      if (coins != null) 'coins': coins,
      if (stars != null) 'stars': stars,
      if (xp != null) 'xp': xp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoinLedgerCompanion copyWith({
    Value<String>? kind,
    Value<String>? item,
    Value<String>? day,
    Value<int>? coins,
    Value<int>? stars,
    Value<int>? xp,
    Value<int>? rowid,
  }) {
    return CoinLedgerCompanion(
      kind: kind ?? this.kind,
      item: item ?? this.item,
      day: day ?? this.day,
      coins: coins ?? this.coins,
      stars: stars ?? this.stars,
      xp: xp ?? this.xp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoinLedgerCompanion(')
          ..write('kind: $kind, ')
          ..write('item: $item, ')
          ..write('day: $day, ')
          ..write('coins: $coins, ')
          ..write('stars: $stars, ')
          ..write('xp: $xp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitLogsTable habitLogs = $HabitLogsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $AvatarProfilesTable avatarProfiles = $AvatarProfilesTable(this);
  late final $CoinLedgerTable coinLedger = $CoinLedgerTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    habitLogs,
    tasks,
    subtasks,
    avatarProfiles,
    coinLedger,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subtasks', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String name,
  required String emoji,
  required int colorValue,
  required String type,
  required int target,
  required String unit,
  required String weekdays,
  required bool archived,
  Value<int?> reminderMinutes,
  Value<String> category,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> emoji,
  Value<int> colorValue,
  Value<String> type,
  Value<int> target,
  Value<String> unit,
  Value<String> weekdays,
  Value<bool> archived,
  Value<int?> reminderMinutes,
  Value<String> category,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitRow> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogsTable, List<HabitLog>>
  _habitLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogs,
    aliasName: 'habits__id__habit_logs__habit_id',
  );

  $$HabitLogsTableProcessedTableManager get habitLogsRefs {
    final manager = $$HabitLogsTableTableManager(
      $_db,
      $_db.habitLogs,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogsRefs(
    Expression<bool> Function($$HabitLogsTableFilterComposer f) f,
  ) {
    final $$HabitLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableFilterComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> habitLogsRefs<T extends Object>(
    Expression<T> Function($$HabitLogsTableAnnotationComposer a) f,
  ) {
    final $$HabitLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitRow,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitRow, $$HabitsTableReferences),
          HabitRow,
          PrefetchHooks Function({bool habitLogsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> weekdays = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                emoji: emoji,
                colorValue: colorValue,
                type: type,
                target: target,
                unit: unit,
                weekdays: weekdays,
                archived: archived,
                reminderMinutes: reminderMinutes,
                category: category,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String emoji,
                required int colorValue,
                required String type,
                required int target,
                required String unit,
                required String weekdays,
                required bool archived,
                Value<int?> reminderMinutes = const Value.absent(),
                Value<String> category = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                emoji: emoji,
                colorValue: colorValue,
                type: type,
                target: target,
                unit: unit,
                weekdays: weekdays,
                archived: archived,
                reminderMinutes: reminderMinutes,
                category: category,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTable, HabitRow>(table),
                  $$HabitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitLogsRefs) db.habitLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogsRefs)
                    await $_getPrefetchedData<HabitRow, $HabitsTable, HabitLog>(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HabitsTableReferences(db, table, p0).habitLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitRow,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitRow, $$HabitsTableReferences),
      HabitRow,
      PrefetchHooks Function({bool habitLogsRefs})
    >;
typedef $$HabitLogsTableCreateCompanionBuilder = HabitLogsCompanion Function({
  required String habitId,
  required String day,
  required int value,
  Value<int> rowid,
});
typedef $$HabitLogsTableUpdateCompanionBuilder = HabitLogsCompanion Function({
  Value<String> habitId,
  Value<String> day,
  Value<int> value,
  Value<int> rowid,
});

final class $$HabitLogsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitLogsTable, HabitLog> {
  $$HabitLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_logs__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogsTable,
          HabitLog,
          $$HabitLogsTableFilterComposer,
          $$HabitLogsTableOrderingComposer,
          $$HabitLogsTableAnnotationComposer,
          $$HabitLogsTableCreateCompanionBuilder,
          $$HabitLogsTableUpdateCompanionBuilder,
          (HabitLog, $$HabitLogsTableReferences),
          HabitLog,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitLogsTableTableManager(_$AppDatabase db, $HabitLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitLogsCompanion(
                habitId: habitId,
                day: day,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required String day,
                required int value,
                Value<int> rowid = const Value.absent(),
              }) => HabitLogsCompanion.insert(
                habitId: habitId,
                day: day,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitLogsTable, HabitLog>(table),
                  $$HabitLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitLogsTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$HabitLogsTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogsTable,
      HabitLog,
      $$HabitLogsTableFilterComposer,
      $$HabitLogsTableOrderingComposer,
      $$HabitLogsTableAnnotationComposer,
      $$HabitLogsTableCreateCompanionBuilder,
      $$HabitLogsTableUpdateCompanionBuilder,
      (HabitLog, $$HabitLogsTableReferences),
      HabitLog,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  required String notes,
  Value<DateTime?> due,
  required bool hasTime,
  required int priority,
  required bool done,
  Value<DateTime?> doneAt,
  required String repeat,
  required int sortOrder,
  Value<int> durationMin,
  Value<String> kind,
  Value<int?> colorValue,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> notes,
  Value<DateTime?> due,
  Value<bool> hasTime,
  Value<int> priority,
  Value<bool> done,
  Value<DateTime?> doneAt,
  Value<String> repeat,
  Value<int> sortOrder,
  Value<int> durationMin,
  Value<String> kind,
  Value<int?> colorValue,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskRow> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubtasksTable, List<SubtaskRow>>
  _subtasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subtasks,
    aliasName: 'tasks__id__subtasks__task_id',
  );

  $$SubtasksTableProcessedTableManager get subtasksRefs {
    final manager = $$SubtasksTableTableManager(
      $_db,
      $_db.subtasks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subtasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasTime => $composableBuilder(
    column: $table.hasTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subtasksRefs(
    Expression<bool> Function($$SubtasksTableFilterComposer f) f,
  ) {
    final $$SubtasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableFilterComposer(
            $db: $db,
            $table: $db.subtasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasTime => $composableBuilder(
    column: $table.hasTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<bool> get hasTime =>
      $composableBuilder(column: $table.hasTime, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  Expression<T> subtasksRefs<T extends Object>(
    Expression<T> Function($$SubtasksTableAnnotationComposer a) f,
  ) {
    final $$SubtasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableAnnotationComposer(
            $db: $db,
            $table: $db.subtasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, $$TasksTableReferences),
          TaskRow,
          PrefetchHooks Function({bool subtasksRefs})
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<bool> hasTime = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String> repeat = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> durationMin = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                notes: notes,
                due: due,
                hasTime: hasTime,
                priority: priority,
                done: done,
                doneAt: doneAt,
                repeat: repeat,
                sortOrder: sortOrder,
                durationMin: durationMin,
                kind: kind,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String notes,
                Value<DateTime?> due = const Value.absent(),
                required bool hasTime,
                required int priority,
                required bool done,
                Value<DateTime?> doneAt = const Value.absent(),
                required String repeat,
                required int sortOrder,
                Value<int> durationMin = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                due: due,
                hasTime: hasTime,
                priority: priority,
                done: done,
                doneAt: doneAt,
                repeat: repeat,
                sortOrder: sortOrder,
                durationMin: durationMin,
                kind: kind,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TaskRow>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subtasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subtasksRefs) db.subtasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subtasksRefs)
                    await $_getPrefetchedData<TaskRow, $TasksTable, SubtaskRow>(
                      currentTable: table,
                      referencedTable: $$TasksTableReferences
                          ._subtasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TasksTableReferences(db, table, p0).subtasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, $$TasksTableReferences),
      TaskRow,
      PrefetchHooks Function({bool subtasksRefs})
    >;
typedef $$SubtasksTableCreateCompanionBuilder = SubtasksCompanion Function({
  required String taskId,
  required int position,
  required String title,
  required bool done,
  Value<int> rowid,
});
typedef $$SubtasksTableUpdateCompanionBuilder = SubtasksCompanion Function({
  Value<String> taskId,
  Value<int> position,
  Value<String> title,
  Value<bool> done,
  Value<int> rowid,
});

final class $$SubtasksTableReferences
    extends BaseReferences<_$AppDatabase, $SubtasksTable, SubtaskRow> {
  $$SubtasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('subtasks__task_id__tasks__id');

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubtasksTable,
          SubtaskRow,
          $$SubtasksTableFilterComposer,
          $$SubtasksTableOrderingComposer,
          $$SubtasksTableAnnotationComposer,
          $$SubtasksTableCreateCompanionBuilder,
          $$SubtasksTableUpdateCompanionBuilder,
          (SubtaskRow, $$SubtasksTableReferences),
          SubtaskRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion(
                taskId: taskId,
                position: position,
                title: title,
                done: done,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required int position,
                required String title,
                required bool done,
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion.insert(
                taskId: taskId,
                position: position,
                title: title,
                done: done,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubtasksTable, SubtaskRow>(table),
                  $$SubtasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$SubtasksTableReferences._taskIdTable(
                          db,
                        ),
                        referencedColumn: $$SubtasksTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubtasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubtasksTable,
      SubtaskRow,
      $$SubtasksTableFilterComposer,
      $$SubtasksTableOrderingComposer,
      $$SubtasksTableAnnotationComposer,
      $$SubtasksTableCreateCompanionBuilder,
      $$SubtasksTableUpdateCompanionBuilder,
      (SubtaskRow, $$SubtasksTableReferences),
      SubtaskRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$AvatarProfilesTableCreateCompanionBuilder =
    AvatarProfilesCompanion Function({
      Value<int> id,
      required String name,
      required String body,
      required int skin,
      required int hairColor,
      required int eyeColor,
      required int muscle,
      Value<bool> autoMuscle,
      Value<String> equipped,
      Value<int> sceneTone,
      Value<int> eyeStyle,
    });
typedef $$AvatarProfilesTableUpdateCompanionBuilder =
    AvatarProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> body,
      Value<int> skin,
      Value<int> hairColor,
      Value<int> eyeColor,
      Value<int> muscle,
      Value<bool> autoMuscle,
      Value<String> equipped,
      Value<int> sceneTone,
      Value<int> eyeStyle,
    });

class $$AvatarProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $AvatarProfilesTable> {
  $$AvatarProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skin => $composableBuilder(
    column: $table.skin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hairColor => $composableBuilder(
    column: $table.hairColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eyeColor => $composableBuilder(
    column: $table.eyeColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get muscle => $composableBuilder(
    column: $table.muscle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoMuscle => $composableBuilder(
    column: $table.autoMuscle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipped => $composableBuilder(
    column: $table.equipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sceneTone => $composableBuilder(
    column: $table.sceneTone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eyeStyle => $composableBuilder(
    column: $table.eyeStyle,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AvatarProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvatarProfilesTable> {
  $$AvatarProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skin => $composableBuilder(
    column: $table.skin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hairColor => $composableBuilder(
    column: $table.hairColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eyeColor => $composableBuilder(
    column: $table.eyeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get muscle => $composableBuilder(
    column: $table.muscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoMuscle => $composableBuilder(
    column: $table.autoMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipped => $composableBuilder(
    column: $table.equipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sceneTone => $composableBuilder(
    column: $table.sceneTone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eyeStyle => $composableBuilder(
    column: $table.eyeStyle,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AvatarProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvatarProfilesTable> {
  $$AvatarProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get skin =>
      $composableBuilder(column: $table.skin, builder: (column) => column);

  GeneratedColumn<int> get hairColor =>
      $composableBuilder(column: $table.hairColor, builder: (column) => column);

  GeneratedColumn<int> get eyeColor =>
      $composableBuilder(column: $table.eyeColor, builder: (column) => column);

  GeneratedColumn<int> get muscle =>
      $composableBuilder(column: $table.muscle, builder: (column) => column);

  GeneratedColumn<bool> get autoMuscle => $composableBuilder(
    column: $table.autoMuscle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipped =>
      $composableBuilder(column: $table.equipped, builder: (column) => column);

  GeneratedColumn<int> get sceneTone =>
      $composableBuilder(column: $table.sceneTone, builder: (column) => column);

  GeneratedColumn<int> get eyeStyle =>
      $composableBuilder(column: $table.eyeStyle, builder: (column) => column);
}

class $$AvatarProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvatarProfilesTable,
          AvatarRow,
          $$AvatarProfilesTableFilterComposer,
          $$AvatarProfilesTableOrderingComposer,
          $$AvatarProfilesTableAnnotationComposer,
          $$AvatarProfilesTableCreateCompanionBuilder,
          $$AvatarProfilesTableUpdateCompanionBuilder,
          (
            AvatarRow,
            BaseReferences<_$AppDatabase, $AvatarProfilesTable, AvatarRow>,
          ),
          AvatarRow,
          PrefetchHooks Function()
        > {
  $$AvatarProfilesTableTableManager(
    _$AppDatabase db,
    $AvatarProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvatarProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AvatarProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AvatarProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> skin = const Value.absent(),
                Value<int> hairColor = const Value.absent(),
                Value<int> eyeColor = const Value.absent(),
                Value<int> muscle = const Value.absent(),
                Value<bool> autoMuscle = const Value.absent(),
                Value<String> equipped = const Value.absent(),
                Value<int> sceneTone = const Value.absent(),
                Value<int> eyeStyle = const Value.absent(),
              }) => AvatarProfilesCompanion(
                id: id,
                name: name,
                body: body,
                skin: skin,
                hairColor: hairColor,
                eyeColor: eyeColor,
                muscle: muscle,
                autoMuscle: autoMuscle,
                equipped: equipped,
                sceneTone: sceneTone,
                eyeStyle: eyeStyle,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String body,
                required int skin,
                required int hairColor,
                required int eyeColor,
                required int muscle,
                Value<bool> autoMuscle = const Value.absent(),
                Value<String> equipped = const Value.absent(),
                Value<int> sceneTone = const Value.absent(),
                Value<int> eyeStyle = const Value.absent(),
              }) => AvatarProfilesCompanion.insert(
                id: id,
                name: name,
                body: body,
                skin: skin,
                hairColor: hairColor,
                eyeColor: eyeColor,
                muscle: muscle,
                autoMuscle: autoMuscle,
                equipped: equipped,
                sceneTone: sceneTone,
                eyeStyle: eyeStyle,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AvatarProfilesTable, AvatarRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AvatarProfilesTable,
                    AvatarRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AvatarProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvatarProfilesTable,
      AvatarRow,
      $$AvatarProfilesTableFilterComposer,
      $$AvatarProfilesTableOrderingComposer,
      $$AvatarProfilesTableAnnotationComposer,
      $$AvatarProfilesTableCreateCompanionBuilder,
      $$AvatarProfilesTableUpdateCompanionBuilder,
      (
        AvatarRow,
        BaseReferences<_$AppDatabase, $AvatarProfilesTable, AvatarRow>,
      ),
      AvatarRow,
      PrefetchHooks Function()
    >;
typedef $$CoinLedgerTableCreateCompanionBuilder = CoinLedgerCompanion Function({
  required String kind,
  required String item,
  required String day,
  required int coins,
  Value<int> stars,
  required int xp,
  Value<int> rowid,
});
typedef $$CoinLedgerTableUpdateCompanionBuilder = CoinLedgerCompanion Function({
  Value<String> kind,
  Value<String> item,
  Value<String> day,
  Value<int> coins,
  Value<int> stars,
  Value<int> xp,
  Value<int> rowid,
});

class $$CoinLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $CoinLedgerTable> {
  $$CoinLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoinLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $CoinLedgerTable> {
  $$CoinLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoinLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoinLedgerTable> {
  $$CoinLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);
}

class $$CoinLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoinLedgerTable,
          LedgerRow,
          $$CoinLedgerTableFilterComposer,
          $$CoinLedgerTableOrderingComposer,
          $$CoinLedgerTableAnnotationComposer,
          $$CoinLedgerTableCreateCompanionBuilder,
          $$CoinLedgerTableUpdateCompanionBuilder,
          (
            LedgerRow,
            BaseReferences<_$AppDatabase, $CoinLedgerTable, LedgerRow>,
          ),
          LedgerRow,
          PrefetchHooks Function()
        > {
  $$CoinLedgerTableTableManager(_$AppDatabase db, $CoinLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoinLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoinLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoinLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<String> item = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoinLedgerCompanion(
                kind: kind,
                item: item,
                day: day,
                coins: coins,
                stars: stars,
                xp: xp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required String item,
                required String day,
                required int coins,
                Value<int> stars = const Value.absent(),
                required int xp,
                Value<int> rowid = const Value.absent(),
              }) => CoinLedgerCompanion.insert(
                kind: kind,
                item: item,
                day: day,
                coins: coins,
                stars: stars,
                xp: xp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoinLedgerTable, LedgerRow>(table),
                  BaseReferences<_$AppDatabase, $CoinLedgerTable, LedgerRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoinLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoinLedgerTable,
      LedgerRow,
      $$CoinLedgerTableFilterComposer,
      $$CoinLedgerTableOrderingComposer,
      $$CoinLedgerTableAnnotationComposer,
      $$CoinLedgerTableCreateCompanionBuilder,
      $$CoinLedgerTableUpdateCompanionBuilder,
      (LedgerRow, BaseReferences<_$AppDatabase, $CoinLedgerTable, LedgerRow>),
      LedgerRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitLogsTableTableManager get habitLogs =>
      $$HabitLogsTableTableManager(_db, _db.habitLogs);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$AvatarProfilesTableTableManager get avatarProfiles =>
      $$AvatarProfilesTableTableManager(_db, _db.avatarProfiles);
  $$CoinLedgerTableTableManager get coinLedger =>
      $$CoinLedgerTableTableManager(_db, _db.coinLedger);
}
