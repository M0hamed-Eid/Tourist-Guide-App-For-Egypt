import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/theme/app_colors.dart';

class CustomButtonAuth extends StatelessWidget {
  final String text;
  final void Function()? onpressed;
  const CustomButtonAuth({super.key, required this.text, this.onpressed});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin:const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        onPressed:onpressed ,color: AppColors.primary(isDark),
        textColor:  AppColors.textPrimary(isDark),
        child: Text(text),),
    );
  }
}
