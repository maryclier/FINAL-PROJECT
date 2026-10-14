import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginKey = 'brew_bloom_logged_in';
  static const String _nameKey = 'brew_bloom_user_name';
  static const String _emailKey = 'brew_bloom_user_email';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  Future<void> login({
    String name = 'Coffee Lover',
    String email = 'hello@brewandbloom.com',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loginKey, true);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'Coffee Lover';
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? 'hello@brewandbloom.com';
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }
}