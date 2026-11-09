// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SpaceRecordsTable extends SpaceRecords
    with TableInfo<$SpaceRecordsTable, SpaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpaceRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    position,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'space_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpaceRow> instance, {
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
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpaceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SpaceRecordsTable createAlias(String alias) {
    return $SpaceRecordsTable(attachedDatabase, alias);
  }
}

class SpaceRow extends DataClass implements Insertable<SpaceRow> {
  final String id;
  final String name;
  final int color;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const SpaceRow({
    required this.id,
    required this.name,
    required this.color,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SpaceRecordsCompanion toCompanion(bool nullToAbsent) {
    return SpaceRecordsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SpaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpaceRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SpaceRow copyWith({
    String? id,
    String? name,
    int? color,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => SpaceRow(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  SpaceRow copyWithCompanion(SpaceRecordsCompanion data) {
    return SpaceRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpaceRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, color, position, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpaceRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SpaceRecordsCompanion extends UpdateCompanion<SpaceRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SpaceRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpaceRecordsCompanion.insert({
    required String id,
    required String name,
    required int color,
    this.position = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SpaceRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpaceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? color,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SpaceRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpaceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntryRecordsTable extends EntryRecords
    with TableInfo<$EntryRecordsTable, EntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES space_records (id)',
    ),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<int> dateKey = GeneratedColumn<int>(
    'date_key',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateKeyMeta = const VerificationMeta(
    'endDateKey',
  );
  @override
  late final GeneratedColumn<int> endDateKey = GeneratedColumn<int>(
    'end_date_key',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceJsonMeta = const VerificationMeta(
    'recurrenceJson',
  );
  @override
  late final GeneratedColumn<String> recurrenceJson = GeneratedColumn<String>(
    'recurrence_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    title,
    notes,
    kind,
    dateKey,
    endDateKey,
    startMinute,
    endMinute,
    allDay,
    status,
    recurrenceJson,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
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
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    }
    if (data.containsKey('end_date_key')) {
      context.handle(
        _endDateKeyMeta,
        endDateKey.isAcceptableOrUnknown(
          data['end_date_key']!,
          _endDateKeyMeta,
        ),
      );
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recurrence_json')) {
      context.handle(
        _recurrenceJsonMeta,
        recurrenceJson.isAcceptableOrUnknown(
          data['recurrence_json']!,
          _recurrenceJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_key'],
      ),
      endDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date_key'],
      ),
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      ),
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      ),
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      recurrenceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EntryRecordsTable createAlias(String alias) {
    return $EntryRecordsTable(attachedDatabase, alias);
  }
}

class EntryRow extends DataClass implements Insertable<EntryRow> {
  final String id;
  final String spaceId;
  final String title;
  final String notes;

  /// One of [EntryKind]. Stored as text so the database stays readable.
  final String kind;

  /// Start date as `YYYYMMDD`, null when the entry is unscheduled.
  final int? dateKey;

  /// End date for multi-day entries.
  final int? endDateKey;

  /// Minutes from midnight, null for all-day entries.
  final int? startMinute;
  final int? endMinute;
  final bool allDay;

  /// One of [EntryStatus].
  final String status;

  /// Serialized [RecurrenceRule], null for one-off entries.
  final String? recurrenceJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const EntryRow({
    required this.id,
    required this.spaceId,
    required this.title,
    required this.notes,
    required this.kind,
    this.dateKey,
    this.endDateKey,
    this.startMinute,
    this.endMinute,
    required this.allDay,
    required this.status,
    this.recurrenceJson,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || dateKey != null) {
      map['date_key'] = Variable<int>(dateKey);
    }
    if (!nullToAbsent || endDateKey != null) {
      map['end_date_key'] = Variable<int>(endDateKey);
    }
    if (!nullToAbsent || startMinute != null) {
      map['start_minute'] = Variable<int>(startMinute);
    }
    if (!nullToAbsent || endMinute != null) {
      map['end_minute'] = Variable<int>(endMinute);
    }
    map['all_day'] = Variable<bool>(allDay);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || recurrenceJson != null) {
      map['recurrence_json'] = Variable<String>(recurrenceJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EntryRecordsCompanion toCompanion(bool nullToAbsent) {
    return EntryRecordsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      title: Value(title),
      notes: Value(notes),
      kind: Value(kind),
      dateKey: dateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(dateKey),
      endDateKey: endDateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateKey),
      startMinute: startMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinute),
      endMinute: endMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinute),
      allDay: Value(allDay),
      status: Value(status),
      recurrenceJson: recurrenceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryRow(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      kind: serializer.fromJson<String>(json['kind']),
      dateKey: serializer.fromJson<int?>(json['dateKey']),
      endDateKey: serializer.fromJson<int?>(json['endDateKey']),
      startMinute: serializer.fromJson<int?>(json['startMinute']),
      endMinute: serializer.fromJson<int?>(json['endMinute']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      status: serializer.fromJson<String>(json['status']),
      recurrenceJson: serializer.fromJson<String?>(json['recurrenceJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'kind': serializer.toJson<String>(kind),
      'dateKey': serializer.toJson<int?>(dateKey),
      'endDateKey': serializer.toJson<int?>(endDateKey),
      'startMinute': serializer.toJson<int?>(startMinute),
      'endMinute': serializer.toJson<int?>(endMinute),
      'allDay': serializer.toJson<bool>(allDay),
      'status': serializer.toJson<String>(status),
      'recurrenceJson': serializer.toJson<String?>(recurrenceJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EntryRow copyWith({
    String? id,
    String? spaceId,
    String? title,
    String? notes,
    String? kind,
    Value<int?> dateKey = const Value.absent(),
    Value<int?> endDateKey = const Value.absent(),
    Value<int?> startMinute = const Value.absent(),
    Value<int?> endMinute = const Value.absent(),
    bool? allDay,
    String? status,
    Value<String?> recurrenceJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EntryRow(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    kind: kind ?? this.kind,
    dateKey: dateKey.present ? dateKey.value : this.dateKey,
    endDateKey: endDateKey.present ? endDateKey.value : this.endDateKey,
    startMinute: startMinute.present ? startMinute.value : this.startMinute,
    endMinute: endMinute.present ? endMinute.value : this.endMinute,
    allDay: allDay ?? this.allDay,
    status: status ?? this.status,
    recurrenceJson: recurrenceJson.present
        ? recurrenceJson.value
        : this.recurrenceJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EntryRow copyWithCompanion(EntryRecordsCompanion data) {
    return EntryRow(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      kind: data.kind.present ? data.kind.value : this.kind,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      endDateKey: data.endDateKey.present
          ? data.endDateKey.value
          : this.endDateKey,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      status: data.status.present ? data.status.value : this.status,
      recurrenceJson: data.recurrenceJson.present
          ? data.recurrenceJson.value
          : this.recurrenceJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryRow(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('kind: $kind, ')
          ..write('dateKey: $dateKey, ')
          ..write('endDateKey: $endDateKey, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('allDay: $allDay, ')
          ..write('status: $status, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    title,
    notes,
    kind,
    dateKey,
    endDateKey,
    startMinute,
    endMinute,
    allDay,
    status,
    recurrenceJson,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryRow &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.kind == this.kind &&
          other.dateKey == this.dateKey &&
          other.endDateKey == this.endDateKey &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.allDay == this.allDay &&
          other.status == this.status &&
          other.recurrenceJson == this.recurrenceJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EntryRecordsCompanion extends UpdateCompanion<EntryRow> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<String> title;
  final Value<String> notes;
  final Value<String> kind;
  final Value<int?> dateKey;
  final Value<int?> endDateKey;
  final Value<int?> startMinute;
  final Value<int?> endMinute;
  final Value<bool> allDay;
  final Value<String> status;
  final Value<String?> recurrenceJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EntryRecordsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.kind = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.endDateKey = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.allDay = const Value.absent(),
    this.status = const Value.absent(),
    this.recurrenceJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryRecordsCompanion.insert({
    required String id,
    required String spaceId,
    required String title,
    this.notes = const Value.absent(),
    required String kind,
    this.dateKey = const Value.absent(),
    this.endDateKey = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.allDay = const Value.absent(),
    required String status,
    this.recurrenceJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       title = Value(title),
       kind = Value(kind),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EntryRow> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? kind,
    Expression<int>? dateKey,
    Expression<int>? endDateKey,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<bool>? allDay,
    Expression<String>? status,
    Expression<String>? recurrenceJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (kind != null) 'kind': kind,
      if (dateKey != null) 'date_key': dateKey,
      if (endDateKey != null) 'end_date_key': endDateKey,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (allDay != null) 'all_day': allDay,
      if (status != null) 'status': status,
      if (recurrenceJson != null) 'recurrence_json': recurrenceJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<String>? title,
    Value<String>? notes,
    Value<String>? kind,
    Value<int?>? dateKey,
    Value<int?>? endDateKey,
    Value<int?>? startMinute,
    Value<int?>? endMinute,
    Value<bool>? allDay,
    Value<String>? status,
    Value<String?>? recurrenceJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EntryRecordsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      kind: kind ?? this.kind,
      dateKey: dateKey ?? this.dateKey,
      endDateKey: endDateKey ?? this.endDateKey,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      allDay: allDay ?? this.allDay,
      status: status ?? this.status,
      recurrenceJson: recurrenceJson ?? this.recurrenceJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<int>(dateKey.value);
    }
    if (endDateKey.present) {
      map['end_date_key'] = Variable<int>(endDateKey.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recurrenceJson.present) {
      map['recurrence_json'] = Variable<String>(recurrenceJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryRecordsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('kind: $kind, ')
          ..write('dateKey: $dateKey, ')
          ..write('endDateKey: $endDateKey, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('allDay: $allDay, ')
          ..write('status: $status, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletionRecordsTable extends CompletionRecords
    with TableInfo<$CompletionRecordsTable, CompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entry_records (id)',
    ),
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<int> dateKey = GeneratedColumn<int>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, dateKey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completion_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, dateKey};
  @override
  CompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletionRow(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CompletionRecordsTable createAlias(String alias) {
    return $CompletionRecordsTable(attachedDatabase, alias);
  }
}

class CompletionRow extends DataClass implements Insertable<CompletionRow> {
  final String entryId;
  final int dateKey;
  final DateTime createdAt;
  const CompletionRow({
    required this.entryId,
    required this.dateKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<String>(entryId);
    map['date_key'] = Variable<int>(dateKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CompletionRecordsCompanion toCompanion(bool nullToAbsent) {
    return CompletionRecordsCompanion(
      entryId: Value(entryId),
      dateKey: Value(dateKey),
      createdAt: Value(createdAt),
    );
  }

  factory CompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletionRow(
      entryId: serializer.fromJson<String>(json['entryId']),
      dateKey: serializer.fromJson<int>(json['dateKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<String>(entryId),
      'dateKey': serializer.toJson<int>(dateKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CompletionRow copyWith({
    String? entryId,
    int? dateKey,
    DateTime? createdAt,
  }) => CompletionRow(
    entryId: entryId ?? this.entryId,
    dateKey: dateKey ?? this.dateKey,
    createdAt: createdAt ?? this.createdAt,
  );
  CompletionRow copyWithCompanion(CompletionRecordsCompanion data) {
    return CompletionRow(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletionRow(')
          ..write('entryId: $entryId, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, dateKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletionRow &&
          other.entryId == this.entryId &&
          other.dateKey == this.dateKey &&
          other.createdAt == this.createdAt);
}

class CompletionRecordsCompanion extends UpdateCompanion<CompletionRow> {
  final Value<String> entryId;
  final Value<int> dateKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CompletionRecordsCompanion({
    this.entryId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletionRecordsCompanion.insert({
    required String entryId,
    required int dateKey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       dateKey = Value(dateKey),
       createdAt = Value(createdAt);
  static Insertable<CompletionRow> custom({
    Expression<String>? entryId,
    Expression<int>? dateKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (dateKey != null) 'date_key': dateKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletionRecordsCompanion copyWith({
    Value<String>? entryId,
    Value<int>? dateKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CompletionRecordsCompanion(
      entryId: entryId ?? this.entryId,
      dateKey: dateKey ?? this.dateKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<int>(dateKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionRecordsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderRecordsTable extends ReminderRecords
    with TableInfo<$ReminderRecordsTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES entry_records (id)',
    ),
  );
  static const VerificationMeta _offsetMinutesMeta = const VerificationMeta(
    'offsetMinutes',
  );
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
    'offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, offsetMinutes, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
        _offsetMinutesMeta,
        offsetMinutes.isAcceptableOrUnknown(
          data['offset_minutes']!,
          _offsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offsetMinutesMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      offsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_minutes'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ReminderRecordsTable createAlias(String alias) {
    return $ReminderRecordsTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String entryId;
  final int offsetMinutes;
  final bool enabled;
  const ReminderRow({
    required this.id,
    required this.entryId,
    required this.offsetMinutes,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['offset_minutes'] = Variable<int>(offsetMinutes);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ReminderRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReminderRecordsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      offsetMinutes: Value(offsetMinutes),
      enabled: Value(enabled),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      offsetMinutes: serializer.fromJson<int>(json['offsetMinutes']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'offsetMinutes': serializer.toJson<int>(offsetMinutes),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? entryId,
    int? offsetMinutes,
    bool? enabled,
  }) => ReminderRow(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    enabled: enabled ?? this.enabled,
  );
  ReminderRow copyWithCompanion(ReminderRecordsCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryId, offsetMinutes, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.offsetMinutes == this.offsetMinutes &&
          other.enabled == this.enabled);
}

class ReminderRecordsCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<int> offsetMinutes;
  final Value<bool> enabled;
  final Value<int> rowid;
  const ReminderRecordsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderRecordsCompanion.insert({
    required String id,
    required String entryId,
    required int offsetMinutes,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       offsetMinutes = Value(offsetMinutes);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<int>? offsetMinutes,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<int>? offsetMinutes,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return ReminderRecordsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRecordsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftPatternRecordsTable extends ShiftPatternRecords
    with TableInfo<$ShiftPatternRecordsTable, ShiftPatternRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftPatternRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES space_records (id)',
    ),
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
  static const VerificationMeta _cycleDaysMeta = const VerificationMeta(
    'cycleDays',
  );
  @override
  late final GeneratedColumn<int> cycleDays = GeneratedColumn<int>(
    'cycle_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDateKeyMeta = const VerificationMeta(
    'anchorDateKey',
  );
  @override
  late final GeneratedColumn<int> anchorDateKey = GeneratedColumn<int>(
    'anchor_date_key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotsJsonMeta = const VerificationMeta(
    'slotsJson',
  );
  @override
  late final GeneratedColumn<String> slotsJson = GeneratedColumn<String>(
    'slots_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    name,
    cycleDays,
    anchorDateKey,
    slotsJson,
    enabled,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_pattern_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftPatternRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cycle_days')) {
      context.handle(
        _cycleDaysMeta,
        cycleDays.isAcceptableOrUnknown(data['cycle_days']!, _cycleDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleDaysMeta);
    }
    if (data.containsKey('anchor_date_key')) {
      context.handle(
        _anchorDateKeyMeta,
        anchorDateKey.isAcceptableOrUnknown(
          data['anchor_date_key']!,
          _anchorDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anchorDateKeyMeta);
    }
    if (data.containsKey('slots_json')) {
      context.handle(
        _slotsJsonMeta,
        slotsJson.isAcceptableOrUnknown(data['slots_json']!, _slotsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_slotsJsonMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftPatternRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftPatternRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cycleDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_days'],
      )!,
      anchorDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor_date_key'],
      )!,
      slotsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slots_json'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ShiftPatternRecordsTable createAlias(String alias) {
    return $ShiftPatternRecordsTable(attachedDatabase, alias);
  }
}

class ShiftPatternRow extends DataClass implements Insertable<ShiftPatternRow> {
  final String id;
  final String spaceId;
  final String name;
  final int cycleDays;
  final int anchorDateKey;

  /// Serialized list of [ShiftSlot].
  final String slotsJson;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ShiftPatternRow({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.cycleDays,
    required this.anchorDateKey,
    required this.slotsJson,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['name'] = Variable<String>(name);
    map['cycle_days'] = Variable<int>(cycleDays);
    map['anchor_date_key'] = Variable<int>(anchorDateKey);
    map['slots_json'] = Variable<String>(slotsJson);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ShiftPatternRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftPatternRecordsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      name: Value(name),
      cycleDays: Value(cycleDays),
      anchorDateKey: Value(anchorDateKey),
      slotsJson: Value(slotsJson),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ShiftPatternRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftPatternRow(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      name: serializer.fromJson<String>(json['name']),
      cycleDays: serializer.fromJson<int>(json['cycleDays']),
      anchorDateKey: serializer.fromJson<int>(json['anchorDateKey']),
      slotsJson: serializer.fromJson<String>(json['slotsJson']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'name': serializer.toJson<String>(name),
      'cycleDays': serializer.toJson<int>(cycleDays),
      'anchorDateKey': serializer.toJson<int>(anchorDateKey),
      'slotsJson': serializer.toJson<String>(slotsJson),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ShiftPatternRow copyWith({
    String? id,
    String? spaceId,
    String? name,
    int? cycleDays,
    int? anchorDateKey,
    String? slotsJson,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ShiftPatternRow(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    name: name ?? this.name,
    cycleDays: cycleDays ?? this.cycleDays,
    anchorDateKey: anchorDateKey ?? this.anchorDateKey,
    slotsJson: slotsJson ?? this.slotsJson,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ShiftPatternRow copyWithCompanion(ShiftPatternRecordsCompanion data) {
    return ShiftPatternRow(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      name: data.name.present ? data.name.value : this.name,
      cycleDays: data.cycleDays.present ? data.cycleDays.value : this.cycleDays,
      anchorDateKey: data.anchorDateKey.present
          ? data.anchorDateKey.value
          : this.anchorDateKey,
      slotsJson: data.slotsJson.present ? data.slotsJson.value : this.slotsJson,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternRow(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('name: $name, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('anchorDateKey: $anchorDateKey, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    name,
    cycleDays,
    anchorDateKey,
    slotsJson,
    enabled,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftPatternRow &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.name == this.name &&
          other.cycleDays == this.cycleDays &&
          other.anchorDateKey == this.anchorDateKey &&
          other.slotsJson == this.slotsJson &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShiftPatternRecordsCompanion extends UpdateCompanion<ShiftPatternRow> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<String> name;
  final Value<int> cycleDays;
  final Value<int> anchorDateKey;
  final Value<String> slotsJson;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShiftPatternRecordsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.name = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.anchorDateKey = const Value.absent(),
    this.slotsJson = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftPatternRecordsCompanion.insert({
    required String id,
    required String spaceId,
    required String name,
    required int cycleDays,
    required int anchorDateKey,
    required String slotsJson,
    this.enabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       name = Value(name),
       cycleDays = Value(cycleDays),
       anchorDateKey = Value(anchorDateKey),
       slotsJson = Value(slotsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShiftPatternRow> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<String>? name,
    Expression<int>? cycleDays,
    Expression<int>? anchorDateKey,
    Expression<String>? slotsJson,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (name != null) 'name': name,
      if (cycleDays != null) 'cycle_days': cycleDays,
      if (anchorDateKey != null) 'anchor_date_key': anchorDateKey,
      if (slotsJson != null) 'slots_json': slotsJson,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftPatternRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<String>? name,
    Value<int>? cycleDays,
    Value<int>? anchorDateKey,
    Value<String>? slotsJson,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ShiftPatternRecordsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      name: name ?? this.name,
      cycleDays: cycleDays ?? this.cycleDays,
      anchorDateKey: anchorDateKey ?? this.anchorDateKey,
      slotsJson: slotsJson ?? this.slotsJson,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cycleDays.present) {
      map['cycle_days'] = Variable<int>(cycleDays.value);
    }
    if (anchorDateKey.present) {
      map['anchor_date_key'] = Variable<int>(anchorDateKey.value);
    }
    if (slotsJson.present) {
      map['slots_json'] = Variable<String>(slotsJson.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternRecordsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('name: $name, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('anchorDateKey: $anchorDateKey, ')
          ..write('slotsJson: $slotsJson, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingRecordsTable extends SettingRecords
    with TableInfo<$SettingRecordsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingRecordsTable createAlias(String alias) {
    return $SettingRecordsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingRecordsCompanion toCompanion(bool nullToAbsent) {
    return SettingRecordsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingRecordsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingRecordsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingRecordsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingRecordsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingRecordsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingRecordsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingRecordsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SpaceRecordsTable spaceRecords = $SpaceRecordsTable(this);
  late final $EntryRecordsTable entryRecords = $EntryRecordsTable(this);
  late final $CompletionRecordsTable completionRecords =
      $CompletionRecordsTable(this);
  late final $ReminderRecordsTable reminderRecords = $ReminderRecordsTable(
    this,
  );
  late final $ShiftPatternRecordsTable shiftPatternRecords =
      $ShiftPatternRecordsTable(this);
  late final $SettingRecordsTable settingRecords = $SettingRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    spaceRecords,
    entryRecords,
    completionRecords,
    reminderRecords,
    shiftPatternRecords,
    settingRecords,
  ];
}

typedef $$SpaceRecordsTableCreateCompanionBuilder =
    SpaceRecordsCompanion Function({
      required String id,
      required String name,
      required int color,
      Value<int> position,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$SpaceRecordsTableUpdateCompanionBuilder =
    SpaceRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> color,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$SpaceRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $SpaceRecordsTable, SpaceRow> {
  $$SpaceRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntryRecordsTable, List<EntryRow>>
  _entryRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entryRecords,
    aliasName: $_aliasNameGenerator(
      db.spaceRecords.id,
      db.entryRecords.spaceId,
    ),
  );

  $$EntryRecordsTableProcessedTableManager get entryRecordsRefs {
    final manager = $$EntryRecordsTableTableManager(
      $_db,
      $_db.entryRecords,
    ).filter((f) => f.spaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entryRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShiftPatternRecordsTable, List<ShiftPatternRow>>
  _shiftPatternRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternRecords,
        aliasName: $_aliasNameGenerator(
          db.spaceRecords.id,
          db.shiftPatternRecords.spaceId,
        ),
      );

  $$ShiftPatternRecordsTableProcessedTableManager get shiftPatternRecordsRefs {
    final manager = $$ShiftPatternRecordsTableTableManager(
      $_db,
      $_db.shiftPatternRecords,
    ).filter((f) => f.spaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SpaceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SpaceRecordsTable> {
  $$SpaceRecordsTableFilterComposer({
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

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entryRecordsRefs(
    Expression<bool> Function($$EntryRecordsTableFilterComposer f) f,
  ) {
    final $$EntryRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableFilterComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shiftPatternRecordsRefs(
    Expression<bool> Function($$ShiftPatternRecordsTableFilterComposer f) f,
  ) {
    final $$ShiftPatternRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftPatternRecords,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftPatternRecordsTableFilterComposer(
            $db: $db,
            $table: $db.shiftPatternRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpaceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpaceRecordsTable> {
  $$SpaceRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpaceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpaceRecordsTable> {
  $$SpaceRecordsTableAnnotationComposer({
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

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> entryRecordsRefs<T extends Object>(
    Expression<T> Function($$EntryRecordsTableAnnotationComposer a) f,
  ) {
    final $$EntryRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shiftPatternRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShiftPatternRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.spaceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SpaceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpaceRecordsTable,
          SpaceRow,
          $$SpaceRecordsTableFilterComposer,
          $$SpaceRecordsTableOrderingComposer,
          $$SpaceRecordsTableAnnotationComposer,
          $$SpaceRecordsTableCreateCompanionBuilder,
          $$SpaceRecordsTableUpdateCompanionBuilder,
          (SpaceRow, $$SpaceRecordsTableReferences),
          SpaceRow,
          PrefetchHooks Function({
            bool entryRecordsRefs,
            bool shiftPatternRecordsRefs,
          })
        > {
  $$SpaceRecordsTableTableManager(_$AppDatabase db, $SpaceRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpaceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpaceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpaceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpaceRecordsCompanion(
                id: id,
                name: name,
                color: color,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int color,
                Value<int> position = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpaceRecordsCompanion.insert(
                id: id,
                name: name,
                color: color,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpaceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({entryRecordsRefs = false, shiftPatternRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entryRecordsRefs) db.entryRecords,
                    if (shiftPatternRecordsRefs) db.shiftPatternRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (entryRecordsRefs)
                        await $_getPrefetchedData<
                          SpaceRow,
                          $SpaceRecordsTable,
                          EntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$SpaceRecordsTableReferences
                              ._entryRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpaceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).entryRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.spaceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftPatternRecordsRefs)
                        await $_getPrefetchedData<
                          SpaceRow,
                          $SpaceRecordsTable,
                          ShiftPatternRow
                        >(
                          currentTable: table,
                          referencedTable: $$SpaceRecordsTableReferences
                              ._shiftPatternRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpaceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.spaceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SpaceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpaceRecordsTable,
      SpaceRow,
      $$SpaceRecordsTableFilterComposer,
      $$SpaceRecordsTableOrderingComposer,
      $$SpaceRecordsTableAnnotationComposer,
      $$SpaceRecordsTableCreateCompanionBuilder,
      $$SpaceRecordsTableUpdateCompanionBuilder,
      (SpaceRow, $$SpaceRecordsTableReferences),
      SpaceRow,
      PrefetchHooks Function({
        bool entryRecordsRefs,
        bool shiftPatternRecordsRefs,
      })
    >;
typedef $$EntryRecordsTableCreateCompanionBuilder =
    EntryRecordsCompanion Function({
      required String id,
      required String spaceId,
      required String title,
      Value<String> notes,
      required String kind,
      Value<int?> dateKey,
      Value<int?> endDateKey,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<bool> allDay,
      required String status,
      Value<String?> recurrenceJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EntryRecordsTableUpdateCompanionBuilder =
    EntryRecordsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<String> title,
      Value<String> notes,
      Value<String> kind,
      Value<int?> dateKey,
      Value<int?> endDateKey,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<bool> allDay,
      Value<String> status,
      Value<String?> recurrenceJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$EntryRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $EntryRecordsTable, EntryRow> {
  $$EntryRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpaceRecordsTable _spaceIdTable(_$AppDatabase db) =>
      db.spaceRecords.createAlias(
        $_aliasNameGenerator(db.entryRecords.spaceId, db.spaceRecords.id),
      );

  $$SpaceRecordsTableProcessedTableManager get spaceId {
    final $_column = $_itemColumn<String>('space_id')!;

    final manager = $$SpaceRecordsTableTableManager(
      $_db,
      $_db.spaceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_spaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CompletionRecordsTable, List<CompletionRow>>
  _completionRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.completionRecords,
        aliasName: $_aliasNameGenerator(
          db.entryRecords.id,
          db.completionRecords.entryId,
        ),
      );

  $$CompletionRecordsTableProcessedTableManager get completionRecordsRefs {
    final manager = $$CompletionRecordsTableTableManager(
      $_db,
      $_db.completionRecords,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _completionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReminderRecordsTable, List<ReminderRow>>
  _reminderRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderRecords,
    aliasName: $_aliasNameGenerator(
      db.entryRecords.id,
      db.reminderRecords.entryId,
    ),
  );

  $$ReminderRecordsTableProcessedTableManager get reminderRecordsRefs {
    final manager = $$ReminderRecordsTableTableManager(
      $_db,
      $_db.reminderRecords,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reminderRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EntryRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $EntryRecordsTable> {
  $$EntryRecordsTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDateKey => $composableBuilder(
    column: $table.endDateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SpaceRecordsTableFilterComposer get spaceId {
    final $$SpaceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> completionRecordsRefs(
    Expression<bool> Function($$CompletionRecordsTableFilterComposer f) f,
  ) {
    final $$CompletionRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completionRecords,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionRecordsTableFilterComposer(
            $db: $db,
            $table: $db.completionRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reminderRecordsRefs(
    Expression<bool> Function($$ReminderRecordsTableFilterComposer f) f,
  ) {
    final $$ReminderRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderRecords,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRecordsTableFilterComposer(
            $db: $db,
            $table: $db.reminderRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntryRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntryRecordsTable> {
  $$EntryRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDateKey => $composableBuilder(
    column: $table.endDateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpaceRecordsTableOrderingComposer get spaceId {
    final $$SpaceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntryRecordsTable> {
  $$EntryRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get endDateKey => $composableBuilder(
    column: $table.endDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$SpaceRecordsTableAnnotationComposer get spaceId {
    final $$SpaceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> completionRecordsRefs<T extends Object>(
    Expression<T> Function($$CompletionRecordsTableAnnotationComposer a) f,
  ) {
    final $$CompletionRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.completionRecords,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletionRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.completionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reminderRecordsRefs<T extends Object>(
    Expression<T> Function($$ReminderRecordsTableAnnotationComposer a) f,
  ) {
    final $$ReminderRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderRecords,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EntryRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntryRecordsTable,
          EntryRow,
          $$EntryRecordsTableFilterComposer,
          $$EntryRecordsTableOrderingComposer,
          $$EntryRecordsTableAnnotationComposer,
          $$EntryRecordsTableCreateCompanionBuilder,
          $$EntryRecordsTableUpdateCompanionBuilder,
          (EntryRow, $$EntryRecordsTableReferences),
          EntryRow,
          PrefetchHooks Function({
            bool spaceId,
            bool completionRecordsRefs,
            bool reminderRecordsRefs,
          })
        > {
  $$EntryRecordsTableTableManager(_$AppDatabase db, $EntryRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntryRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> dateKey = const Value.absent(),
                Value<int?> endDateKey = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> recurrenceJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryRecordsCompanion(
                id: id,
                spaceId: spaceId,
                title: title,
                notes: notes,
                kind: kind,
                dateKey: dateKey,
                endDateKey: endDateKey,
                startMinute: startMinute,
                endMinute: endMinute,
                allDay: allDay,
                status: status,
                recurrenceJson: recurrenceJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required String title,
                Value<String> notes = const Value.absent(),
                required String kind,
                Value<int?> dateKey = const Value.absent(),
                Value<int?> endDateKey = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                required String status,
                Value<String?> recurrenceJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryRecordsCompanion.insert(
                id: id,
                spaceId: spaceId,
                title: title,
                notes: notes,
                kind: kind,
                dateKey: dateKey,
                endDateKey: endDateKey,
                startMinute: startMinute,
                endMinute: endMinute,
                allDay: allDay,
                status: status,
                recurrenceJson: recurrenceJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntryRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                spaceId = false,
                completionRecordsRefs = false,
                reminderRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (completionRecordsRefs) db.completionRecords,
                    if (reminderRecordsRefs) db.reminderRecords,
                  ],
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
                        if (spaceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.spaceId,
                                    referencedTable:
                                        $$EntryRecordsTableReferences
                                            ._spaceIdTable(db),
                                    referencedColumn:
                                        $$EntryRecordsTableReferences
                                            ._spaceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (completionRecordsRefs)
                        await $_getPrefetchedData<
                          EntryRow,
                          $EntryRecordsTable,
                          CompletionRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntryRecordsTableReferences
                              ._completionRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntryRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).completionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reminderRecordsRefs)
                        await $_getPrefetchedData<
                          EntryRow,
                          $EntryRecordsTable,
                          ReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntryRecordsTableReferences
                              ._reminderRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntryRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EntryRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntryRecordsTable,
      EntryRow,
      $$EntryRecordsTableFilterComposer,
      $$EntryRecordsTableOrderingComposer,
      $$EntryRecordsTableAnnotationComposer,
      $$EntryRecordsTableCreateCompanionBuilder,
      $$EntryRecordsTableUpdateCompanionBuilder,
      (EntryRow, $$EntryRecordsTableReferences),
      EntryRow,
      PrefetchHooks Function({
        bool spaceId,
        bool completionRecordsRefs,
        bool reminderRecordsRefs,
      })
    >;
typedef $$CompletionRecordsTableCreateCompanionBuilder =
    CompletionRecordsCompanion Function({
      required String entryId,
      required int dateKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CompletionRecordsTableUpdateCompanionBuilder =
    CompletionRecordsCompanion Function({
      Value<String> entryId,
      Value<int> dateKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CompletionRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CompletionRecordsTable, CompletionRow> {
  $$CompletionRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EntryRecordsTable _entryIdTable(_$AppDatabase db) =>
      db.entryRecords.createAlias(
        $_aliasNameGenerator(db.completionRecords.entryId, db.entryRecords.id),
      );

  $$EntryRecordsTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$EntryRecordsTableTableManager(
      $_db,
      $_db.entryRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionRecordsTable> {
  $$CompletionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EntryRecordsTableFilterComposer get entryId {
    final $$EntryRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableFilterComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionRecordsTable> {
  $$CompletionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntryRecordsTableOrderingComposer get entryId {
    final $$EntryRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionRecordsTable> {
  $$CompletionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EntryRecordsTableAnnotationComposer get entryId {
    final $$EntryRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletionRecordsTable,
          CompletionRow,
          $$CompletionRecordsTableFilterComposer,
          $$CompletionRecordsTableOrderingComposer,
          $$CompletionRecordsTableAnnotationComposer,
          $$CompletionRecordsTableCreateCompanionBuilder,
          $$CompletionRecordsTableUpdateCompanionBuilder,
          (CompletionRow, $$CompletionRecordsTableReferences),
          CompletionRow,
          PrefetchHooks Function({bool entryId})
        > {
  $$CompletionRecordsTableTableManager(
    _$AppDatabase db,
    $CompletionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> entryId = const Value.absent(),
                Value<int> dateKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletionRecordsCompanion(
                entryId: entryId,
                dateKey: dateKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entryId,
                required int dateKey,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CompletionRecordsCompanion.insert(
                entryId: entryId,
                dateKey: dateKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompletionRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
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
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable:
                                    $$CompletionRecordsTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$CompletionRecordsTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$CompletionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletionRecordsTable,
      CompletionRow,
      $$CompletionRecordsTableFilterComposer,
      $$CompletionRecordsTableOrderingComposer,
      $$CompletionRecordsTableAnnotationComposer,
      $$CompletionRecordsTableCreateCompanionBuilder,
      $$CompletionRecordsTableUpdateCompanionBuilder,
      (CompletionRow, $$CompletionRecordsTableReferences),
      CompletionRow,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$ReminderRecordsTableCreateCompanionBuilder =
    ReminderRecordsCompanion Function({
      required String id,
      required String entryId,
      required int offsetMinutes,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$ReminderRecordsTableUpdateCompanionBuilder =
    ReminderRecordsCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<int> offsetMinutes,
      Value<bool> enabled,
      Value<int> rowid,
    });

final class $$ReminderRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderRecordsTable, ReminderRow> {
  $$ReminderRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EntryRecordsTable _entryIdTable(_$AppDatabase db) =>
      db.entryRecords.createAlias(
        $_aliasNameGenerator(db.reminderRecords.entryId, db.entryRecords.id),
      );

  $$EntryRecordsTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$EntryRecordsTableTableManager(
      $_db,
      $_db.entryRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReminderRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderRecordsTable> {
  $$ReminderRecordsTableFilterComposer({
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

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$EntryRecordsTableFilterComposer get entryId {
    final $$EntryRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableFilterComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderRecordsTable> {
  $$ReminderRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$EntryRecordsTableOrderingComposer get entryId {
    final $$EntryRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderRecordsTable> {
  $$ReminderRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$EntryRecordsTableAnnotationComposer get entryId {
    final $$EntryRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.entryRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.entryRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReminderRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderRecordsTable,
          ReminderRow,
          $$ReminderRecordsTableFilterComposer,
          $$ReminderRecordsTableOrderingComposer,
          $$ReminderRecordsTableAnnotationComposer,
          $$ReminderRecordsTableCreateCompanionBuilder,
          $$ReminderRecordsTableUpdateCompanionBuilder,
          (ReminderRow, $$ReminderRecordsTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool entryId})
        > {
  $$ReminderRecordsTableTableManager(
    _$AppDatabase db,
    $ReminderRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<int> offsetMinutes = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRecordsCompanion(
                id: id,
                entryId: entryId,
                offsetMinutes: offsetMinutes,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entryId,
                required int offsetMinutes,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderRecordsCompanion.insert(
                id: id,
                entryId: entryId,
                offsetMinutes: offsetMinutes,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReminderRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
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
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable:
                                    $$ReminderRecordsTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$ReminderRecordsTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$ReminderRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderRecordsTable,
      ReminderRow,
      $$ReminderRecordsTableFilterComposer,
      $$ReminderRecordsTableOrderingComposer,
      $$ReminderRecordsTableAnnotationComposer,
      $$ReminderRecordsTableCreateCompanionBuilder,
      $$ReminderRecordsTableUpdateCompanionBuilder,
      (ReminderRow, $$ReminderRecordsTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$ShiftPatternRecordsTableCreateCompanionBuilder =
    ShiftPatternRecordsCompanion Function({
      required String id,
      required String spaceId,
      required String name,
      required int cycleDays,
      required int anchorDateKey,
      required String slotsJson,
      Value<bool> enabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ShiftPatternRecordsTableUpdateCompanionBuilder =
    ShiftPatternRecordsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<String> name,
      Value<int> cycleDays,
      Value<int> anchorDateKey,
      Value<String> slotsJson,
      Value<bool> enabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ShiftPatternRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftPatternRecordsTable,
          ShiftPatternRow
        > {
  $$ShiftPatternRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SpaceRecordsTable _spaceIdTable(_$AppDatabase db) =>
      db.spaceRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftPatternRecords.spaceId,
          db.spaceRecords.id,
        ),
      );

  $$SpaceRecordsTableProcessedTableManager get spaceId {
    final $_column = $_itemColumn<String>('space_id')!;

    final manager = $$SpaceRecordsTableTableManager(
      $_db,
      $_db.spaceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_spaceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftPatternRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftPatternRecordsTable> {
  $$ShiftPatternRecordsTableFilterComposer({
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

  ColumnFilters<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anchorDateKey => $composableBuilder(
    column: $table.anchorDateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SpaceRecordsTableFilterComposer get spaceId {
    final $$SpaceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftPatternRecordsTable> {
  $$ShiftPatternRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anchorDateKey => $composableBuilder(
    column: $table.anchorDateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotsJson => $composableBuilder(
    column: $table.slotsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpaceRecordsTableOrderingComposer get spaceId {
    final $$SpaceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftPatternRecordsTable> {
  $$ShiftPatternRecordsTableAnnotationComposer({
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

  GeneratedColumn<int> get cycleDays =>
      $composableBuilder(column: $table.cycleDays, builder: (column) => column);

  GeneratedColumn<int> get anchorDateKey => $composableBuilder(
    column: $table.anchorDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slotsJson =>
      $composableBuilder(column: $table.slotsJson, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$SpaceRecordsTableAnnotationComposer get spaceId {
    final $$SpaceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.spaceId,
      referencedTable: $db.spaceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpaceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.spaceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftPatternRecordsTable,
          ShiftPatternRow,
          $$ShiftPatternRecordsTableFilterComposer,
          $$ShiftPatternRecordsTableOrderingComposer,
          $$ShiftPatternRecordsTableAnnotationComposer,
          $$ShiftPatternRecordsTableCreateCompanionBuilder,
          $$ShiftPatternRecordsTableUpdateCompanionBuilder,
          (ShiftPatternRow, $$ShiftPatternRecordsTableReferences),
          ShiftPatternRow,
          PrefetchHooks Function({bool spaceId})
        > {
  $$ShiftPatternRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftPatternRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftPatternRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftPatternRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftPatternRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> cycleDays = const Value.absent(),
                Value<int> anchorDateKey = const Value.absent(),
                Value<String> slotsJson = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternRecordsCompanion(
                id: id,
                spaceId: spaceId,
                name: name,
                cycleDays: cycleDays,
                anchorDateKey: anchorDateKey,
                slotsJson: slotsJson,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required String name,
                required int cycleDays,
                required int anchorDateKey,
                required String slotsJson,
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternRecordsCompanion.insert(
                id: id,
                spaceId: spaceId,
                name: name,
                cycleDays: cycleDays,
                anchorDateKey: anchorDateKey,
                slotsJson: slotsJson,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftPatternRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({spaceId = false}) {
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
                    if (spaceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.spaceId,
                                referencedTable:
                                    $$ShiftPatternRecordsTableReferences
                                        ._spaceIdTable(db),
                                referencedColumn:
                                    $$ShiftPatternRecordsTableReferences
                                        ._spaceIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$ShiftPatternRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftPatternRecordsTable,
      ShiftPatternRow,
      $$ShiftPatternRecordsTableFilterComposer,
      $$ShiftPatternRecordsTableOrderingComposer,
      $$ShiftPatternRecordsTableAnnotationComposer,
      $$ShiftPatternRecordsTableCreateCompanionBuilder,
      $$ShiftPatternRecordsTableUpdateCompanionBuilder,
      (ShiftPatternRow, $$ShiftPatternRecordsTableReferences),
      ShiftPatternRow,
      PrefetchHooks Function({bool spaceId})
    >;
typedef $$SettingRecordsTableCreateCompanionBuilder =
    SettingRecordsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingRecordsTableUpdateCompanionBuilder =
    SettingRecordsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingRecordsTable> {
  $$SettingRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingRecordsTable> {
  $$SettingRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingRecordsTable> {
  $$SettingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingRecordsTable,
          SettingRow,
          $$SettingRecordsTableFilterComposer,
          $$SettingRecordsTableOrderingComposer,
          $$SettingRecordsTableAnnotationComposer,
          $$SettingRecordsTableCreateCompanionBuilder,
          $$SettingRecordsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingRecordsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingRecordsTableTableManager(
    _$AppDatabase db,
    $SettingRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SettingRecordsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingRecordsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingRecordsTable,
      SettingRow,
      $$SettingRecordsTableFilterComposer,
      $$SettingRecordsTableOrderingComposer,
      $$SettingRecordsTableAnnotationComposer,
      $$SettingRecordsTableCreateCompanionBuilder,
      $$SettingRecordsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $SettingRecordsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpaceRecordsTableTableManager get spaceRecords =>
      $$SpaceRecordsTableTableManager(_db, _db.spaceRecords);
  $$EntryRecordsTableTableManager get entryRecords =>
      $$EntryRecordsTableTableManager(_db, _db.entryRecords);
  $$CompletionRecordsTableTableManager get completionRecords =>
      $$CompletionRecordsTableTableManager(_db, _db.completionRecords);
  $$ReminderRecordsTableTableManager get reminderRecords =>
      $$ReminderRecordsTableTableManager(_db, _db.reminderRecords);
  $$ShiftPatternRecordsTableTableManager get shiftPatternRecords =>
      $$ShiftPatternRecordsTableTableManager(_db, _db.shiftPatternRecords);
  $$SettingRecordsTableTableManager get settingRecords =>
      $$SettingRecordsTableTableManager(_db, _db.settingRecords);
}
