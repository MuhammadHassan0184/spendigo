import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/Models/budget_model.dart';
import 'package:spendigo/Models/notification_model.dart';
import 'package:spendigo/services/hive_service.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BackupService {
  static Future<void> exportBackup() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        showCustomSnackBar("Error", "User not logged in", isError: true);
        return;
      }

      // 1. Collect Data from Hive
      final transactionBox = Hive.box<TransactionModel>('transactions_$uid');
      final walletBox = Hive.box<WalletModel>('wallets_$uid');
      final budgetBox = Hive.box<BudgetModel>('budgets_$uid');
      final notificationBox = Hive.box<NotificationModel>('notifications_$uid');

      final data = {
        'transactions': transactionBox.values.map((t) => t.toMap()).toList(),
        'wallets': walletBox.values.map((w) => w.toMap()).toList(),
        'budgets': budgetBox.values.map((b) => b.toMap()).toList(),
        'notifications': notificationBox.values.map((n) => n.toMap()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
        'version': '1.0',
      };

      // 2. Convert to JSON string
      final jsonString = jsonEncode(data);

      // 3. Save to Temporary File
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/spendigo_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonString);

      // 4. Share the File
      await Share.shareXFiles([XFile(file.path)], text: 'My Spendigo Backup');

      showCustomSnackBar("Success", "Backup exported successfully!");
    } catch (e) {
      showCustomSnackBar("Error", "Failed to export backup: $e", isError: true);
    }
  }

  static Future<void> importBackup() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        showCustomSnackBar("Error", "User not logged in", isError: true);
        return;
      }

      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // 2. Validate Data
      if (!data.containsKey('transactions') || !data.containsKey('wallets')) {
        showCustomSnackBar(
          "Error",
          "Invalid backup file format",
          isError: true,
        );
        return;
      }

      // 3. Clear Existing Data
      final transactionBox = Hive.box<TransactionModel>('transactions_$uid');
      final walletBox = Hive.box<WalletModel>('wallets_$uid');
      final budgetBox = Hive.box<BudgetModel>('budgets_$uid');
      final notificationBox = Hive.box<NotificationModel>('notifications_$uid');

      await transactionBox.clear();
      await walletBox.clear();
      await budgetBox.clear();
      await notificationBox.clear();

      // 4. Import New Data
      final List transactions = data['transactions'];
      final List wallets = data['wallets'];
      final List budgets = data['budgets'];
      final List notifications = data['notifications'] ?? [];

      await transactionBox.addAll(
        transactions.map((t) => TransactionModel.fromMap(t)).toList(),
      );
      await walletBox.addAll(
        wallets.map((w) => WalletModel.fromMap(w)).toList(),
      );
      await budgetBox.addAll(
        budgets.map((b) => BudgetModel.fromMap(b)).toList(),
      );
      await notificationBox.addAll(
        notifications.map((n) => NotificationModel.fromMap(n)).toList(),
      );

      // 5. Refresh UI
      HiveService.refreshAllControllers();

      showCustomSnackBar("Success", "Data restored successfully!");
    } catch (e) {
      showCustomSnackBar("Error", "Failed to import backup: $e", isError: true);
    }
  }
}
