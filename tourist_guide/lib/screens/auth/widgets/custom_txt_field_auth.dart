import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/theme/app_colors.dart';

class CustomTextFormFieldAuth extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData iconData;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isNumber;
  final bool obscureText;
  final VoidCallback? onTapIcon;

  const CustomTextFormFieldAuth({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.iconData,
    required this.controller,
    required this.validator,
    this.isNumber = false,
    this.obscureText = false,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.emailAddress,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 25,
          ),
          labelText: labelText,
          suffixIcon: InkWell(
            onTap: onTapIcon,
            child: Icon(
              iconData,
              color: AppColors.textSecondary(isDark),
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary(isDark),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
