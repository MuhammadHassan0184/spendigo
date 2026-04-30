// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/notification_controller.dart';
import 'package:spendigo/Models/notification_model.dart';

class NotificationHistoryScreen extends StatelessWidget {
  NotificationHistoryScreen({super.key});

  final NotificationController _ctrl = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 4),

              // Title
              const Expanded(
                child: Center(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              // Badge + Clear button
              Obx(() {
                if (_ctrl.notifications.isEmpty) return const SizedBox();
                return TextButton.icon(
                  onPressed: _showClearDialog,
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                  label: const Text(
                    'Clear all',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Obx(() {
      if (_ctrl.notifications.isEmpty) return _buildEmptyState();

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        itemCount: _ctrl.notifications.length,
        itemBuilder: (context, index) {
          final item = _ctrl.notifications[index];
          final showDateHeader = _shouldShowDateHeader(index);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateHeader) _buildDateHeader(item.timestamp),
              _buildNotificationCard(item, index),
            ],
          );
        },
      );
    });
  }

  // ─── Date Header ──────────────────────────────────────────────────────────
  bool _shouldShowDateHeader(int index) {
    if (index == 0) return true;
    final prev = _ctrl.notifications[index - 1].timestamp;
    final curr = _ctrl.notifications[index].timestamp;
    return !_isSameDay(prev, curr);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      label = '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: AppColors.stroke, thickness: 1)),
        ],
      ),
    );
  }

  // ─── Notification Card ────────────────────────────────────────────────────
  Widget _buildNotificationCard(NotificationModel item, int index) {
    final isAlert =
        item.title.toLowerCase().contains('alert') ||
        item.title.toLowerCase().contains('low') ||
        item.title.toLowerCase().contains('budget');

    final Color accentColor = isAlert
        ? const Color(0xFFFF6B6B)
        : AppColors.primary;
    final IconData iconData = isAlert
        ? Icons.warning_amber_rounded
        : Icons.notifications_active_rounded;

    return Dismissible(
      key: ValueKey(item.timestamp.millisecondsSinceEpoch + index),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) {
        _ctrl.notifications.removeAt(index);
        final box = item.box;
        if (box != null) item.delete();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),

              // Icon
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: accentColor, size: 22),
                ),
              ),

              // Text content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(item.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B6B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 48,
              color: AppColors.secondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Notifications Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see wallet & budget alerts here\nonce they are triggered.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: const Text(
          'This will permanently remove all notification history.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _ctrl.clearAll();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
