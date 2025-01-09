import 'package:flutter/material.dart';
import 'package:tourist_guide/core/constants/app_constants.dart';
import 'package:tourist_guide/core/theme/app_colors.dart';
import 'package:tourist_guide/core/utils/responsive_utils.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import 'package:provider/provider.dart';
import 'package:tourist_guide/screens/favorites/widgets/favorites_provider.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favoritePlaces = favoritesProvider.favoritePlaceIds
            .map((id) =>
                AppConstants.allPlaces.firstWhere((place) => place.id == id))
            .toList();

        if (favoritePlaces.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: favoritePlaces.length,
          itemBuilder: (context, index) {
            return PlaceCard(
              place: favoritePlaces[index],
            );
          },
        );
      },
    );
  }
}
