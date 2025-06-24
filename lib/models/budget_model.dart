import 'package:flutter/material.dart';

class BudgetModel {
  final String id;
  final String userId;
  final String name;
  final String iconUrl;
  final double totalBudget;
  final double spentAmount;
  final String currency;
  final Color color;
  final DateTime createdAt;
  final DateTime periodStart;
  final DateTime periodEnd;
  final bool isActive;
  final String? description;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconUrl,
    required this.totalBudget,
    this.spentAmount = 0.0,
    this.currency = 'INR',
    required this.color,
    required this.createdAt,
    required this.periodStart,
    required this.periodEnd,
    this.isActive = true,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'iconUrl': iconUrl,
      'totalBudget': totalBudget,
      'spentAmount': spentAmount,
      'currency': currency,
      'colorValue': color.value,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'periodStart': periodStart.millisecondsSinceEpoch,
      'periodEnd': periodEnd.millisecondsSinceEpoch,
      'isActive': isActive,
      'description': description,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
      totalBudget: (map['totalBudget'] ?? 0).toDouble(),
      spentAmount: (map['spentAmount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'INR',
      color: Color(map['colorValue'] ?? 0xFF000000),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      periodStart: DateTime.fromMillisecondsSinceEpoch(map['periodStart'] ?? 0),
      periodEnd: DateTime.fromMillisecondsSinceEpoch(map['periodEnd'] ?? 0),
      isActive: map['isActive'] ?? true,
      description: map['description'],
    );
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? iconUrl,
    double? totalBudget,
    double? spentAmount,
    String? currency,
    Color? color,
    DateTime? createdAt,
    DateTime? periodStart,
    DateTime? periodEnd,
    bool? isActive,
    String? description,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      totalBudget: totalBudget ?? this.totalBudget,
      spentAmount: spentAmount ?? this.spentAmount,
      currency: currency ?? this.currency,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
    );
  }

  // Helper methods
  double get leftAmount => totalBudget - spentAmount;
  
  double get spentPercentage => 
      totalBudget > 0 ? (spentAmount / totalBudget) * 100 : 0;
  
  bool get isOverBudget => spentAmount > totalBudget;
  
  String get formattedTotalBudget => '₹${totalBudget.toStringAsFixed(0)}';
  String get formattedSpentAmount => '₹${spentAmount.toStringAsFixed(0)}';
  String get formattedLeftAmount => '₹${leftAmount.toStringAsFixed(0)}';
}