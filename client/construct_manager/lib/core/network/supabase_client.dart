import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  static const _authSessionKey = 'supabase_auth_session';

  static final _authOptions = AuthClientOptions(
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
      _setupAuthListener();
      return;
    }

    _client = SupabaseClient(url, key, authOptions: _authOptions);
    _currentUrl = url;
    _currentKey = key;
    _setupAuthListener();
    await _restoreSession();
  }

  Future<void> updateSettings(String url, String key) async {
    if (_currentUrl == url && _currentKey == key) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefSupabaseUrl, url);
    await prefs.setString(AppConstants.prefSupabaseAnonKey, key);

    _client = SupabaseClient(url, key, authOptions: _authOptions);
    _currentUrl = url;
    _currentKey = key;
    _setupAuthListener();
    await _restoreSession();
  }

  void _setupAuthListener() {
    client.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        _saveSession(data.session!);
      } else if (data.event == AuthChangeEvent.signedOut) {
        _clearSession();
      }
    });
  }

  Future<void> _saveSession(Session session) async {
    final storage = const FlutterSecureStorage();
    await storage.write(
      key: _authSessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<void> _clearSession() async {
    final storage = const FlutterSecureStorage();
    await storage.delete(key: _authSessionKey);
  }

  Future<void> _restoreSession() async {
    try {
      final storage = const FlutterSecureStorage();
      final data = await storage.read(key: _authSessionKey);
      if (data != null) {
        await client.auth.recoverSession(data);
      }
    } catch (_) {
      // ignore restore errors — user will just need to log in again
    }
  }

  GoTrueClient get auth => client.auth;
  SupabaseStorageClient get storage => client.storage;
}
