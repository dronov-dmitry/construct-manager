import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
  }

  Future<bool> authenticate() async {
    try {
      // local_auth 3.x: AuthenticationOptions убран, параметры передаются напрямую.
      // stickyAuth → persistAcrossBackgrounding
      // useErrorDialogs убран (обработка ошибок теперь через LocalAuthException)
      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to access ConstructManager',
        persistAcrossBackgrounding: true,
      );
      return result;
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
