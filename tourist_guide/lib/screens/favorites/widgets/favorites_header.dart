import 'package:flutter/material.dart';
import 'package:tourist_guide/core/theme/app_colors.dart';
import 'package:tourist_guide/core/theme/text_themes.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'app.navigation.favorites'.tr(),
            style: AppTextTheme.textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your favorite tourist destinations in Egypt',
            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
