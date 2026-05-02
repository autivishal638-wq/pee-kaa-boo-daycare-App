// filepath: pee_ka_boo/lib/models/payment.dart

class Payment {
  final String id;
  final String childId;
  final String childName;
  final String month; // e.g., "April 2026"
  final double dayCareCharges;
  final double mealCharges;
  final double extraCharges;
  final double lateFee;
  final double totalAmount;
  final double paidAmount;
  final String paymentStatus; // Paid, Pending, Partial, Overdue
  final String? paymentMethod; // Cash, UPI, Bank Transfer
  final DateTime? paymentDate;
  final String? remarks;
  final DateTime dueDate;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.childId,
    required this.childName,
    required this.month,
    required this.dayCareCharges,
    required this.mealCharges,
    this.extraCharges = 0,
    this.lateFee = 0,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentDate,
    this.remarks,
    required this.dueDate,
    required this.createdAt,
  });

  factory Payment.fromMap(Map<String, dynamic> map, String docId) {
    return Payment(
      id: docId,
      childId: map['childId'] ?? '',
      childName: map['childName'] ?? '',
      month: map['month'] ?? '',
      dayCareCharges: (map['dayCareCharges'] ?? 0).toDouble(),
      mealCharges: (map['mealCharges'] ?? 0).toDouble(),
      extraCharges: (map['extraCharges'] ?? 0).toDouble(),
      lateFee: (map['lateFee'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paidAmount: (map['paidAmount'] ?? 0).toDouble(),
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      paymentMethod: map['paymentMethod'],
      paymentDate: map['paymentDate'] != null 
          ? DateTime.parse(map['paymentDate']) 
          : null,
      remarks: map['remarks'],
      dueDate: DateTime.parse(map['dueDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'childName': childName,
      'month': month,
      'dayCareCharges': dayCareCharges,
      'mealCharges': mealCharges,
      'extraCharges': extraCharges,
      'lateFee': lateFee,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate?.toIso8601String(),
      'remarks': remarks,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Calculate if overdue
  bool get isOverdue {
    final now = DateTime.now();
    return paymentStatus != 'Paid' && now.isAfter(dueDate);
  }

  // Calculate days overdue
  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  // Calculate late fee
  double get calculatedLateFee {
    if (isOverdue) {
      return daysOverdue * 100; // ₹100 per day as per T&C
    }
    return 0;
  }
}