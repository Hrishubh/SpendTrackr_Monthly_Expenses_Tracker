class SubscriptionModel {
  final String id;
  final String userId;
  final String name;
  final String iconUrl;
  final double price;
  final String currency;
  final String billingCycle; // monthly, yearly, weekly
  final DateTime nextBillingDate;
  final DateTime createdAt;
  final bool isActive;
  final String? description;
  final String? category;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconUrl,
    required this.price,
    this.currency = 'INR',
    this.billingCycle = 'monthly',
    required this.nextBillingDate,
    required this.createdAt,
    this.isActive = true,
    this.description,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'iconUrl': iconUrl,
      'price': price,
      'currency': currency,
      'billingCycle': billingCycle,
      'nextBillingDate': nextBillingDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'description': description,
      'category': category,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'INR',
      billingCycle: map['billingCycle'] ?? 'monthly',
      nextBillingDate: DateTime.fromMillisecondsSinceEpoch(map['nextBillingDate'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      description: map['description'],
      category: map['category'],
    );
  }

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? iconUrl,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? nextBillingDate,
    DateTime? createdAt,
    bool? isActive,
    String? description,
    String? category,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  // Helper method to get formatted price
  String get formattedPrice {
    return '₹${price.toStringAsFixed(0)}';
  }

  // Helper method to check if bill is due soon (within 7 days)
  bool get isDueSoon {
    final now = DateTime.now();
    final difference = nextBillingDate.difference(now).inDays;
    return difference <= 7 && difference >= 0;
  }
}