import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final int lines;

  const LoadingShimmer({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = 8,
    this.lines = 4,
  });

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.lines, (index) {
            final widthFactor = index == widget.lines - 1 ? 0.6 : 1.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: widget.height,
                width: widget.width == double.infinity
                    ? double.infinity
                    : widget.width * widthFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
                    end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
                    colors: [
                      Colors.grey.withOpacity(0.1),
                      Colors.grey.withOpacity(0.25),
                      Colors.grey.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({super.key, this.message = 'Analyzing with AI...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          LoadingShimmer(lines: 3),
        ],
      ),
    );
  }
}
