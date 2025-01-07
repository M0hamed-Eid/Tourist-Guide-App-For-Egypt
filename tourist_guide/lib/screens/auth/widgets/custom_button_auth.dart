import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CustomButtonAuth extends StatelessWidget {
  final String text;
  final void Function()? onpressed;
  const CustomButtonAuth({Key? key, required this.text, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin:const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        onPressed:onpressed ,color: AppColors.primary,
        textColor:  AppColors.surface,
        child: Text(text),),
    );
  }
}
