import 'package:flutter/material.dart';
import '../../core/models/governorate.dart';
import '../../core/repositories/governorate_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_themes.dart';
import 'landmarks/landmarks_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/theme/theme_bloc.dart';

class GovernmentsPage extends StatelessWidget {
  const GovernmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final governorates = GovernorateRepository.getGovernorates();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: governorates.length,
      itemBuilder: (context, index) {
        return _GovernorateCard(governorate: governorates[index]);
      },
    );
  }
}

class _GovernorateCard extends StatelessWidget {
  final Governorate governorate;

  const _GovernorateCard({required this.governorate});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToLandmarks(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'governorate_${governorate.name}',
              child: _buildImage(),
            ),
            _buildContent(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        governorate.image.image(
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            governorate.name,
            style: AppTextTheme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary(isDark),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            governorate.description,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(isDark),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.primary(isDark),
              ),
              const SizedBox(width: 4),
              Text(
                '${governorate.landmarks.length} Landmarks',
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.primary(isDark),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildExploreButton(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary(isDark).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Explore',
            style: TextStyle(
              color: AppColors.primary(isDark),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward,
            size: 16,
            color: AppColors.primary(isDark),
          ),
        ],
      ),
    );
  }

  void _navigateToLandmarks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandmarksPage(governorate: governorate),
      ),
    );
  }
}