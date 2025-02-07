import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/places/places_bloc.dart';
import '../../core/bloc/favorites/favorites_bloc.dart';
import 'bottom_nav_bar.dart';
import 'favorites/favorites_page.dart';
import 'governments/governments_page.dart';
import 'home/home.dart';
import 'app_bar.dart';
import 'profile/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const GovernmentsPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<PlacesBloc>().add(LoadAllPlaces());
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}