// filepath: pee_ka_boo/lib/models/child.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Child {
  final String id;
  final String fullName;
  final String? nickname;
  final DateTime? dateOfBirth;
  final int? age;
  final String gender; // Male, Female, Other
  final String? homeAddress;
  final String? city;
  final String? pinCode;
  final String? previousDayCareHistory;

  // Parent 1
  final String parent1Name;
  final String parent1Relationship;
  final String parent1Mobile;
  final String? parent1Email;
  final String? parent1Occupation;

  // Parent 2
  final String? parent2Name;
  final String? parent2Relationship;
  final String? parent2Mobile;
  final String? parent2Email;
  final String? parent2Occupation;

  // Emergency Contact
  final String? emergencyContactName;
  final String? emergencyContactRelationship;
  final String? emergencyContactNumber;

  // Health Information
  final String? bloodGroup;
  final String? allergies;
  final String? medicalConditions;
  final String? doctorNameAndContact;

  // Attendance & Schedule
  final DateTime? preferredStartDate;
  final List<String> daysOfAttendance; // Mon, Tue, Wed, Thu, Fri
  final String timingType; // Full Day, Half Day, Custom Hours
  final int? customHoursStart;
  final int? customHoursEnd;
  final List<String> mealOptions; // Breakfast, Lunch, Snacks

  // Program Enrolment
  final int daysPerWeek;
  final int registeredHours;
  final double dayCareCharges;
  final double mealCharges;
  final double totalAmount;

  // Authorized Pick-up Persons
  final List<Map<String, String>> authorizedPickupPersons;

  // Additional Information
  final String? specialNeeds;
  final String? habits;
  final String? comfortItems;

  // Status
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Child({
    required this.id,
    required this.fullName,
    this.nickname,
    this.dateOfBirth,
    this.age,
    required this.gender,
    this.homeAddress,
    this.city,
    this.pinCode,
    this.previousDayCareHistory,
    required this.parent1Name,
    required this.parent1Relationship,
    required this.parent1Mobile,
    this.parent1Email,
    this.parent1Occupation,
    this.parent2Name,
    this.parent2Relationship,
    this.parent2Mobile,
    this.parent2Email,
    this.parent2Occupation,
    this.emergencyContactName,
    this.emergencyContactRelationship,
    this.emergencyContactNumber,
    this.bloodGroup,
    this.allergies,
    this.medicalConditions,
    this.doctorNameAndContact,
    this.preferredStartDate,
    required this.daysOfAttendance,
    required this.timingType,
    this.customHoursStart,
    this.customHoursEnd,
    required this.mealOptions,
    required this.daysPerWeek,
    required this.registeredHours,
    required this.dayCareCharges,
    required this.mealCharges,
    required this.totalAmount,
    required this.authorizedPickupPersons,
    this.specialNeeds,
    this.habits,
    this.comfortItems,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Child.fromMap(Map<String, dynamic> map, String docId) {
    return Child(
      id: docId,
      fullName: map['fullName'] ?? '',
      nickname: map['nickname'],
      dateOfBirth: _parseDate(map['dateOfBirth']),
      age: map['age'],
      gender: map['gender'] ?? '',
      homeAddress: map['homeAddress'],
      city: map['city'],
      pinCode: map['pinCode'],
      previousDayCareHistory: map['previousDayCareHistory'],
      parent1Name: map['parent1Name'] ?? '',
      parent1Relationship: map['parent1Relationship'] ?? '',
      parent1Mobile: map['parent1Mobile'] ?? '',
      parent1Email: map['parent1Email'],
      parent1Occupation: map['parent1Occupation'],
      parent2Name: map['parent2Name'],
      parent2Relationship: map['parent2Relationship'],
      parent2Mobile: map['parent2Mobile'],
      parent2Email: map['parent2Email'],
      parent2Occupation: map['parent2Occupation'],
      emergencyContactName: map['emergencyContactName'],
      emergencyContactRelationship: map['emergencyContactRelationship'],
      emergencyContactNumber: map['emergencyContactNumber'],
      bloodGroup: map['bloodGroup'],
      allergies: map['allergies'],
      medicalConditions: map['medicalConditions'],
      doctorNameAndContact: map['doctorNameAndContact'],
      preferredStartDate: _parseDate(map['preferredStartDate']),
      daysOfAttendance: List<String>.from(map['daysOfAttendance'] ?? []),
      timingType: map['timingType'] ?? 'Full Day',
      customHoursStart: map['customHoursStart'],
      customHoursEnd: map['customHoursEnd'],
      mealOptions: List<String>.from(map['mealOptions'] ?? []),
      daysPerWeek: map['daysPerWeek'] ?? 0,
      registeredHours: map['registeredHours'] ?? 0,
      dayCareCharges: (map['dayCareCharges'] ?? 0).toDouble(),
      mealCharges: (map['mealCharges'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      authorizedPickupPersons: List<Map<String, String>>.from(
        (map['authorizedPickupPersons'] ?? [])
            .map((e) => Map<String, String>.from(e)),
      ),
      specialNeeds: map['specialNeeds'],
      habits: map['habits'],
      comfortItems: map['comfortItems'],
      isActive: map['isActive'] ?? true,
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'age': age,
      'gender': gender,
      'homeAddress': homeAddress,
      'city': city,
      'pinCode': pinCode,
      'previousDayCareHistory': previousDayCareHistory,
      'parent1Name': parent1Name,
      'parent1Relationship': parent1Relationship,
      'parent1Mobile': parent1Mobile,
      'parent1Email': parent1Email,
      'parent1Occupation': parent1Occupation,
      'parent2Name': parent2Name,
      'parent2Relationship': parent2Relationship,
      'parent2Mobile': parent2Mobile,
      'parent2Email': parent2Email,
      'parent2Occupation': parent2Occupation,
      'emergencyContactName': emergencyContactName,
      'emergencyContactRelationship': emergencyContactRelationship,
      'emergencyContactNumber': emergencyContactNumber,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'doctorNameAndContact': doctorNameAndContact,
      'preferredStartDate': preferredStartDate?.toIso8601String(),
      'daysOfAttendance': daysOfAttendance,
      'timingType': timingType,
      'customHoursStart': customHoursStart,
      'customHoursEnd': customHoursEnd,
      'mealOptions': mealOptions,
      'daysPerWeek': daysPerWeek,
      'registeredHours': registeredHours,
      'dayCareCharges': dayCareCharges,
      'mealCharges': mealCharges,
      'totalAmount': totalAmount,
      'authorizedPickupPersons': authorizedPickupPersons,
      'specialNeeds': specialNeeds,
      'habits': habits,
      'comfortItems': comfortItems,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
