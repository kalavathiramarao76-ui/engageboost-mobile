import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../models/settings_model.dart';
import '../widgets/hook_card.dart';
import '../widgets/loading_shimmer.dart';

class HooksScreen extends StatefulWidget {
  const HooksScreen({super.key});

  @override
  State<HooksScreen> createState() => _HooksScreenState();
}

class _HooksScreenState extends State<HooksScreen> {
  final _controller = TextEditingController();
  List<String> _hooks = [];
  bool _isLoading = false;

  Future<void> _generateHooks() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hooks = [];
    });

    final settings = context.read<SettingsModel>();
    final aiService = context.read<AiService>();
    aiService.configure(endpoint: settings.endpoint, model: settings.model);

    try {
      final hooks = await aiService.generateHooks(_controller.text.trim());
      if (mounted) {
        setState(() {
          _hooks = hooks;
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
        title: const Text('Hook Generator'),
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
                  hintText: 'Paste your LinkedIn post for hook alternatives...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _generateHooks,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.bolt_rounded),
                  label: Text(
                    _isLoading ? 'Generating...' : 'Generate Hooks',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              if (_isLoading)
                const LoadingOverlay(message: 'Crafting scroll-stopping hooks...'),

              if (_hooks.isNotEmpty) ...[
                Text(
                  '${_hooks.length} Hooks Generated',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_hooks.length, (i) {
                  return HookCard(
                    hook: _hooks[i],
                    index: i,
                  ).animate().fadeIn(
                        delay: Duration(milliseconds: i * 120),
                        duration: 400.ms,
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
