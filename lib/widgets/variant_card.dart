import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';

class VariantCard extends StatelessWidget {
  final String variant;
  final int index;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const VariantCard({
    super.key,
    required this.variant,
    required this.index,
    this.onFavorite,
    this.isFavorite = false,
  });

  static const _labels = ['Professional', 'Storytelling', 'Data-Driven'];
  static const _icons = [Icons.business_center, Icons.auto_stories, Icons.insights];
  static const _colors = [Color(0xFF5C6BC0), Color(0xFFE91E63), Color(0xFF00BCD4)];

  @override
  Widget build(BuildContext context) {
    final label = index < _labels.length ? _labels[index] : 'Variant ${index + 1}';
    final icon = index < _icons.length ? _icons[index] : Icons.text_snippet;
    final color = index < _colors.length ? _colors[index] : Colors.indigo;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.glassDecoration(opacity: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Variant ${String.fromCharCode(65 + index)}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              variant,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: Colors.grey[400],
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: variant));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Variant copied!'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 20),
                  color: Colors.grey[400],
                  onPressed: () => Share.share(variant),
                ),
                const Spacer(),
                if (onFavorite != null)
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                    ),
                    color: isFavorite ? Colors.redAccent : Colors.grey[400],
                    onPressed: onFavorite,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
