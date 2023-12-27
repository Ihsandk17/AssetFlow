class TransactionModel {
  int transactionId;
  int accountId;
  String transactionType;
  String transactionName;
  String transactionDes;
  DateTime transactionTime;
  double transactionAmount;

  TransactionModel({
    required this.transactionId,
    required this.accountId,
    required this.transactionType,
    required this.transactionName,
    required this.transactionDes,
    required this.transactionTime,
    required this.transactionAmount,
  });

  // Convert the TransactionModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'transactionType': transactionType,
      'transactionName': transactionName,
      'transactionDes': transactionDes,
      'transactionTime':
          transactionTime.toIso8601String(), // Convert DateTime to String
      'transactionAmount': transactionAmount,
    };
  }

  // Create a TransactionModel object from a Map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['id'],
      accountId: map['accountId'],
      transactionType: map['transactionType'],
      transactionName: map['transactionName'],
      transactionDes: map['transactionDes'],
      transactionTime: DateTime.parse(map['transactionTime']),
      transactionAmount: map['transactionAmount'].toDouble(), // Cast to double
    );
  }
}
