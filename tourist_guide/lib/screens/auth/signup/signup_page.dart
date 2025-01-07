import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/custom_button_auth.dart';
import '../widgets/custom_text_auth.dart';
import '../widgets/custom_txt_field_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController nameController=TextEditingController();


  bool isShowPassword = true;

  showPassword(){
    isShowPassword = isShowPassword == true ? false : true;
    setState(() {});
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Account created successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.login);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void validateAndSubmit() {
    if (formKey.currentState!.validate()) {
      showSuccessDialog();
    }
  }

  Future<void> saveSignupData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passController.text);
    await prefs.setString('phone', phoneController.text);

    validateAndSubmit();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        child: Form(
          key: formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextAuth(text1: "Sign up", text2: "Create your account"),
                  CustomTextFormFieldAuth(hintText: "Enter your Full Name",
                    labalText: "Full Name",
                    iconData: Icons.person_outline,
                    mycontroller: nameController,
                    isNunmber: false,
                    valid: (val) {
                      if(val == null||val.isEmpty){
                        return "Full Name is required ";
                      }if (val[0] != val[0].toUpperCase()){
                        return "The First letter must be capitalized";
                      }
                      return null;
                    },
                  ),
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
                  CustomTextFormFieldAuth(hintText: "Enter Your Phone Number",
                    obscuretext: false,
                    labalText: "Phone Number",
                    iconData: Icons.phone,
                    mycontroller: phoneController,
                    isNunmber: true,
                    valid: (val) {
                      if(val == null||val.isEmpty){
                        return "Phone Number is required ";
                      }if (val.length>11 && val.length<6){
                        return "Phone must be greater than 6 and less than 12 ";
                      }
                      return null;
                    },
                  ),
                  CustomButtonAuth(text: "sign Up",
                    onpressed:() {
                      saveSignupData();
                    },),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          InkWell(child: const Text("Login",
                            style: TextStyle(color: AppColors.primary,
                            ),
                          ),
                            onTap: (){
                              Navigator.pushNamed(context, AppRouter.login);
                            },),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
