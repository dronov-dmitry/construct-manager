import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/constants.dart';
import 'core/network/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseClientManager.instance.initialize();
  await setupLocator();

  final prefs = await SharedPreferences.getInstance();
  final themeMode = prefs.getString(AppConstants.prefThemeMode) ?? 'system';

  runApp(ConstructManagerApp(initialThemeMode: themeMode));
}

Future<void> setupLocator() async {
  // DI setup placeholder
}

class ConstructManagerApp extends StatefulWidget {
  final String initialThemeMode;

  const ConstructManagerApp({super.key, required this.initialThemeMode});

  @override
  State<ConstructManagerApp> createState() => _ConstructManagerAppState();
}

class _ConstructManagerAppState extends State<ConstructManagerApp> {
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _parseThemeMode(widget.initialThemeMode);
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ConstructManager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
