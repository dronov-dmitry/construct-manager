import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/constants.dart';
import '../../core/network/supabase_client.dart';
import '../../core/utils/validators.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseClientManager.instance.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e, st) {
      if (mounted) {
        final msg = e.toString();
        if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
          _showConnectionError();
        } else {
          ErrorReportDialog.show(
            context,
            error: e,
            stack: st,
            contextInfo: 'login',
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showConnectionError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cloud_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('Нет подключения к серверу'),
          ],
        ),
        content: const Text(
          'Приложение не может подключиться к серверу.\n\n'
          'Нажмите на иконку в правом верхнем углу и '
          'укажите адрес вашего Supabase сервера и Anon Key.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Закрыть'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showServerConfig();
            },
            icon: const Icon(Icons.dns_outlined),
            label: const Text('Настроить сервер'),
          ),
        ],
      ),
    );
  }

  Future<void> _showServerConfig() async {
    final urlController = TextEditingController();
    final keyController = TextEditingController();
    final prefs = await SharedPreferences.getInstance();
    urlController.text = prefs.getString(AppConstants.prefSupabaseUrl) ?? '';
    keyController.text = prefs.getString(AppConstants.prefSupabaseAnonKey) ?? '';

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Настройки сервера'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Supabase URL',
                hintText: 'https://your-project.supabase.co',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Supabase Anon Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => launchUrl(
                Uri.parse('https://dronov-dmitry.github.io/construct-manager/supabase.html'),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.open_in_new, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Инструкция по настройке Supabase',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              final url = urlController.text.trim();
              final key = keyController.text.trim();
              if (url.isEmpty || key.isEmpty) return;
              await SupabaseClientManager.instance.updateSettings(url, key);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.dns_outlined),
            tooltip: 'Настройки сервера',
            onPressed: _showServerConfig,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.construction,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s.app_title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: s.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final err = Validators.email(v);
                      return err != null ? s.toast_invalid_email : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: s.password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (v) {
                      final err = Validators.password(v);
                      return err != null ? s.toast_password_length : null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(s.sign_in),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: Text(s.no_account),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
