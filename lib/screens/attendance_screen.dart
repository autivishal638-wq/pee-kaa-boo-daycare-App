// filepath: pee_ka_boo/lib/screens/attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/attendance.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('EEEE').format(_selectedDate),
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy').format(_selectedDate),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
          ),
          // Attendance List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('children')
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final children = snapshot.data!.docs
                    .map((doc) => Child.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                if (children.isEmpty) {
                  return const Center(
                    child: Text('No children registered yet'),
                  );
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('attendance')
                      .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate))
                      .snapshots(),
                  builder: (context, attendanceSnapshot) {
                    Map<String, Attendance> attendanceMap = {};
                    if (attendanceSnapshot.hasData) {
                      for (var doc in attendanceSnapshot.data!.docs) {
                        final att = Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                        attendanceMap[att.childId] = att;
                      }
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        final child = children[index];
                        final attendance = attendanceMap[child.id];
                        return _AttendanceCard(
                          child: child,
                          attendance: attendance,
                          selectedDate: _selectedDate,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
}

class _AttendanceCard extends StatelessWidget {
  final Child child;
  final Attendance? attendance;
  final DateTime selectedDate;

  const _AttendanceCard({
    required this.child,
    this.attendance,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = attendance?.status == 'Present';
    final isAbsent = attendance?.status == 'Absent';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: isPresent
                  ? Colors.green[200]
                  : isAbsent
                      ? Colors.red[200]
                      : Colors.grey[200],
              child: Text(
                child.fullName.isNotEmpty ? child.fullName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    child.parent1Name,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (attendance != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'In: ${attendance!.checkInTime}${attendance!.checkOutTime != null ? " | Out: ${attendance!.checkOutTime}" : ""}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            // Status Buttons
            Row(
              children: [
                _StatusButton(
                  label: 'Present',
                  color: Colors.green,
                  isSelected: isPresent,
                  onTap: () => _markAttendance(context, 'Present'),
                ),
                const SizedBox(width: 8),
                _StatusButton(
                  label: 'Absent',
                  color: Colors.red,
                  isSelected: isAbsent,
                  onTap: () => _markAttendance(context, 'Absent'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAttendance(BuildContext context, String status) async {
    try {
      final now = DateTime.now();
      final timeString = DateFormat('HH:mm').format(now);

      if (attendance != null) {
        // Update existing
        await FirebaseFirestore.instance.collection('attendance').doc(attendance!.id).update({
          'status': status,
          'checkOutTime': status == 'Absent' ? null : timeString,
        });
      } else {
        // Create new
        await FirebaseFirestore.instance.collection('attendance').add({
          'childId': child.id,
          'childName': child.fullName,
          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
          'checkInTime': status == 'Present' ? timeString : '',
          'checkOutTime': null,
          'status': status,
          'mealsProvided': child.mealOptions,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${child.fullName} marked as $status'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}