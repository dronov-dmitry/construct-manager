import '../../core/network/supabase_client.dart';
import '../models/user.dart';

class UserService {
  Future<void> writeNewUser(
    String userUid,
    String name,
    String email,
    bool admin,
    bool isEmailVerified,
    String role,
  ) async {
    final user = User(
      uid: userUid,
      name: name,
      email: email,
      admin: admin,
      isEmailVerified: isEmailVerified,
      role: role,
    );
    await SupabaseClientManager.instance.client
        .from('users')
        .upsert(user.toJson());
  }

  Future<List<User>> getAllUsers() async {
    final data = await SupabaseClientManager.instance.client
        .from('users')
        .select();
    final list = data as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }
}
