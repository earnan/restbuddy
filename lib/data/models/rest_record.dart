import 'package:isar/isar.dart';
import '../../domain/enums/rest_status.dart';

part 'rest_record.g.dart';

@collection
class RestRecord {
  Id id = Isar.autoIncrement;

  late String restType;
  late int durationSeconds;
  late int actualDurationSeconds;
  late DateTime startTime;
  DateTime? endTime;

  @enumerated
  late RestStatus status;
  String? skipReason;

  late DateTime createdAt;

  RestRecord();

  factory RestRecord.create({
    required String restType,
    required int durationSeconds,
    required RestStatus status,
    int? actualDurationSeconds,
  }) {
    final now = DateTime.now();
    return RestRecord()
      ..restType = restType
      ..durationSeconds = durationSeconds
      ..actualDurationSeconds = actualDurationSeconds ?? 0
      ..startTime = now
      ..endTime = status == RestStatus.completed ? now.add(Duration(seconds: durationSeconds)) : now
      ..status = status
      ..createdAt = now;
  }
}
