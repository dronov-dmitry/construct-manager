import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/constants.dart';
import '../../core/locale_service.dart';
import '../../core/network/supabase_client.dart';
import '../../core/theme_service.dart';
import '../../l10n/app_localizations.dart';
import '../../services/github_update_service.dart';
import '../shell/app_drawer.dart';
import '../../ui/error_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _urlController = TextEditingController();
  final _keyController = TextEditingController();
  bool _isSaving = false;
  String _selectedLanguage = 'ru';
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadLanguage();
    _themeMode = ThemeService.instance.themeMode;
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(AppConstants.prefLanguage);
    if (lang != null && mounted) {
      setState(() => _selectedLanguage = lang);
    }
  }

  Future<void> _onThemeChanged(ThemeMode mode) async {
    await ThemeService.instance.setThemeMode(mode);
    if (mounted) setState(() => _themeMode = mode);
  }

  Future<void> _checkForUpdatesManually() async {
    final s = AppLocalizations.of(context)!;
    final version = await GithubUpdateService.getCurrentVersion();
    final updater = GithubUpdateService(currentVersion: version);
    final info = await updater.checkForUpdate();

    if (!mounted) return;

    if (info == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${s.up_to_date} v$version')),
      );
      return;
    }

    _showUpdateDialog(updater, info);
  }

  void _showUpdateDialog(GithubUpdateService updater, UpdateInfo info) {
    final s = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('${s.update_available} v${info.version}'),
        content: Text(
          '${s.current_version}: v${updater.currentVersion}\n'
          '${s.new_version}: v${info.version}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.update_later),
          ),
          if (info.canAutoUpdate)
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                _downloadAndInstall(updater, info);
              },
              icon: const Icon(Icons.download),
              label: Text(s.download),
            ),
          if (!info.canAutoUpdate)
            FilledButton.icon(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final uri = Uri.parse(info.releaseUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.open_in_new),
              label: Text(s.open_release),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstall(GithubUpdateService updater, UpdateInfo info) async {
    final s = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final path = await updater.downloadAsset(info);
    if (!mounted) return;
    Navigator.of(context).pop();

    if (path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.download_error)),
        );
      }
      return;
    }

    final installed = await updater.installAsset(path);
    if (!mounted) return;
    if (!installed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${s.open_file_error}: $path')),
      );
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _urlController.text = prefs.getString(AppConstants.prefSupabaseUrl) ?? '';
    _keyController.text = prefs.getString(AppConstants.prefSupabaseAnonKey) ?? '';
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      await SupabaseClientManager.instance.updateSettings(
        _urlController.text.trim(),
        _keyController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.save)),
        );
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final isLoggedIn = SupabaseClientManager.instance.auth.currentUser != null;
            context.go(isLoggedIn ? '/home' : '/login');
          },
        ),
        title: Text(s.settings),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.language, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLanguage,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ru', child: Text('Русский')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                      DropdownMenuItem(value: 'uk', child: Text('Українська')),
                    ],
                    onChanged: (lang) async {
                      if (lang == null) return;
                      await LocaleService.instance.setLocale(lang);
                      setState(() => _selectedLanguage = lang);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.theme, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(value: ThemeMode.light, label: Text(s.theme_light)),
                      ButtonSegment(value: ThemeMode.dark, label: Text(s.theme_dark)),
                      ButtonSegment(value: ThemeMode.system, label: Text(s.theme_system)),
                    ],
                    selected: {_themeMode},
                    onSelectionChanged: (selected) => _onThemeChanged(selected.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.supabase_config, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: s.supabase_url,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _keyController,
                    decoration: InputDecoration(
                      labelText: s.supabase_key,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(s.save),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => launchUrl(
                      Uri.parse('https://dronov-dmitry.github.io/construct-manager/supabase.html'),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.open_in_new, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          s.supabase_guide,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.system_update),
              title: Text(s.check_updates),
              trailing: const Icon(Icons.chevron_right),
              onTap: _checkForUpdatesManually,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(s.update_email),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) context.push('/update-email');
              }),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outlined),
              title: Text(s.update_password),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) context.push('/update-password');
              }),
            ),
          ),
        ],
      ),
    );
  }
}
