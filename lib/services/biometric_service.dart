import 'package:local_auth/local_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Box? get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    if (!Hive.isBoxOpen('settings_$uid')) return null;
    return Hive.box('settings_$uid');
  }

  static bool isBiometricEnabled() {
    final box = _box;
    if (box == null) return false;
    return box.get('isBiometricEnabled', defaultValue: false);
  }

  static Future<void> setBiometricEnabled(bool value) async {
    final box = _box;
    if (box != null) {
      await box.put('isBiometricEnabled', value);
    }
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
