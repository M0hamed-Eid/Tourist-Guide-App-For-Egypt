import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/theme/app_colors.dart';
class CustomTextAuth extends StatelessWidget {

  final String text1;
  final String text2;
  const CustomTextAuth({super.key, required this.text1, required this.text2});


  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Column(
      children: [
        Text(text1,style: TextStyle(fontSize: 53,
            color: AppColors.primary(isDark),fontWeight: FontWeight.bold),),
        Text(text2,style: TextStyle(fontSize: 16,
            color: AppColors.textPrimary(isDark)),),
        SizedBox(height: MediaQuery.of(context).size.height/17,),
      ],
    );
  }
}
