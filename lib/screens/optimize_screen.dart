import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../models/settings_model.dart';
import '../models/favorites_model.dart';
import '../models/post_optimization.dart';
import '../widgets/before_after_card.dart';
import '../widgets/favorite_button.dart';
import '../utils/helpers.dart';

class OptimizeScreen extends StatefulWidget {
  const OptimizeScreen({super.key});

  @override
  State<OptimizeScreen> createState() => _OptimizeScreenState();
}

class _OptimizeScreenState extends State<OptimizeScreen> {
  final _controller = TextEditingController();
  String _optimizedText = '';
  bool _isLoading = false;
  bool _isStreaming = false;
  PostOptimization? _currentOptimization;

  Future<void> _optimize() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _isStreaming = true;
      _optimizedText = '';
    });

    final settings = context.read<SettingsModel>();
    final aiService = context.read<AiService>();
    aiService.configure(endpoint: settings.endpoint, model: settings.model);

    try {
      await for (final chunk in aiService.streamOptimize(_controller.text.trim())) {
        if (mounted) {
          setState(() {
            _optimizedText += chunk;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    if (mounted) {
      final optimization = PostOptimization(
        id: Helpers.generateId(),
        originalText: _controller.text.trim(),
        optimizedText: _optimizedText,
        type: 'optimize',
        createdAt: DateTime.now(),
      );
      setState(() {
        _isLoading = false;
        _isStreaming = false;
        _currentOptimization = optimization;
      });
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
        title: const Text('Optimize Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentOptimization != null)
            FavoriteButton(optimization: _currentOptimization!),
          const SizedBox(width: 12),
        ],
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
              // Input
              TextField(
                controller: _controller,
                maxLines: 6,
                style: const TextStyle(fontSize: 14, height: 1.6),
                decoration: const InputDecoration(
                  hintText: 'Paste your LinkedIn post here...',
                  hintStyle: TextStyle(color: Colors.grey),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              // Optimize button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _optimize,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    _isLoading ? 'Optimizing...' : 'Optimize with AI',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Before/After
              if (_controller.text.isNotEmpty || _optimizedText.isNotEmpty)
                BeforeAfterCard(
                  beforeText: _controller.text,
                  afterText: _optimizedText,
                  isLoading: _isStreaming,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
