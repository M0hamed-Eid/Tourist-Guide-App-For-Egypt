import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
class CustomTextAuth extends StatelessWidget {

  final String text1;
  final String text2;
  const CustomTextAuth({super.key, required this.text1, required this.text2});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(text1,style: TextStyle(fontSize: 53,
              color: AppColors.primary,fontWeight: FontWeight.bold),),
          Text(text2,style: TextStyle(fontSize: 16,
              color: AppColors.textSecondary),),
          SizedBox(height: MediaQuery.of(context).size.height/17,),
        ],
      ),
    );
  }
}
