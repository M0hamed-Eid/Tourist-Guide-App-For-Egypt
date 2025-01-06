import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import 'section_title.dart';

class SuggestedPlaces extends StatelessWidget {
  const SuggestedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'app.sections.suggested_places'.tr()),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: AppConstants.suggestedPlaces.length,
          itemBuilder: (context, index) {
            return PlaceCard(
              place: AppConstants.suggestedPlaces[index],
            );
          },
        ),
      ],
    );
  }
}
