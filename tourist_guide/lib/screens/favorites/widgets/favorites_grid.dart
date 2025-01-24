import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:tourist_guide/core/theme/app_colors.dart';
import 'package:tourist_guide/core/utils/responsive_utils.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/favorites/favorites_bloc.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesLoaded) {
          if (state.places.isEmpty) {
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
                    'No favorites yet'.tr(),
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
            itemCount: state.places.length,
            itemBuilder: (context, index) {
              return PlaceCard(place: state.places[index]);
            },
          );
        } else if (state is FavoritesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FavoritesBloc>().add(LoadFavorites());
                  },
                  child: Text('Retry'.tr()),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}