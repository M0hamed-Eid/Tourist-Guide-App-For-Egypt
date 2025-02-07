import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_guide/core/theme/app_colors.dart';

import '../core/bloc/theme/theme_bloc.dart';
import '../core/routes/app_router.dart';

@override
PreferredSizeWidget buildAppBar(BuildContext context) {
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
      ),
      IconButton(
        icon: Icon(
          Icons.language,
          color: AppColors.white,
        ),
        onPressed: () async {
          if (context.locale == const Locale('en', 'US')) {
            context.setLocale(const Locale('ar', 'EG'));
          } else {
            context.setLocale(const Locale('en', 'US'));
          }

          if (context.mounted) {
            await Future.delayed(const Duration(milliseconds: 100));
            Navigator.pushReplacementNamed(
              context,
              ModalRoute.of(context)?.settings.name ?? AppRouter.home,
            );
          }
        },
      ),
    ],
  );
}
