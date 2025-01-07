import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/screens/auth/widgets/custom_text_auth.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/custom_button_auth.dart';
import '../widgets/custom_txt_field_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  String errorMessage = '';

  Future<void> validateLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (formKey.currentState!.validate() && emailController.text == savedEmail
        && passController.text == savedPassword) {
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRouter.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }



  bool isShowPassword = true;

  showPassword(){
    isShowPassword = isShowPassword == true ? false : true;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        child: Form(
          key: formKey,
          child: SafeArea(
            child: Column(
              children: [
                CustomTextAuth(text1: "Welcome", text2: "Enter your credential to login"),
                CustomTextFormFieldAuth(hintText: "Enter your email",
                  labalText: "Email",
                  iconData: Icons.email_outlined,
                  mycontroller: emailController,
                  isNunmber: false,
                  valid: (val) {
                    if(val == null||val.isEmpty){
                      return "Email is required ";
                    }if (!val.contains("@")){
                      return "Email must contain '@'";
                    }
                    return null;
                  },
                ),
                CustomTextFormFieldAuth(hintText: "Enter your Password",
                  obscuretext: isShowPassword,
                  onTapIcon: showPassword,
                  labalText: "Password",
                  iconData: isShowPassword?Icons.lock_outline:Icons.lock_open,
                  mycontroller: passController,
                  isNunmber: false,
                  valid: (val) {
                    if(val == null||val.isEmpty){
                      return "Password is required ";
                    }if (val.length<6){
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                InkWell(
                  child: const Align(
                      alignment:AlignmentDirectional.topEnd ,
                      child: Text("Forget Password",
                        style: TextStyle(color: AppColors.primary,),
                      ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, AppRouter.home);
                  },),
                CustomButtonAuth(text: "Login",
                  onpressed:() {
                    validateLogin();
                  },),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        InkWell(child: const Text("SignUp",
                          style: TextStyle(color: AppColors.primary,
                          ),
                        ),
                          onTap: (){
                            Navigator.pushNamed(context, AppRouter.signup);
                          },),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
