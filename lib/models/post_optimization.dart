class PostOptimization {
  final String id;
  final String originalText;
  final String optimizedText;
  final String type; // 'optimize', 'score', 'variant', 'hook'
  final DateTime createdAt;
  final int? score;
  final Map<String, int>? dimensions;

  PostOptimization({
    required this.id,
    required this.originalText,
    required this.optimizedText,
    required this.type,
    required this.createdAt,
    this.score,
    this.dimensions,
  });

  factory PostOptimization.fromJson(Map<String, dynamic> json) {
    return PostOptimization(
      id: json['id'] ?? '',
      originalText: json['originalText'] ?? '',
      optimizedText: json['optimizedText'] ?? '',
      type: json['type'] ?? 'optimize',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      score: json['score'],
      dimensions: json['dimensions'] != null
          ? Map<String, int>.from(json['dimensions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'optimizedText': optimizedText,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'score': score,
      'dimensions': dimensions,
    };
  }
}
