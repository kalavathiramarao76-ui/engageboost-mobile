import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'models/settings_model.dart';
import 'screens/splash_screen.dart';

class EngageBoostApp extends StatelessWidget {
  const EngageBoostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'EngageBoost AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
