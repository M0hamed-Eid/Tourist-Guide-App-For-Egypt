import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/favorites/favorites_bloc.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/models/place.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';

class PlaceCard extends StatefulWidget {
  final Place place;
  final double? width;

  const PlaceCard({
    super.key,
    required this.place,
    this.width,
  });

  @override
  PlaceCardState createState() => PlaceCardState();
}

class PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favoritesState) {
          final isFavorite = favoritesState is FavoritesLoaded &&
              favoritesState.places.any((place) => place.id == widget.place.id);

          return SizedBox(
            width: widget.width ?? ResponsiveUtils.getCardWidth(context),
            child: Stack(
              children: [
                Card(
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildImage()),
                      _buildContent(),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: AppColors.surface(isDark),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.error : AppColors.textSecondary(isDark),
                      ),
                      onPressed: () {
                        context.read<FavoritesBloc>().add(ToggleFavorite(widget.place.id));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  Widget _buildImage() {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Container(
      color: AppColors.textLight(isDark),
      child: Image.asset(
        widget.place.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildContent() {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.place.nameKey.tr(),
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.place.governorateKey.tr(),
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: ResponsiveUtils.isMobile(context) ? 12 : 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.place.descriptionKey.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: ResponsiveUtils.isMobile(context) ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
