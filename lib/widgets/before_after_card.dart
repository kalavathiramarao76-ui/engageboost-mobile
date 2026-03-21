import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class BeforeAfterCard extends StatelessWidget {
  final String beforeText;
  final String afterText;
  final bool isLoading;

  const BeforeAfterCard({
    super.key,
    required this.beforeText,
    required this.afterText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSection(
          context,
          title: 'Original',
          text: beforeText,
          icon: Icons.article_outlined,
          color: Colors.grey[400]!,
        ),
        const SizedBox(height: 16),
        Icon(Icons.arrow_downward_rounded,
            color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(height: 16),
        _buildSection(
          context,
          title: 'Optimized',
          text: isLoading ? '$afterText|' : afterText,
          icon: Icons.auto_awesome,
          color: const Color(0xFF5C6BC0),
          isOptimized: true,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String text,
    required IconData icon,
    required Color color,
    bool isOptimized = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration(
        opacity: isOptimized ? 0.08 : 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (text.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title text copied!'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(Icons.copy_rounded, color: color, size: 18),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text.isEmpty ? 'Waiting for input...' : text,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: text.isEmpty ? Colors.grey[600] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
