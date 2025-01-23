import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/favorites/widgets/favorites_grid.dart';
import '../base_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 2,
      appBar: AppBar(
        title: Text('app.navigation.favorites'.tr()),
      ),
      body: FavoritesGrid(),
    );
  }
}
