import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/subscription_model.dart';
import 'firebase_service.dart';

class SubscriptionService {
  final FirebaseService _firebaseService = FirebaseService();
  final Uuid _uuid = const Uuid();

  // Add a new subscription
  Future<void> addSubscription(SubscriptionModel subscription) async {
    try {
      await _firebaseService.subscriptionsCollection
          .doc(subscription.id)
          .set(subscription.toMap());
    } catch (e) {
      throw 'Failed to add subscription. Please try again.';
    }
  }

  // Update subscription
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    try {
      await _firebaseService.subscriptionsCollection
          .doc(subscription.id)
          .update(subscription.toMap());
    } catch (e) {
      throw 'Failed to update subscription. Please try again.';
    }
  }

  // Delete subscription
  Future<void> deleteSubscription(String subscriptionId) async {
    try {
      await _firebaseService.subscriptionsCollection
          .doc(subscriptionId)
          .delete();
    } catch (e) {
      throw 'Failed to delete subscription. Please try again.';
    }
  }

  // Get user subscriptions stream
  Stream<List<SubscriptionModel>> getUserSubscriptions(String userId) {
    return _firebaseService.subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get upcoming bills (next 30 days)
  Stream<List<SubscriptionModel>> getUpcomingBills(String userId) {
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    return _firebaseService.subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .where('nextBillingDate', isGreaterThanOrEqualTo: now.millisecondsSinceEpoch)
        .where('nextBillingDate', isLessThanOrEqualTo: thirtyDaysFromNow.millisecondsSinceEpoch)
        .orderBy('nextBillingDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get subscription by ID
  Future<SubscriptionModel?> getSubscriptionById(String subscriptionId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.subscriptionsCollection
          .doc(subscriptionId)
          .get();
      
      if (doc.exists) {
        return SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to get subscription. Please try again.';
    }
  }

  // Calculate total monthly subscription cost
  Future<double> getTotalMonthlySubscriptionCost(String userId) async {
    try {
      QuerySnapshot snapshot = await _firebaseService.subscriptionsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final subscription = SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>);
        
        // Convert to monthly cost based on billing cycle
        switch (subscription.billingCycle.toLowerCase()) {
          case 'monthly':
            total += subscription.price;
            break;
          case 'yearly':
            total += subscription.price / 12;
            break;
          case 'weekly':
            total += subscription.price * 4.33; // Average weeks per month
            break;
        }
      }
      
      return total;
    } catch (e) {
      throw 'Failed to calculate total subscription cost.';
    }
  }

  // Create a new subscription with generated ID
  SubscriptionModel createSubscription({
    required String userId,
    required String name,
    required String iconUrl,
    required double price,
    String currency = 'INR',
    String billingCycle = 'monthly',
    required DateTime nextBillingDate,
    String? description,
    String? category,
  }) {
    return SubscriptionModel(
      id: _uuid.v4(),
      userId: userId,
      name: name,
      iconUrl: iconUrl,
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      nextBillingDate: nextBillingDate,
      createdAt: DateTime.now(),
      description: description,
      category: category,
    );
  }

  // Seed dummy data for a user
  Future<void> seedDummySubscriptions(String userId) async {
    final dummySubscriptions = [
      createSubscription(
        userId: userId,
        name: 'Spotify',
        iconUrl: 'assets/img/spotify_logo.png',
        price: 199,
        nextBillingDate: DateTime.now().add(const Duration(days: 15)),
        category: 'Entertainment',
        description: 'Music streaming service',
      ),
      createSubscription(
        userId: userId,
        name: 'YouTube Premium',
        iconUrl: 'assets/img/youtube_logo.png',
        price: 399,
        nextBillingDate: DateTime.now().add(const Duration(days: 8)),
        category: 'Entertainment',
        description: 'Video streaming service',
      ),
      createSubscription(
        userId: userId,
        name: 'Microsoft OneDrive',
        iconUrl: 'assets/img/onedrive_logo.png',
        price: 250,
        nextBillingDate: DateTime.now().add(const Duration(days: 22)),
        category: 'Productivity',
        description: 'Cloud storage service',
      ),
      createSubscription(
        userId: userId,
        name: 'Netflix',
        iconUrl: 'assets/img/netflix_logo.png',
        price: 500,
        nextBillingDate: DateTime.now().add(const Duration(days: 5)),
        category: 'Entertainment',
        description: 'Video streaming service',
      ),
    ];

    for (var subscription in dummySubscriptions) {
      await addSubscription(subscription);
    }
  }
}