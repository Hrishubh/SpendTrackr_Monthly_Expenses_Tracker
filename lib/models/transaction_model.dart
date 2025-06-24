class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final double amount;
  final String currency;
  final String type; // income, expense, subscription
  final String category;
  final DateTime date;
  final DateTime createdAt;
  final String? subscriptionId;
  final String? budgetId;
  final String? paymentMethod;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.amount,
    this.currency = 'INR',
    required this.type,
    required this.category,
    required this.date,
    required this.createdAt,
    this.subscriptionId,
    this.budgetId,
    this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'currency': currency,
      'type': type,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'subscriptionId': subscriptionId,
      'budgetId': budgetId,
      'paymentMethod': paymentMethod,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      amount: (map['amount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'INR',
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      subscriptionId: map['subscriptionId'],
      budgetId: map['budgetId'],
      paymentMethod: map['paymentMethod'],
    );
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? amount,
    String? currency,
    String? type,
    String? category,
    DateTime? date,
    DateTime? createdAt,
    String? subscriptionId,
    String? budgetId,
    String? paymentMethod,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      budgetId: budgetId ?? this.budgetId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  // Helper methods
  String get formattedAmount => '₹${amount.toStringAsFixed(0)}';
  
  bool get isExpense => type == 'expense' || type == 'subscription';
  bool get isIncome => type == 'income';
}