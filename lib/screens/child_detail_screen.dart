// filepath: pee_ka_boo/lib/screens/child_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child.dart';

class ChildDetailScreen extends StatelessWidget {
  final String childId;

  const ChildDetailScreen({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Child Details'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('children').doc(childId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final child = Child.fromMap(snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.pink[200],
                        child: Text(
                          child.fullName.isNotEmpty ? child.fullName[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.fullName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (child.nickname != null && child.nickname!.isNotEmpty)
                              Text(
                                '(${child.nickname})',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Age: ${child.age ?? "N/A"} | ${child.gender}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Parent Information
                _DetailSection(
                  title: 'Parent Information',
                  icon: Icons.people,
                  children: [
                    _DetailRow(label: 'Parent 1', value: child.parent1Name),
                    _DetailRow(label: 'Relation', value: child.parent1Relationship),
                    _DetailRow(label: 'Mobile', value: child.parent1Mobile),
                    if (child.parent1Email != null && child.parent1Email!.isNotEmpty)
                      _DetailRow(label: 'Email', value: child.parent1Email!),
                    if (child.parent1Occupation != null && child.parent1Occupation!.isNotEmpty)
                      _DetailRow(label: 'Occupation', value: child.parent1Occupation!),
                    if (child.parent2Name != null && child.parent2Name!.isNotEmpty) ...[
                      const Divider(),
                      _DetailRow(label: 'Parent 2', value: child.parent2Name!),
                      _DetailRow(label: 'Relation', value: child.parent2Relationship ?? ''),
                      _DetailRow(label: 'Mobile', value: child.parent2Mobile ?? ''),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Emergency Contact
                if (child.emergencyContactName != null && child.emergencyContactName!.isNotEmpty)
                  _DetailSection(
                    title: 'Emergency Contact',
                    icon: Icons.emergency,
                    children: [
                      _DetailRow(label: 'Name', value: child.emergencyContactName!),
                      _DetailRow(label: 'Relation', value: child.emergencyContactRelationship ?? ''),
                      _DetailRow(label: 'Contact', value: child.emergencyContactNumber ?? ''),
                    ],
                  ),
                if (child.emergencyContactName != null && child.emergencyContactName!.isNotEmpty)
                  const SizedBox(height: 12),

                // Health Information
                if (child.bloodGroup != null || child.allergies != null || child.medicalConditions != null)
                  _DetailSection(
                    title: 'Health Information',
                    icon: Icons.medical_services,
                    children: [
                      if (child.bloodGroup != null && child.bloodGroup!.isNotEmpty)
                        _DetailRow(label: 'Blood Group', value: child.bloodGroup!),
                      if (child.allergies != null && child.allergies!.isNotEmpty)
                        _DetailRow(label: 'Allergies', value: child.allergies!),
                      if (child.medicalConditions != null && child.medicalConditions!.isNotEmpty)
                        _DetailRow(label: 'Medical Conditions', value: child.medicalConditions!),
                      if (child.doctorNameAndContact != null && child.doctorNameAndContact!.isNotEmpty)
                        _DetailRow(label: 'Doctor', value: child.doctorNameAndContact!),
                    ],
                  ),
                if (child.bloodGroup != null || child.allergies != null || child.medicalConditions != null)
                  const SizedBox(height: 12),

                // Attendance & Schedule
                _DetailSection(
                  title: 'Schedule',
                  icon: Icons.schedule,
                  children: [
                    _DetailRow(label: 'Days', value: child.daysOfAttendance.join(', ')),
                    _DetailRow(label: 'Timing', value: child.timingType),
                    _DetailRow(label: 'Meals', value: child.mealOptions.isNotEmpty ? child.mealOptions.join(', ') : 'None'),
                  ],
                ),
                const SizedBox(height: 12),

                // Billing
                _DetailSection(
                  title: 'Billing',
                  icon: Icons.currency_rupee,
                  children: [
                    _DetailRow(label: 'Day Care Charges', value: '₹${child.dayCareCharges.toStringAsFixed(0)}'),
                    _DetailRow(label: 'Meal Charges', value: '₹${child.mealCharges.toStringAsFixed(0)}'),
                    _DetailRow(label: 'Total', value: '₹${child.totalAmount.toStringAsFixed(0)}'),
                  ],
                ),
                const SizedBox(height: 12),

                // Authorized Pick-up
                if (child.authorizedPickupPersons.isNotEmpty)
                  _DetailSection(
                    title: 'Authorized Pick-up Persons',
                    icon: Icons.person,
                    children: child.authorizedPickupPersons.asMap().entries.map((entry) {
                      return _DetailRow(
                        label: 'Person ${entry.key + 1}',
                        value: '${entry.value['name']} (${entry.value['relation']}) - ${entry.value['contact']}',
                      );
                    }).toList(),
                  ),
                if (child.authorizedPickupPersons.isNotEmpty)
                  const SizedBox(height: 12),

                // Additional Info
                if (child.specialNeeds != null || child.habits != null || child.comfortItems != null)
                  _DetailSection(
                    title: 'Additional Information',
                    icon: Icons.info,
                    children: [
                      if (child.specialNeeds != null && child.specialNeeds!.isNotEmpty)
                        _DetailRow(label: 'Special Needs', value: child.specialNeeds!),
                      if (child.habits != null && child.habits!.isNotEmpty)
                        _DetailRow(label: 'Habits', value: child.habits!),
                      if (child.comfortItems != null && child.comfortItems!.isNotEmpty)
                        _DetailRow(label: 'Comfort Items', value: child.comfortItems!),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Child'),
        content: const Text('Are you sure you want to delete this child? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await FirebaseFirestore.instance.collection('children').doc(childId).delete();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Child deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.pink[400], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}