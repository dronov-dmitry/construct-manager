import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/supabase_client.dart';
import '../../core/utils/validators.dart';
import '../../data/services/user_service.dart';
import '../../l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseClientManager.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final authUser = SupabaseClientManager.instance.auth.currentUser;
      if (authUser != null) {
        await _userService.writeNewUser(
          authUser.id,
          _nameController.text.trim(),
          authUser.email ?? '',
          false,
          authUser.emailConfirmedAt != null,
          'executor',
        );
      }
      if (mounted) {
        final s = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s?.email_verif_send ?? 'Verification email sent')),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/home');
        });
      }
    } catch (e) {
      if (mounted) {
        final s = AppLocalizations.of(context);
        final message = _formatAuthError(e, s);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(s?.error ?? 'Error'),
            content: SelectableText(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(s?.cancel ?? 'OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatAuthError(Object e, AppLocalizations? s) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('user already registered') || msg.contains('already exists')) {
      return s?.toast_user_exists ?? 'User already exists';
    }
    if (msg.contains('weak password')) {
      return s?.toast_password_length ?? 'Password must be at least 8 characters';
    }
    if (msg.contains('invalid email') || msg.contains('not a valid email')) {
      return s?.toast_invalid_email ?? 'Invalid email format';
    }
    if (msg.contains('network') || msg.contains('socket') || msg.contains('connection')) {
      return s?.toast_network_error ?? 'Network error. Check your connection';
    }
    return '${s?.toast_unexpected_error ?? "Unexpected error"}: ${e.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
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
                  Text(
                    s.sign_up,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _repeatPasswordController,
                    decoration: InputDecoration(
                      labelText: s.repeat_password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureRepeatPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _obscureRepeatPassword = !_obscureRepeatPassword),
                      ),
                    ),
                    obscureText: _obscureRepeatPassword,
                    validator: (v) {
                      final err = Validators.repeatPassword(v, _passwordController.text);
                      return err != null ? s.toast_passwords_dont_match : null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(s.sign_up),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) context.go('/login');
                    }),
                    child: Text(s.has_account),
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
