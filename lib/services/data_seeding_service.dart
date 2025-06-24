import 'package:cloud_firestore/cloud_firestore.dart';
import 'subscription_service.dart';
import 'budget_service.dart';
import 'firebase_service.dart';

class DataSeedingService {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final BudgetService _budgetService = BudgetService();
  final FirebaseService _firebaseService = FirebaseService();

  // Check if user has any data
  Future<bool> hasUserData(String userId) async {
    try {
      // Check if user has any subscriptions
      final subscriptionsSnapshot = await _firebaseService.subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      // Check if user has any budgets
      final budgetsSnapshot = await _firebaseService.budgetsCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return subscriptionsSnapshot.docs.isNotEmpty || budgetsSnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Seed all dummy data for a new user
  Future<void> seedAllDummyData(String userId) async {
    try {
      // Check if user already has data
      final hasData = await hasUserData(userId);
      if (hasData) {
        return; // Don't seed if user already has data
      }

      // Seed subscriptions
      await _subscriptionService.seedDummySubscriptions(userId);

      // Seed budgets
      await _budgetService.seedDummyBudgets(userId);

      // Mark user as having seeded data
      await _markUserAsSeeded(userId);
    } catch (e) {
      throw 'Failed to seed dummy data: $e';
    }
  }

  // Mark user as having seeded data
  Future<void> _markUserAsSeeded(String userId) async {
    await _firebaseService.usersCollection.doc(userId).update({
      'hasSeededData': true,
      'seededAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Check if user has been seeded
  Future<bool> isUserSeeded(String userId) async {
    try {
      final userDoc = await _firebaseService.usersCollection.doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['hasSeededData'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Reset user data (for testing purposes)
  Future<void> resetUserData(String userId) async {
    try {
      // Delete all user subscriptions
      final subscriptionsSnapshot = await _firebaseService.subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in subscriptionsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete all user budgets
      final budgetsSnapshot = await _firebaseService.budgetsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in budgetsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete all user transactions
      final transactionsSnapshot = await _firebaseService.transactionsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in transactionsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete all user cards
      final cardsSnapshot = await _firebaseService.cardsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      for (var doc in cardsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Update user document
      await _firebaseService.usersCollection.doc(userId).update({
        'hasSeededData': false,
        'resetAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw 'Failed to reset user data: $e';
    }
  }
}