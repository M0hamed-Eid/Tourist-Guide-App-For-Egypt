import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/home/widgets/popular_places.dart';
import 'widgets/suggested_places.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/bloc/places/places_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlacesBloc>().add(LoadAllPlaces());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SuggestedPlaces(),
            SizedBox(height: 16),
            PopularPlaces(),
          ],
        ),
      ),
    );
  }
}