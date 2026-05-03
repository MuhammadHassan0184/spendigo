import 'package:local_auth/local_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Box get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box('settings_$uid');
  }

  static bool isBiometricEnabled() {
    return _box.get('isBiometricEnabled', defaultValue: false);
  }

  static Future<void> setBiometricEnabled(bool value) async {
    await _box.put('isBiometricEnabled', value);
  }

  static Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        return true; // Fallback if device doesn't support it
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to open Spendigo',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      showCustomSnackBar("Error", "Authentication failed: $e", isError: true);
      return false;
    }
  }
}
