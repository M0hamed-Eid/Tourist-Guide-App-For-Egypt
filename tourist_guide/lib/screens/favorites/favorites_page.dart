import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/favorites/widgets/favorites_grid.dart';
import '../base_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/favorites/favorites_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return const FavoritesGrid();
  }
}
