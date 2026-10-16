import 'package:brew_and_bloom/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'keeps the login and profile details after restoring the service',
    () async {
      final authService = AuthService();

      await authService.login(name: 'Mia Santos', email: 'mia@example.com');
      await authService.updateProfile(
        name: 'Mia Bloom',
        email: 'mia.bloom@example.com',
      );

      final restoredService = AuthService();

      expect(await restoredService.isLoggedIn(), isTrue);
      expect(await restoredService.getName(), 'Mia Bloom');
      expect(await restoredService.getEmail(), 'mia.bloom@example.com');
    },
  );
}
