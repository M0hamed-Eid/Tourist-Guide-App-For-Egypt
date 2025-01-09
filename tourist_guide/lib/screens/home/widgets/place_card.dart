import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/place.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../favorites/widgets/favorites_provider.dart';

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
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.place.id);

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
              backgroundColor: AppColors.surface.withValues(),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(widget.place.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      color: AppColors.textLight,
      child: Image.asset(
        widget.place.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.place.nameKey.tr(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.place.governorateKey.tr(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.isMobile(context) ? 12 : 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.place.descriptionKey.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.isMobile(context) ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
