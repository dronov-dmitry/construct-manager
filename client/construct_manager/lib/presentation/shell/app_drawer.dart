import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/supabase_client.dart';
import '../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final user = SupabaseClientManager.instance.auth.currentUser;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            (user?.email ?? '?')[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.email ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Text(s.home_title),
                    onTap: () => _navigate(context, '/home'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(s.my_projects),
                    onTap: () => _navigate(context, '/constructions'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(s.settings),
                    onTap: () => _navigate(context, '/settings'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(s.about_title),
                    onTap: () => _navigate(context, '/info'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(s.logout),
              onTap: () async {
                await SupabaseClientManager.instance.client.auth.signOut();
                if (context.mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) context.go('/login');
                  });
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String path) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(path);
    });
  }
}
