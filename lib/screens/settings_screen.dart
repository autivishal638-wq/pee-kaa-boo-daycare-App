// filepath: pee_ka_boo/lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../services/firebase_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.pink[200],
                  child: const Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        FirebaseService.currentUser?.email ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // General Settings
          const Text(
            'General',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.business,
            title: 'Daycare Info',
            subtitle: 'Pee-Kaa-Boo Play House',
            onTap: () => _showDaycareInfoDialog(context),
          ),
          _SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notifications',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.schedule,
            title: 'Working Hours',
            subtitle: 'Mon - Fri (Full/Half Day)',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // Billing Settings
          const Text(
            'Billing',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.currency_rupee,
            title: 'Fee Structure',
            subtitle: '₹1200/hour, ₹700 meals, ₹1000 lunch',
            onTap: () => _showFeeStructureDialog(context),
          ),
          _SettingsTile(
            icon: Icons.calendar_month,
            title: 'Payment Due Date',
            subtitle: '5th of every month',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.warning,
            title: 'Late Fee',
            subtitle: '₹100 per day after due date',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // Data Management
          const Text(
            'Data',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.backup,
            title: 'Backup Data',
            subtitle: 'Export all records',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.analytics,
            title: 'Reports',
            subtitle: 'Attendance & Revenue reports',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // About
          const Text(
            'About',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.info,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help with the app',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // Logout
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDaycareInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daycare Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pee-Kaa-Boo Play House'),
            SizedBox(height: 8),
            Text('Operating Days: Monday - Friday'),
            Text('Closed: Saturdays, Sundays & Holidays'),
            SizedBox(height: 8),
            Text('Note: No pick-up/drop facility'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeeStructureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fee Structure'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Day Care Charges:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• ₹1200 per hour per month'),
            Text('• Paid in advance'),
            SizedBox(height: 12),
            Text('Meal Charges:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• ₹700 per month (Snacks/Breakfast)'),
            Text('• ₹1000 per month (Lunch)'),
            SizedBox(height: 12),
            Text('Extra Charges:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• ₹100 per hour beyond registered hours'),
            Text('• ₹100 per day late fee after 5th'),
            SizedBox(height: 12),
            Text('First Month:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• Before 15th: Full charges'),
            Text('• After 15th: Half charges'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseService.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.pink[400]),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}