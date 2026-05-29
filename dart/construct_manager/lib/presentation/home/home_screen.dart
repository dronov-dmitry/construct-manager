import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/supabase_client.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
