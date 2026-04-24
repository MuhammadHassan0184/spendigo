class WalletModel {
  final String name;
  final double balance;
  final bool receiveAlert;
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
