import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/supabase_client.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    await SupabaseClientManager.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) async {
    await SupabaseClientManager.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await SupabaseClientManager.instance.client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await SupabaseClientManager.instance.client.auth.resetPasswordForEmail(email);
  }

  Future<void> updateEmail(String email) async {
    await SupabaseClientManager.instance.client.auth.updateUser(
      UserAttributes(email: email),
    );
  }

  Future<void> updatePassword(String password) async {
    await SupabaseClientManager.instance.client.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  Future<void> sendEmailVerification() async {
    final user = SupabaseClientManager.instance.client.auth.currentUser;
    if (user != null && user.emailConfirmedAt == null) {
      await SupabaseClientManager.instance.client.auth.resend(
        type: OtpType.signup,
        email: user.email!,
      );
    }
  }

  bool get isLoggedIn =>
      SupabaseClientManager.instance.client.auth.currentUser != null;
}
