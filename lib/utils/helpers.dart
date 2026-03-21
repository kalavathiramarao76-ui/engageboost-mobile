import 'package:flutter/services.dart';

class Helpers {
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static int scoreToColor(int score) {
    if (score >= 80) return 0xFF4CAF50; // green
    if (score >= 60) return 0xFFFFC107; // amber
    if (score >= 40) return 0xFFFF9800; // orange
    return 0xFFF44336; // red
  }

  static String scoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    return 'Needs Work';
  }
}
