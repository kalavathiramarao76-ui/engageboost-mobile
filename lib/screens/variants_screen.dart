import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../models/settings_model.dart';
import '../models/favorites_model.dart';
import '../models/post_optimization.dart';
import '../widgets/variant_card.dart';
import '../widgets/loading_shimmer.dart';
import '../utils/helpers.dart';

class VariantsScreen extends StatefulWidget {
  const VariantsScreen({super.key});

  @override
  State<VariantsScreen> createState() => _VariantsScreenState();
}

class _VariantsScreenState extends State<VariantsScreen> {
  final _controller = TextEditingController();
  List<String> _variants = [];
  bool _isLoading = false;

  Future<void> _generateVariants() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _variants = [];
    });

    final settings = context.read<SettingsModel>();
    final aiService = context.read<AiService>();
    aiService.configure(endpoint: settings.endpoint, model: settings.model);

    try {
      final variants = await aiService.generateVariants(_controller.text.trim());
      if (mounted) {
        setState(() {
          _variants = variants;
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
        title: const Text('A/B Variants'),
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
                  hintText: 'Paste your LinkedIn post for A/B variants...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _generateVariants,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.science_rounded),
                  label: Text(
                    _isLoading ? 'Generating...' : 'Generate Variants',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              if (_isLoading)
                const LoadingOverlay(message: 'Creating A/B variants...'),

              if (_variants.isNotEmpty) ...[
                Text(
                  '${_variants.length} Variants Generated',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_variants.length, (i) {
                  final id = '${Helpers.generateId()}_variant_$i';
                  return Consumer<FavoritesModel>(
                    builder: (context, favModel, _) {
                      return VariantCard(
                        variant: _variants[i],
                        index: i,
                        isFavorite: favModel.isFavorite(id),
                        onFavorite: () {
                          favModel.toggleFavorite(PostOptimization(
                            id: id,
                            originalText: _controller.text.trim(),
                            optimizedText: _variants[i],
                            type: 'variant',
                            createdAt: DateTime.now(),
                          ));
                        },
                      ).animate().fadeIn(
                            delay: Duration(milliseconds: i * 150),
                            duration: 400.ms,
                          );
                    },
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
