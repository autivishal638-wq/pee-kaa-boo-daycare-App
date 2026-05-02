// filepath: pee_ka_boo/lib/config/admin_config.dart

/// List of admin email addresses
/// Add your admin email here to grant admin access
class AdminConfig {
  static const List<String> adminEmails = [
    'nishigandhabhor@gmail.com',
  ];

  /// Check if an email is an admin
  static bool isAdmin(String email) {
    return adminEmails.contains(email.toLowerCase().trim());
  }
}