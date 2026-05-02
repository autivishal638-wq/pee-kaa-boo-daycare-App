// filepath: pee_ka_boo/lib/models/attendance.dart

class Attendance {
  final String id;
  final String childId;
  final String childName;
  final DateTime date;
  final String checkInTime;
  final String? checkOutTime;
  final String status; // Present, Absent, Late
  final String? remarks;
  final List<String> mealsProvided; // Breakfast, Lunch, Snacks
  final int? extraHours;
  final double? extraCharges;
  final DateTime createdAt;

  Attendance({
    required this.id,
    required this.childId,
    required this.childName,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.remarks,
    required this.mealsProvided,
    this.extraHours,
    this.extraCharges,
    required this.createdAt,
  });

  factory Attendance.fromMap(Map<String, dynamic> map, String docId) {
    return Attendance(
      id: docId,
      childId: map['childId'] ?? '',
      childName: map['childName'] ?? '',
      date: DateTime.parse(map['date']),
      checkInTime: map['checkInTime'] ?? '',
      checkOutTime: map['checkOutTime'],
      status: map['status'] ?? 'Present',
      remarks: map['remarks'],
      mealsProvided: List<String>.from(map['mealsProvided'] ?? []),
      extraHours: map['extraHours'],
      extraCharges: map['extraCharges']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'childName': childName,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
      'remarks': remarks,
      'mealsProvided': mealsProvided,
      'extraHours': extraHours,
      'extraCharges': extraCharges,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}