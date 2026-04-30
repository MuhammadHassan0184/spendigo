import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 3)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime timestamp;

  NotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
  });
}
