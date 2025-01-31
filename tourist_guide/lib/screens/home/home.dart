import 'package:flutter/material.dart';
import 'package:tourist_guide/core/bloc/favorites/favorites_bloc.dart';
import 'package:tourist_guide/screens/home/widgets/app_bar.dart';
import 'package:tourist_guide/screens/home/widgets/popular_places.dart';
import '../base_page.dart';
import 'widgets/suggested_places.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/bloc/places/places_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PlacesBloc>().add(LoadAllPlaces());
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 0,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
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
      ),
    );
  }
}