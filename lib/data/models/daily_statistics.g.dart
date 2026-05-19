// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_statistics.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyStatisticsCollection on Isar {
  IsarCollection<DailyStatistics> get dailyStatistics => this.collection();
}

const DailyStatisticsSchema = CollectionSchema(
  name: r'DailyStatistics',
  id: -2494834750806470970,
  properties: {
    r'completedCount': PropertySchema(
      id: 0,
      name: r'completedCount',
      type: IsarType.long,
    ),
    r'completionRate': PropertySchema(
      id: 1,
      name: r'completionRate',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'hourlyRestCounts': PropertySchema(
      id: 3,
      name: r'hourlyRestCounts',
      type: IsarType.longList,
    ),
    r'skippedCount': PropertySchema(
      id: 4,
      name: r'skippedCount',
      type: IsarType.long,
    ),
    r'totalRestCount': PropertySchema(
      id: 5,
      name: r'totalRestCount',
      type: IsarType.long,
    ),
    r'totalRestSeconds': PropertySchema(
      id: 6,
      name: r'totalRestSeconds',
      type: IsarType.long,
    ),
    r'workSeconds': PropertySchema(
      id: 7,
      name: r'workSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyStatisticsEstimateSize,
  serialize: _dailyStatisticsSerialize,
  deserialize: _dailyStatisticsDeserialize,
  deserializeProp: _dailyStatisticsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyStatisticsGetId,
  getLinks: _dailyStatisticsGetLinks,
  attach: _dailyStatisticsAttach,
  version: '3.1.0+1',
);

int _dailyStatisticsEstimateSize(
  DailyStatistics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hourlyRestCounts.length * 8;
  return bytesCount;
}

void _dailyStatisticsSerialize(
  DailyStatistics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedCount);
  writer.writeDouble(offsets[1], object.completionRate);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLongList(offsets[3], object.hourlyRestCounts);
  writer.writeLong(offsets[4], object.skippedCount);
  writer.writeLong(offsets[5], object.totalRestCount);
  writer.writeLong(offsets[6], object.totalRestSeconds);
  writer.writeLong(offsets[7], object.workSeconds);
}

DailyStatistics _dailyStatisticsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyStatistics();
  object.completedCount = reader.readLong(offsets[0]);
  object.completionRate = reader.readDouble(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.hourlyRestCounts = reader.readLongList(offsets[3]) ?? [];
  object.id = id;
  object.skippedCount = reader.readLong(offsets[4]);
  object.totalRestCount = reader.readLong(offsets[5]);
  object.totalRestSeconds = reader.readLong(offsets[6]);
  object.workSeconds = reader.readLong(offsets[7]);
  return object;
}

P _dailyStatisticsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyStatisticsGetId(DailyStatistics object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyStatisticsGetLinks(DailyStatistics object) {
  return [];
}

void _dailyStatisticsAttach(
    IsarCollection<dynamic> col, Id id, DailyStatistics object) {
  object.id = id;
}

extension DailyStatisticsQueryWhereSort
    on QueryBuilder<DailyStatistics, DailyStatistics, QWhere> {
  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyStatisticsQueryWhere
    on QueryBuilder<DailyStatistics, DailyStatistics, QWhereClause> {
  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyStatisticsQueryFilter
    on QueryBuilder<DailyStatistics, DailyStatistics, QFilterCondition> {
  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completionRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completionRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completionRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      completionRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourlyRestCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hourlyRestCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hourlyRestCounts',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hourlyRestCounts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      hourlyRestCountsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hourlyRestCounts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      skippedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skippedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      skippedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skippedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      skippedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skippedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      skippedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skippedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRestCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRestCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRestCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRestCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      totalRestSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRestSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      workSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      workSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      workSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterFilterCondition>
      workSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyStatisticsQueryObject
    on QueryBuilder<DailyStatistics, DailyStatistics, QFilterCondition> {}

extension DailyStatisticsQueryLinks
    on QueryBuilder<DailyStatistics, DailyStatistics, QFilterCondition> {}

extension DailyStatisticsQuerySortBy
    on QueryBuilder<DailyStatistics, DailyStatistics, QSortBy> {
  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByCompletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByCompletedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortBySkippedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skippedCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortBySkippedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skippedCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByTotalRestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByTotalRestCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByTotalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByTotalRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      sortByWorkSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workSeconds', Sort.desc);
    });
  }
}

extension DailyStatisticsQuerySortThenBy
    on QueryBuilder<DailyStatistics, DailyStatistics, QSortThenBy> {
  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByCompletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByCompletedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenBySkippedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skippedCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenBySkippedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skippedCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByTotalRestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByTotalRestCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByTotalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByTotalRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QAfterSortBy>
      thenByWorkSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workSeconds', Sort.desc);
    });
  }
}

extension DailyStatisticsQueryWhereDistinct
    on QueryBuilder<DailyStatistics, DailyStatistics, QDistinct> {
  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByCompletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedCount');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionRate');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByHourlyRestCounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourlyRestCounts');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctBySkippedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skippedCount');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByTotalRestCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRestCount');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByTotalRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRestSeconds');
    });
  }

  QueryBuilder<DailyStatistics, DailyStatistics, QDistinct>
      distinctByWorkSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workSeconds');
    });
  }
}

extension DailyStatisticsQueryProperty
    on QueryBuilder<DailyStatistics, DailyStatistics, QQueryProperty> {
  QueryBuilder<DailyStatistics, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyStatistics, int, QQueryOperations>
      completedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedCount');
    });
  }

  QueryBuilder<DailyStatistics, double, QQueryOperations>
      completionRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionRate');
    });
  }

  QueryBuilder<DailyStatistics, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyStatistics, List<int>, QQueryOperations>
      hourlyRestCountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourlyRestCounts');
    });
  }

  QueryBuilder<DailyStatistics, int, QQueryOperations> skippedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skippedCount');
    });
  }

  QueryBuilder<DailyStatistics, int, QQueryOperations>
      totalRestCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRestCount');
    });
  }

  QueryBuilder<DailyStatistics, int, QQueryOperations>
      totalRestSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRestSeconds');
    });
  }

  QueryBuilder<DailyStatistics, int, QQueryOperations> workSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workSeconds');
    });
  }
}
