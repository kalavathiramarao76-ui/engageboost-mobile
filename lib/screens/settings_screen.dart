import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';
import '../models/favorites_model.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _endpointController;
  late TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsModel>();
    _endpointController = TextEditingController(text: settings.endpoint);
    _modelController = TextEditingController(text: settings.model);
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E)],
          ),
        ),
        child: Consumer<SettingsModel>(
          builder: (context, settings, _) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // AI Configuration
                _SectionHeader(title: 'AI Configuration'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.glassDecoration(opacity: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API Endpoint',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _endpointController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'https://sai.sharedllm.com',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save_rounded, size: 20),
                            onPressed: () {
                              settings.setEndpoint(_endpointController.text.trim());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Endpoint saved'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Model',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _modelController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'gpt-oss:120b',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save_rounded, size: 20),
                            onPressed: () {
                              settings.setModel(_modelController.text.trim());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Model saved'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Appearance
                _SectionHeader(title: 'Appearance'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.glassDecoration(opacity: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _ThemeOption(
                            label: 'Dark',
                            icon: Icons.dark_mode_rounded,
                            isSelected: settings.themeMode == ThemeMode.dark,
                            onTap: () => settings.setThemeMode(ThemeMode.dark),
                          ),
                          const SizedBox(width: 12),
                          _ThemeOption(
                            label: 'Light',
                            icon: Icons.light_mode_rounded,
                            isSelected: settings.themeMode == ThemeMode.light,
                            onTap: () => settings.setThemeMode(ThemeMode.light),
                          ),
                          const SizedBox(width: 12),
                          _ThemeOption(
                            label: 'System',
                            icon: Icons.settings_brightness_rounded,
                            isSelected: settings.themeMode == ThemeMode.system,
                            onTap: () => settings.setThemeMode(ThemeMode.system),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Data
                _SectionHeader(title: 'Data'),
                const SizedBox(height: 12),
                Container(
                  decoration: AppTheme.glassDecoration(opacity: 0.08),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.redAccent.withOpacity(0.15),
                      ),
                      child: const Icon(Icons.delete_forever_rounded,
                          color: Colors.redAccent, size: 22),
                    ),
                    title: const Text(
                      'Clear All Data',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Text(
                      'Reset settings and clear favorites',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    onTap: () => _showClearDialog(context, settings),
                  ),
                ),

                const SizedBox(height: 40),

                // About
                Center(
                  child: Column(
                    children: [
                      Text(
                        'EngageBoost AI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Powered by AI',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, SettingsModel settings) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Data?'),
        content: const Text(
            'This will reset all settings to defaults and clear your favorites. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              settings.clearData();
              context.read<FavoritesModel>().clearAll();
              _endpointController.text = 'https://sai.sharedllm.com';
              _modelController.text = 'gpt-oss:120b';
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child:
                const Text('Clear', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey[500],
        letterSpacing: 1.5,
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? const Color(0xFF5C6BC0).withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF5C6BC0)
                  : Colors.grey.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF5C6BC0)
                    : Colors.grey[500],
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF5C6BC0)
                      : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
