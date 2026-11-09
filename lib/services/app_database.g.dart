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
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readOnlyMeta = const VerificationMeta(
    'readOnly',
  );
  @override
  late final GeneratedColumn<bool> readOnly = GeneratedColumn<bool>(
    'read_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastCompletedAtMeta = const VerificationMeta(
    'lastCompletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedAt =
      GeneratedColumn<DateTime>(
        'last_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _repeatAfterCompletionDaysMeta =
      const VerificationMeta('repeatAfterCompletionDays');
  @override
  late final GeneratedColumn<int> repeatAfterCompletionDays =
      GeneratedColumn<int>(
        'repeat_after_completion_days',
        aliasedName,
        true,
        type: DriftSqlType.int,
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
    timeZone,
    startAt,
    endAt,
    allDay,
    status,
    recurrenceJson,
    source,
    externalId,
    readOnly,
    lastCompletedAt,
    repeatAfterCompletionDays,
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
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
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
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('read_only')) {
      context.handle(
        _readOnlyMeta,
        readOnly.isAcceptableOrUnknown(data['read_only']!, _readOnlyMeta),
      );
    }
    if (data.containsKey('last_completed_at')) {
      context.handle(
        _lastCompletedAtMeta,
        lastCompletedAt.isAcceptableOrUnknown(
          data['last_completed_at']!,
          _lastCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('repeat_after_completion_days')) {
      context.handle(
        _repeatAfterCompletionDaysMeta,
        repeatAfterCompletionDays.isAcceptableOrUnknown(
          data['repeat_after_completion_days']!,
          _repeatAfterCompletionDaysMeta,
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
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
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
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      readOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read_only'],
      )!,
      lastCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_at'],
      ),
      repeatAfterCompletionDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_after_completion_days'],
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

  /// Anchor date as `YYYYMMDD`, in [timeZone] for timed entries.
  final int? dateKey;

  /// End date for multi-day all-day entries.
  final int? endDateKey;

  /// Local minutes from midnight, null for all-day entries. An end of 1440 or
  /// more means the entry crosses midnight.
  final int? startMinute;
  final int? endMinute;

  /// IANA timezone for the wall-clock fields, null for all-day entries.
  final String? timeZone;

  /// Resolved anchor instants in UTC, null for all-day entries.
  final DateTime? startAt;
  final DateTime? endAt;
  final bool allDay;

  /// One of [EntryStatus].
  final String status;

  /// Serialized [RecurrenceRule], null for one-off entries.
  final String? recurrenceJson;

  /// Import source such as `ics`, null for user entries.
  final String? source;
  final String? externalId;
  final bool readOnly;
  final DateTime? lastCompletedAt;
  final int? repeatAfterCompletionDays;
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
    this.timeZone,
    this.startAt,
    this.endAt,
    required this.allDay,
    required this.status,
    this.recurrenceJson,
    this.source,
    this.externalId,
    required this.readOnly,
    this.lastCompletedAt,
    this.repeatAfterCompletionDays,
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
    if (!nullToAbsent || timeZone != null) {
      map['time_zone'] = Variable<String>(timeZone);
    }
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    map['all_day'] = Variable<bool>(allDay);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || recurrenceJson != null) {
      map['recurrence_json'] = Variable<String>(recurrenceJson);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['read_only'] = Variable<bool>(readOnly);
    if (!nullToAbsent || lastCompletedAt != null) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt);
    }
    if (!nullToAbsent || repeatAfterCompletionDays != null) {
      map['repeat_after_completion_days'] = Variable<int>(
        repeatAfterCompletionDays,
      );
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
      timeZone: timeZone == null && nullToAbsent
          ? const Value.absent()
          : Value(timeZone),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      allDay: Value(allDay),
      status: Value(status),
      recurrenceJson: recurrenceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceJson),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      readOnly: Value(readOnly),
      lastCompletedAt: lastCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAt),
      repeatAfterCompletionDays:
          repeatAfterCompletionDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatAfterCompletionDays),
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
      timeZone: serializer.fromJson<String?>(json['timeZone']),
      startAt: serializer.fromJson<DateTime?>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      status: serializer.fromJson<String>(json['status']),
      recurrenceJson: serializer.fromJson<String?>(json['recurrenceJson']),
      source: serializer.fromJson<String?>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      readOnly: serializer.fromJson<bool>(json['readOnly']),
      lastCompletedAt: serializer.fromJson<DateTime?>(json['lastCompletedAt']),
      repeatAfterCompletionDays: serializer.fromJson<int?>(
        json['repeatAfterCompletionDays'],
      ),
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
      'timeZone': serializer.toJson<String?>(timeZone),
      'startAt': serializer.toJson<DateTime?>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'allDay': serializer.toJson<bool>(allDay),
      'status': serializer.toJson<String>(status),
      'recurrenceJson': serializer.toJson<String?>(recurrenceJson),
      'source': serializer.toJson<String?>(source),
      'externalId': serializer.toJson<String?>(externalId),
      'readOnly': serializer.toJson<bool>(readOnly),
      'lastCompletedAt': serializer.toJson<DateTime?>(lastCompletedAt),
      'repeatAfterCompletionDays': serializer.toJson<int?>(
        repeatAfterCompletionDays,
      ),
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
    Value<String?> timeZone = const Value.absent(),
    Value<DateTime?> startAt = const Value.absent(),
    Value<DateTime?> endAt = const Value.absent(),
    bool? allDay,
    String? status,
    Value<String?> recurrenceJson = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    bool? readOnly,
    Value<DateTime?> lastCompletedAt = const Value.absent(),
    Value<int?> repeatAfterCompletionDays = const Value.absent(),
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
    timeZone: timeZone.present ? timeZone.value : this.timeZone,
    startAt: startAt.present ? startAt.value : this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    allDay: allDay ?? this.allDay,
    status: status ?? this.status,
    recurrenceJson: recurrenceJson.present
        ? recurrenceJson.value
        : this.recurrenceJson,
    source: source.present ? source.value : this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
    readOnly: readOnly ?? this.readOnly,
    lastCompletedAt: lastCompletedAt.present
        ? lastCompletedAt.value
        : this.lastCompletedAt,
    repeatAfterCompletionDays: repeatAfterCompletionDays.present
        ? repeatAfterCompletionDays.value
        : this.repeatAfterCompletionDays,
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
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      status: data.status.present ? data.status.value : this.status,
      recurrenceJson: data.recurrenceJson.present
          ? data.recurrenceJson.value
          : this.recurrenceJson,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      readOnly: data.readOnly.present ? data.readOnly.value : this.readOnly,
      lastCompletedAt: data.lastCompletedAt.present
          ? data.lastCompletedAt.value
          : this.lastCompletedAt,
      repeatAfterCompletionDays: data.repeatAfterCompletionDays.present
          ? data.repeatAfterCompletionDays.value
          : this.repeatAfterCompletionDays,
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
          ..write('timeZone: $timeZone, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('status: $status, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('readOnly: $readOnly, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('repeatAfterCompletionDays: $repeatAfterCompletionDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    spaceId,
    title,
    notes,
    kind,
    dateKey,
    endDateKey,
    startMinute,
    endMinute,
    timeZone,
    startAt,
    endAt,
    allDay,
    status,
    recurrenceJson,
    source,
    externalId,
    readOnly,
    lastCompletedAt,
    repeatAfterCompletionDays,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
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
          other.timeZone == this.timeZone &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.allDay == this.allDay &&
          other.status == this.status &&
          other.recurrenceJson == this.recurrenceJson &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.readOnly == this.readOnly &&
          other.lastCompletedAt == this.lastCompletedAt &&
          other.repeatAfterCompletionDays == this.repeatAfterCompletionDays &&
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
  final Value<String?> timeZone;
  final Value<DateTime?> startAt;
  final Value<DateTime?> endAt;
  final Value<bool> allDay;
  final Value<String> status;
  final Value<String?> recurrenceJson;
  final Value<String?> source;
  final Value<String?> externalId;
  final Value<bool> readOnly;
  final Value<DateTime?> lastCompletedAt;
  final Value<int?> repeatAfterCompletionDays;
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
    this.timeZone = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.status = const Value.absent(),
    this.recurrenceJson = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.readOnly = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.repeatAfterCompletionDays = const Value.absent(),
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
    this.timeZone = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.allDay = const Value.absent(),
    required String status,
    this.recurrenceJson = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.readOnly = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.repeatAfterCompletionDays = const Value.absent(),
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
    Expression<String>? timeZone,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<bool>? allDay,
    Expression<String>? status,
    Expression<String>? recurrenceJson,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<bool>? readOnly,
    Expression<DateTime>? lastCompletedAt,
    Expression<int>? repeatAfterCompletionDays,
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
      if (timeZone != null) 'time_zone': timeZone,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (allDay != null) 'all_day': allDay,
      if (status != null) 'status': status,
      if (recurrenceJson != null) 'recurrence_json': recurrenceJson,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (readOnly != null) 'read_only': readOnly,
      if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt,
      if (repeatAfterCompletionDays != null)
        'repeat_after_completion_days': repeatAfterCompletionDays,
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
    Value<String?>? timeZone,
    Value<DateTime?>? startAt,
    Value<DateTime?>? endAt,
    Value<bool>? allDay,
    Value<String>? status,
    Value<String?>? recurrenceJson,
    Value<String?>? source,
    Value<String?>? externalId,
    Value<bool>? readOnly,
    Value<DateTime?>? lastCompletedAt,
    Value<int?>? repeatAfterCompletionDays,
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
      timeZone: timeZone ?? this.timeZone,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      allDay: allDay ?? this.allDay,
      status: status ?? this.status,
      recurrenceJson: recurrenceJson ?? this.recurrenceJson,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      readOnly: readOnly ?? this.readOnly,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      repeatAfterCompletionDays:
          repeatAfterCompletionDays ?? this.repeatAfterCompletionDays,
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
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
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
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (readOnly.present) {
      map['read_only'] = Variable<bool>(readOnly.value);
    }
    if (lastCompletedAt.present) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt.value);
    }
    if (repeatAfterCompletionDays.present) {
      map['repeat_after_completion_days'] = Variable<int>(
        repeatAfterCompletionDays.value,
      );
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
          ..write('timeZone: $timeZone, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('status: $status, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('readOnly: $readOnly, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('repeatAfterCompletionDays: $repeatAfterCompletionDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagRecordsTable extends TagRecords
    with TableInfo<$TagRecordsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagRecordsTable(this.attachedDatabase, [this._alias]);
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    spaceId,
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
  static const String $name = 'tag_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
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
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      ),
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
  $TagRecordsTable createAlias(String alias) {
    return $TagRecordsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String? spaceId;
  final String name;
  final int color;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const TagRow({
    required this.id,
    this.spaceId,
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
    if (!nullToAbsent || spaceId != null) {
      map['space_id'] = Variable<String>(spaceId);
    }
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

  TagRecordsCompanion toCompanion(bool nullToAbsent) {
    return TagRecordsCompanion(
      id: Value(id),
      spaceId: spaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(spaceId),
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

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String?>(json['spaceId']),
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
      'spaceId': serializer.toJson<String?>(spaceId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TagRow copyWith({
    String? id,
    Value<String?> spaceId = const Value.absent(),
    String? name,
    int? color,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TagRow(
    id: id ?? this.id,
    spaceId: spaceId.present ? spaceId.value : this.spaceId,
    name: name ?? this.name,
    color: color ?? this.color,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TagRow copyWithCompanion(TagRecordsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
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
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
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
  int get hashCode => Object.hash(
    id,
    spaceId,
    name,
    color,
    position,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.name == this.name &&
          other.color == this.color &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TagRecordsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String?> spaceId;
  final Value<String> name;
  final Value<int> color;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TagRecordsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagRecordsCompanion.insert({
    required String id,
    this.spaceId = const Value.absent(),
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
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
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
      if (spaceId != null) 'space_id': spaceId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? spaceId,
    Value<String>? name,
    Value<int>? color,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TagRecordsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
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
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
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
    return (StringBuffer('TagRecordsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
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

class $EntryTagRecordsTable extends EntryTagRecords
    with TableInfo<$EntryTagRecordsTable, EntryTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryTagRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tag_records (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_tag_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryTagRow> instance, {
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
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, tagId};
  @override
  EntryTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryTagRow(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $EntryTagRecordsTable createAlias(String alias) {
    return $EntryTagRecordsTable(attachedDatabase, alias);
  }
}

class EntryTagRow extends DataClass implements Insertable<EntryTagRow> {
  final String entryId;
  final String tagId;
  const EntryTagRow({required this.entryId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<String>(entryId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  EntryTagRecordsCompanion toCompanion(bool nullToAbsent) {
    return EntryTagRecordsCompanion(
      entryId: Value(entryId),
      tagId: Value(tagId),
    );
  }

  factory EntryTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryTagRow(
      entryId: serializer.fromJson<String>(json['entryId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<String>(entryId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  EntryTagRow copyWith({String? entryId, String? tagId}) =>
      EntryTagRow(entryId: entryId ?? this.entryId, tagId: tagId ?? this.tagId);
  EntryTagRow copyWithCompanion(EntryTagRecordsCompanion data) {
    return EntryTagRow(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryTagRow(')
          ..write('entryId: $entryId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryTagRow &&
          other.entryId == this.entryId &&
          other.tagId == this.tagId);
}

class EntryTagRecordsCompanion extends UpdateCompanion<EntryTagRow> {
  final Value<String> entryId;
  final Value<String> tagId;
  final Value<int> rowid;
  const EntryTagRecordsCompanion({
    this.entryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryTagRecordsCompanion.insert({
    required String entryId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       tagId = Value(tagId);
  static Insertable<EntryTagRow> custom({
    Expression<String>? entryId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryTagRecordsCompanion copyWith({
    Value<String>? entryId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return EntryTagRecordsCompanion(
      entryId: entryId ?? this.entryId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryTagRecordsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('tagId: $tagId, ')
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
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
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
  static const VerificationMeta _commuteMinutesMeta = const VerificationMeta(
    'commuteMinutes',
  );
  @override
  late final GeneratedColumn<int> commuteMinutes = GeneratedColumn<int>(
    'commute_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windDownMinutesMeta = const VerificationMeta(
    'windDownMinutes',
  );
  @override
  late final GeneratedColumn<int> windDownMinutes = GeneratedColumn<int>(
    'wind_down_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    timeZone,
    cycleDays,
    anchorDateKey,
    commuteMinutes,
    windDownMinutes,
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
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
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
    if (data.containsKey('commute_minutes')) {
      context.handle(
        _commuteMinutesMeta,
        commuteMinutes.isAcceptableOrUnknown(
          data['commute_minutes']!,
          _commuteMinutesMeta,
        ),
      );
    }
    if (data.containsKey('wind_down_minutes')) {
      context.handle(
        _windDownMinutesMeta,
        windDownMinutes.isAcceptableOrUnknown(
          data['wind_down_minutes']!,
          _windDownMinutesMeta,
        ),
      );
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
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      cycleDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_days'],
      )!,
      anchorDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor_date_key'],
      )!,
      commuteMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}commute_minutes'],
      ),
      windDownMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_down_minutes'],
      ),
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

  /// IANA timezone the slot times are defined in.
  final String timeZone;
  final int cycleDays;
  final int anchorDateKey;

  /// Per-pattern sleep overrides in minutes. Null uses the global buffer.
  final int? commuteMinutes;
  final int? windDownMinutes;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ShiftPatternRow({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.timeZone,
    required this.cycleDays,
    required this.anchorDateKey,
    this.commuteMinutes,
    this.windDownMinutes,
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
    map['time_zone'] = Variable<String>(timeZone);
    map['cycle_days'] = Variable<int>(cycleDays);
    map['anchor_date_key'] = Variable<int>(anchorDateKey);
    if (!nullToAbsent || commuteMinutes != null) {
      map['commute_minutes'] = Variable<int>(commuteMinutes);
    }
    if (!nullToAbsent || windDownMinutes != null) {
      map['wind_down_minutes'] = Variable<int>(windDownMinutes);
    }
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
      timeZone: Value(timeZone),
      cycleDays: Value(cycleDays),
      anchorDateKey: Value(anchorDateKey),
      commuteMinutes: commuteMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(commuteMinutes),
      windDownMinutes: windDownMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(windDownMinutes),
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
      timeZone: serializer.fromJson<String>(json['timeZone']),
      cycleDays: serializer.fromJson<int>(json['cycleDays']),
      anchorDateKey: serializer.fromJson<int>(json['anchorDateKey']),
      commuteMinutes: serializer.fromJson<int?>(json['commuteMinutes']),
      windDownMinutes: serializer.fromJson<int?>(json['windDownMinutes']),
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
      'timeZone': serializer.toJson<String>(timeZone),
      'cycleDays': serializer.toJson<int>(cycleDays),
      'anchorDateKey': serializer.toJson<int>(anchorDateKey),
      'commuteMinutes': serializer.toJson<int?>(commuteMinutes),
      'windDownMinutes': serializer.toJson<int?>(windDownMinutes),
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
    String? timeZone,
    int? cycleDays,
    int? anchorDateKey,
    Value<int?> commuteMinutes = const Value.absent(),
    Value<int?> windDownMinutes = const Value.absent(),
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ShiftPatternRow(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    name: name ?? this.name,
    timeZone: timeZone ?? this.timeZone,
    cycleDays: cycleDays ?? this.cycleDays,
    anchorDateKey: anchorDateKey ?? this.anchorDateKey,
    commuteMinutes: commuteMinutes.present
        ? commuteMinutes.value
        : this.commuteMinutes,
    windDownMinutes: windDownMinutes.present
        ? windDownMinutes.value
        : this.windDownMinutes,
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
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      cycleDays: data.cycleDays.present ? data.cycleDays.value : this.cycleDays,
      anchorDateKey: data.anchorDateKey.present
          ? data.anchorDateKey.value
          : this.anchorDateKey,
      commuteMinutes: data.commuteMinutes.present
          ? data.commuteMinutes.value
          : this.commuteMinutes,
      windDownMinutes: data.windDownMinutes.present
          ? data.windDownMinutes.value
          : this.windDownMinutes,
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
          ..write('timeZone: $timeZone, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('anchorDateKey: $anchorDateKey, ')
          ..write('commuteMinutes: $commuteMinutes, ')
          ..write('windDownMinutes: $windDownMinutes, ')
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
    timeZone,
    cycleDays,
    anchorDateKey,
    commuteMinutes,
    windDownMinutes,
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
          other.timeZone == this.timeZone &&
          other.cycleDays == this.cycleDays &&
          other.anchorDateKey == this.anchorDateKey &&
          other.commuteMinutes == this.commuteMinutes &&
          other.windDownMinutes == this.windDownMinutes &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShiftPatternRecordsCompanion extends UpdateCompanion<ShiftPatternRow> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<String> name;
  final Value<String> timeZone;
  final Value<int> cycleDays;
  final Value<int> anchorDateKey;
  final Value<int?> commuteMinutes;
  final Value<int?> windDownMinutes;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShiftPatternRecordsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.name = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.anchorDateKey = const Value.absent(),
    this.commuteMinutes = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
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
    this.timeZone = const Value.absent(),
    required int cycleDays,
    required int anchorDateKey,
    this.commuteMinutes = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
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
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShiftPatternRow> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<String>? name,
    Expression<String>? timeZone,
    Expression<int>? cycleDays,
    Expression<int>? anchorDateKey,
    Expression<int>? commuteMinutes,
    Expression<int>? windDownMinutes,
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
      if (timeZone != null) 'time_zone': timeZone,
      if (cycleDays != null) 'cycle_days': cycleDays,
      if (anchorDateKey != null) 'anchor_date_key': anchorDateKey,
      if (commuteMinutes != null) 'commute_minutes': commuteMinutes,
      if (windDownMinutes != null) 'wind_down_minutes': windDownMinutes,
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
    Value<String>? timeZone,
    Value<int>? cycleDays,
    Value<int>? anchorDateKey,
    Value<int?>? commuteMinutes,
    Value<int?>? windDownMinutes,
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
      timeZone: timeZone ?? this.timeZone,
      cycleDays: cycleDays ?? this.cycleDays,
      anchorDateKey: anchorDateKey ?? this.anchorDateKey,
      commuteMinutes: commuteMinutes ?? this.commuteMinutes,
      windDownMinutes: windDownMinutes ?? this.windDownMinutes,
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
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (cycleDays.present) {
      map['cycle_days'] = Variable<int>(cycleDays.value);
    }
    if (anchorDateKey.present) {
      map['anchor_date_key'] = Variable<int>(anchorDateKey.value);
    }
    if (commuteMinutes.present) {
      map['commute_minutes'] = Variable<int>(commuteMinutes.value);
    }
    if (windDownMinutes.present) {
      map['wind_down_minutes'] = Variable<int>(windDownMinutes.value);
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
          ..write('timeZone: $timeZone, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('anchorDateKey: $anchorDateKey, ')
          ..write('commuteMinutes: $commuteMinutes, ')
          ..write('windDownMinutes: $windDownMinutes, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftSlotRecordsTable extends ShiftSlotRecords
    with TableInfo<$ShiftSlotRecordsTable, ShiftSlotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftSlotRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patternIdMeta = const VerificationMeta(
    'patternId',
  );
  @override
  late final GeneratedColumn<String> patternId = GeneratedColumn<String>(
    'pattern_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_pattern_records (id)',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patternId,
    dayIndex,
    label,
    startMinute,
    endMinute,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_slot_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftSlotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern_id')) {
      context.handle(
        _patternIdMeta,
        patternId.isAcceptableOrUnknown(data['pattern_id']!, _patternIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patternIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
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
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftSlotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftSlotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patternId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
    );
  }

  @override
  $ShiftSlotRecordsTable createAlias(String alias) {
    return $ShiftSlotRecordsTable(attachedDatabase, alias);
  }
}

class ShiftSlotRow extends DataClass implements Insertable<ShiftSlotRow> {
  final int id;
  final String patternId;
  final int dayIndex;
  final String label;
  final int startMinute;
  final int endMinute;
  const ShiftSlotRow({
    required this.id,
    required this.patternId,
    required this.dayIndex,
    required this.label,
    required this.startMinute,
    required this.endMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern_id'] = Variable<String>(patternId);
    map['day_index'] = Variable<int>(dayIndex);
    map['label'] = Variable<String>(label);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    return map;
  }

  ShiftSlotRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftSlotRecordsCompanion(
      id: Value(id),
      patternId: Value(patternId),
      dayIndex: Value(dayIndex),
      label: Value(label),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
    );
  }

  factory ShiftSlotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftSlotRow(
      id: serializer.fromJson<int>(json['id']),
      patternId: serializer.fromJson<String>(json['patternId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      label: serializer.fromJson<String>(json['label']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patternId': serializer.toJson<String>(patternId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'label': serializer.toJson<String>(label),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
    };
  }

  ShiftSlotRow copyWith({
    int? id,
    String? patternId,
    int? dayIndex,
    String? label,
    int? startMinute,
    int? endMinute,
  }) => ShiftSlotRow(
    id: id ?? this.id,
    patternId: patternId ?? this.patternId,
    dayIndex: dayIndex ?? this.dayIndex,
    label: label ?? this.label,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
  );
  ShiftSlotRow copyWithCompanion(ShiftSlotRecordsCompanion data) {
    return ShiftSlotRow(
      id: data.id.present ? data.id.value : this.id,
      patternId: data.patternId.present ? data.patternId.value : this.patternId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      label: data.label.present ? data.label.value : this.label,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftSlotRow(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('label: $label, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patternId, dayIndex, label, startMinute, endMinute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftSlotRow &&
          other.id == this.id &&
          other.patternId == this.patternId &&
          other.dayIndex == this.dayIndex &&
          other.label == this.label &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute);
}

class ShiftSlotRecordsCompanion extends UpdateCompanion<ShiftSlotRow> {
  final Value<int> id;
  final Value<String> patternId;
  final Value<int> dayIndex;
  final Value<String> label;
  final Value<int> startMinute;
  final Value<int> endMinute;
  const ShiftSlotRecordsCompanion({
    this.id = const Value.absent(),
    this.patternId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.label = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
  });
  ShiftSlotRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String patternId,
    required int dayIndex,
    this.label = const Value.absent(),
    required int startMinute,
    required int endMinute,
  }) : patternId = Value(patternId),
       dayIndex = Value(dayIndex),
       startMinute = Value(startMinute),
       endMinute = Value(endMinute);
  static Insertable<ShiftSlotRow> custom({
    Expression<int>? id,
    Expression<String>? patternId,
    Expression<int>? dayIndex,
    Expression<String>? label,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patternId != null) 'pattern_id': patternId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (label != null) 'label': label,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
    });
  }

  ShiftSlotRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? patternId,
    Value<int>? dayIndex,
    Value<String>? label,
    Value<int>? startMinute,
    Value<int>? endMinute,
  }) {
    return ShiftSlotRecordsCompanion(
      id: id ?? this.id,
      patternId: patternId ?? this.patternId,
      dayIndex: dayIndex ?? this.dayIndex,
      label: label ?? this.label,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patternId.present) {
      map['pattern_id'] = Variable<String>(patternId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftSlotRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('label: $label, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute')
          ..write(')'))
        .toString();
  }
}

class $ShiftPatternTagRecordsTable extends ShiftPatternTagRecords
    with TableInfo<$ShiftPatternTagRecordsTable, ShiftPatternTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftPatternTagRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _patternIdMeta = const VerificationMeta(
    'patternId',
  );
  @override
  late final GeneratedColumn<String> patternId = GeneratedColumn<String>(
    'pattern_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_pattern_records (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tag_records (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [patternId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_pattern_tag_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftPatternTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pattern_id')) {
      context.handle(
        _patternIdMeta,
        patternId.isAcceptableOrUnknown(data['pattern_id']!, _patternIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patternIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {patternId, tagId};
  @override
  ShiftPatternTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftPatternTagRow(
      patternId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $ShiftPatternTagRecordsTable createAlias(String alias) {
    return $ShiftPatternTagRecordsTable(attachedDatabase, alias);
  }
}

class ShiftPatternTagRow extends DataClass
    implements Insertable<ShiftPatternTagRow> {
  final String patternId;
  final String tagId;
  const ShiftPatternTagRow({required this.patternId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pattern_id'] = Variable<String>(patternId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  ShiftPatternTagRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftPatternTagRecordsCompanion(
      patternId: Value(patternId),
      tagId: Value(tagId),
    );
  }

  factory ShiftPatternTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftPatternTagRow(
      patternId: serializer.fromJson<String>(json['patternId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'patternId': serializer.toJson<String>(patternId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  ShiftPatternTagRow copyWith({String? patternId, String? tagId}) =>
      ShiftPatternTagRow(
        patternId: patternId ?? this.patternId,
        tagId: tagId ?? this.tagId,
      );
  ShiftPatternTagRow copyWithCompanion(ShiftPatternTagRecordsCompanion data) {
    return ShiftPatternTagRow(
      patternId: data.patternId.present ? data.patternId.value : this.patternId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternTagRow(')
          ..write('patternId: $patternId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(patternId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftPatternTagRow &&
          other.patternId == this.patternId &&
          other.tagId == this.tagId);
}

class ShiftPatternTagRecordsCompanion
    extends UpdateCompanion<ShiftPatternTagRow> {
  final Value<String> patternId;
  final Value<String> tagId;
  final Value<int> rowid;
  const ShiftPatternTagRecordsCompanion({
    this.patternId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftPatternTagRecordsCompanion.insert({
    required String patternId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : patternId = Value(patternId),
       tagId = Value(tagId);
  static Insertable<ShiftPatternTagRow> custom({
    Expression<String>? patternId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (patternId != null) 'pattern_id': patternId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftPatternTagRecordsCompanion copyWith({
    Value<String>? patternId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return ShiftPatternTagRecordsCompanion(
      patternId: patternId ?? this.patternId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (patternId.present) {
      map['pattern_id'] = Variable<String>(patternId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftPatternTagRecordsCompanion(')
          ..write('patternId: $patternId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftExceptionRecordsTable extends ShiftExceptionRecords
    with TableInfo<$ShiftExceptionRecordsTable, ShiftExceptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftExceptionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patternIdMeta = const VerificationMeta(
    'patternId',
  );
  @override
  late final GeneratedColumn<String> patternId = GeneratedColumn<String>(
    'pattern_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_pattern_records (id)',
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patternId,
    dateKey,
    type,
    startMinute,
    endMinute,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_exception_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftExceptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern_id')) {
      context.handle(
        _patternIdMeta,
        patternId.isAcceptableOrUnknown(data['pattern_id']!, _patternIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patternIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftExceptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftExceptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patternId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_key'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      ),
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $ShiftExceptionRecordsTable createAlias(String alias) {
    return $ShiftExceptionRecordsTable(attachedDatabase, alias);
  }
}

class ShiftExceptionRow extends DataClass
    implements Insertable<ShiftExceptionRow> {
  final int id;
  final String patternId;
  final int dateKey;

  /// One of [ShiftExceptionType].
  final String type;
  final int? startMinute;
  final int? endMinute;
  final String note;
  const ShiftExceptionRow({
    required this.id,
    required this.patternId,
    required this.dateKey,
    required this.type,
    this.startMinute,
    this.endMinute,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern_id'] = Variable<String>(patternId);
    map['date_key'] = Variable<int>(dateKey);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || startMinute != null) {
      map['start_minute'] = Variable<int>(startMinute);
    }
    if (!nullToAbsent || endMinute != null) {
      map['end_minute'] = Variable<int>(endMinute);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  ShiftExceptionRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftExceptionRecordsCompanion(
      id: Value(id),
      patternId: Value(patternId),
      dateKey: Value(dateKey),
      type: Value(type),
      startMinute: startMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinute),
      endMinute: endMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinute),
      note: Value(note),
    );
  }

  factory ShiftExceptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftExceptionRow(
      id: serializer.fromJson<int>(json['id']),
      patternId: serializer.fromJson<String>(json['patternId']),
      dateKey: serializer.fromJson<int>(json['dateKey']),
      type: serializer.fromJson<String>(json['type']),
      startMinute: serializer.fromJson<int?>(json['startMinute']),
      endMinute: serializer.fromJson<int?>(json['endMinute']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patternId': serializer.toJson<String>(patternId),
      'dateKey': serializer.toJson<int>(dateKey),
      'type': serializer.toJson<String>(type),
      'startMinute': serializer.toJson<int?>(startMinute),
      'endMinute': serializer.toJson<int?>(endMinute),
      'note': serializer.toJson<String>(note),
    };
  }

  ShiftExceptionRow copyWith({
    int? id,
    String? patternId,
    int? dateKey,
    String? type,
    Value<int?> startMinute = const Value.absent(),
    Value<int?> endMinute = const Value.absent(),
    String? note,
  }) => ShiftExceptionRow(
    id: id ?? this.id,
    patternId: patternId ?? this.patternId,
    dateKey: dateKey ?? this.dateKey,
    type: type ?? this.type,
    startMinute: startMinute.present ? startMinute.value : this.startMinute,
    endMinute: endMinute.present ? endMinute.value : this.endMinute,
    note: note ?? this.note,
  );
  ShiftExceptionRow copyWithCompanion(ShiftExceptionRecordsCompanion data) {
    return ShiftExceptionRow(
      id: data.id.present ? data.id.value : this.id,
      patternId: data.patternId.present ? data.patternId.value : this.patternId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      type: data.type.present ? data.type.value : this.type,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftExceptionRow(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dateKey: $dateKey, ')
          ..write('type: $type, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patternId, dateKey, type, startMinute, endMinute, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftExceptionRow &&
          other.id == this.id &&
          other.patternId == this.patternId &&
          other.dateKey == this.dateKey &&
          other.type == this.type &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.note == this.note);
}

class ShiftExceptionRecordsCompanion
    extends UpdateCompanion<ShiftExceptionRow> {
  final Value<int> id;
  final Value<String> patternId;
  final Value<int> dateKey;
  final Value<String> type;
  final Value<int?> startMinute;
  final Value<int?> endMinute;
  final Value<String> note;
  const ShiftExceptionRecordsCompanion({
    this.id = const Value.absent(),
    this.patternId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.type = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.note = const Value.absent(),
  });
  ShiftExceptionRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String patternId,
    required int dateKey,
    required String type,
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.note = const Value.absent(),
  }) : patternId = Value(patternId),
       dateKey = Value(dateKey),
       type = Value(type);
  static Insertable<ShiftExceptionRow> custom({
    Expression<int>? id,
    Expression<String>? patternId,
    Expression<int>? dateKey,
    Expression<String>? type,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patternId != null) 'pattern_id': patternId,
      if (dateKey != null) 'date_key': dateKey,
      if (type != null) 'type': type,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (note != null) 'note': note,
    });
  }

  ShiftExceptionRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? patternId,
    Value<int>? dateKey,
    Value<String>? type,
    Value<int?>? startMinute,
    Value<int?>? endMinute,
    Value<String>? note,
  }) {
    return ShiftExceptionRecordsCompanion(
      id: id ?? this.id,
      patternId: patternId ?? this.patternId,
      dateKey: dateKey ?? this.dateKey,
      type: type ?? this.type,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patternId.present) {
      map['pattern_id'] = Variable<String>(patternId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<int>(dateKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftExceptionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('dateKey: $dateKey, ')
          ..write('type: $type, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ShiftChecklistItemRecordsTable extends ShiftChecklistItemRecords
    with TableInfo<$ShiftChecklistItemRecordsTable, ShiftChecklistItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftChecklistItemRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternIdMeta = const VerificationMeta(
    'patternId',
  );
  @override
  late final GeneratedColumn<String> patternId = GeneratedColumn<String>(
    'pattern_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_pattern_records (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [id, patternId, label, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_checklist_item_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftChecklistItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pattern_id')) {
      context.handle(
        _patternIdMeta,
        patternId.isAcceptableOrUnknown(data['pattern_id']!, _patternIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patternIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftChecklistItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftChecklistItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patternId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ShiftChecklistItemRecordsTable createAlias(String alias) {
    return $ShiftChecklistItemRecordsTable(attachedDatabase, alias);
  }
}

class ShiftChecklistItemRow extends DataClass
    implements Insertable<ShiftChecklistItemRow> {
  final String id;
  final String patternId;
  final String label;
  final int position;
  const ShiftChecklistItemRow({
    required this.id,
    required this.patternId,
    required this.label,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pattern_id'] = Variable<String>(patternId);
    map['label'] = Variable<String>(label);
    map['position'] = Variable<int>(position);
    return map;
  }

  ShiftChecklistItemRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftChecklistItemRecordsCompanion(
      id: Value(id),
      patternId: Value(patternId),
      label: Value(label),
      position: Value(position),
    );
  }

  factory ShiftChecklistItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftChecklistItemRow(
      id: serializer.fromJson<String>(json['id']),
      patternId: serializer.fromJson<String>(json['patternId']),
      label: serializer.fromJson<String>(json['label']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patternId': serializer.toJson<String>(patternId),
      'label': serializer.toJson<String>(label),
      'position': serializer.toJson<int>(position),
    };
  }

  ShiftChecklistItemRow copyWith({
    String? id,
    String? patternId,
    String? label,
    int? position,
  }) => ShiftChecklistItemRow(
    id: id ?? this.id,
    patternId: patternId ?? this.patternId,
    label: label ?? this.label,
    position: position ?? this.position,
  );
  ShiftChecklistItemRow copyWithCompanion(
    ShiftChecklistItemRecordsCompanion data,
  ) {
    return ShiftChecklistItemRow(
      id: data.id.present ? data.id.value : this.id,
      patternId: data.patternId.present ? data.patternId.value : this.patternId,
      label: data.label.present ? data.label.value : this.label,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftChecklistItemRow(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('label: $label, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patternId, label, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftChecklistItemRow &&
          other.id == this.id &&
          other.patternId == this.patternId &&
          other.label == this.label &&
          other.position == this.position);
}

class ShiftChecklistItemRecordsCompanion
    extends UpdateCompanion<ShiftChecklistItemRow> {
  final Value<String> id;
  final Value<String> patternId;
  final Value<String> label;
  final Value<int> position;
  final Value<int> rowid;
  const ShiftChecklistItemRecordsCompanion({
    this.id = const Value.absent(),
    this.patternId = const Value.absent(),
    this.label = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftChecklistItemRecordsCompanion.insert({
    required String id,
    required String patternId,
    required String label,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patternId = Value(patternId),
       label = Value(label);
  static Insertable<ShiftChecklistItemRow> custom({
    Expression<String>? id,
    Expression<String>? patternId,
    Expression<String>? label,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patternId != null) 'pattern_id': patternId,
      if (label != null) 'label': label,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftChecklistItemRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? patternId,
    Value<String>? label,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return ShiftChecklistItemRecordsCompanion(
      id: id ?? this.id,
      patternId: patternId ?? this.patternId,
      label: label ?? this.label,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patternId.present) {
      map['pattern_id'] = Variable<String>(patternId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftChecklistItemRecordsCompanion(')
          ..write('id: $id, ')
          ..write('patternId: $patternId, ')
          ..write('label: $label, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftChecklistCompletionRecordsTable
    extends ShiftChecklistCompletionRecords
    with
        TableInfo<
          $ShiftChecklistCompletionRecordsTable,
          ShiftChecklistCompletionRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftChecklistCompletionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_checklist_item_records (id)',
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
  static const VerificationMeta _slotKeyMeta = const VerificationMeta(
    'slotKey',
  );
  @override
  late final GeneratedColumn<String> slotKey = GeneratedColumn<String>(
    'slot_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  List<GeneratedColumn> get $columns => [itemId, dateKey, slotKey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_checklist_completion_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftChecklistCompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('slot_key')) {
      context.handle(
        _slotKeyMeta,
        slotKey.isAcceptableOrUnknown(data['slot_key']!, _slotKeyMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, dateKey, slotKey};
  @override
  ShiftChecklistCompletionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftChecklistCompletionRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_key'],
      )!,
      slotKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShiftChecklistCompletionRecordsTable createAlias(String alias) {
    return $ShiftChecklistCompletionRecordsTable(attachedDatabase, alias);
  }
}

class ShiftChecklistCompletionRow extends DataClass
    implements Insertable<ShiftChecklistCompletionRow> {
  final String itemId;
  final int dateKey;

  /// Identity of the shift slot inside the pattern. An empty value is the
  /// legacy single-slot key and is backfilled during the v5 to v6 migration.
  final String slotKey;
  final DateTime createdAt;
  const ShiftChecklistCompletionRow({
    required this.itemId,
    required this.dateKey,
    required this.slotKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['date_key'] = Variable<int>(dateKey);
    map['slot_key'] = Variable<String>(slotKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShiftChecklistCompletionRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShiftChecklistCompletionRecordsCompanion(
      itemId: Value(itemId),
      dateKey: Value(dateKey),
      slotKey: Value(slotKey),
      createdAt: Value(createdAt),
    );
  }

  factory ShiftChecklistCompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftChecklistCompletionRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      dateKey: serializer.fromJson<int>(json['dateKey']),
      slotKey: serializer.fromJson<String>(json['slotKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'dateKey': serializer.toJson<int>(dateKey),
      'slotKey': serializer.toJson<String>(slotKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShiftChecklistCompletionRow copyWith({
    String? itemId,
    int? dateKey,
    String? slotKey,
    DateTime? createdAt,
  }) => ShiftChecklistCompletionRow(
    itemId: itemId ?? this.itemId,
    dateKey: dateKey ?? this.dateKey,
    slotKey: slotKey ?? this.slotKey,
    createdAt: createdAt ?? this.createdAt,
  );
  ShiftChecklistCompletionRow copyWithCompanion(
    ShiftChecklistCompletionRecordsCompanion data,
  ) {
    return ShiftChecklistCompletionRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      slotKey: data.slotKey.present ? data.slotKey.value : this.slotKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftChecklistCompletionRow(')
          ..write('itemId: $itemId, ')
          ..write('dateKey: $dateKey, ')
          ..write('slotKey: $slotKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, dateKey, slotKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftChecklistCompletionRow &&
          other.itemId == this.itemId &&
          other.dateKey == this.dateKey &&
          other.slotKey == this.slotKey &&
          other.createdAt == this.createdAt);
}

class ShiftChecklistCompletionRecordsCompanion
    extends UpdateCompanion<ShiftChecklistCompletionRow> {
  final Value<String> itemId;
  final Value<int> dateKey;
  final Value<String> slotKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShiftChecklistCompletionRecordsCompanion({
    this.itemId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.slotKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftChecklistCompletionRecordsCompanion.insert({
    required String itemId,
    required int dateKey,
    this.slotKey = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       dateKey = Value(dateKey),
       createdAt = Value(createdAt);
  static Insertable<ShiftChecklistCompletionRow> custom({
    Expression<String>? itemId,
    Expression<int>? dateKey,
    Expression<String>? slotKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (dateKey != null) 'date_key': dateKey,
      if (slotKey != null) 'slot_key': slotKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftChecklistCompletionRecordsCompanion copyWith({
    Value<String>? itemId,
    Value<int>? dateKey,
    Value<String>? slotKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShiftChecklistCompletionRecordsCompanion(
      itemId: itemId ?? this.itemId,
      dateKey: dateKey ?? this.dateKey,
      slotKey: slotKey ?? this.slotKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<int>(dateKey.value);
    }
    if (slotKey.present) {
      map['slot_key'] = Variable<String>(slotKey.value);
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
    return (StringBuffer('ShiftChecklistCompletionRecordsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('dateKey: $dateKey, ')
          ..write('slotKey: $slotKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HomeItemRecordsTable extends HomeItemRecords
    with TableInfo<$HomeItemRecordsTable, HomeItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeItemRecordsTable(this.attachedDatabase, [this._alias]);
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
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reorderLevelMeta = const VerificationMeta(
    'reorderLevel',
  );
  @override
  late final GeneratedColumn<double> reorderLevel = GeneratedColumn<double>(
    'reorder_level',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _lastPurchasedAtMeta = const VerificationMeta(
    'lastPurchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPurchasedAt =
      GeneratedColumn<DateTime>(
        'last_purchased_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
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
    name,
    category,
    location,
    quantity,
    reorderLevel,
    unit,
    notes,
    lastPurchasedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_item_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomeItemRow> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('reorder_level')) {
      context.handle(
        _reorderLevelMeta,
        reorderLevel.isAcceptableOrUnknown(
          data['reorder_level']!,
          _reorderLevelMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('last_purchased_at')) {
      context.handle(
        _lastPurchasedAtMeta,
        lastPurchasedAt.isAcceptableOrUnknown(
          data['last_purchased_at']!,
          _lastPurchasedAtMeta,
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
  HomeItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      reorderLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reorder_level'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      lastPurchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_purchased_at'],
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
  $HomeItemRecordsTable createAlias(String alias) {
    return $HomeItemRecordsTable(attachedDatabase, alias);
  }
}

class HomeItemRow extends DataClass implements Insertable<HomeItemRow> {
  final String id;
  final String name;
  final String category;
  final String location;
  final double quantity;

  /// Threshold at or below which the item is low stock. Null means no alert.
  final double? reorderLevel;
  final String unit;
  final String notes;
  final DateTime? lastPurchasedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const HomeItemRow({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.quantity,
    this.reorderLevel,
    required this.unit,
    required this.notes,
    this.lastPurchasedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['location'] = Variable<String>(location);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || reorderLevel != null) {
      map['reorder_level'] = Variable<double>(reorderLevel);
    }
    map['unit'] = Variable<String>(unit);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || lastPurchasedAt != null) {
      map['last_purchased_at'] = Variable<DateTime>(lastPurchasedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  HomeItemRecordsCompanion toCompanion(bool nullToAbsent) {
    return HomeItemRecordsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      location: Value(location),
      quantity: Value(quantity),
      reorderLevel: reorderLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(reorderLevel),
      unit: Value(unit),
      notes: Value(notes),
      lastPurchasedAt: lastPurchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchasedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory HomeItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeItemRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      location: serializer.fromJson<String>(json['location']),
      quantity: serializer.fromJson<double>(json['quantity']),
      reorderLevel: serializer.fromJson<double?>(json['reorderLevel']),
      unit: serializer.fromJson<String>(json['unit']),
      notes: serializer.fromJson<String>(json['notes']),
      lastPurchasedAt: serializer.fromJson<DateTime?>(json['lastPurchasedAt']),
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
      'category': serializer.toJson<String>(category),
      'location': serializer.toJson<String>(location),
      'quantity': serializer.toJson<double>(quantity),
      'reorderLevel': serializer.toJson<double?>(reorderLevel),
      'unit': serializer.toJson<String>(unit),
      'notes': serializer.toJson<String>(notes),
      'lastPurchasedAt': serializer.toJson<DateTime?>(lastPurchasedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  HomeItemRow copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    double? quantity,
    Value<double?> reorderLevel = const Value.absent(),
    String? unit,
    String? notes,
    Value<DateTime?> lastPurchasedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => HomeItemRow(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    location: location ?? this.location,
    quantity: quantity ?? this.quantity,
    reorderLevel: reorderLevel.present ? reorderLevel.value : this.reorderLevel,
    unit: unit ?? this.unit,
    notes: notes ?? this.notes,
    lastPurchasedAt: lastPurchasedAt.present
        ? lastPurchasedAt.value
        : this.lastPurchasedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  HomeItemRow copyWithCompanion(HomeItemRecordsCompanion data) {
    return HomeItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      location: data.location.present ? data.location.value : this.location,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      reorderLevel: data.reorderLevel.present
          ? data.reorderLevel.value
          : this.reorderLevel,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastPurchasedAt: data.lastPurchasedAt.present
          ? data.lastPurchasedAt.value
          : this.lastPurchasedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('location: $location, ')
          ..write('quantity: $quantity, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('lastPurchasedAt: $lastPurchasedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    location,
    quantity,
    reorderLevel,
    unit,
    notes,
    lastPurchasedAt,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.location == this.location &&
          other.quantity == this.quantity &&
          other.reorderLevel == this.reorderLevel &&
          other.unit == this.unit &&
          other.notes == this.notes &&
          other.lastPurchasedAt == this.lastPurchasedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class HomeItemRecordsCompanion extends UpdateCompanion<HomeItemRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> location;
  final Value<double> quantity;
  final Value<double?> reorderLevel;
  final Value<String> unit;
  final Value<String> notes;
  final Value<DateTime?> lastPurchasedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const HomeItemRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.location = const Value.absent(),
    this.quantity = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastPurchasedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomeItemRecordsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    this.location = const Value.absent(),
    this.quantity = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastPurchasedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HomeItemRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? location,
    Expression<double>? quantity,
    Expression<double>? reorderLevel,
    Expression<String>? unit,
    Expression<String>? notes,
    Expression<DateTime>? lastPurchasedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (location != null) 'location': location,
      if (quantity != null) 'quantity': quantity,
      if (reorderLevel != null) 'reorder_level': reorderLevel,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
      if (lastPurchasedAt != null) 'last_purchased_at': lastPurchasedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomeItemRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? location,
    Value<double>? quantity,
    Value<double?>? reorderLevel,
    Value<String>? unit,
    Value<String>? notes,
    Value<DateTime?>? lastPurchasedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return HomeItemRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      lastPurchasedAt: lastPurchasedAt ?? this.lastPurchasedAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (reorderLevel.present) {
      map['reorder_level'] = Variable<double>(reorderLevel.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lastPurchasedAt.present) {
      map['last_purchased_at'] = Variable<DateTime>(lastPurchasedAt.value);
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
    return (StringBuffer('HomeItemRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('location: $location, ')
          ..write('quantity: $quantity, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('lastPurchasedAt: $lastPurchasedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemRecordsTable extends ShoppingItemRecords
    with TableInfo<$ShoppingItemRecordsTable, ShoppingItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _homeItemIdMeta = const VerificationMeta(
    'homeItemId',
  );
  @override
  late final GeneratedColumn<String> homeItemId = GeneratedColumn<String>(
    'home_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES home_item_records (id)',
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
    quantity,
    unit,
    checked,
    note,
    homeItemId,
    position,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_item_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItemRow> instance, {
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
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('home_item_id')) {
      context.handle(
        _homeItemIdMeta,
        homeItemId.isAcceptableOrUnknown(
          data['home_item_id']!,
          _homeItemIdMeta,
        ),
      );
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
  ShoppingItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      homeItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_item_id'],
      ),
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
  $ShoppingItemRecordsTable createAlias(String alias) {
    return $ShoppingItemRecordsTable(attachedDatabase, alias);
  }
}

class ShoppingItemRow extends DataClass implements Insertable<ShoppingItemRow> {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final bool checked;
  final String note;
  final String? homeItemId;

  /// Manual order inside the list. Lower values come first.
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ShoppingItemRow({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.checked,
    required this.note,
    this.homeItemId,
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
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['checked'] = Variable<bool>(checked);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || homeItemId != null) {
      map['home_item_id'] = Variable<String>(homeItemId);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ShoppingItemRecordsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemRecordsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      checked: Value(checked),
      note: Value(note),
      homeItemId: homeItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(homeItemId),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ShoppingItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItemRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      checked: serializer.fromJson<bool>(json['checked']),
      note: serializer.fromJson<String>(json['note']),
      homeItemId: serializer.fromJson<String?>(json['homeItemId']),
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
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'checked': serializer.toJson<bool>(checked),
      'note': serializer.toJson<String>(note),
      'homeItemId': serializer.toJson<String?>(homeItemId),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ShoppingItemRow copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    bool? checked,
    String? note,
    Value<String?> homeItemId = const Value.absent(),
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ShoppingItemRow(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    checked: checked ?? this.checked,
    note: note ?? this.note,
    homeItemId: homeItemId.present ? homeItemId.value : this.homeItemId,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ShoppingItemRow copyWithCompanion(ShoppingItemRecordsCompanion data) {
    return ShoppingItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      checked: data.checked.present ? data.checked.value : this.checked,
      note: data.note.present ? data.note.value : this.note,
      homeItemId: data.homeItemId.present
          ? data.homeItemId.value
          : this.homeItemId,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked, ')
          ..write('note: $note, ')
          ..write('homeItemId: $homeItemId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    quantity,
    unit,
    checked,
    note,
    homeItemId,
    position,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.checked == this.checked &&
          other.note == this.note &&
          other.homeItemId == this.homeItemId &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShoppingItemRecordsCompanion extends UpdateCompanion<ShoppingItemRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<bool> checked;
  final Value<String> note;
  final Value<String?> homeItemId;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShoppingItemRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
    this.note = const Value.absent(),
    this.homeItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemRecordsCompanion.insert({
    required String id,
    required String name,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
    this.note = const Value.absent(),
    this.homeItemId = const Value.absent(),
    this.position = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ShoppingItemRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? checked,
    Expression<String>? note,
    Expression<String>? homeItemId,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (checked != null) 'checked': checked,
      if (note != null) 'note': note,
      if (homeItemId != null) 'home_item_id': homeItemId,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? quantity,
    Value<String>? unit,
    Value<bool>? checked,
    Value<String>? note,
    Value<String?>? homeItemId,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ShoppingItemRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      checked: checked ?? this.checked,
      note: note ?? this.note,
      homeItemId: homeItemId ?? this.homeItemId,
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
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (homeItemId.present) {
      map['home_item_id'] = Variable<String>(homeItemId.value);
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
    return (StringBuffer('ShoppingItemRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked, ')
          ..write('note: $note, ')
          ..write('homeItemId: $homeItemId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdentityRecordsTable extends IdentityRecords
    with TableInfo<$IdentityRecordsTable, IdentityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentityRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _certificatePemMeta = const VerificationMeta(
    'certificatePem',
  );
  @override
  late final GeneratedColumn<String> certificatePem = GeneratedColumn<String>(
    'certificate_pem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _privateKeyPemMeta = const VerificationMeta(
    'privateKeyPem',
  );
  @override
  late final GeneratedColumn<String> privateKeyPem = GeneratedColumn<String>(
    'private_key_pem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mcpTokenMeta = const VerificationMeta(
    'mcpToken',
  );
  @override
  late final GeneratedColumn<String> mcpToken = GeneratedColumn<String>(
    'mcp_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    deviceName,
    username,
    pinSalt,
    pinHash,
    certificatePem,
    privateKeyPem,
    mcpToken,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdentityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    } else if (isInserting) {
      context.missing(_pinSaltMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('certificate_pem')) {
      context.handle(
        _certificatePemMeta,
        certificatePem.isAcceptableOrUnknown(
          data['certificate_pem']!,
          _certificatePemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_certificatePemMeta);
    }
    if (data.containsKey('private_key_pem')) {
      context.handle(
        _privateKeyPemMeta,
        privateKeyPem.isAcceptableOrUnknown(
          data['private_key_pem']!,
          _privateKeyPemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_privateKeyPemMeta);
    }
    if (data.containsKey('mcp_token')) {
      context.handle(
        _mcpTokenMeta,
        mcpToken.isAcceptableOrUnknown(data['mcp_token']!, _mcpTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_mcpTokenMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdentityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdentityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      deviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      certificatePem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}certificate_pem'],
      )!,
      privateKeyPem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}private_key_pem'],
      )!,
      mcpToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mcp_token'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IdentityRecordsTable createAlias(String alias) {
    return $IdentityRecordsTable(attachedDatabase, alias);
  }
}

class IdentityRow extends DataClass implements Insertable<IdentityRow> {
  final int id;
  final String deviceId;
  final String deviceName;
  final String username;
  final String pinSalt;
  final String pinHash;
  final String certificatePem;
  final String privateKeyPem;
  final String mcpToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IdentityRow({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.username,
    required this.pinSalt,
    required this.pinHash,
    required this.certificatePem,
    required this.privateKeyPem,
    required this.mcpToken,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['device_name'] = Variable<String>(deviceName);
    map['username'] = Variable<String>(username);
    map['pin_salt'] = Variable<String>(pinSalt);
    map['pin_hash'] = Variable<String>(pinHash);
    map['certificate_pem'] = Variable<String>(certificatePem);
    map['private_key_pem'] = Variable<String>(privateKeyPem);
    map['mcp_token'] = Variable<String>(mcpToken);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IdentityRecordsCompanion toCompanion(bool nullToAbsent) {
    return IdentityRecordsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      deviceName: Value(deviceName),
      username: Value(username),
      pinSalt: Value(pinSalt),
      pinHash: Value(pinHash),
      certificatePem: Value(certificatePem),
      privateKeyPem: Value(privateKeyPem),
      mcpToken: Value(mcpToken),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IdentityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdentityRow(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      username: serializer.fromJson<String>(json['username']),
      pinSalt: serializer.fromJson<String>(json['pinSalt']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      certificatePem: serializer.fromJson<String>(json['certificatePem']),
      privateKeyPem: serializer.fromJson<String>(json['privateKeyPem']),
      mcpToken: serializer.fromJson<String>(json['mcpToken']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceName': serializer.toJson<String>(deviceName),
      'username': serializer.toJson<String>(username),
      'pinSalt': serializer.toJson<String>(pinSalt),
      'pinHash': serializer.toJson<String>(pinHash),
      'certificatePem': serializer.toJson<String>(certificatePem),
      'privateKeyPem': serializer.toJson<String>(privateKeyPem),
      'mcpToken': serializer.toJson<String>(mcpToken),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IdentityRow copyWith({
    int? id,
    String? deviceId,
    String? deviceName,
    String? username,
    String? pinSalt,
    String? pinHash,
    String? certificatePem,
    String? privateKeyPem,
    String? mcpToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IdentityRow(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    deviceName: deviceName ?? this.deviceName,
    username: username ?? this.username,
    pinSalt: pinSalt ?? this.pinSalt,
    pinHash: pinHash ?? this.pinHash,
    certificatePem: certificatePem ?? this.certificatePem,
    privateKeyPem: privateKeyPem ?? this.privateKeyPem,
    mcpToken: mcpToken ?? this.mcpToken,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IdentityRow copyWithCompanion(IdentityRecordsCompanion data) {
    return IdentityRow(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceName: data.deviceName.present
          ? data.deviceName.value
          : this.deviceName,
      username: data.username.present ? data.username.value : this.username,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      certificatePem: data.certificatePem.present
          ? data.certificatePem.value
          : this.certificatePem,
      privateKeyPem: data.privateKeyPem.present
          ? data.privateKeyPem.value
          : this.privateKeyPem,
      mcpToken: data.mcpToken.present ? data.mcpToken.value : this.mcpToken,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdentityRow(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('username: $username, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinHash: $pinHash, ')
          ..write('certificatePem: $certificatePem, ')
          ..write('privateKeyPem: $privateKeyPem, ')
          ..write('mcpToken: $mcpToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    deviceName,
    username,
    pinSalt,
    pinHash,
    certificatePem,
    privateKeyPem,
    mcpToken,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdentityRow &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.deviceName == this.deviceName &&
          other.username == this.username &&
          other.pinSalt == this.pinSalt &&
          other.pinHash == this.pinHash &&
          other.certificatePem == this.certificatePem &&
          other.privateKeyPem == this.privateKeyPem &&
          other.mcpToken == this.mcpToken &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IdentityRecordsCompanion extends UpdateCompanion<IdentityRow> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> deviceName;
  final Value<String> username;
  final Value<String> pinSalt;
  final Value<String> pinHash;
  final Value<String> certificatePem;
  final Value<String> privateKeyPem;
  final Value<String> mcpToken;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IdentityRecordsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.username = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.certificatePem = const Value.absent(),
    this.privateKeyPem = const Value.absent(),
    this.mcpToken = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IdentityRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String deviceName,
    required String username,
    required String pinSalt,
    required String pinHash,
    required String certificatePem,
    required String privateKeyPem,
    required String mcpToken,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : deviceId = Value(deviceId),
       deviceName = Value(deviceName),
       username = Value(username),
       pinSalt = Value(pinSalt),
       pinHash = Value(pinHash),
       certificatePem = Value(certificatePem),
       privateKeyPem = Value(privateKeyPem),
       mcpToken = Value(mcpToken),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<IdentityRow> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? deviceName,
    Expression<String>? username,
    Expression<String>? pinSalt,
    Expression<String>? pinHash,
    Expression<String>? certificatePem,
    Expression<String>? privateKeyPem,
    Expression<String>? mcpToken,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (username != null) 'username': username,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinHash != null) 'pin_hash': pinHash,
      if (certificatePem != null) 'certificate_pem': certificatePem,
      if (privateKeyPem != null) 'private_key_pem': privateKeyPem,
      if (mcpToken != null) 'mcp_token': mcpToken,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IdentityRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? deviceName,
    Value<String>? username,
    Value<String>? pinSalt,
    Value<String>? pinHash,
    Value<String>? certificatePem,
    Value<String>? privateKeyPem,
    Value<String>? mcpToken,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return IdentityRecordsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      username: username ?? this.username,
      pinSalt: pinSalt ?? this.pinSalt,
      pinHash: pinHash ?? this.pinHash,
      certificatePem: certificatePem ?? this.certificatePem,
      privateKeyPem: privateKeyPem ?? this.privateKeyPem,
      mcpToken: mcpToken ?? this.mcpToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (certificatePem.present) {
      map['certificate_pem'] = Variable<String>(certificatePem.value);
    }
    if (privateKeyPem.present) {
      map['private_key_pem'] = Variable<String>(privateKeyPem.value);
    }
    if (mcpToken.present) {
      map['mcp_token'] = Variable<String>(mcpToken.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentityRecordsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('username: $username, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinHash: $pinHash, ')
          ..write('certificatePem: $certificatePem, ')
          ..write('privateKeyPem: $privateKeyPem, ')
          ..write('mcpToken: $mcpToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PairedDeviceRecordsTable extends PairedDeviceRecords
    with TableInfo<$PairedDeviceRecordsTable, PairedDeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairedDeviceRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _certificateFingerprintMeta =
      const VerificationMeta('certificateFingerprint');
  @override
  late final GeneratedColumn<String> certificateFingerprint =
      GeneratedColumn<String>(
        'certificate_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sharedKeyMeta = const VerificationMeta(
    'sharedKey',
  );
  @override
  late final GeneratedColumn<String> sharedKey = GeneratedColumn<String>(
    'shared_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    username,
    certificateFingerprint,
    sharedKey,
    host,
    port,
    lastSeenAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paired_device_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PairedDeviceRow> instance, {
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
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('certificate_fingerprint')) {
      context.handle(
        _certificateFingerprintMeta,
        certificateFingerprint.isAcceptableOrUnknown(
          data['certificate_fingerprint']!,
          _certificateFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_certificateFingerprintMeta);
    }
    if (data.containsKey('shared_key')) {
      context.handle(
        _sharedKeyMeta,
        sharedKey.isAcceptableOrUnknown(data['shared_key']!, _sharedKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sharedKeyMeta);
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PairedDeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PairedDeviceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      certificateFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}certificate_fingerprint'],
      )!,
      sharedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_key'],
      )!,
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PairedDeviceRecordsTable createAlias(String alias) {
    return $PairedDeviceRecordsTable(attachedDatabase, alias);
  }
}

class PairedDeviceRow extends DataClass implements Insertable<PairedDeviceRow> {
  final String id;
  final String name;
  final String username;
  final String certificateFingerprint;
  final String sharedKey;
  final String host;
  final int port;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PairedDeviceRow({
    required this.id,
    required this.name,
    required this.username,
    required this.certificateFingerprint,
    required this.sharedKey,
    required this.host,
    required this.port,
    this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['username'] = Variable<String>(username);
    map['certificate_fingerprint'] = Variable<String>(certificateFingerprint);
    map['shared_key'] = Variable<String>(sharedKey);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PairedDeviceRecordsCompanion toCompanion(bool nullToAbsent) {
    return PairedDeviceRecordsCompanion(
      id: Value(id),
      name: Value(name),
      username: Value(username),
      certificateFingerprint: Value(certificateFingerprint),
      sharedKey: Value(sharedKey),
      host: Value(host),
      port: Value(port),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PairedDeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PairedDeviceRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      username: serializer.fromJson<String>(json['username']),
      certificateFingerprint: serializer.fromJson<String>(
        json['certificateFingerprint'],
      ),
      sharedKey: serializer.fromJson<String>(json['sharedKey']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'username': serializer.toJson<String>(username),
      'certificateFingerprint': serializer.toJson<String>(
        certificateFingerprint,
      ),
      'sharedKey': serializer.toJson<String>(sharedKey),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PairedDeviceRow copyWith({
    String? id,
    String? name,
    String? username,
    String? certificateFingerprint,
    String? sharedKey,
    String? host,
    int? port,
    Value<DateTime?> lastSeenAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PairedDeviceRow(
    id: id ?? this.id,
    name: name ?? this.name,
    username: username ?? this.username,
    certificateFingerprint:
        certificateFingerprint ?? this.certificateFingerprint,
    sharedKey: sharedKey ?? this.sharedKey,
    host: host ?? this.host,
    port: port ?? this.port,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PairedDeviceRow copyWithCompanion(PairedDeviceRecordsCompanion data) {
    return PairedDeviceRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      certificateFingerprint: data.certificateFingerprint.present
          ? data.certificateFingerprint.value
          : this.certificateFingerprint,
      sharedKey: data.sharedKey.present ? data.sharedKey.value : this.sharedKey,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PairedDeviceRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('certificateFingerprint: $certificateFingerprint, ')
          ..write('sharedKey: $sharedKey, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    username,
    certificateFingerprint,
    sharedKey,
    host,
    port,
    lastSeenAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PairedDeviceRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.username == this.username &&
          other.certificateFingerprint == this.certificateFingerprint &&
          other.sharedKey == this.sharedKey &&
          other.host == this.host &&
          other.port == this.port &&
          other.lastSeenAt == this.lastSeenAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PairedDeviceRecordsCompanion extends UpdateCompanion<PairedDeviceRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> username;
  final Value<String> certificateFingerprint;
  final Value<String> sharedKey;
  final Value<String> host;
  final Value<int> port;
  final Value<DateTime?> lastSeenAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PairedDeviceRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.certificateFingerprint = const Value.absent(),
    this.sharedKey = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PairedDeviceRecordsCompanion.insert({
    required String id,
    required String name,
    required String username,
    required String certificateFingerprint,
    required String sharedKey,
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       username = Value(username),
       certificateFingerprint = Value(certificateFingerprint),
       sharedKey = Value(sharedKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PairedDeviceRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? certificateFingerprint,
    Expression<String>? sharedKey,
    Expression<String>? host,
    Expression<int>? port,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (certificateFingerprint != null)
        'certificate_fingerprint': certificateFingerprint,
      if (sharedKey != null) 'shared_key': sharedKey,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PairedDeviceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? username,
    Value<String>? certificateFingerprint,
    Value<String>? sharedKey,
    Value<String>? host,
    Value<int>? port,
    Value<DateTime?>? lastSeenAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PairedDeviceRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      certificateFingerprint:
          certificateFingerprint ?? this.certificateFingerprint,
      sharedKey: sharedKey ?? this.sharedKey,
      host: host ?? this.host,
      port: port ?? this.port,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (certificateFingerprint.present) {
      map['certificate_fingerprint'] = Variable<String>(
        certificateFingerprint.value,
      );
    }
    if (sharedKey.present) {
      map['shared_key'] = Variable<String>(sharedKey.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairedDeviceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('certificateFingerprint: $certificateFingerprint, ')
          ..write('sharedKey: $sharedKey, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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

class $HomePurchaseRecordsTable extends HomePurchaseRecords
    with TableInfo<$HomePurchaseRecordsTable, HomePurchaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomePurchaseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeItemIdMeta = const VerificationMeta(
    'homeItemId',
  );
  @override
  late final GeneratedColumn<String> homeItemId = GeneratedColumn<String>(
    'home_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES home_item_records (id)',
    ),
  );
  static const VerificationMeta _shoppingItemIdMeta = const VerificationMeta(
    'shoppingItemId',
  );
  @override
  late final GeneratedColumn<String> shoppingItemId = GeneratedColumn<String>(
    'shopping_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_item_records (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeItemId,
    shoppingItemId,
    quantity,
    note,
    purchasedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_purchase_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomePurchaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('home_item_id')) {
      context.handle(
        _homeItemIdMeta,
        homeItemId.isAcceptableOrUnknown(
          data['home_item_id']!,
          _homeItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeItemIdMeta);
    }
    if (data.containsKey('shopping_item_id')) {
      context.handle(
        _shoppingItemIdMeta,
        shoppingItemId.isAcceptableOrUnknown(
          data['shopping_item_id']!,
          _shoppingItemIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HomePurchaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomePurchaseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      homeItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_item_id'],
      )!,
      shoppingItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shopping_item_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
    );
  }

  @override
  $HomePurchaseRecordsTable createAlias(String alias) {
    return $HomePurchaseRecordsTable(attachedDatabase, alias);
  }
}

class HomePurchaseRow extends DataClass implements Insertable<HomePurchaseRow> {
  final String id;
  final String homeItemId;
  final String? shoppingItemId;
  final double quantity;
  final String note;
  final DateTime purchasedAt;
  const HomePurchaseRow({
    required this.id,
    required this.homeItemId,
    this.shoppingItemId,
    required this.quantity,
    required this.note,
    required this.purchasedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['home_item_id'] = Variable<String>(homeItemId);
    if (!nullToAbsent || shoppingItemId != null) {
      map['shopping_item_id'] = Variable<String>(shoppingItemId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['note'] = Variable<String>(note);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    return map;
  }

  HomePurchaseRecordsCompanion toCompanion(bool nullToAbsent) {
    return HomePurchaseRecordsCompanion(
      id: Value(id),
      homeItemId: Value(homeItemId),
      shoppingItemId: shoppingItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(shoppingItemId),
      quantity: Value(quantity),
      note: Value(note),
      purchasedAt: Value(purchasedAt),
    );
  }

  factory HomePurchaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomePurchaseRow(
      id: serializer.fromJson<String>(json['id']),
      homeItemId: serializer.fromJson<String>(json['homeItemId']),
      shoppingItemId: serializer.fromJson<String?>(json['shoppingItemId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      note: serializer.fromJson<String>(json['note']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'homeItemId': serializer.toJson<String>(homeItemId),
      'shoppingItemId': serializer.toJson<String?>(shoppingItemId),
      'quantity': serializer.toJson<double>(quantity),
      'note': serializer.toJson<String>(note),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
    };
  }

  HomePurchaseRow copyWith({
    String? id,
    String? homeItemId,
    Value<String?> shoppingItemId = const Value.absent(),
    double? quantity,
    String? note,
    DateTime? purchasedAt,
  }) => HomePurchaseRow(
    id: id ?? this.id,
    homeItemId: homeItemId ?? this.homeItemId,
    shoppingItemId: shoppingItemId.present
        ? shoppingItemId.value
        : this.shoppingItemId,
    quantity: quantity ?? this.quantity,
    note: note ?? this.note,
    purchasedAt: purchasedAt ?? this.purchasedAt,
  );
  HomePurchaseRow copyWithCompanion(HomePurchaseRecordsCompanion data) {
    return HomePurchaseRow(
      id: data.id.present ? data.id.value : this.id,
      homeItemId: data.homeItemId.present
          ? data.homeItemId.value
          : this.homeItemId,
      shoppingItemId: data.shoppingItemId.present
          ? data.shoppingItemId.value
          : this.shoppingItemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomePurchaseRow(')
          ..write('id: $id, ')
          ..write('homeItemId: $homeItemId, ')
          ..write('shoppingItemId: $shoppingItemId, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, homeItemId, shoppingItemId, quantity, note, purchasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomePurchaseRow &&
          other.id == this.id &&
          other.homeItemId == this.homeItemId &&
          other.shoppingItemId == this.shoppingItemId &&
          other.quantity == this.quantity &&
          other.note == this.note &&
          other.purchasedAt == this.purchasedAt);
}

class HomePurchaseRecordsCompanion extends UpdateCompanion<HomePurchaseRow> {
  final Value<String> id;
  final Value<String> homeItemId;
  final Value<String?> shoppingItemId;
  final Value<double> quantity;
  final Value<String> note;
  final Value<DateTime> purchasedAt;
  final Value<int> rowid;
  const HomePurchaseRecordsCompanion({
    this.id = const Value.absent(),
    this.homeItemId = const Value.absent(),
    this.shoppingItemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HomePurchaseRecordsCompanion.insert({
    required String id,
    required String homeItemId,
    this.shoppingItemId = const Value.absent(),
    required double quantity,
    this.note = const Value.absent(),
    required DateTime purchasedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       homeItemId = Value(homeItemId),
       quantity = Value(quantity),
       purchasedAt = Value(purchasedAt);
  static Insertable<HomePurchaseRow> custom({
    Expression<String>? id,
    Expression<String>? homeItemId,
    Expression<String>? shoppingItemId,
    Expression<double>? quantity,
    Expression<String>? note,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeItemId != null) 'home_item_id': homeItemId,
      if (shoppingItemId != null) 'shopping_item_id': shoppingItemId,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HomePurchaseRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? homeItemId,
    Value<String?>? shoppingItemId,
    Value<double>? quantity,
    Value<String>? note,
    Value<DateTime>? purchasedAt,
    Value<int>? rowid,
  }) {
    return HomePurchaseRecordsCompanion(
      id: id ?? this.id,
      homeItemId: homeItemId ?? this.homeItemId,
      shoppingItemId: shoppingItemId ?? this.shoppingItemId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (homeItemId.present) {
      map['home_item_id'] = Variable<String>(homeItemId.value);
    }
    if (shoppingItemId.present) {
      map['shopping_item_id'] = Variable<String>(shoppingItemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomePurchaseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('homeItemId: $homeItemId, ')
          ..write('shoppingItemId: $shoppingItemId, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('purchasedAt: $purchasedAt, ')
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
  late final $TagRecordsTable tagRecords = $TagRecordsTable(this);
  late final $EntryTagRecordsTable entryTagRecords = $EntryTagRecordsTable(
    this,
  );
  late final $CompletionRecordsTable completionRecords =
      $CompletionRecordsTable(this);
  late final $ReminderRecordsTable reminderRecords = $ReminderRecordsTable(
    this,
  );
  late final $ShiftPatternRecordsTable shiftPatternRecords =
      $ShiftPatternRecordsTable(this);
  late final $ShiftSlotRecordsTable shiftSlotRecords = $ShiftSlotRecordsTable(
    this,
  );
  late final $ShiftPatternTagRecordsTable shiftPatternTagRecords =
      $ShiftPatternTagRecordsTable(this);
  late final $ShiftExceptionRecordsTable shiftExceptionRecords =
      $ShiftExceptionRecordsTable(this);
  late final $ShiftChecklistItemRecordsTable shiftChecklistItemRecords =
      $ShiftChecklistItemRecordsTable(this);
  late final $ShiftChecklistCompletionRecordsTable
  shiftChecklistCompletionRecords = $ShiftChecklistCompletionRecordsTable(this);
  late final $HomeItemRecordsTable homeItemRecords = $HomeItemRecordsTable(
    this,
  );
  late final $ShoppingItemRecordsTable shoppingItemRecords =
      $ShoppingItemRecordsTable(this);
  late final $IdentityRecordsTable identityRecords = $IdentityRecordsTable(
    this,
  );
  late final $PairedDeviceRecordsTable pairedDeviceRecords =
      $PairedDeviceRecordsTable(this);
  late final $SettingRecordsTable settingRecords = $SettingRecordsTable(this);
  late final $HomePurchaseRecordsTable homePurchaseRecords =
      $HomePurchaseRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    spaceRecords,
    entryRecords,
    tagRecords,
    entryTagRecords,
    completionRecords,
    reminderRecords,
    shiftPatternRecords,
    shiftSlotRecords,
    shiftPatternTagRecords,
    shiftExceptionRecords,
    shiftChecklistItemRecords,
    shiftChecklistCompletionRecords,
    homeItemRecords,
    shoppingItemRecords,
    identityRecords,
    pairedDeviceRecords,
    settingRecords,
    homePurchaseRecords,
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

  static MultiTypedResultKey<$TagRecordsTable, List<TagRow>>
  _tagRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tagRecords,
    aliasName: $_aliasNameGenerator(db.spaceRecords.id, db.tagRecords.spaceId),
  );

  $$TagRecordsTableProcessedTableManager get tagRecordsRefs {
    final manager = $$TagRecordsTableTableManager(
      $_db,
      $_db.tagRecords,
    ).filter((f) => f.spaceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagRecordsRefsTable($_db));
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

  Expression<bool> tagRecordsRefs(
    Expression<bool> Function($$TagRecordsTableFilterComposer f) f,
  ) {
    final $$TagRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableFilterComposer(
            $db: $db,
            $table: $db.tagRecords,
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

  Expression<T> tagRecordsRefs<T extends Object>(
    Expression<T> Function($$TagRecordsTableAnnotationComposer a) f,
  ) {
    final $$TagRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.spaceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.tagRecords,
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
            bool tagRecordsRefs,
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
              ({
                entryRecordsRefs = false,
                tagRecordsRefs = false,
                shiftPatternRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entryRecordsRefs) db.entryRecords,
                    if (tagRecordsRefs) db.tagRecords,
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
                      if (tagRecordsRefs)
                        await $_getPrefetchedData<
                          SpaceRow,
                          $SpaceRecordsTable,
                          TagRow
                        >(
                          currentTable: table,
                          referencedTable: $$SpaceRecordsTableReferences
                              ._tagRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpaceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).tagRecordsRefs,
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
        bool tagRecordsRefs,
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
      Value<String?> timeZone,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<bool> allDay,
      required String status,
      Value<String?> recurrenceJson,
      Value<String?> source,
      Value<String?> externalId,
      Value<bool> readOnly,
      Value<DateTime?> lastCompletedAt,
      Value<int?> repeatAfterCompletionDays,
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
      Value<String?> timeZone,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<bool> allDay,
      Value<String> status,
      Value<String?> recurrenceJson,
      Value<String?> source,
      Value<String?> externalId,
      Value<bool> readOnly,
      Value<DateTime?> lastCompletedAt,
      Value<int?> repeatAfterCompletionDays,
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

  static MultiTypedResultKey<$EntryTagRecordsTable, List<EntryTagRow>>
  _entryTagRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entryTagRecords,
    aliasName: $_aliasNameGenerator(
      db.entryRecords.id,
      db.entryTagRecords.entryId,
    ),
  );

  $$EntryTagRecordsTableProcessedTableManager get entryTagRecordsRefs {
    final manager = $$EntryTagRecordsTableTableManager(
      $_db,
      $_db.entryTagRecords,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _entryTagRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
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

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get readOnly => $composableBuilder(
    column: $table.readOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatAfterCompletionDays => $composableBuilder(
    column: $table.repeatAfterCompletionDays,
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

  Expression<bool> entryTagRecordsRefs(
    Expression<bool> Function($$EntryTagRecordsTableFilterComposer f) f,
  ) {
    final $$EntryTagRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryTagRecords,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryTagRecordsTableFilterComposer(
            $db: $db,
            $table: $db.entryTagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get readOnly => $composableBuilder(
    column: $table.readOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatAfterCompletionDays => $composableBuilder(
    column: $table.repeatAfterCompletionDays,
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

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get readOnly =>
      $composableBuilder(column: $table.readOnly, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedAt => $composableBuilder(
    column: $table.lastCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatAfterCompletionDays => $composableBuilder(
    column: $table.repeatAfterCompletionDays,
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

  Expression<T> entryTagRecordsRefs<T extends Object>(
    Expression<T> Function($$EntryTagRecordsTableAnnotationComposer a) f,
  ) {
    final $$EntryTagRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryTagRecords,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryTagRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.entryTagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
            bool entryTagRecordsRefs,
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
                Value<String?> timeZone = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> recurrenceJson = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> readOnly = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int?> repeatAfterCompletionDays = const Value.absent(),
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
                timeZone: timeZone,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                status: status,
                recurrenceJson: recurrenceJson,
                source: source,
                externalId: externalId,
                readOnly: readOnly,
                lastCompletedAt: lastCompletedAt,
                repeatAfterCompletionDays: repeatAfterCompletionDays,
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
                Value<String?> timeZone = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                required String status,
                Value<String?> recurrenceJson = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<bool> readOnly = const Value.absent(),
                Value<DateTime?> lastCompletedAt = const Value.absent(),
                Value<int?> repeatAfterCompletionDays = const Value.absent(),
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
                timeZone: timeZone,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                status: status,
                recurrenceJson: recurrenceJson,
                source: source,
                externalId: externalId,
                readOnly: readOnly,
                lastCompletedAt: lastCompletedAt,
                repeatAfterCompletionDays: repeatAfterCompletionDays,
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
                entryTagRecordsRefs = false,
                completionRecordsRefs = false,
                reminderRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entryTagRecordsRefs) db.entryTagRecords,
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
                      if (entryTagRecordsRefs)
                        await $_getPrefetchedData<
                          EntryRow,
                          $EntryRecordsTable,
                          EntryTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$EntryRecordsTableReferences
                              ._entryTagRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EntryRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).entryTagRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
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
        bool entryTagRecordsRefs,
        bool completionRecordsRefs,
        bool reminderRecordsRefs,
      })
    >;
typedef $$TagRecordsTableCreateCompanionBuilder =
    TagRecordsCompanion Function({
      required String id,
      Value<String?> spaceId,
      required String name,
      required int color,
      Value<int> position,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TagRecordsTableUpdateCompanionBuilder =
    TagRecordsCompanion Function({
      Value<String> id,
      Value<String?> spaceId,
      Value<String> name,
      Value<int> color,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TagRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $TagRecordsTable, TagRow> {
  $$TagRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SpaceRecordsTable _spaceIdTable(_$AppDatabase db) =>
      db.spaceRecords.createAlias(
        $_aliasNameGenerator(db.tagRecords.spaceId, db.spaceRecords.id),
      );

  $$SpaceRecordsTableProcessedTableManager? get spaceId {
    final $_column = $_itemColumn<String>('space_id');
    if ($_column == null) return null;
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

  static MultiTypedResultKey<$EntryTagRecordsTable, List<EntryTagRow>>
  _entryTagRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.entryTagRecords,
    aliasName: $_aliasNameGenerator(db.tagRecords.id, db.entryTagRecords.tagId),
  );

  $$EntryTagRecordsTableProcessedTableManager get entryTagRecordsRefs {
    final manager = $$EntryTagRecordsTableTableManager(
      $_db,
      $_db.entryTagRecords,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _entryTagRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftPatternTagRecordsTable,
    List<ShiftPatternTagRow>
  >
  _shiftPatternTagRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternTagRecords,
        aliasName: $_aliasNameGenerator(
          db.tagRecords.id,
          db.shiftPatternTagRecords.tagId,
        ),
      );

  $$ShiftPatternTagRecordsTableProcessedTableManager
  get shiftPatternTagRecordsRefs {
    final manager = $$ShiftPatternTagRecordsTableTableManager(
      $_db,
      $_db.shiftPatternTagRecords,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternTagRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TagRecordsTable> {
  $$TagRecordsTableFilterComposer({
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

  Expression<bool> entryTagRecordsRefs(
    Expression<bool> Function($$EntryTagRecordsTableFilterComposer f) f,
  ) {
    final $$EntryTagRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryTagRecords,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryTagRecordsTableFilterComposer(
            $db: $db,
            $table: $db.entryTagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shiftPatternTagRecordsRefs(
    Expression<bool> Function($$ShiftPatternTagRecordsTableFilterComposer f) f,
  ) {
    final $$ShiftPatternTagRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternTagRecords,
          getReferencedColumn: (t) => t.tagId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternTagRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftPatternTagRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TagRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TagRecordsTable> {
  $$TagRecordsTableOrderingComposer({
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

class $$TagRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagRecordsTable> {
  $$TagRecordsTableAnnotationComposer({
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

  Expression<T> entryTagRecordsRefs<T extends Object>(
    Expression<T> Function($$EntryTagRecordsTableAnnotationComposer a) f,
  ) {
    final $$EntryTagRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entryTagRecords,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntryTagRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.entryTagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shiftPatternTagRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternTagRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShiftPatternTagRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternTagRecords,
          getReferencedColumn: (t) => t.tagId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternTagRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternTagRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TagRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagRecordsTable,
          TagRow,
          $$TagRecordsTableFilterComposer,
          $$TagRecordsTableOrderingComposer,
          $$TagRecordsTableAnnotationComposer,
          $$TagRecordsTableCreateCompanionBuilder,
          $$TagRecordsTableUpdateCompanionBuilder,
          (TagRow, $$TagRecordsTableReferences),
          TagRow,
          PrefetchHooks Function({
            bool spaceId,
            bool entryTagRecordsRefs,
            bool shiftPatternTagRecordsRefs,
          })
        > {
  $$TagRecordsTableTableManager(_$AppDatabase db, $TagRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> spaceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagRecordsCompanion(
                id: id,
                spaceId: spaceId,
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
                Value<String?> spaceId = const Value.absent(),
                required String name,
                required int color,
                Value<int> position = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagRecordsCompanion.insert(
                id: id,
                spaceId: spaceId,
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
                  $$TagRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                spaceId = false,
                entryTagRecordsRefs = false,
                shiftPatternTagRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (entryTagRecordsRefs) db.entryTagRecords,
                    if (shiftPatternTagRecordsRefs) db.shiftPatternTagRecords,
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
                                    referencedTable: $$TagRecordsTableReferences
                                        ._spaceIdTable(db),
                                    referencedColumn:
                                        $$TagRecordsTableReferences
                                            ._spaceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (entryTagRecordsRefs)
                        await $_getPrefetchedData<
                          TagRow,
                          $TagRecordsTable,
                          EntryTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$TagRecordsTableReferences
                              ._entryTagRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TagRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).entryTagRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftPatternTagRecordsRefs)
                        await $_getPrefetchedData<
                          TagRow,
                          $TagRecordsTable,
                          ShiftPatternTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$TagRecordsTableReferences
                              ._shiftPatternTagRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TagRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternTagRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
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

typedef $$TagRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagRecordsTable,
      TagRow,
      $$TagRecordsTableFilterComposer,
      $$TagRecordsTableOrderingComposer,
      $$TagRecordsTableAnnotationComposer,
      $$TagRecordsTableCreateCompanionBuilder,
      $$TagRecordsTableUpdateCompanionBuilder,
      (TagRow, $$TagRecordsTableReferences),
      TagRow,
      PrefetchHooks Function({
        bool spaceId,
        bool entryTagRecordsRefs,
        bool shiftPatternTagRecordsRefs,
      })
    >;
typedef $$EntryTagRecordsTableCreateCompanionBuilder =
    EntryTagRecordsCompanion Function({
      required String entryId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$EntryTagRecordsTableUpdateCompanionBuilder =
    EntryTagRecordsCompanion Function({
      Value<String> entryId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$EntryTagRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $EntryTagRecordsTable, EntryTagRow> {
  $$EntryTagRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EntryRecordsTable _entryIdTable(_$AppDatabase db) =>
      db.entryRecords.createAlias(
        $_aliasNameGenerator(db.entryTagRecords.entryId, db.entryRecords.id),
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

  static $TagRecordsTable _tagIdTable(_$AppDatabase db) =>
      db.tagRecords.createAlias(
        $_aliasNameGenerator(db.entryTagRecords.tagId, db.tagRecords.id),
      );

  $$TagRecordsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagRecordsTableTableManager(
      $_db,
      $_db.tagRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntryTagRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $EntryTagRecordsTable> {
  $$EntryTagRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagRecordsTableFilterComposer get tagId {
    final $$TagRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableFilterComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryTagRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntryTagRecordsTable> {
  $$EntryTagRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagRecordsTableOrderingComposer get tagId {
    final $$TagRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryTagRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntryTagRecordsTable> {
  $$EntryTagRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$TagRecordsTableAnnotationComposer get tagId {
    final $$TagRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntryTagRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntryTagRecordsTable,
          EntryTagRow,
          $$EntryTagRecordsTableFilterComposer,
          $$EntryTagRecordsTableOrderingComposer,
          $$EntryTagRecordsTableAnnotationComposer,
          $$EntryTagRecordsTableCreateCompanionBuilder,
          $$EntryTagRecordsTableUpdateCompanionBuilder,
          (EntryTagRow, $$EntryTagRecordsTableReferences),
          EntryTagRow,
          PrefetchHooks Function({bool entryId, bool tagId})
        > {
  $$EntryTagRecordsTableTableManager(
    _$AppDatabase db,
    $EntryTagRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntryTagRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntryTagRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntryTagRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entryId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryTagRecordsCompanion(
                entryId: entryId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entryId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => EntryTagRecordsCompanion.insert(
                entryId: entryId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntryTagRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, tagId = false}) {
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
                                    $$EntryTagRecordsTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$EntryTagRecordsTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable:
                                    $$EntryTagRecordsTableReferences
                                        ._tagIdTable(db),
                                referencedColumn:
                                    $$EntryTagRecordsTableReferences
                                        ._tagIdTable(db)
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

typedef $$EntryTagRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntryTagRecordsTable,
      EntryTagRow,
      $$EntryTagRecordsTableFilterComposer,
      $$EntryTagRecordsTableOrderingComposer,
      $$EntryTagRecordsTableAnnotationComposer,
      $$EntryTagRecordsTableCreateCompanionBuilder,
      $$EntryTagRecordsTableUpdateCompanionBuilder,
      (EntryTagRow, $$EntryTagRecordsTableReferences),
      EntryTagRow,
      PrefetchHooks Function({bool entryId, bool tagId})
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
      Value<String> timeZone,
      required int cycleDays,
      required int anchorDateKey,
      Value<int?> commuteMinutes,
      Value<int?> windDownMinutes,
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
      Value<String> timeZone,
      Value<int> cycleDays,
      Value<int> anchorDateKey,
      Value<int?> commuteMinutes,
      Value<int?> windDownMinutes,
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

  static MultiTypedResultKey<$ShiftSlotRecordsTable, List<ShiftSlotRow>>
  _shiftSlotRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shiftSlotRecords,
    aliasName: $_aliasNameGenerator(
      db.shiftPatternRecords.id,
      db.shiftSlotRecords.patternId,
    ),
  );

  $$ShiftSlotRecordsTableProcessedTableManager get shiftSlotRecordsRefs {
    final manager = $$ShiftSlotRecordsTableTableManager(
      $_db,
      $_db.shiftSlotRecords,
    ).filter((f) => f.patternId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftSlotRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftPatternTagRecordsTable,
    List<ShiftPatternTagRow>
  >
  _shiftPatternTagRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftPatternTagRecords,
        aliasName: $_aliasNameGenerator(
          db.shiftPatternRecords.id,
          db.shiftPatternTagRecords.patternId,
        ),
      );

  $$ShiftPatternTagRecordsTableProcessedTableManager
  get shiftPatternTagRecordsRefs {
    final manager = $$ShiftPatternTagRecordsTableTableManager(
      $_db,
      $_db.shiftPatternTagRecords,
    ).filter((f) => f.patternId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftPatternTagRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftExceptionRecordsTable,
    List<ShiftExceptionRow>
  >
  _shiftExceptionRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftExceptionRecords,
        aliasName: $_aliasNameGenerator(
          db.shiftPatternRecords.id,
          db.shiftExceptionRecords.patternId,
        ),
      );

  $$ShiftExceptionRecordsTableProcessedTableManager
  get shiftExceptionRecordsRefs {
    final manager = $$ShiftExceptionRecordsTableTableManager(
      $_db,
      $_db.shiftExceptionRecords,
    ).filter((f) => f.patternId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftExceptionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ShiftChecklistItemRecordsTable,
    List<ShiftChecklistItemRow>
  >
  _shiftChecklistItemRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftChecklistItemRecords,
        aliasName: $_aliasNameGenerator(
          db.shiftPatternRecords.id,
          db.shiftChecklistItemRecords.patternId,
        ),
      );

  $$ShiftChecklistItemRecordsTableProcessedTableManager
  get shiftChecklistItemRecordsRefs {
    final manager = $$ShiftChecklistItemRecordsTableTableManager(
      $_db,
      $_db.shiftChecklistItemRecords,
    ).filter((f) => f.patternId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftChecklistItemRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
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

  ColumnFilters<int> get commuteMinutes => $composableBuilder(
    column: $table.commuteMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
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

  Expression<bool> shiftSlotRecordsRefs(
    Expression<bool> Function($$ShiftSlotRecordsTableFilterComposer f) f,
  ) {
    final $$ShiftSlotRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftSlotRecords,
      getReferencedColumn: (t) => t.patternId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftSlotRecordsTableFilterComposer(
            $db: $db,
            $table: $db.shiftSlotRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shiftPatternTagRecordsRefs(
    Expression<bool> Function($$ShiftPatternTagRecordsTableFilterComposer f) f,
  ) {
    final $$ShiftPatternTagRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternTagRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternTagRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftPatternTagRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> shiftExceptionRecordsRefs(
    Expression<bool> Function($$ShiftExceptionRecordsTableFilterComposer f) f,
  ) {
    final $$ShiftExceptionRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftExceptionRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftExceptionRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftExceptionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> shiftChecklistItemRecordsRefs(
    Expression<bool> Function($$ShiftChecklistItemRecordsTableFilterComposer f)
    f,
  ) {
    final $$ShiftChecklistItemRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftChecklistItemRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistItemRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftChecklistItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
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

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
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

  ColumnOrderings<int> get commuteMinutes => $composableBuilder(
    column: $table.commuteMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
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

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<int> get cycleDays =>
      $composableBuilder(column: $table.cycleDays, builder: (column) => column);

  GeneratedColumn<int> get anchorDateKey => $composableBuilder(
    column: $table.anchorDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get commuteMinutes => $composableBuilder(
    column: $table.commuteMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => column,
  );

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

  Expression<T> shiftSlotRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftSlotRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShiftSlotRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shiftSlotRecords,
      getReferencedColumn: (t) => t.patternId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftSlotRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftSlotRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shiftPatternTagRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftPatternTagRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShiftPatternTagRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftPatternTagRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternTagRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftPatternTagRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftExceptionRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftExceptionRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShiftExceptionRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftExceptionRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftExceptionRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftExceptionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> shiftChecklistItemRecordsRefs<T extends Object>(
    Expression<T> Function($$ShiftChecklistItemRecordsTableAnnotationComposer a)
    f,
  ) {
    final $$ShiftChecklistItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftChecklistItemRecords,
          getReferencedColumn: (t) => t.patternId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftChecklistItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
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
          PrefetchHooks Function({
            bool spaceId,
            bool shiftSlotRecordsRefs,
            bool shiftPatternTagRecordsRefs,
            bool shiftExceptionRecordsRefs,
            bool shiftChecklistItemRecordsRefs,
          })
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
                Value<String> timeZone = const Value.absent(),
                Value<int> cycleDays = const Value.absent(),
                Value<int> anchorDateKey = const Value.absent(),
                Value<int?> commuteMinutes = const Value.absent(),
                Value<int?> windDownMinutes = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternRecordsCompanion(
                id: id,
                spaceId: spaceId,
                name: name,
                timeZone: timeZone,
                cycleDays: cycleDays,
                anchorDateKey: anchorDateKey,
                commuteMinutes: commuteMinutes,
                windDownMinutes: windDownMinutes,
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
                Value<String> timeZone = const Value.absent(),
                required int cycleDays,
                required int anchorDateKey,
                Value<int?> commuteMinutes = const Value.absent(),
                Value<int?> windDownMinutes = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternRecordsCompanion.insert(
                id: id,
                spaceId: spaceId,
                name: name,
                timeZone: timeZone,
                cycleDays: cycleDays,
                anchorDateKey: anchorDateKey,
                commuteMinutes: commuteMinutes,
                windDownMinutes: windDownMinutes,
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
          prefetchHooksCallback:
              ({
                spaceId = false,
                shiftSlotRecordsRefs = false,
                shiftPatternTagRecordsRefs = false,
                shiftExceptionRecordsRefs = false,
                shiftChecklistItemRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftSlotRecordsRefs) db.shiftSlotRecords,
                    if (shiftPatternTagRecordsRefs) db.shiftPatternTagRecords,
                    if (shiftExceptionRecordsRefs) db.shiftExceptionRecords,
                    if (shiftChecklistItemRecordsRefs)
                      db.shiftChecklistItemRecords,
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
                    return [
                      if (shiftSlotRecordsRefs)
                        await $_getPrefetchedData<
                          ShiftPatternRow,
                          $ShiftPatternRecordsTable,
                          ShiftSlotRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftPatternRecordsTableReferences
                              ._shiftSlotRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftPatternRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftSlotRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patternId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftPatternTagRecordsRefs)
                        await $_getPrefetchedData<
                          ShiftPatternRow,
                          $ShiftPatternRecordsTable,
                          ShiftPatternTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftPatternRecordsTableReferences
                              ._shiftPatternTagRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftPatternRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftPatternTagRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patternId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftExceptionRecordsRefs)
                        await $_getPrefetchedData<
                          ShiftPatternRow,
                          $ShiftPatternRecordsTable,
                          ShiftExceptionRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftPatternRecordsTableReferences
                              ._shiftExceptionRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftPatternRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftExceptionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patternId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shiftChecklistItemRecordsRefs)
                        await $_getPrefetchedData<
                          ShiftPatternRow,
                          $ShiftPatternRecordsTable,
                          ShiftChecklistItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftPatternRecordsTableReferences
                              ._shiftChecklistItemRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftPatternRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftChecklistItemRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patternId == item.id,
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
      PrefetchHooks Function({
        bool spaceId,
        bool shiftSlotRecordsRefs,
        bool shiftPatternTagRecordsRefs,
        bool shiftExceptionRecordsRefs,
        bool shiftChecklistItemRecordsRefs,
      })
    >;
typedef $$ShiftSlotRecordsTableCreateCompanionBuilder =
    ShiftSlotRecordsCompanion Function({
      Value<int> id,
      required String patternId,
      required int dayIndex,
      Value<String> label,
      required int startMinute,
      required int endMinute,
    });
typedef $$ShiftSlotRecordsTableUpdateCompanionBuilder =
    ShiftSlotRecordsCompanion Function({
      Value<int> id,
      Value<String> patternId,
      Value<int> dayIndex,
      Value<String> label,
      Value<int> startMinute,
      Value<int> endMinute,
    });

final class $$ShiftSlotRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShiftSlotRecordsTable, ShiftSlotRow> {
  $$ShiftSlotRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftPatternRecordsTable _patternIdTable(_$AppDatabase db) =>
      db.shiftPatternRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftSlotRecords.patternId,
          db.shiftPatternRecords.id,
        ),
      );

  $$ShiftPatternRecordsTableProcessedTableManager get patternId {
    final $_column = $_itemColumn<String>('pattern_id')!;

    final manager = $$ShiftPatternRecordsTableTableManager(
      $_db,
      $_db.shiftPatternRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patternIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftSlotRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftSlotRecordsTable> {
  $$ShiftSlotRecordsTableFilterComposer({
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

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
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

  $$ShiftPatternRecordsTableFilterComposer get patternId {
    final $$ShiftPatternRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternRecords,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$ShiftSlotRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftSlotRecordsTable> {
  $$ShiftSlotRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
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

  $$ShiftPatternRecordsTableOrderingComposer get patternId {
    final $$ShiftPatternRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shiftPatternRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftSlotRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftSlotRecordsTable> {
  $$ShiftSlotRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  $$ShiftPatternRecordsTableAnnotationComposer get patternId {
    final $$ShiftPatternRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$ShiftSlotRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftSlotRecordsTable,
          ShiftSlotRow,
          $$ShiftSlotRecordsTableFilterComposer,
          $$ShiftSlotRecordsTableOrderingComposer,
          $$ShiftSlotRecordsTableAnnotationComposer,
          $$ShiftSlotRecordsTableCreateCompanionBuilder,
          $$ShiftSlotRecordsTableUpdateCompanionBuilder,
          (ShiftSlotRow, $$ShiftSlotRecordsTableReferences),
          ShiftSlotRow,
          PrefetchHooks Function({bool patternId})
        > {
  $$ShiftSlotRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftSlotRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftSlotRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftSlotRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftSlotRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> patternId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
              }) => ShiftSlotRecordsCompanion(
                id: id,
                patternId: patternId,
                dayIndex: dayIndex,
                label: label,
                startMinute: startMinute,
                endMinute: endMinute,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String patternId,
                required int dayIndex,
                Value<String> label = const Value.absent(),
                required int startMinute,
                required int endMinute,
              }) => ShiftSlotRecordsCompanion.insert(
                id: id,
                patternId: patternId,
                dayIndex: dayIndex,
                label: label,
                startMinute: startMinute,
                endMinute: endMinute,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftSlotRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patternId = false}) {
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
                    if (patternId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patternId,
                                referencedTable:
                                    $$ShiftSlotRecordsTableReferences
                                        ._patternIdTable(db),
                                referencedColumn:
                                    $$ShiftSlotRecordsTableReferences
                                        ._patternIdTable(db)
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

typedef $$ShiftSlotRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftSlotRecordsTable,
      ShiftSlotRow,
      $$ShiftSlotRecordsTableFilterComposer,
      $$ShiftSlotRecordsTableOrderingComposer,
      $$ShiftSlotRecordsTableAnnotationComposer,
      $$ShiftSlotRecordsTableCreateCompanionBuilder,
      $$ShiftSlotRecordsTableUpdateCompanionBuilder,
      (ShiftSlotRow, $$ShiftSlotRecordsTableReferences),
      ShiftSlotRow,
      PrefetchHooks Function({bool patternId})
    >;
typedef $$ShiftPatternTagRecordsTableCreateCompanionBuilder =
    ShiftPatternTagRecordsCompanion Function({
      required String patternId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$ShiftPatternTagRecordsTableUpdateCompanionBuilder =
    ShiftPatternTagRecordsCompanion Function({
      Value<String> patternId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$ShiftPatternTagRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftPatternTagRecordsTable,
          ShiftPatternTagRow
        > {
  $$ShiftPatternTagRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftPatternRecordsTable _patternIdTable(_$AppDatabase db) =>
      db.shiftPatternRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftPatternTagRecords.patternId,
          db.shiftPatternRecords.id,
        ),
      );

  $$ShiftPatternRecordsTableProcessedTableManager get patternId {
    final $_column = $_itemColumn<String>('pattern_id')!;

    final manager = $$ShiftPatternRecordsTableTableManager(
      $_db,
      $_db.shiftPatternRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patternIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagRecordsTable _tagIdTable(_$AppDatabase db) =>
      db.tagRecords.createAlias(
        $_aliasNameGenerator(db.shiftPatternTagRecords.tagId, db.tagRecords.id),
      );

  $$TagRecordsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagRecordsTableTableManager(
      $_db,
      $_db.tagRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftPatternTagRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftPatternTagRecordsTable> {
  $$ShiftPatternTagRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ShiftPatternRecordsTableFilterComposer get patternId {
    final $$ShiftPatternRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternRecords,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$TagRecordsTableFilterComposer get tagId {
    final $$TagRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableFilterComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternTagRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftPatternTagRecordsTable> {
  $$ShiftPatternTagRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ShiftPatternRecordsTableOrderingComposer get patternId {
    final $$ShiftPatternRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shiftPatternRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TagRecordsTableOrderingComposer get tagId {
    final $$TagRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternTagRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftPatternTagRecordsTable> {
  $$ShiftPatternTagRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ShiftPatternRecordsTableAnnotationComposer get patternId {
    final $$ShiftPatternRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$TagRecordsTableAnnotationComposer get tagId {
    final $$TagRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tagRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.tagRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftPatternTagRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftPatternTagRecordsTable,
          ShiftPatternTagRow,
          $$ShiftPatternTagRecordsTableFilterComposer,
          $$ShiftPatternTagRecordsTableOrderingComposer,
          $$ShiftPatternTagRecordsTableAnnotationComposer,
          $$ShiftPatternTagRecordsTableCreateCompanionBuilder,
          $$ShiftPatternTagRecordsTableUpdateCompanionBuilder,
          (ShiftPatternTagRow, $$ShiftPatternTagRecordsTableReferences),
          ShiftPatternTagRow,
          PrefetchHooks Function({bool patternId, bool tagId})
        > {
  $$ShiftPatternTagRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftPatternTagRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftPatternTagRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftPatternTagRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftPatternTagRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> patternId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternTagRecordsCompanion(
                patternId: patternId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String patternId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => ShiftPatternTagRecordsCompanion.insert(
                patternId: patternId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftPatternTagRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patternId = false, tagId = false}) {
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
                    if (patternId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patternId,
                                referencedTable:
                                    $$ShiftPatternTagRecordsTableReferences
                                        ._patternIdTable(db),
                                referencedColumn:
                                    $$ShiftPatternTagRecordsTableReferences
                                        ._patternIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable:
                                    $$ShiftPatternTagRecordsTableReferences
                                        ._tagIdTable(db),
                                referencedColumn:
                                    $$ShiftPatternTagRecordsTableReferences
                                        ._tagIdTable(db)
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

typedef $$ShiftPatternTagRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftPatternTagRecordsTable,
      ShiftPatternTagRow,
      $$ShiftPatternTagRecordsTableFilterComposer,
      $$ShiftPatternTagRecordsTableOrderingComposer,
      $$ShiftPatternTagRecordsTableAnnotationComposer,
      $$ShiftPatternTagRecordsTableCreateCompanionBuilder,
      $$ShiftPatternTagRecordsTableUpdateCompanionBuilder,
      (ShiftPatternTagRow, $$ShiftPatternTagRecordsTableReferences),
      ShiftPatternTagRow,
      PrefetchHooks Function({bool patternId, bool tagId})
    >;
typedef $$ShiftExceptionRecordsTableCreateCompanionBuilder =
    ShiftExceptionRecordsCompanion Function({
      Value<int> id,
      required String patternId,
      required int dateKey,
      required String type,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<String> note,
    });
typedef $$ShiftExceptionRecordsTableUpdateCompanionBuilder =
    ShiftExceptionRecordsCompanion Function({
      Value<int> id,
      Value<String> patternId,
      Value<int> dateKey,
      Value<String> type,
      Value<int?> startMinute,
      Value<int?> endMinute,
      Value<String> note,
    });

final class $$ShiftExceptionRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftExceptionRecordsTable,
          ShiftExceptionRow
        > {
  $$ShiftExceptionRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftPatternRecordsTable _patternIdTable(_$AppDatabase db) =>
      db.shiftPatternRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftExceptionRecords.patternId,
          db.shiftPatternRecords.id,
        ),
      );

  $$ShiftPatternRecordsTableProcessedTableManager get patternId {
    final $_column = $_itemColumn<String>('pattern_id')!;

    final manager = $$ShiftPatternRecordsTableTableManager(
      $_db,
      $_db.shiftPatternRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patternIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftExceptionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftExceptionRecordsTable> {
  $$ShiftExceptionRecordsTableFilterComposer({
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

  ColumnFilters<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftPatternRecordsTableFilterComposer get patternId {
    final $$ShiftPatternRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternRecords,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$ShiftExceptionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftExceptionRecordsTable> {
  $$ShiftExceptionRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftPatternRecordsTableOrderingComposer get patternId {
    final $$ShiftPatternRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shiftPatternRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftExceptionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftExceptionRecordsTable> {
  $$ShiftExceptionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ShiftPatternRecordsTableAnnotationComposer get patternId {
    final $$ShiftPatternRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$ShiftExceptionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftExceptionRecordsTable,
          ShiftExceptionRow,
          $$ShiftExceptionRecordsTableFilterComposer,
          $$ShiftExceptionRecordsTableOrderingComposer,
          $$ShiftExceptionRecordsTableAnnotationComposer,
          $$ShiftExceptionRecordsTableCreateCompanionBuilder,
          $$ShiftExceptionRecordsTableUpdateCompanionBuilder,
          (ShiftExceptionRow, $$ShiftExceptionRecordsTableReferences),
          ShiftExceptionRow,
          PrefetchHooks Function({bool patternId})
        > {
  $$ShiftExceptionRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftExceptionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftExceptionRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftExceptionRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftExceptionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> patternId = const Value.absent(),
                Value<int> dateKey = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ShiftExceptionRecordsCompanion(
                id: id,
                patternId: patternId,
                dateKey: dateKey,
                type: type,
                startMinute: startMinute,
                endMinute: endMinute,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String patternId,
                required int dateKey,
                required String type,
                Value<int?> startMinute = const Value.absent(),
                Value<int?> endMinute = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ShiftExceptionRecordsCompanion.insert(
                id: id,
                patternId: patternId,
                dateKey: dateKey,
                type: type,
                startMinute: startMinute,
                endMinute: endMinute,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftExceptionRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patternId = false}) {
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
                    if (patternId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patternId,
                                referencedTable:
                                    $$ShiftExceptionRecordsTableReferences
                                        ._patternIdTable(db),
                                referencedColumn:
                                    $$ShiftExceptionRecordsTableReferences
                                        ._patternIdTable(db)
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

typedef $$ShiftExceptionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftExceptionRecordsTable,
      ShiftExceptionRow,
      $$ShiftExceptionRecordsTableFilterComposer,
      $$ShiftExceptionRecordsTableOrderingComposer,
      $$ShiftExceptionRecordsTableAnnotationComposer,
      $$ShiftExceptionRecordsTableCreateCompanionBuilder,
      $$ShiftExceptionRecordsTableUpdateCompanionBuilder,
      (ShiftExceptionRow, $$ShiftExceptionRecordsTableReferences),
      ShiftExceptionRow,
      PrefetchHooks Function({bool patternId})
    >;
typedef $$ShiftChecklistItemRecordsTableCreateCompanionBuilder =
    ShiftChecklistItemRecordsCompanion Function({
      required String id,
      required String patternId,
      required String label,
      Value<int> position,
      Value<int> rowid,
    });
typedef $$ShiftChecklistItemRecordsTableUpdateCompanionBuilder =
    ShiftChecklistItemRecordsCompanion Function({
      Value<String> id,
      Value<String> patternId,
      Value<String> label,
      Value<int> position,
      Value<int> rowid,
    });

final class $$ShiftChecklistItemRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftChecklistItemRecordsTable,
          ShiftChecklistItemRow
        > {
  $$ShiftChecklistItemRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftPatternRecordsTable _patternIdTable(_$AppDatabase db) =>
      db.shiftPatternRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftChecklistItemRecords.patternId,
          db.shiftPatternRecords.id,
        ),
      );

  $$ShiftPatternRecordsTableProcessedTableManager get patternId {
    final $_column = $_itemColumn<String>('pattern_id')!;

    final manager = $$ShiftPatternRecordsTableTableManager(
      $_db,
      $_db.shiftPatternRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patternIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ShiftChecklistCompletionRecordsTable,
    List<ShiftChecklistCompletionRow>
  >
  _shiftChecklistCompletionRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shiftChecklistCompletionRecords,
        aliasName: $_aliasNameGenerator(
          db.shiftChecklistItemRecords.id,
          db.shiftChecklistCompletionRecords.itemId,
        ),
      );

  $$ShiftChecklistCompletionRecordsTableProcessedTableManager
  get shiftChecklistCompletionRecordsRefs {
    final manager = $$ShiftChecklistCompletionRecordsTableTableManager(
      $_db,
      $_db.shiftChecklistCompletionRecords,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shiftChecklistCompletionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftChecklistItemRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftChecklistItemRecordsTable> {
  $$ShiftChecklistItemRecordsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftPatternRecordsTableFilterComposer get patternId {
    final $$ShiftPatternRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patternId,
      referencedTable: $db.shiftPatternRecords,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<bool> shiftChecklistCompletionRecordsRefs(
    Expression<bool> Function(
      $$ShiftChecklistCompletionRecordsTableFilterComposer f,
    )
    f,
  ) {
    final $$ShiftChecklistCompletionRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftChecklistCompletionRecords,
          getReferencedColumn: (t) => t.itemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistCompletionRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftChecklistCompletionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftChecklistItemRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftChecklistItemRecordsTable> {
  $$ShiftChecklistItemRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftPatternRecordsTableOrderingComposer get patternId {
    final $$ShiftPatternRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftPatternRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shiftPatternRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftChecklistItemRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftChecklistItemRecordsTable> {
  $$ShiftChecklistItemRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ShiftPatternRecordsTableAnnotationComposer get patternId {
    final $$ShiftPatternRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.patternId,
          referencedTable: $db.shiftPatternRecords,
          getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  Expression<T> shiftChecklistCompletionRecordsRefs<T extends Object>(
    Expression<T> Function(
      $$ShiftChecklistCompletionRecordsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$ShiftChecklistCompletionRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shiftChecklistCompletionRecords,
          getReferencedColumn: (t) => t.itemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistCompletionRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftChecklistCompletionRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShiftChecklistItemRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftChecklistItemRecordsTable,
          ShiftChecklistItemRow,
          $$ShiftChecklistItemRecordsTableFilterComposer,
          $$ShiftChecklistItemRecordsTableOrderingComposer,
          $$ShiftChecklistItemRecordsTableAnnotationComposer,
          $$ShiftChecklistItemRecordsTableCreateCompanionBuilder,
          $$ShiftChecklistItemRecordsTableUpdateCompanionBuilder,
          (ShiftChecklistItemRow, $$ShiftChecklistItemRecordsTableReferences),
          ShiftChecklistItemRow,
          PrefetchHooks Function({
            bool patternId,
            bool shiftChecklistCompletionRecordsRefs,
          })
        > {
  $$ShiftChecklistItemRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftChecklistItemRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftChecklistItemRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftChecklistItemRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftChecklistItemRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patternId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftChecklistItemRecordsCompanion(
                id: id,
                patternId: patternId,
                label: label,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patternId,
                required String label,
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftChecklistItemRecordsCompanion.insert(
                id: id,
                patternId: patternId,
                label: label,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftChecklistItemRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patternId = false,
                shiftChecklistCompletionRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftChecklistCompletionRecordsRefs)
                      db.shiftChecklistCompletionRecords,
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
                        if (patternId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.patternId,
                                    referencedTable:
                                        $$ShiftChecklistItemRecordsTableReferences
                                            ._patternIdTable(db),
                                    referencedColumn:
                                        $$ShiftChecklistItemRecordsTableReferences
                                            ._patternIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shiftChecklistCompletionRecordsRefs)
                        await $_getPrefetchedData<
                          ShiftChecklistItemRow,
                          $ShiftChecklistItemRecordsTable,
                          ShiftChecklistCompletionRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ShiftChecklistItemRecordsTableReferences
                                  ._shiftChecklistCompletionRecordsRefsTable(
                                    db,
                                  ),
                          managerFromTypedResult: (p0) =>
                              $$ShiftChecklistItemRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftChecklistCompletionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
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

typedef $$ShiftChecklistItemRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftChecklistItemRecordsTable,
      ShiftChecklistItemRow,
      $$ShiftChecklistItemRecordsTableFilterComposer,
      $$ShiftChecklistItemRecordsTableOrderingComposer,
      $$ShiftChecklistItemRecordsTableAnnotationComposer,
      $$ShiftChecklistItemRecordsTableCreateCompanionBuilder,
      $$ShiftChecklistItemRecordsTableUpdateCompanionBuilder,
      (ShiftChecklistItemRow, $$ShiftChecklistItemRecordsTableReferences),
      ShiftChecklistItemRow,
      PrefetchHooks Function({
        bool patternId,
        bool shiftChecklistCompletionRecordsRefs,
      })
    >;
typedef $$ShiftChecklistCompletionRecordsTableCreateCompanionBuilder =
    ShiftChecklistCompletionRecordsCompanion Function({
      required String itemId,
      required int dateKey,
      Value<String> slotKey,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShiftChecklistCompletionRecordsTableUpdateCompanionBuilder =
    ShiftChecklistCompletionRecordsCompanion Function({
      Value<String> itemId,
      Value<int> dateKey,
      Value<String> slotKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ShiftChecklistCompletionRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShiftChecklistCompletionRecordsTable,
          ShiftChecklistCompletionRow
        > {
  $$ShiftChecklistCompletionRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftChecklistItemRecordsTable _itemIdTable(_$AppDatabase db) =>
      db.shiftChecklistItemRecords.createAlias(
        $_aliasNameGenerator(
          db.shiftChecklistCompletionRecords.itemId,
          db.shiftChecklistItemRecords.id,
        ),
      );

  $$ShiftChecklistItemRecordsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$ShiftChecklistItemRecordsTableTableManager(
      $_db,
      $_db.shiftChecklistItemRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShiftChecklistCompletionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftChecklistCompletionRecordsTable> {
  $$ShiftChecklistCompletionRecordsTableFilterComposer({
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

  ColumnFilters<String> get slotKey => $composableBuilder(
    column: $table.slotKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftChecklistItemRecordsTableFilterComposer get itemId {
    final $$ShiftChecklistItemRecordsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.itemId,
          referencedTable: $db.shiftChecklistItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistItemRecordsTableFilterComposer(
                $db: $db,
                $table: $db.shiftChecklistItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftChecklistCompletionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftChecklistCompletionRecordsTable> {
  $$ShiftChecklistCompletionRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get slotKey => $composableBuilder(
    column: $table.slotKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftChecklistItemRecordsTableOrderingComposer get itemId {
    final $$ShiftChecklistItemRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.itemId,
          referencedTable: $db.shiftChecklistItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistItemRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shiftChecklistItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftChecklistCompletionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftChecklistCompletionRecordsTable> {
  $$ShiftChecklistCompletionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get slotKey =>
      $composableBuilder(column: $table.slotKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShiftChecklistItemRecordsTableAnnotationComposer get itemId {
    final $$ShiftChecklistItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.itemId,
          referencedTable: $db.shiftChecklistItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShiftChecklistItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shiftChecklistItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ShiftChecklistCompletionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftChecklistCompletionRecordsTable,
          ShiftChecklistCompletionRow,
          $$ShiftChecklistCompletionRecordsTableFilterComposer,
          $$ShiftChecklistCompletionRecordsTableOrderingComposer,
          $$ShiftChecklistCompletionRecordsTableAnnotationComposer,
          $$ShiftChecklistCompletionRecordsTableCreateCompanionBuilder,
          $$ShiftChecklistCompletionRecordsTableUpdateCompanionBuilder,
          (
            ShiftChecklistCompletionRow,
            $$ShiftChecklistCompletionRecordsTableReferences,
          ),
          ShiftChecklistCompletionRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$ShiftChecklistCompletionRecordsTableTableManager(
    _$AppDatabase db,
    $ShiftChecklistCompletionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftChecklistCompletionRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ShiftChecklistCompletionRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShiftChecklistCompletionRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<int> dateKey = const Value.absent(),
                Value<String> slotKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftChecklistCompletionRecordsCompanion(
                itemId: itemId,
                dateKey: dateKey,
                slotKey: slotKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required int dateKey,
                Value<String> slotKey = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShiftChecklistCompletionRecordsCompanion.insert(
                itemId: itemId,
                dateKey: dateKey,
                slotKey: slotKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShiftChecklistCompletionRecordsTableReferences(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
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
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable:
                                    $$ShiftChecklistCompletionRecordsTableReferences
                                        ._itemIdTable(db),
                                referencedColumn:
                                    $$ShiftChecklistCompletionRecordsTableReferences
                                        ._itemIdTable(db)
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

typedef $$ShiftChecklistCompletionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftChecklistCompletionRecordsTable,
      ShiftChecklistCompletionRow,
      $$ShiftChecklistCompletionRecordsTableFilterComposer,
      $$ShiftChecklistCompletionRecordsTableOrderingComposer,
      $$ShiftChecklistCompletionRecordsTableAnnotationComposer,
      $$ShiftChecklistCompletionRecordsTableCreateCompanionBuilder,
      $$ShiftChecklistCompletionRecordsTableUpdateCompanionBuilder,
      (
        ShiftChecklistCompletionRow,
        $$ShiftChecklistCompletionRecordsTableReferences,
      ),
      ShiftChecklistCompletionRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$HomeItemRecordsTableCreateCompanionBuilder =
    HomeItemRecordsCompanion Function({
      required String id,
      required String name,
      Value<String> category,
      Value<String> location,
      Value<double> quantity,
      Value<double?> reorderLevel,
      Value<String> unit,
      Value<String> notes,
      Value<DateTime?> lastPurchasedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$HomeItemRecordsTableUpdateCompanionBuilder =
    HomeItemRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String> location,
      Value<double> quantity,
      Value<double?> reorderLevel,
      Value<String> unit,
      Value<String> notes,
      Value<DateTime?> lastPurchasedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$HomeItemRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HomeItemRecordsTable, HomeItemRow> {
  $$HomeItemRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ShoppingItemRecordsTable, List<ShoppingItemRow>>
  _shoppingItemRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.shoppingItemRecords,
        aliasName: $_aliasNameGenerator(
          db.homeItemRecords.id,
          db.shoppingItemRecords.homeItemId,
        ),
      );

  $$ShoppingItemRecordsTableProcessedTableManager get shoppingItemRecordsRefs {
    final manager = $$ShoppingItemRecordsTableTableManager(
      $_db,
      $_db.shoppingItemRecords,
    ).filter((f) => f.homeItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _shoppingItemRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HomePurchaseRecordsTable, List<HomePurchaseRow>>
  _homePurchaseRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.homePurchaseRecords,
        aliasName: $_aliasNameGenerator(
          db.homeItemRecords.id,
          db.homePurchaseRecords.homeItemId,
        ),
      );

  $$HomePurchaseRecordsTableProcessedTableManager get homePurchaseRecordsRefs {
    final manager = $$HomePurchaseRecordsTableTableManager(
      $_db,
      $_db.homePurchaseRecords,
    ).filter((f) => f.homeItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _homePurchaseRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HomeItemRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HomeItemRecordsTable> {
  $$HomeItemRecordsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPurchasedAt => $composableBuilder(
    column: $table.lastPurchasedAt,
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

  Expression<bool> shoppingItemRecordsRefs(
    Expression<bool> Function($$ShoppingItemRecordsTableFilterComposer f) f,
  ) {
    final $$ShoppingItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItemRecords,
      getReferencedColumn: (t) => t.homeItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> homePurchaseRecordsRefs(
    Expression<bool> Function($$HomePurchaseRecordsTableFilterComposer f) f,
  ) {
    final $$HomePurchaseRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homePurchaseRecords,
      getReferencedColumn: (t) => t.homeItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomePurchaseRecordsTableFilterComposer(
            $db: $db,
            $table: $db.homePurchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HomeItemRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HomeItemRecordsTable> {
  $$HomeItemRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPurchasedAt => $composableBuilder(
    column: $table.lastPurchasedAt,
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

class $$HomeItemRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomeItemRecordsTable> {
  $$HomeItemRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPurchasedAt => $composableBuilder(
    column: $table.lastPurchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> shoppingItemRecordsRefs<T extends Object>(
    Expression<T> Function($$ShoppingItemRecordsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.shoppingItemRecords,
          getReferencedColumn: (t) => t.homeItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> homePurchaseRecordsRefs<T extends Object>(
    Expression<T> Function($$HomePurchaseRecordsTableAnnotationComposer a) f,
  ) {
    final $$HomePurchaseRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homePurchaseRecords,
          getReferencedColumn: (t) => t.homeItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomePurchaseRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.homePurchaseRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HomeItemRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomeItemRecordsTable,
          HomeItemRow,
          $$HomeItemRecordsTableFilterComposer,
          $$HomeItemRecordsTableOrderingComposer,
          $$HomeItemRecordsTableAnnotationComposer,
          $$HomeItemRecordsTableCreateCompanionBuilder,
          $$HomeItemRecordsTableUpdateCompanionBuilder,
          (HomeItemRow, $$HomeItemRecordsTableReferences),
          HomeItemRow,
          PrefetchHooks Function({
            bool shoppingItemRecordsRefs,
            bool homePurchaseRecordsRefs,
          })
        > {
  $$HomeItemRecordsTableTableManager(
    _$AppDatabase db,
    $HomeItemRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeItemRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeItemRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeItemRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> reorderLevel = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> lastPurchasedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeItemRecordsCompanion(
                id: id,
                name: name,
                category: category,
                location: location,
                quantity: quantity,
                reorderLevel: reorderLevel,
                unit: unit,
                notes: notes,
                lastPurchasedAt: lastPurchasedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> category = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> reorderLevel = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> lastPurchasedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomeItemRecordsCompanion.insert(
                id: id,
                name: name,
                category: category,
                location: location,
                quantity: quantity,
                reorderLevel: reorderLevel,
                unit: unit,
                notes: notes,
                lastPurchasedAt: lastPurchasedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomeItemRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shoppingItemRecordsRefs = false,
                homePurchaseRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shoppingItemRecordsRefs) db.shoppingItemRecords,
                    if (homePurchaseRecordsRefs) db.homePurchaseRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shoppingItemRecordsRefs)
                        await $_getPrefetchedData<
                          HomeItemRow,
                          $HomeItemRecordsTable,
                          ShoppingItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$HomeItemRecordsTableReferences
                              ._shoppingItemRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HomeItemRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingItemRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (homePurchaseRecordsRefs)
                        await $_getPrefetchedData<
                          HomeItemRow,
                          $HomeItemRecordsTable,
                          HomePurchaseRow
                        >(
                          currentTable: table,
                          referencedTable: $$HomeItemRecordsTableReferences
                              ._homePurchaseRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HomeItemRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).homePurchaseRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.homeItemId == item.id,
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

typedef $$HomeItemRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomeItemRecordsTable,
      HomeItemRow,
      $$HomeItemRecordsTableFilterComposer,
      $$HomeItemRecordsTableOrderingComposer,
      $$HomeItemRecordsTableAnnotationComposer,
      $$HomeItemRecordsTableCreateCompanionBuilder,
      $$HomeItemRecordsTableUpdateCompanionBuilder,
      (HomeItemRow, $$HomeItemRecordsTableReferences),
      HomeItemRow,
      PrefetchHooks Function({
        bool shoppingItemRecordsRefs,
        bool homePurchaseRecordsRefs,
      })
    >;
typedef $$ShoppingItemRecordsTableCreateCompanionBuilder =
    ShoppingItemRecordsCompanion Function({
      required String id,
      required String name,
      Value<double> quantity,
      Value<String> unit,
      Value<bool> checked,
      Value<String> note,
      Value<String?> homeItemId,
      Value<int> position,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ShoppingItemRecordsTableUpdateCompanionBuilder =
    ShoppingItemRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> quantity,
      Value<String> unit,
      Value<bool> checked,
      Value<String> note,
      Value<String?> homeItemId,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ShoppingItemRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ShoppingItemRecordsTable,
          ShoppingItemRow
        > {
  $$ShoppingItemRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HomeItemRecordsTable _homeItemIdTable(_$AppDatabase db) =>
      db.homeItemRecords.createAlias(
        $_aliasNameGenerator(
          db.shoppingItemRecords.homeItemId,
          db.homeItemRecords.id,
        ),
      );

  $$HomeItemRecordsTableProcessedTableManager? get homeItemId {
    final $_column = $_itemColumn<String>('home_item_id');
    if ($_column == null) return null;
    final manager = $$HomeItemRecordsTableTableManager(
      $_db,
      $_db.homeItemRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HomePurchaseRecordsTable, List<HomePurchaseRow>>
  _homePurchaseRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.homePurchaseRecords,
        aliasName: $_aliasNameGenerator(
          db.shoppingItemRecords.id,
          db.homePurchaseRecords.shoppingItemId,
        ),
      );

  $$HomePurchaseRecordsTableProcessedTableManager get homePurchaseRecordsRefs {
    final manager = $$HomePurchaseRecordsTableTableManager(
      $_db,
      $_db.homePurchaseRecords,
    ).filter((f) => f.shoppingItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _homePurchaseRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingItemRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemRecordsTable> {
  $$ShoppingItemRecordsTableFilterComposer({
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

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  $$HomeItemRecordsTableFilterComposer get homeItemId {
    final $$HomeItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> homePurchaseRecordsRefs(
    Expression<bool> Function($$HomePurchaseRecordsTableFilterComposer f) f,
  ) {
    final $$HomePurchaseRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.homePurchaseRecords,
      getReferencedColumn: (t) => t.shoppingItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomePurchaseRecordsTableFilterComposer(
            $db: $db,
            $table: $db.homePurchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingItemRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemRecordsTable> {
  $$ShoppingItemRecordsTableOrderingComposer({
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

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  $$HomeItemRecordsTableOrderingComposer get homeItemId {
    final $$HomeItemRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemRecordsTable> {
  $$ShoppingItemRecordsTableAnnotationComposer({
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

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$HomeItemRecordsTableAnnotationComposer get homeItemId {
    final $$HomeItemRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> homePurchaseRecordsRefs<T extends Object>(
    Expression<T> Function($$HomePurchaseRecordsTableAnnotationComposer a) f,
  ) {
    final $$HomePurchaseRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.homePurchaseRecords,
          getReferencedColumn: (t) => t.shoppingItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HomePurchaseRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.homePurchaseRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ShoppingItemRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemRecordsTable,
          ShoppingItemRow,
          $$ShoppingItemRecordsTableFilterComposer,
          $$ShoppingItemRecordsTableOrderingComposer,
          $$ShoppingItemRecordsTableAnnotationComposer,
          $$ShoppingItemRecordsTableCreateCompanionBuilder,
          $$ShoppingItemRecordsTableUpdateCompanionBuilder,
          (ShoppingItemRow, $$ShoppingItemRecordsTableReferences),
          ShoppingItemRow,
          PrefetchHooks Function({
            bool homeItemId,
            bool homePurchaseRecordsRefs,
          })
        > {
  $$ShoppingItemRecordsTableTableManager(
    _$AppDatabase db,
    $ShoppingItemRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ShoppingItemRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> homeItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemRecordsCompanion(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                checked: checked,
                note: note,
                homeItemId: homeItemId,
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
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> homeItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemRecordsCompanion.insert(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                checked: checked,
                note: note,
                homeItemId: homeItemId,
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
                  $$ShoppingItemRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({homeItemId = false, homePurchaseRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (homePurchaseRecordsRefs) db.homePurchaseRecords,
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
                        if (homeItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.homeItemId,
                                    referencedTable:
                                        $$ShoppingItemRecordsTableReferences
                                            ._homeItemIdTable(db),
                                    referencedColumn:
                                        $$ShoppingItemRecordsTableReferences
                                            ._homeItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (homePurchaseRecordsRefs)
                        await $_getPrefetchedData<
                          ShoppingItemRow,
                          $ShoppingItemRecordsTable,
                          HomePurchaseRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShoppingItemRecordsTableReferences
                              ._homePurchaseRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShoppingItemRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).homePurchaseRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shoppingItemId == item.id,
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

typedef $$ShoppingItemRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemRecordsTable,
      ShoppingItemRow,
      $$ShoppingItemRecordsTableFilterComposer,
      $$ShoppingItemRecordsTableOrderingComposer,
      $$ShoppingItemRecordsTableAnnotationComposer,
      $$ShoppingItemRecordsTableCreateCompanionBuilder,
      $$ShoppingItemRecordsTableUpdateCompanionBuilder,
      (ShoppingItemRow, $$ShoppingItemRecordsTableReferences),
      ShoppingItemRow,
      PrefetchHooks Function({bool homeItemId, bool homePurchaseRecordsRefs})
    >;
typedef $$IdentityRecordsTableCreateCompanionBuilder =
    IdentityRecordsCompanion Function({
      Value<int> id,
      required String deviceId,
      required String deviceName,
      required String username,
      required String pinSalt,
      required String pinHash,
      required String certificatePem,
      required String privateKeyPem,
      required String mcpToken,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$IdentityRecordsTableUpdateCompanionBuilder =
    IdentityRecordsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> deviceName,
      Value<String> username,
      Value<String> pinSalt,
      Value<String> pinHash,
      Value<String> certificatePem,
      Value<String> privateKeyPem,
      Value<String> mcpToken,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$IdentityRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $IdentityRecordsTable> {
  $$IdentityRecordsTableFilterComposer({
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

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get certificatePem => $composableBuilder(
    column: $table.certificatePem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privateKeyPem => $composableBuilder(
    column: $table.privateKeyPem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mcpToken => $composableBuilder(
    column: $table.mcpToken,
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
}

class $$IdentityRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdentityRecordsTable> {
  $$IdentityRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get certificatePem => $composableBuilder(
    column: $table.certificatePem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privateKeyPem => $composableBuilder(
    column: $table.privateKeyPem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mcpToken => $composableBuilder(
    column: $table.mcpToken,
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
}

class $$IdentityRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentityRecordsTable> {
  $$IdentityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get certificatePem => $composableBuilder(
    column: $table.certificatePem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get privateKeyPem => $composableBuilder(
    column: $table.privateKeyPem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mcpToken =>
      $composableBuilder(column: $table.mcpToken, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IdentityRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentityRecordsTable,
          IdentityRow,
          $$IdentityRecordsTableFilterComposer,
          $$IdentityRecordsTableOrderingComposer,
          $$IdentityRecordsTableAnnotationComposer,
          $$IdentityRecordsTableCreateCompanionBuilder,
          $$IdentityRecordsTableUpdateCompanionBuilder,
          (
            IdentityRow,
            BaseReferences<_$AppDatabase, $IdentityRecordsTable, IdentityRow>,
          ),
          IdentityRow,
          PrefetchHooks Function()
        > {
  $$IdentityRecordsTableTableManager(
    _$AppDatabase db,
    $IdentityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdentityRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdentityRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> pinSalt = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> certificatePem = const Value.absent(),
                Value<String> privateKeyPem = const Value.absent(),
                Value<String> mcpToken = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IdentityRecordsCompanion(
                id: id,
                deviceId: deviceId,
                deviceName: deviceName,
                username: username,
                pinSalt: pinSalt,
                pinHash: pinHash,
                certificatePem: certificatePem,
                privateKeyPem: privateKeyPem,
                mcpToken: mcpToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String deviceName,
                required String username,
                required String pinSalt,
                required String pinHash,
                required String certificatePem,
                required String privateKeyPem,
                required String mcpToken,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => IdentityRecordsCompanion.insert(
                id: id,
                deviceId: deviceId,
                deviceName: deviceName,
                username: username,
                pinSalt: pinSalt,
                pinHash: pinHash,
                certificatePem: certificatePem,
                privateKeyPem: privateKeyPem,
                mcpToken: mcpToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IdentityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentityRecordsTable,
      IdentityRow,
      $$IdentityRecordsTableFilterComposer,
      $$IdentityRecordsTableOrderingComposer,
      $$IdentityRecordsTableAnnotationComposer,
      $$IdentityRecordsTableCreateCompanionBuilder,
      $$IdentityRecordsTableUpdateCompanionBuilder,
      (
        IdentityRow,
        BaseReferences<_$AppDatabase, $IdentityRecordsTable, IdentityRow>,
      ),
      IdentityRow,
      PrefetchHooks Function()
    >;
typedef $$PairedDeviceRecordsTableCreateCompanionBuilder =
    PairedDeviceRecordsCompanion Function({
      required String id,
      required String name,
      required String username,
      required String certificateFingerprint,
      required String sharedKey,
      Value<String> host,
      Value<int> port,
      Value<DateTime?> lastSeenAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PairedDeviceRecordsTableUpdateCompanionBuilder =
    PairedDeviceRecordsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> username,
      Value<String> certificateFingerprint,
      Value<String> sharedKey,
      Value<String> host,
      Value<int> port,
      Value<DateTime?> lastSeenAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PairedDeviceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PairedDeviceRecordsTable> {
  $$PairedDeviceRecordsTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get certificateFingerprint => $composableBuilder(
    column: $table.certificateFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedKey => $composableBuilder(
    column: $table.sharedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
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
}

class $$PairedDeviceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PairedDeviceRecordsTable> {
  $$PairedDeviceRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get certificateFingerprint => $composableBuilder(
    column: $table.certificateFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedKey => $composableBuilder(
    column: $table.sharedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
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
}

class $$PairedDeviceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairedDeviceRecordsTable> {
  $$PairedDeviceRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get certificateFingerprint => $composableBuilder(
    column: $table.certificateFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sharedKey =>
      $composableBuilder(column: $table.sharedKey, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PairedDeviceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairedDeviceRecordsTable,
          PairedDeviceRow,
          $$PairedDeviceRecordsTableFilterComposer,
          $$PairedDeviceRecordsTableOrderingComposer,
          $$PairedDeviceRecordsTableAnnotationComposer,
          $$PairedDeviceRecordsTableCreateCompanionBuilder,
          $$PairedDeviceRecordsTableUpdateCompanionBuilder,
          (
            PairedDeviceRow,
            BaseReferences<
              _$AppDatabase,
              $PairedDeviceRecordsTable,
              PairedDeviceRow
            >,
          ),
          PairedDeviceRow,
          PrefetchHooks Function()
        > {
  $$PairedDeviceRecordsTableTableManager(
    _$AppDatabase db,
    $PairedDeviceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PairedDeviceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PairedDeviceRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PairedDeviceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> certificateFingerprint = const Value.absent(),
                Value<String> sharedKey = const Value.absent(),
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PairedDeviceRecordsCompanion(
                id: id,
                name: name,
                username: username,
                certificateFingerprint: certificateFingerprint,
                sharedKey: sharedKey,
                host: host,
                port: port,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String username,
                required String certificateFingerprint,
                required String sharedKey,
                Value<String> host = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PairedDeviceRecordsCompanion.insert(
                id: id,
                name: name,
                username: username,
                certificateFingerprint: certificateFingerprint,
                sharedKey: sharedKey,
                host: host,
                port: port,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PairedDeviceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairedDeviceRecordsTable,
      PairedDeviceRow,
      $$PairedDeviceRecordsTableFilterComposer,
      $$PairedDeviceRecordsTableOrderingComposer,
      $$PairedDeviceRecordsTableAnnotationComposer,
      $$PairedDeviceRecordsTableCreateCompanionBuilder,
      $$PairedDeviceRecordsTableUpdateCompanionBuilder,
      (
        PairedDeviceRow,
        BaseReferences<
          _$AppDatabase,
          $PairedDeviceRecordsTable,
          PairedDeviceRow
        >,
      ),
      PairedDeviceRow,
      PrefetchHooks Function()
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
typedef $$HomePurchaseRecordsTableCreateCompanionBuilder =
    HomePurchaseRecordsCompanion Function({
      required String id,
      required String homeItemId,
      Value<String?> shoppingItemId,
      required double quantity,
      Value<String> note,
      required DateTime purchasedAt,
      Value<int> rowid,
    });
typedef $$HomePurchaseRecordsTableUpdateCompanionBuilder =
    HomePurchaseRecordsCompanion Function({
      Value<String> id,
      Value<String> homeItemId,
      Value<String?> shoppingItemId,
      Value<double> quantity,
      Value<String> note,
      Value<DateTime> purchasedAt,
      Value<int> rowid,
    });

final class $$HomePurchaseRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HomePurchaseRecordsTable,
          HomePurchaseRow
        > {
  $$HomePurchaseRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HomeItemRecordsTable _homeItemIdTable(_$AppDatabase db) =>
      db.homeItemRecords.createAlias(
        $_aliasNameGenerator(
          db.homePurchaseRecords.homeItemId,
          db.homeItemRecords.id,
        ),
      );

  $$HomeItemRecordsTableProcessedTableManager get homeItemId {
    final $_column = $_itemColumn<String>('home_item_id')!;

    final manager = $$HomeItemRecordsTableTableManager(
      $_db,
      $_db.homeItemRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ShoppingItemRecordsTable _shoppingItemIdTable(_$AppDatabase db) =>
      db.shoppingItemRecords.createAlias(
        $_aliasNameGenerator(
          db.homePurchaseRecords.shoppingItemId,
          db.shoppingItemRecords.id,
        ),
      );

  $$ShoppingItemRecordsTableProcessedTableManager? get shoppingItemId {
    final $_column = $_itemColumn<String>('shopping_item_id');
    if ($_column == null) return null;
    final manager = $$ShoppingItemRecordsTableTableManager(
      $_db,
      $_db.shoppingItemRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shoppingItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HomePurchaseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HomePurchaseRecordsTable> {
  $$HomePurchaseRecordsTableFilterComposer({
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

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HomeItemRecordsTableFilterComposer get homeItemId {
    final $$HomeItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingItemRecordsTableFilterComposer get shoppingItemId {
    final $$ShoppingItemRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shoppingItemId,
      referencedTable: $db.shoppingItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemRecordsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HomePurchaseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HomePurchaseRecordsTable> {
  $$HomePurchaseRecordsTableOrderingComposer({
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

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HomeItemRecordsTableOrderingComposer get homeItemId {
    final $$HomeItemRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingItemRecordsTableOrderingComposer get shoppingItemId {
    final $$ShoppingItemRecordsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shoppingItemId,
          referencedTable: $db.shoppingItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingItemRecordsTableOrderingComposer(
                $db: $db,
                $table: $db.shoppingItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$HomePurchaseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomePurchaseRecordsTable> {
  $$HomePurchaseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  $$HomeItemRecordsTableAnnotationComposer get homeItemId {
    final $$HomeItemRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeItemId,
      referencedTable: $db.homeItemRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HomeItemRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.homeItemRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ShoppingItemRecordsTableAnnotationComposer get shoppingItemId {
    final $$ShoppingItemRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.shoppingItemId,
          referencedTable: $db.shoppingItemRecords,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ShoppingItemRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.shoppingItemRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$HomePurchaseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomePurchaseRecordsTable,
          HomePurchaseRow,
          $$HomePurchaseRecordsTableFilterComposer,
          $$HomePurchaseRecordsTableOrderingComposer,
          $$HomePurchaseRecordsTableAnnotationComposer,
          $$HomePurchaseRecordsTableCreateCompanionBuilder,
          $$HomePurchaseRecordsTableUpdateCompanionBuilder,
          (HomePurchaseRow, $$HomePurchaseRecordsTableReferences),
          HomePurchaseRow,
          PrefetchHooks Function({bool homeItemId, bool shoppingItemId})
        > {
  $$HomePurchaseRecordsTableTableManager(
    _$AppDatabase db,
    $HomePurchaseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomePurchaseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomePurchaseRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HomePurchaseRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> homeItemId = const Value.absent(),
                Value<String?> shoppingItemId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HomePurchaseRecordsCompanion(
                id: id,
                homeItemId: homeItemId,
                shoppingItemId: shoppingItemId,
                quantity: quantity,
                note: note,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String homeItemId,
                Value<String?> shoppingItemId = const Value.absent(),
                required double quantity,
                Value<String> note = const Value.absent(),
                required DateTime purchasedAt,
                Value<int> rowid = const Value.absent(),
              }) => HomePurchaseRecordsCompanion.insert(
                id: id,
                homeItemId: homeItemId,
                shoppingItemId: shoppingItemId,
                quantity: quantity,
                note: note,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HomePurchaseRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({homeItemId = false, shoppingItemId = false}) {
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
                        if (homeItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.homeItemId,
                                    referencedTable:
                                        $$HomePurchaseRecordsTableReferences
                                            ._homeItemIdTable(db),
                                    referencedColumn:
                                        $$HomePurchaseRecordsTableReferences
                                            ._homeItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (shoppingItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shoppingItemId,
                                    referencedTable:
                                        $$HomePurchaseRecordsTableReferences
                                            ._shoppingItemIdTable(db),
                                    referencedColumn:
                                        $$HomePurchaseRecordsTableReferences
                                            ._shoppingItemIdTable(db)
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

typedef $$HomePurchaseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomePurchaseRecordsTable,
      HomePurchaseRow,
      $$HomePurchaseRecordsTableFilterComposer,
      $$HomePurchaseRecordsTableOrderingComposer,
      $$HomePurchaseRecordsTableAnnotationComposer,
      $$HomePurchaseRecordsTableCreateCompanionBuilder,
      $$HomePurchaseRecordsTableUpdateCompanionBuilder,
      (HomePurchaseRow, $$HomePurchaseRecordsTableReferences),
      HomePurchaseRow,
      PrefetchHooks Function({bool homeItemId, bool shoppingItemId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpaceRecordsTableTableManager get spaceRecords =>
      $$SpaceRecordsTableTableManager(_db, _db.spaceRecords);
  $$EntryRecordsTableTableManager get entryRecords =>
      $$EntryRecordsTableTableManager(_db, _db.entryRecords);
  $$TagRecordsTableTableManager get tagRecords =>
      $$TagRecordsTableTableManager(_db, _db.tagRecords);
  $$EntryTagRecordsTableTableManager get entryTagRecords =>
      $$EntryTagRecordsTableTableManager(_db, _db.entryTagRecords);
  $$CompletionRecordsTableTableManager get completionRecords =>
      $$CompletionRecordsTableTableManager(_db, _db.completionRecords);
  $$ReminderRecordsTableTableManager get reminderRecords =>
      $$ReminderRecordsTableTableManager(_db, _db.reminderRecords);
  $$ShiftPatternRecordsTableTableManager get shiftPatternRecords =>
      $$ShiftPatternRecordsTableTableManager(_db, _db.shiftPatternRecords);
  $$ShiftSlotRecordsTableTableManager get shiftSlotRecords =>
      $$ShiftSlotRecordsTableTableManager(_db, _db.shiftSlotRecords);
  $$ShiftPatternTagRecordsTableTableManager get shiftPatternTagRecords =>
      $$ShiftPatternTagRecordsTableTableManager(
        _db,
        _db.shiftPatternTagRecords,
      );
  $$ShiftExceptionRecordsTableTableManager get shiftExceptionRecords =>
      $$ShiftExceptionRecordsTableTableManager(_db, _db.shiftExceptionRecords);
  $$ShiftChecklistItemRecordsTableTableManager get shiftChecklistItemRecords =>
      $$ShiftChecklistItemRecordsTableTableManager(
        _db,
        _db.shiftChecklistItemRecords,
      );
  $$ShiftChecklistCompletionRecordsTableTableManager
  get shiftChecklistCompletionRecords =>
      $$ShiftChecklistCompletionRecordsTableTableManager(
        _db,
        _db.shiftChecklistCompletionRecords,
      );
  $$HomeItemRecordsTableTableManager get homeItemRecords =>
      $$HomeItemRecordsTableTableManager(_db, _db.homeItemRecords);
  $$ShoppingItemRecordsTableTableManager get shoppingItemRecords =>
      $$ShoppingItemRecordsTableTableManager(_db, _db.shoppingItemRecords);
  $$IdentityRecordsTableTableManager get identityRecords =>
      $$IdentityRecordsTableTableManager(_db, _db.identityRecords);
  $$PairedDeviceRecordsTableTableManager get pairedDeviceRecords =>
      $$PairedDeviceRecordsTableTableManager(_db, _db.pairedDeviceRecords);
  $$SettingRecordsTableTableManager get settingRecords =>
      $$SettingRecordsTableTableManager(_db, _db.settingRecords);
  $$HomePurchaseRecordsTableTableManager get homePurchaseRecords =>
      $$HomePurchaseRecordsTableTableManager(_db, _db.homePurchaseRecords);
}
