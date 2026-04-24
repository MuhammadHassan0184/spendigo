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
}
