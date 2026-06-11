import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gotrue/gotrue.dart' show AuthApiException;
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
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
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
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/home');
        });
      }
    } catch (e, st) {
      if (mounted) {
        final msg = e.toString();
        if (e is AuthApiException && e.code == 'invalid_credentials') {
          _showInvalidCredentialsError();
        } else if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
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

  void _showInvalidCredentialsError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Ошибка входа'),
          ],
        ),
        content: const Text('Неверный email или пароль. Проверьте введённые данные.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
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
          'Перейдите в Настройки → Подключение к серверу '
          'и укажите адрес вашего Supabase сервера и Anon Key.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Закрыть'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/settings');
            },
            icon: const Icon(Icons.settings),
            label: const Text('Настройки'),
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    validator: (v) {
                      final err = Validators.email(v);
                      return err != null ? s.toast_invalid_email : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
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
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
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
                    onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) context.push('/signup');
                    }),
                    child: Text(s.no_account),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) context.push('/settings');
                    }),
                    icon: const Icon(Icons.settings, size: 18),
                    label: Text(s.settings),
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
