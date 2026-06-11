import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/network/supabase_client.dart';
import '../../l10n/app_localizations.dart';

class InfoAppScreen extends StatelessWidget {
  const InfoAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final isLoggedIn = SupabaseClientManager.instance.auth.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(isLoggedIn ? '/home' : '/login'),
        ),
        title: Text(s.about_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.construction,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              s.about_description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openUrl(context, 'https://dronov-dmitry.github.io/'),
              icon: const Icon(Icons.open_in_new),
              label: Text(s.website),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openUrl(context, 'https://github.com/dronov-dmitry/'),
              icon: const Icon(Icons.code),
              label: Text(s.github_profile),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openUrl(context, 'https://youtu.be/MbzCh3P16tI'),
              icon: const Icon(Icons.video_library),
              label: Text(s.video_guide),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
