import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/screens/auth/widgets/custom_text_auth.dart';
import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/bloc/auth/auth_state.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
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
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      CustomTextAuth(
                        text1: "Welcome",
                        text2: "Enter your credentials to login",
                      ),
                      const SizedBox(height: 48),
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
                      const SizedBox(height: 24),
                      CustomTextFormFieldAuth(
                        hintText: "Enter your Password",
                        obscuretext: isShowPassword,
                        onTapIcon: showPassword,
                        labalText: "Password",
                        iconData: isShowPassword
                            ? Icons.lock_outline
                            : Icons.lock_open,
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
                      const SizedBox(height: 32),
                      CustomButtonAuth(
                        text: "Login",
                        onpressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                email: emailController.text,
                                password: passController.text,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.signup);
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColors.primary(isDark),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}