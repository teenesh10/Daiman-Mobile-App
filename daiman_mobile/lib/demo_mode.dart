import 'package:shared_preferences/shared_preferences.dart';

class DemoMode {
  static const String _demoModeKey = 'demo_mode';
  static const String _demoUserKey = 'demo_user';
  
  // Demo user data
  static const Map<String, dynamic> demoUser = {
    'uid': 'demo_user_123',
    'email': 'demo@daiman.com',
    'username': 'Demo User',
    'isVerified': true,
  };

  // Check if app is in demo mode
  static Future<bool> isDemoMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_demoModeKey) ?? false;
  }

  // Enable demo mode
  static Future<void> enableDemoMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_demoModeKey, true);
    await prefs.setString(_demoUserKey, 'demo_user_123');
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', 'demo@daiman.com');
  }

  // Disable demo mode
  static Future<void> disableDemoMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_demoModeKey, false);
    await prefs.remove(_demoUserKey);
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
  }

  // Get demo user data
  static Map<String, dynamic> getDemoUserData() {
    return demoUser;
  }

  // Check if current user is demo user
  static Future<bool> isDemoUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_demoUserKey);
    return userId == 'demo_user_123';
  }
}
