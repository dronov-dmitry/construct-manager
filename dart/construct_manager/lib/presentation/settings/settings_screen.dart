import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/constants.dart';
import '../../core/network/supabase_client.dart';
import '../../l10n/app_localizations.dart';
import '../../services/app_update.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _urlController = TextEditingController();
  final _keyController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _checkForUpdatesManually() async {
    final version = await AppUpdate.getCurrentVersion();
    final updater = AppUpdate(currentVersion: version);
    final info = await updater.checkForUpdate();

    if (!mounted) return;

    if (info == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('У вас актуальная версия v$version')),
      );
      return;
    }

    _showUpdateDialog(updater, info);
  }

  void _showUpdateDialog(AppUpdate updater, UpdateInfo info) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Доступно обновление v${info.version}'),
        content: Text(
          'Текущая: v${updater.currentVersion}\n'
          'Новая: v${info.version}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Позже'),
          ),
          if (info.canAutoUpdate)
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                _downloadAndInstall(updater, info);
              },
              icon: const Icon(Icons.download),
              label: const Text('Скачать'),
            ),
          if (!info.canAutoUpdate)
            FilledButton.icon(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final uri = Uri.parse(info.releaseUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Открыть релиз'),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstall(AppUpdate updater, UpdateInfo info) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final path = await updater.downloadAsset(info);
    if (!mounted) return;
    Navigator.of(context).pop();

    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка скачивания')),
      );
      return;
    }

    final installed = await updater.installAsset(path);
    if (!mounted) return;
    if (!installed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть файл. Скачано в: $path')),
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
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
      appBar: AppBar(title: Text(s.settings)),
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
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'ru', label: Text(s.russian)),
                      ButtonSegment(value: 'en', label: Text(s.english)),
                    ],
                    selected: const {'ru'},
                    onSelectionChanged: (selected) {},
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
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                      ButtonSegment(value: ThemeMode.system, label: Text('System')),
                    ],
                    selected: {ThemeMode.light},
                    onSelectionChanged: (selected) {},
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
                          'Инструкция по настройке Supabase',
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
              title: const Text('Проверить обновления'),
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
              onTap: () => context.push('/update-email'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outlined),
              title: Text(s.update_password),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/update-password'),
            ),
          ),
        ],
      ),
    );
  }
}
