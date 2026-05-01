import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendigo/Models/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  
  Box<NotificationModel> get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box<NotificationModel>('notifications_$uid');
  }

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      loadNotifications();
    }
  }

  void loadNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('notifications_$uid')) {
      // Load in reverse-chronological order (newest first)
      final items = _box.values.toList();
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifications.assignAll(items);
    }
  }

  Future<void> addNotification(String title, String body) async {
    final item = NotificationModel(
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    await _box.add(item);
    // Prepend so newest is always first
    notifications.insert(0, item);
  }

  Future<void> clearAll() async {
    await _box.clear();
    notifications.clear();
  }

  int get unreadCount => notifications.length;
}
