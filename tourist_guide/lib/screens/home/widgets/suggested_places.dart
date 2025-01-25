import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/screens/home/widgets/place_card.dart';
import '../../../core/bloc/places/places_bloc.dart';
import '../../../core/utils/responsive_utils.dart';
import 'section_title.dart';

class SuggestedPlaces extends StatelessWidget {
  const SuggestedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'app.sections.suggested_places'.tr()),
            if (state is PlacesLoading && state.isSuggestedLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is PlacesLoaded && state.suggestedPlaces != null)
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
                itemCount: state.suggestedPlaces!.length,
                itemBuilder: (context, index) {
                  return PlaceCard(place: state.suggestedPlaces![index]);
                },
              )
            else if (state is PlacesError && state.isSuggestedError)
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
                            context.read<PlacesBloc>().add(LoadSuggestedPlaces());
                          },
                          child: Text('Retry'.tr()),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is! PlacesLoaded || state.suggestedPlaces == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PlacesBloc>().add(LoadSuggestedPlaces());
                        },
                        child: Text('Load Suggested Places'.tr()),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}