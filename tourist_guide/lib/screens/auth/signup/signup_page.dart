import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/bloc/auth/auth_event.dart';
import '../../../core/bloc/auth/auth_state.dart';
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Account created successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Form(
              key: formKey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CustomTextAuth(
                        text1: "Sign up",
                        text2: "Create your account",
                      ),
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
                        iconData: isShowPassword ? Icons.lock_outline : Icons.lock_open,
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
                      IntlPhoneField(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 25,
                          ),
                          labelText: 'Phone Number',
                          suffixIcon: const Icon(Icons.phone),
                          hintText: "Enter your phone number",
                          hintStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        initialCountryCode: 'EG',
                        onChanged: (phone) {
                          phoneController.text = phone.completeNumber;
                        },
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButtonAuth(
                            text: state is AuthLoading ? "Creating Account..." : "Sign Up",
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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              InkWell(
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRouter.login,
                                  );
                                },
                              ),
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
        ),
      ),
    );
  }
}