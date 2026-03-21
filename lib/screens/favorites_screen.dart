import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/favorites_model.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoritesModel>(
            builder: (context, favModel, _) {
              if (favModel.allFavorites.isEmpty) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _showClearDialog(context, favModel),
              );
            },
          ),
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
        child: Consumer<FavoritesModel>(
          builder: (context, favModel, _) {
            return Column(
              children: [
                // Filter chips
                if (favModel.allFavorites.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: ['all', 'optimize', 'variant', 'hook'].map((f) {
                        final isSelected = favModel.filter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              f == 'all'
                                  ? 'All'
                                  : f[0].toUpperCase() + f.substring(1),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[400],
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) => favModel.setFilter(f),
                            backgroundColor: Colors.transparent,
                            selectedColor: const Color(0xFF5C6BC0),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF5C6BC0)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // List
                Expanded(
                  child: favModel.favorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 64, color: Colors.grey[700]),
                              const SizedBox(height: 16),
                              Text(
                                'No favorites yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Save your best optimizations here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          itemCount: favModel.favorites.length,
                          itemBuilder: (context, index) {
                            final fav = favModel.favorites[index];
                            return Dismissible(
                              key: Key(fav.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.delete_rounded,
                                    color: Colors.redAccent),
                              ),
                              onDismissed: (_) => favModel.removeFavorite(fav.id),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration:
                                    AppTheme.glassDecoration(opacity: 0.08),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: _typeColor(fav.type)
                                          .withOpacity(0.15),
                                    ),
                                    child: Icon(
                                      _typeIcon(fav.type),
                                      color: _typeColor(fav.type),
                                      size: 22,
                                    ),
                                  ),
                                  title: Text(
                                    Helpers.truncate(fav.optimizedText, 60),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: _typeColor(fav.type)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            fav.type.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: _typeColor(fav.type),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Helpers.timeAgo(fav.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.favorite,
                                        color: Colors.redAccent, size: 22),
                                    onPressed: () =>
                                        favModel.removeFavorite(fav.id),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(
                                  delay: Duration(milliseconds: index * 60),
                                  duration: 300.ms,
                                );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'optimize':
        return const Color(0xFF5C6BC0);
      case 'variant':
        return const Color(0xFFE91E63);
      case 'hook':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF00BCD4);
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'optimize':
        return Icons.auto_awesome;
      case 'variant':
        return Icons.science_rounded;
      case 'hook':
        return Icons.bolt_rounded;
      default:
        return Icons.text_snippet;
    }
  }

  void _showClearDialog(BuildContext context, FavoritesModel favModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Favorites?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              favModel.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
