class CardModel {
  final String id;
  final String userId;
  final String cardName;
  final String cardNumber; // Last 4 digits only for security
  final String cardType; // visa, mastercard, amex, etc.
  final String? cardHolderName;
  final DateTime? expiryDate;
  final double? creditLimit;
  final double? currentBalance;
  final String currency;
  final DateTime createdAt;
  final bool isActive;
  final String? bankName;
  final int colorCode; // For card background color

  CardModel({
    required this.id,
    required this.userId,
    required this.cardName,
    required this.cardNumber,
    required this.cardType,
    this.cardHolderName,
    this.expiryDate,
    this.creditLimit,
    this.currentBalance,
    this.currency = 'INR',
    required this.createdAt,
    this.isActive = true,
    this.bankName,
    required this.colorCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cardName': cardName,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'creditLimit': creditLimit,
      'currentBalance': currentBalance,
      'currency': currency,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'bankName': bankName,
      'colorCode': colorCode,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      cardName: map['cardName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cardType: map['cardType'] ?? '',
      cardHolderName: map['cardHolderName'],
      expiryDate: map['expiryDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'])
          : null,
      creditLimit: map['creditLimit']?.toDouble(),
      currentBalance: map['currentBalance']?.toDouble(),
      currency: map['currency'] ?? 'INR',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      bankName: map['bankName'],
      colorCode: map['colorCode'] ?? 0xFF000000,
    );
  }

  CardModel copyWith({
    String? id,
    String? userId,
    String? cardName,
    String? cardNumber,
    String? cardType,
    String? cardHolderName,
    DateTime? expiryDate,
    double? creditLimit,
    double? currentBalance,
    String? currency,
    DateTime? createdAt,
    bool? isActive,
    String? bankName,
    int? colorCode,
  }) {
    return CardModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardName: cardName ?? this.cardName,
      cardNumber: cardNumber ?? this.cardNumber,
      cardType: cardType ?? this.cardType,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      creditLimit: creditLimit ?? this.creditLimit,
      currentBalance: currentBalance ?? this.currentBalance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      bankName: bankName ?? this.bankName,
      colorCode: colorCode ?? this.colorCode,
    );
  }

  // Helper methods
  String get maskedCardNumber => '**** **** **** $cardNumber';
  
  String get formattedCreditLimit => 
      creditLimit != null ? '₹${creditLimit!.toStringAsFixed(0)}' : 'N/A';
  
  String get formattedCurrentBalance => 
      currentBalance != null ? '₹${currentBalance!.toStringAsFixed(0)}' : 'N/A';
  
  double get availableCredit => 
      (creditLimit ?? 0) - (currentBalance ?? 0);
  
  String get formattedAvailableCredit => '₹${availableCredit.toStringAsFixed(0)}';
  
  bool get isExpired => 
      expiryDate != null && expiryDate!.isBefore(DateTime.now());
}