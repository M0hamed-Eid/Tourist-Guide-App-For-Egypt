import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';

@override
PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(
        Icons.logout,
        color: AppColors.surface,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      },
    ),
    title: Text(
      'app.title'.tr(),
      style: TextStyle(
        color: AppColors.surface,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(
          Icons.language,
          color: AppColors.surface,
        ),
        onPressed: () async {
          if (context.locale == const Locale('en', 'US')) {
            context.setLocale(const Locale('ar', 'EG'));
          } else {
            context.setLocale(const Locale('en', 'US'));
          }

          // Force rebuild of all widgets that depend on direction
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
