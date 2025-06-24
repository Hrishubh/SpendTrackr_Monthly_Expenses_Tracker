import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/budget_model.dart';
import '../common/color_extension.dart';
import 'firebase_service.dart';

class BudgetService {
  final FirebaseService _firebaseService = FirebaseService();
  final Uuid _uuid = const Uuid();

  // Add a new budget
  Future<void> addBudget(BudgetModel budget) async {
    try {
      await _firebaseService.budgetsCollection
          .doc(budget.id)
          .set(budget.toMap());
    } catch (e) {
      throw 'Failed to add budget. Please try again.';
    }
  }

  // Update budget
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _firebaseService.budgetsCollection
          .doc(budget.id)
          .update(budget.toMap());
    } catch (e) {
      throw 'Failed to update budget. Please try again.';
    }
  }

  // Update budget spent amount
  Future<void> updateBudgetSpentAmount(String budgetId, double newSpentAmount) async {
    try {
      await _firebaseService.budgetsCollection
          .doc(budgetId)
          .update({'spentAmount': newSpentAmount});
    } catch (e) {
      throw 'Failed to update budget spent amount. Please try again.';
    }
  }

  // Delete budget
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _firebaseService.budgetsCollection
          .doc(budgetId)
          .delete();
    } catch (e) {
      throw 'Failed to delete budget. Please try again.';
    }
  }

  // Get user budgets stream
  Stream<List<BudgetModel>> getUserBudgets(String userId) {
    return _firebaseService.budgetsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get current month budgets
  Stream<List<BudgetModel>> getCurrentMonthBudgets(String userId) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _firebaseService.budgetsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .where('periodStart', isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch)
        .where('periodEnd', isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
        .orderBy('periodStart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get budget by ID
  Future<BudgetModel?> getBudgetById(String budgetId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.budgetsCollection
          .doc(budgetId)
          .get();
      
      if (doc.exists) {
        return BudgetModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get budget. Please try again.';
    }
  }

  // Calculate total budget amount for current month
  Future<double> getTotalMonthlyBudget(String userId) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshot = await _firebaseService.budgetsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .where('periodStart', isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch)
          .where('periodEnd', isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final budget = BudgetModel.fromMap(doc.data() as Map<String, dynamic>);
        total += budget.totalBudget;
      }
      
      return total;
    } catch (e) {
      throw 'Failed to calculate total budget.';
    }
  }

  // Calculate total spent amount for current month
  Future<double> getTotalMonthlySpent(String userId) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshot = await _firebaseService.budgetsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .where('periodStart', isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch)
          .where('periodEnd', isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final budget = BudgetModel.fromMap(doc.data() as Map<String, dynamic>);
        total += budget.spentAmount;
      }
      
      return total;
    } catch (e) {
      throw 'Failed to calculate total spent amount.';
    }
  }

  // Create a new budget with generated ID
  BudgetModel createBudget({
    required String userId,
    required String name,
    required String iconUrl,
    required double totalBudget,
    required Color color,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? description,
  }) {
    final now = DateTime.now();
    final defaultPeriodStart = periodStart ?? DateTime(now.year, now.month, 1);
    final defaultPeriodEnd = periodEnd ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return BudgetModel(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      iconUrl: iconUrl,
      totalBudget: totalBudget,
      color: color,
      createdAt: DateTime.now(),
      periodStart: defaultPeriodStart,
      periodEnd: defaultPeriodEnd,
      description: description,
    );
  }

  // Seed dummy data for a user
  Future<void> seedDummyBudgets(String userId) async {
    final now = DateTime.now();
    final periodStart = DateTime(now.year, now.month, 1);
    final periodEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final dummyBudgets = [
      createBudget(
        userId: userId,
        name: 'Security',
        iconUrl: 'assets/img/security.png',
        totalBudget: 3000,
        color: TColor.secondaryG,
        periodStart: periodStart,
        periodEnd: periodEnd,
        description: 'Security and insurance expenses',
      ).copyWith(spentAmount: 1960),
      
      createBudget(
        userId: userId,
        name: 'Entertainment',
        iconUrl: 'assets/img/entertainment.png',
        totalBudget: 7000,
        color: TColor.secondary50,
        periodStart: periodStart,
        periodEnd: periodEnd,
        description: 'Movies, games, and entertainment',
      ).copyWith(spentAmount: 4950),
      
      createBudget(
        userId: userId,
        name: 'Auto & Transport',
        iconUrl: 'assets/img/auto_&_transport.png',
        totalBudget: 10000,
        color: TColor.primary10,
        periodStart: periodStart,
        periodEnd: periodEnd,
        description: 'Vehicle and transportation costs',
      ).copyWith(spentAmount: 7500),
      
      createBudget(
        userId: userId,
        name: 'Food & Dining',
        iconUrl: 'assets/img/food.png',
        totalBudget: 8000,
        color: TColor.gray60,
        periodStart: periodStart,
        periodEnd: periodEnd,
        description: 'Restaurants and food delivery',
      ).copyWith(spentAmount: 5200),
      
      createBudget(
        userId: userId,
        name: 'Shopping',
        iconUrl: 'assets/img/shopping.png',
        totalBudget: 5000,
        color: TColor.secondary,
        periodStart: periodStart,
        periodEnd: periodEnd,
        description: 'Clothing and personal items',
      ).copyWith(spentAmount: 3100),
    ];

    for (var budget in dummyBudgets) {
      await addBudget(budget);
    }
  }
}