// lib/core/widgets/custom_bottom_nav_bar.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/routes/app_router.dart';
import '../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final List<({IconData icon, IconData activeIcon, String route, String labelKey})> _navItems = [
    (
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    route: AppRouter.home,
    labelKey: 'app.navigation.home',
    ),
    (
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    route: AppRouter.governments,
    labelKey: 'app.navigation.governments',
    ),
    (
    icon: Icons.favorite_border,
    activeIcon: Icons.favorite,
    route: AppRouter.favorites,
    labelKey: 'app.navigation.favorites',
    ),
    (
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    route: AppRouter.profile,
    labelKey: 'app.navigation.profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          onTap(index);
          if (ModalRoute.of(context)?.settings.name != _navItems[index].route) {
            Navigator.pushReplacementNamed(context, _navItems[index].route);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.labelKey.tr(),
          );
        }).toList(),
      ),
    );
  }
}