import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/network/supabase_client.dart';
import '../../l10n/app_localizations.dart';
import '../../services/app_update.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    final version = await AppUpdate.getCurrentVersion();
    final updater = AppUpdate(currentVersion: version);
    final info = await updater.checkForUpdate();
    if (info == null || !mounted) return;

    _showUpdateDialog(updater, info);
  }

  void _showUpdateDialog(AppUpdate updater, UpdateInfo info) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Доступно обновление v${info.version}'),
        content: Text(
          'Новая версия приложения доступна для скачивания.\n\n'
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

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final user = SupabaseClientManager.instance.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.home_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseClientManager.instance.client.auth.signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(user?.email ?? '', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              user?.emailConfirmedAt != null ? s.email_verified : s.email_not_verified,
              style: TextStyle(
                color: user?.emailConfirmedAt != null ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/constructions'),
              icon: const Icon(Icons.folder),
              label: Text(s.my_projects),
            ),
          ],
        ),
      ),
    );
  }
}
