// filepath: pee_ka_boo/lib/services/firebase_service.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/child.dart';
import '../models/attendance.dart';
import '../models/payment.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const _uuid = Uuid();

  // ==================== AUTH ====================
  
  static Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  static Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;

  // ==================== CHILDREN ====================

  static Future<String> addChild(Child child) async {
    final docRef = _db.collection('children').doc();
    await docRef.set(child.toMap());
    return docRef.id;
  }

  static Future<void> updateChild(Child child) async {
    await _db.collection('children').doc(child.id).update(child.toMap());
  }

  static Future<void> deleteChild(String childId) async {
    await _db.collection('children').doc(childId).delete();
  }

  static Stream<List<Child>> getChildren() {
    return _db.collection('children')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Child.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Future<Child?> getChild(String childId) async {
    final doc = await _db.collection('children').doc(childId).get();
    if (doc.exists) {
      return Child.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // ==================== ATTENDANCE ====================

  static Future<String> markAttendance(Attendance attendance) async {
    final docRef = _db.collection('attendance').doc();
    await docRef.set(attendance.toMap());
    return docRef.id;
  }

  static Future<void> updateAttendance(Attendance attendance) async {
    await _db.collection('attendance').doc(attendance.id).update(attendance.toMap());
  }

  static Stream<List<Attendance>> getAttendanceForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return _db.collection('attendance')
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attendance.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Stream<List<Attendance>> getAttendanceForChild(String childId) {
    return _db.collection('attendance')
        .where('childId', isEqualTo: childId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attendance.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ==================== PAYMENTS ====================

  static Future<String> createPayment(Payment payment) async {
    final docRef = _db.collection('payments').doc();
    await docRef.set(payment.toMap());
    return docRef.id;
  }

  static Future<void> updatePayment(Payment payment) async {
    await _db.collection('payments').doc(payment.id).update(payment.toMap());
  }

  static Stream<List<Payment>> getPaymentsForChild(String childId) {
    return _db.collection('payments')
        .where('childId', isEqualTo: childId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Stream<List<Payment>> getAllPayments() {
    return _db.collection('payments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Stream<List<Payment>> getPendingPayments() {
    return _db.collection('payments')
        .where('paymentStatus', whereIn: ['Pending', 'Partial', 'Overdue'])
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Payment.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ==================== UTILITIES ====================

  static String generateId() {
    return _uuid.v4();
  }

  static String getCurrentMonth() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  // Calculate fee based on T&C
  static double calculateDayCareCharges(int hours, int daysPerWeek) {
    const hourlyRate = 1200;
    return (hours * hourlyRate).toDouble();
  }

  static double calculateMealCharges(List<String> mealOptions) {
    double total = 0;
    if (mealOptions.contains('Breakfast') || mealOptions.contains('Snacks')) {
      total += 700;
    }
    if (mealOptions.contains('Lunch')) {
      total += 1000;
    }
    return total;
  }

  // Pro-rating for first month
  static double calculateProRatedCharges(double monthlyCharge, DateTime joinDate) {
    final day = joinDate.day;
    if (day < 15) {
      return monthlyCharge; // Full month
    } else {
      return monthlyCharge / 2; // Half month
    }
  }
}