import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_wall.dart';
import '../services/auth_service.dart';
import 'optimize_screen.dart';
import 'score_screen.dart';
import 'variants_screen.dart';
import 'hooks_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _showAuthWall = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final needsAuth = await _authService.needsAuth();
    if (mounted) setState(() => _showAuthWall = needsAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(context),
          if (_showAuthWall)
            AuthWall(
              authService: _authService,
              onSignedIn: () => setState(() => _showAuthWall = false),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E), Color(0xFF0F0F23)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                          ),
                        ),
                        child: const Icon(Icons.rocket_launch_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EngageBoost AI',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 30)),
                            ),
                          ),
                          Text(
                            'LinkedIn Post Optimizer',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        ),
                        icon: Icon(Icons.settings_rounded,
                            color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

              // Tagline
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'Supercharge your LinkedIn presence',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: Text(
                    'AI-powered tools to optimize, score, and test your posts',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ),

              // Tool Cards
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _ToolCard(
                      title: 'Optimize Post',
                      subtitle: 'AI-powered post enhancement with streaming',
                      icon: Icons.auto_awesome,
                      gradient: const [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                      delay: 0,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const OptimizeScreen())),
                    ),
                    _ToolCard(
                      title: 'Engagement Score',
                      subtitle: 'Rate your post across 5 dimensions (0-100)',
                      icon: Icons.analytics_rounded,
                      gradient: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      delay: 1,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ScoreScreen())),
                    ),
                    _ToolCard(
                      title: 'A/B Variants',
                      subtitle: 'Generate 3 alternative versions to test',
                      icon: Icons.science_rounded,
                      gradient: const [Color(0xFFE91E63), Color(0xFFC2185B)],
                      delay: 2,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const VariantsScreen())),
                    ),
                    _ToolCard(
                      title: 'Hook Generator',
                      subtitle: '5 scroll-stopping opening lines',
                      icon: Icons.bolt_rounded,
                      gradient: const [Color(0xFFFF9800), Color(0xFFE65100)],
                      delay: 3,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HooksScreen())),
                    ),
                    _ToolCard(
                      title: 'Favorites',
                      subtitle: 'Your saved optimizations and variants',
                      icon: Icons.favorite_rounded,
                      gradient: const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                      delay: 4,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final int delay;
  final VoidCallback onTap;

  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glassDecoration(opacity: 0.08),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: gradient),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey[600], size: 24),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 300 + delay * 80), duration: 400.ms)
        .slideX(begin: 0.05, end: 0);
  }
}
