import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 1)
class WalletModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double balance;
  @HiveField(2)
  final bool receiveAlert;
  @HiveField(3)
  final double alertPercentage;

  WalletModel({
    required this.name,
    required this.balance,
    required this.receiveAlert,
    required this.alertPercentage,
  });

  WalletModel copyWith({
    String? name,
    double? balance,
    bool? receiveAlert,
    double? alertPercentage,
  }) {
    return WalletModel(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      receiveAlert: receiveAlert ?? this.receiveAlert,
      alertPercentage: alertPercentage ?? this.alertPercentage,
    );
  }
}
