import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/bloc/theme/theme_bloc.dart';
import '../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final List<({IconData icon, IconData activeIcon, String labelKey})>
      _navItems = [
    (
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      labelKey: 'app.navigation.home',
    ),
    (
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      labelKey: 'app.navigation.governments',
    ),
    (
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      labelKey: 'app.navigation.favorites',
    ),
    (
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      labelKey: 'app.navigation.profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow(isDark),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface(isDark),
            selectedItemColor: AppColors.primary(isDark),
            unselectedItemColor: AppColors.textSecondary(isDark),
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
    );
  }
}
