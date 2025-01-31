import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:tourist_guide/core/theme/app_colors.dart';
import 'package:tourist_guide/core/utils/responsive_utils.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/favorites/favorites_bloc.dart';
import '../../../core/bloc/theme/theme_bloc.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FavoritesLoaded) {
          if (state.places.isEmpty) {
            return const EmptyFavorites();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: state.places.length,
            itemBuilder: (context, index) {
              return PlaceCard(
                place: state.places[index],
                key: ValueKey(state.places[index].id), // Add key for proper updates
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.textSecondary(isDark),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet'.tr(),
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}