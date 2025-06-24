import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Current user
  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.uid;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Collection references
  CollectionReference get usersCollection => firestore.collection('users');
  CollectionReference get subscriptionsCollection => firestore.collection('subscriptions');
  CollectionReference get budgetsCollection => firestore.collection('budgets');
  CollectionReference get transactionsCollection => firestore.collection('transactions');
  CollectionReference get cardsCollection => firestore.collection('cards');

  // User-specific collection references
  CollectionReference getUserSubscriptions(String userId) =>
      firestore.collection('subscriptions').where('userId', isEqualTo: userId) as CollectionReference;

  CollectionReference getUserBudgets(String userId) =>
      firestore.collection('budgets').where('userId', isEqualTo: userId) as CollectionReference;

  CollectionReference getUserTransactions(String userId) =>
      firestore.collection('transactions').where('userId', isEqualTo: userId) as CollectionReference;

  CollectionReference getUserCards(String userId) =>
      firestore.collection('cards').where('userId', isEqualTo: userId) as CollectionReference;

  // Auth state stream
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}