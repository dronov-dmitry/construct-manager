import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';

class SupabaseClientManager {
  static SupabaseClientManager? _instance;
  late SupabaseClient _client;
  String _currentUrl = '';
  String _currentKey = '';

  SupabaseClientManager._();

  static SupabaseClientManager get instance {
    _instance ??= SupabaseClientManager._();
    return _instance!;
  }

  SupabaseClient get client => _client;

  static const _authOptions = AuthClientOptions(
    authFlowType: AuthFlowType.implicit,
  );

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(AppConstants.prefSupabaseUrl) ?? '';
    final key = prefs.getString(AppConstants.prefSupabaseAnonKey) ?? '';

    if (url.isEmpty || key.isEmpty) {
      _client = SupabaseClient(
        'https://demo.supabase.co',
        'demo-key-placeholder',
        authOptions: _authOptions,
      );
      _currentUrl = 'https://demo.supabase.co';
      _currentKey = 'demo-key-placeholder';
      return;
    }

    _client = SupabaseClient(url, key, authOptions: _authOptions);
    _currentUrl = url;
    _currentKey = key;
  }

  Future<void> updateSettings(String url, String key) async {
    if (_currentUrl == url && _currentKey == key) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefSupabaseUrl, url);
    await prefs.setString(AppConstants.prefSupabaseAnonKey, key);

    _client = SupabaseClient(url, key, authOptions: _authOptions);
    _currentUrl = url;
    _currentKey = key;
  }

  GoTrueClient get auth => client.auth;
  SupabaseStorageClient get storage => client.storage;
}
