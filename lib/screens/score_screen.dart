import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../models/settings_model.dart';
import '../models/engagement_score.dart';
import '../widgets/score_ring.dart';
import '../widgets/loading_shimmer.dart';
import '../theme/app_theme.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final _controller = TextEditingController();
  EngagementScore? _score;
  bool _isLoading = false;

  Future<void> _analyzeScore() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _score = null;
    });

    final settings = context.read<SettingsModel>();
    final aiService = context.read<AiService>();
    aiService.configure(endpoint: settings.endpoint, model: settings.model);

    try {
      final score = await aiService.scorePost(_controller.text.trim());
      if (mounted) {
        setState(() {
          _score = score;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engagement Score'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                maxLines: 5,
                style: const TextStyle(fontSize: 14, height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'Paste your LinkedIn post to score...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _analyzeScore,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.analytics_rounded),
                  label: Text(
                    _isLoading ? 'Analyzing...' : 'Score My Post',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              if (_isLoading) const LoadingOverlay(message: 'Scoring your post...'),

              if (_score != null) ...[
                // Overall score ring
                Center(
                  child: ScoreRing(
                    score: _score!.overall,
                    size: 200,
                    strokeWidth: 14,
                    label: 'ENGAGEMENT',
                  ),
                ).animate().fadeIn(duration: 500.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                    ),
                const SizedBox(height: 32),

                // Dimension bars
                ..._score!.dimensions.entries.map((entry) {
                  return _DimensionBar(
                    label: entry.key,
                    score: entry.value,
                  ).animate().fadeIn(
                        delay: Duration(
                            milliseconds:
                                300 + _score!.dimensions.keys.toList().indexOf(entry.key) * 100),
                        duration: 400.ms,
                      );
                }),

                const SizedBox(height: 24),

                // Feedback
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.glassDecoration(opacity: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: Colors.amber[400], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'AI Feedback',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.amber[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _score!.feedback,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DimensionBar extends StatelessWidget {
  final String label;
  final int score;

  const _DimensionBar({required this.label, required this.score});

  Color _color(int s) {
    if (s >= 80) return const Color(0xFF4CAF50);
    if (s >= 60) return const Color(0xFFFFC107);
    if (s >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$score/100',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _color(score),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: _color(score).withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(_color(score)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
