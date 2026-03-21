import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class HookCard extends StatelessWidget {
  final String hook;
  final int index;

  const HookCard({
    super.key,
    required this.hook,
    required this.index,
  });

  static const _styles = [
    'Question Hook',
    'Bold Statement',
    'Statistic',
    'Story Opener',
    'Contrarian Take',
  ];

  static const _icons = [
    Icons.help_outline_rounded,
    Icons.bolt_rounded,
    Icons.bar_chart_rounded,
    Icons.menu_book_rounded,
    Icons.shuffle_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final style = index < _styles.length ? _styles[index] : 'Hook ${index + 1}';
    final icon = index < _icons.length ? _icons[index] : Icons.lightbulb;
    final hue = (index * 55.0) % 360;
    final color = HSLColor.fromAHSL(1.0, hue, 0.65, 0.55).toColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.glassDecoration(opacity: 0.06),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          style,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            hook,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy_rounded, color: Colors.grey[500], size: 20),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: hook));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Hook copied!'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
