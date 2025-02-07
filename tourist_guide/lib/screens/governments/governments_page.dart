import 'package:flutter/material.dart';
import '../../core/models/governorate.dart';
import '../../core/repositories/governorate_repository.dart';
import '../../core/theme/text_themes.dart';
import 'landmarks/landmarks_page.dart';

class GovernmentsPage extends StatelessWidget {
  const GovernmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final governorates = GovernorateRepository.getGovernorates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Egyptian Governorates'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: governorates.length,
        itemBuilder: (context, index) {
          return _GovernorateCard(governorate: governorates[index]);
        },
      ),
    );
  }
}

class _GovernorateCard extends StatelessWidget {
  final Governorate governorate;

  const _GovernorateCard({required this.governorate});

  @override
  Widget build(BuildContext context) {
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
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      governorate.image.path,
      height: 150,
      fit: BoxFit.cover,
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            governorate.name,
            style: AppTextTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            governorate.description,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: Color(0xFF42A5F5),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Color(0xFF42A5F5)),
              const SizedBox(width: 4),
              Text(
                '${governorate.landmarks.length} Landmarks',
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: Color(0xFF42A5F5),
                ),
              ),
            ],
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