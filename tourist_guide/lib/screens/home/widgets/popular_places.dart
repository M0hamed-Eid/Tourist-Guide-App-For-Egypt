import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import 'package:tourist_guide/screens/home/widgets/section_title.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive_utils.dart';

class PopularPlaces extends StatelessWidget {
  const PopularPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'app.sections.popular_places'.tr()),
        SizedBox(
          height: ResponsiveUtils.isMobile(context) ? 250 : 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.popularPlaces.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PlaceCard(
                  place: AppConstants.popularPlaces[index],
                  width: ResponsiveUtils.getPopularCardWidth(context),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
