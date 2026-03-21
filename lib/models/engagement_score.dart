class EngagementScore {
  final int overall;
  final int hook;
  final int readability;
  final int cta;
  final int emotion;
  final int formatting;
  final String feedback;

  EngagementScore({
    required this.overall,
    required this.hook,
    required this.readability,
    required this.cta,
    required this.emotion,
    required this.formatting,
    required this.feedback,
  });

  Map<String, int> get dimensions => {
    'Hook': hook,
    'Readability': readability,
    'CTA': cta,
    'Emotion': emotion,
    'Formatting': formatting,
  };

  factory EngagementScore.fromJson(Map<String, dynamic> json) {
    return EngagementScore(
      overall: json['overall'] ?? 0,
      hook: json['hook'] ?? 0,
      readability: json['readability'] ?? 0,
      cta: json['cta'] ?? 0,
      emotion: json['emotion'] ?? 0,
      formatting: json['formatting'] ?? 0,
      feedback: json['feedback'] ?? '',
    );
  }
}
