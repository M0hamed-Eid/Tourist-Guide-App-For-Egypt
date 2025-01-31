import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/bloc/auth/auth_state.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/custom_button_auth.dart';
import '../widgets/custom_text_auth.dart';
import '../widgets/custom_txt_field_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/auth/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  bool isShowPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showPassword() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  void showSuccessDialog() {
    final isDark = context.read<ThemeBloc>().state.isDark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(isDark),
        title: Text(
          "Success",
          style: TextStyle(
            color: AppColors.textPrimary(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Account created successfully",
          style: TextStyle(
            color: AppColors.textSecondary(isDark),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, AppRouter.login);
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: AppColors.primary(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
            showSuccessDialog();
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
                      const CustomTextAuth(
                        text1: "Sign up",
                        text2: "Create your account",
                      ),
                      const SizedBox(height: 48),
                      CustomTextFormFieldAuth(
                        hintText: "Enter your Full Name",
                        labalText: "Full Name",
                        iconData: Icons.person_outline,
                        mycontroller: nameController,
                        isNunmber: false,
                        valid: (val) {
                          if (val == null || val.isEmpty) {
                            return "Full Name is required ";
                          }
                          if (val[0] != val[0].toUpperCase()) {
                            return "The First letter must be capitalized";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 24),
                      Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.textSecondary(isDark),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.primary(isDark),
                              ),
                            ),
                          ),
                        ),
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 25,
                            ),
                            labelText: 'Phone Number',
                            suffixIcon: Icon(
                              Icons.phone,
                              color: AppColors.textSecondary(isDark),
                            ),
                            hintText: "Enter your phone number",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                          initialCountryCode: 'EG',
                          onChanged: (phone) {
                            phoneController.text = phone.completeNumber;
                          },
                          dropdownTextStyle: TextStyle(
                            color: AppColors.textPrimary(isDark),
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButtonAuth(
                            text: state is AuthLoading
                                ? "Creating Account..."
                                : "Sign Up",
                            onpressed: state is AuthLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                            SignUpRequested(
                                              name: nameController.text,
                                              email: emailController.text,
                                              password: passController.text,
                                              phone: phoneController.text,
                                            ),
                                          );
                                    }
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRouter.login,
                              );
                            },
                            child: Text(
                              "Login",
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
