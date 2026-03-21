import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorites_model.dart';
import '../models/post_optimization.dart';

class FavoriteButton extends StatelessWidget {
  final PostOptimization optimization;
  final double size;

  const FavoriteButton({
    super.key,
    required this.optimization,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesModel>(
      builder: (context, favModel, _) {
        final isFav = favModel.isFavorite(optimization.id);
        return GestureDetector(
          onTap: () {
            favModel.toggleFavorite(optimization);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isFav ? 'Removed from favorites' : 'Added to favorites'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFav),
              color: isFav ? Colors.redAccent : Colors.grey[400],
              size: size,
            ),
          ),
        );
      },
    );
  }
}
