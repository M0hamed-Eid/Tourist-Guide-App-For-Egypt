import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/screens/auth/widgets/custom_text_auth.dart';

import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/bloc/auth/auth_state.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/custom_button_auth.dart';
import '../widgets/custom_txt_field_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isShowPassword = true;

  void showPassword() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Form(
              key: formKey,
              child: SafeArea(
                child: Column(
                  children: [
                    CustomTextAuth(
                        text1: "Welcome",
                        text2: "Enter your credential to login"),
                    CustomTextFormFieldAuth(
                      hintText: "Enter your email",
                      labalText: "Email",
                      iconData: Icons.email_outlined,
                      mycontroller: emailController,
                      isNunmber: false,
                      valid: (val) {
                        if (val == null || val.isEmpty) {
                          return "Email is required ";
                        }
                        if (!val.contains("@")) {
                          return "Email must contain '@'";
                        }
                        return null;
                      },
                    ),
                    CustomTextFormFieldAuth(
                      hintText: "Enter your Password",
                      obscuretext: isShowPassword,
                      onTapIcon: showPassword,
                      labalText: "Password",
                      iconData:
                          isShowPassword ? Icons.lock_outline : Icons.lock_open,
                      mycontroller: passController,
                      isNunmber: false,
                      valid: (val) {
                        if (val == null || val.isEmpty) {
                          return "Password is required ";
                        }
                        if (val.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    CustomButtonAuth(
                      text: "Login",
                      onpressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(LoginRequested(
                              email: emailController.text,
                              password: passController.text));
                        }
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            InkWell(
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.signup);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
