import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const _telegramUsername = 'DmitryDronov';

/// Показывается вместо чёрного экрана при ошибке запуска.
class ErrorApp extends StatelessWidget {
  const ErrorApp({
    super.key,
    required this.error,
    this.stack,
  });

  final Object error;
  final StackTrace? stack;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16213E),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Startup Error',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCard('System', _sysInfo(), Colors.blueAccent),
                const SizedBox(height: 12),
                _infoCard('Error', error.toString(), Colors.redAccent),
                if (stack != null) ...[
                  const SizedBox(height: 12),
                  _infoCard('Stack trace', stack.toString(), Colors.orangeAccent),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String content, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 6),
          SelectableText(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Диалог отправки отчёта об ошибке с копированием в Telegram.
class ErrorReportDialog extends StatefulWidget {
  const ErrorReportDialog({
    super.key,
    required this.error,
    this.stack,
    this.contextInfo,
  });

  final Object error;
  final StackTrace? stack;
  final String? contextInfo;

  static Future<void> show(BuildContext context, {
    required Object error,
    StackTrace? stack,
    String? contextInfo,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ErrorReportDialog(
        error: error,
        stack: stack,
        contextInfo: contextInfo,
      ),
    );
  }

  @override
  State<ErrorReportDialog> createState() => _ErrorReportDialogState();
}

class _ErrorReportDialogState extends State<ErrorReportDialog> {
  bool _copied = false;

  String _sysInfo() {
    try {
      return 'OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n'
          'Dart: ${Platform.version}';
    } catch (_) {
      return 'OS: unknown';
    }
  }

  String _buildReport() {
    final sys = _sysInfo();
    final err = widget.error.toString();
    final stackStr = widget.stack?.toString() ?? '';
    final contextStr =
        widget.contextInfo != null ? '\nContext: ${widget.contextInfo}' : '';

    return '🐛 ConstructManager crash\n\n'
        '📱 $sys\n'
        '❌ Error\n$err\n'
        '📋 Stack\n$stackStr'
        '$contextStr';
  }

  Future<void> _sendReport() async {
    final report = _buildReport();

    await Clipboard.setData(ClipboardData(text: report));
    if (mounted) setState(() => _copied = true);

    for (final uri in [
      Uri.parse('tg://resolve?domain=$_telegramUsername'),
      Uri.parse('https://t.me/$_telegramUsername'),
    ]) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent),
          SizedBox(width: 8),
          Text('Ошибка'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: SelectableText(
                widget.error.toString(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            if (widget.contextInfo != null) ...[
              const SizedBox(height: 8),
              Text(
                'Раздел: ${widget.contextInfo}',
                style: TextStyle(
                    fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
        FilledButton.icon(
          onPressed: _sendReport,
          icon: Icon(_copied ? Icons.check : Icons.telegram),
          label: Text(_copied
              ? 'Скопировано — вставьте в Telegram'
              : 'Отправить отчёт'),
        ),
      ],
    );
  }
}

String _sysInfo() {
  try {
    return 'OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n'
        'Dart: ${Platform.version}';
  } catch (_) {
    return 'OS: unknown';
  }
}
