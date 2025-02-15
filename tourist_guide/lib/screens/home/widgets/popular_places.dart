import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import 'package:tourist_guide/screens/home/widgets/section_title.dart';
import '../../../core/bloc/places/places_bloc.dart';
import '../../../core/utils/responsive_utils.dart';

class PopularPlaces extends StatelessWidget {
  const PopularPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'app.sections.popular_places'.tr()),
            if (state is PlacesLoading && state.isPopularLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is PlacesLoaded)
              SizedBox(
                height: ResponsiveUtils.isMobile(context) ? 250 : 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.popularPlaces.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: PlaceCard(
                        place: state.popularPlaces[index],
                        width: ResponsiveUtils.getPopularCardWidth(context),
                      ),
                    );
                  },
                ),
              )
            else if (state is PlacesError && state.isPopularError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PlacesBloc>().add(LoadPopularPlaces());
                          },
                          child: Text('Retry'.tr()),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is! PlacesLoaded)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PlacesBloc>().add(LoadPopularPlaces());
                        },
                        child: Text('Load Popular Places'.tr()),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
