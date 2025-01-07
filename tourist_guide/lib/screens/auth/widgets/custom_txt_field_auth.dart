import 'package:flutter/material.dart';

class CustomTextFormFieldAuth extends StatelessWidget {
  final String hintText;
  final String labalText;
  final IconData iconData;
  final TextEditingController mycontroller;
  final String? Function (String?) valid;
  final bool isNunmber;
  final bool? obscuretext;
  final void Function()? onTapIcon;

  const CustomTextFormFieldAuth({Key? key,
    required this.hintText, required this.labalText,
    required this.iconData, required this.mycontroller,
    required this.valid, required this.isNunmber,
    this.obscuretext ,this.onTapIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText:obscuretext==null||obscuretext==false ? false:true ,
        keyboardType: isNunmber? const TextInputType.numberWithOptions(decimal: true)
            :TextInputType.emailAddress,
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
          label: Text(labalText),
          suffixIcon:InkWell(child: Icon(iconData),onTap:onTapIcon ,) ,
          hintText: hintText,
          hintStyle:const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
