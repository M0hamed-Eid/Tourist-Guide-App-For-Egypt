import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/theme/app_colors.dart';

import '../core/bloc/theme/theme_bloc.dart';
import '../core/routes/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return AppBar(
      backgroundColor: AppColors.primaryDark(isDark),
      leading: IconButton(
        icon: Icon(
          Icons.logout,
          color: AppColors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRouter.login);
        },
      ),
      title: Text(
        'app.title'.tr(),
        style: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.brightness_6,
            color: AppColors.white,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleTheme());
          },
        )
      ],
    );
  }
}
