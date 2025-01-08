import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/screens/home/widgets/app_bar.dart';
import 'package:tourist_guide/screens/home/widgets/popular_places.dart';
import '../base_page.dart';
import 'widgets/suggested_places.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 0,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SuggestedPlaces(),
            PopularPlaces(),
          ],
        ),
      ),
    );
  }
}