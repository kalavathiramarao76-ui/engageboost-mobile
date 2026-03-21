import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/ai_service.dart';
import 'models/favorites_model.dart';
import 'models/settings_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        ChangeNotifierProvider(create: (_) => FavoritesModel()),
        Provider(create: (_) => AiService()),
      ],
      child: const EngageBoostApp(),
    ),
  );
}
