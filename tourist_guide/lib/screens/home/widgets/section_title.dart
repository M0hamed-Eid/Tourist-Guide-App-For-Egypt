import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_themes.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: AppTextTheme.textTheme.displaySmall?.copyWith(
          color: AppColors.textPrimary(isDark),
        ),
      ),
    );
  }
}