import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app.dart';
import 'core/locale_service.dart';
import 'core/network/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme_service.dart';
import 'l10n/app_localizations.dart';
import 'ui/error_screen.dart';

final _messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Workaround for Flutter Windows issue:
  // Holding Alt sends repeat key events with mismatched modifier flags,
  // triggering an assertion in raw_keyboard.dart.
  HardwareKeyboard.instance.addHandler((event) {
    if (event is KeyRepeatEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.altLeft ||
          key == LogicalKeyboardKey.altRight ||
          key == LogicalKeyboardKey.controlLeft ||
          key == LogicalKeyboardKey.controlRight ||
          key == LogicalKeyboardKey.shiftLeft ||
          key == LogicalKeyboardKey.shiftRight) {
        return true;
      }
    }
    return false;
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    final msg = details.exceptionAsString();
    if (msg.contains('AnimationController.dispose() called more than once')) {
      FlutterError.dumpErrorToConsole(details);
      return;
    }
    FlutterError.dumpErrorToConsole(details);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = navigatorKey.currentState;
      if (nav == null) return;
      ErrorReportDialog.showWithGlobalKey(navigatorKey, error: details.exception, stack: details.stack);
    });
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    final msg = error.toString();
    if (msg.contains('AnimationController.dispose() called more than once')) {
      debugPrint('(suppressed) $msg');
      return true;
    }
    debugPrint('Unhandled error: $error\n$stack');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = navigatorKey.currentState;
      if (nav == null) return;
      ErrorReportDialog.showWithGlobalKey(navigatorKey, error: error, stack: stack);
    });
    return true;
  };

  Object? initError;
  StackTrace? initStack;
  try {
    await SupabaseClientManager.instance.initialize();
    await setupLocator();
    await LocaleService.instance.load();
    await ThemeService.instance.load();
  } catch (e, st) {
    initError = e;
    initStack = st;
  }

  SupabaseClientManager.instance.client.auth.onAuthStateChange.listen((data) {
    // Session recovered from deep link (email confirmation, etc.)
    // GoRouter redirect will handle navigation
  });

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return _RenderErrorWidget(details: details);
  };

  if (initError != null) {
    runApp(ErrorApp(error: initError, stack: initStack));
    return;
  }

  runApp(const ConstructManagerApp());
}

Future<void> setupLocator() async {
  // DI setup placeholder
}

class _RenderErrorWidget extends StatefulWidget {
  const _RenderErrorWidget({required this.details});

  final FlutterErrorDetails details;

  @override
  State<_RenderErrorWidget> createState() => _RenderErrorWidgetState();
}

class _RenderErrorWidgetState extends State<_RenderErrorWidget> {
  bool _copied = false;

  String _buildReport() {
    return '🐛 ConstructManager render error\n\n'
        '❌ ${widget.details.exceptionAsString()}\n'
        '📋 ${widget.details.stack ?? ''}';
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.details.exceptionAsString()));
    if (mounted) setState(() => _copied = true);
  }

  Future<void> _sendReport() async {
    final report = _buildReport();
    await Clipboard.setData(ClipboardData(text: report));
    if (mounted) setState(() => _copied = true);

    const username = 'DmitryDronov';
    for (final uri in [
      Uri.parse('tg://resolve?domain=$username'),
      Uri.parse('https://t.me/$username'),
    ]) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1A2E),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Render Error',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      widget.details.exceptionAsString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _copy,
                    icon: Icon(_copied ? Icons.check : Icons.copy, size: 16),
                    label: Text(_copied ? 'Copied' : 'Copy error'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _sendReport,
                    icon: const Icon(Icons.telegram, size: 16),
                    label: Text(_copied ? 'Copied — paste in Telegram' : 'Send to Telegram'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConstructManagerApp extends StatefulWidget {
  const ConstructManagerApp({super.key});

  @override
  State<ConstructManagerApp> createState() => _ConstructManagerAppState();
}

class _ConstructManagerAppState extends State<ConstructManagerApp> {
  @override
  void initState() {
    super.initState();
    LocaleService.instance.addListener(_onChanged);
    ThemeService.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    LocaleService.instance.removeListener(_onChanged);
    ThemeService.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: const ValueKey('ConstructManagerApp'),
      title: 'ConstructManager',
      debugShowCheckedModeBanner: false,
      locale: LocaleService.instance.locale,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeService.instance.themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      scaffoldMessengerKey: _messengerKey,
    );
  }
}
