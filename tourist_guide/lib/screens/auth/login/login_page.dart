import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/bloc/auth/auth_bloc.dart';
import '../../../core/bloc/auth/auth_state.dart';
import '../../../core/bloc/theme/theme_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/singleton/app_state_singleton.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators/form_validator.dart';
import '../widgets/custom_button_auth.dart';
import '../widgets/custom_text_auth.dart';
import '../widgets/custom_txt_field_auth.dart';
import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailValidator = EmailValidator();
  final _passwordValidator = PasswordValidator();

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(
      authBloc: context.read<AuthBloc>(),
      appState: context.read<AppStateSingleton>(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChanges,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: _buildLoginForm(isDark),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(state.message);
    } else if (state is AuthAuthenticated) {
      _viewModel.appState.updateUser(state.user);
      _navigateToMain();
    }
  }

  Widget _buildLoginForm(bool isDark) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomTextAuth(
                    text1: "Welcome",
                    text2: "Enter your credentials to login",
                  ),
                  const SizedBox(height: 48),
                  _buildEmailField(),
                  const SizedBox(height: 24),
                  _buildPasswordField(),
                  const SizedBox(height: 32),
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                  _buildSignUpLink(isDark),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormFieldAuth(
      hintText: "Enter your email",
      labelText: "Email",
      iconData: Icons.email_outlined,
      controller: _emailController,
      validator: _emailValidator.validate,
    );
  }

  Widget _buildPasswordField() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        return CustomTextFormFieldAuth(
          hintText: "Enter your password",
          labelText: "Password",
          iconData: viewModel.isPasswordVisible
              ? Icons.lock_open
              : Icons.lock_outline,
          controller: _passwordController,
          obscureText: !viewModel.isPasswordVisible,
          onTapIcon: viewModel.togglePasswordVisibility,
          validator: _passwordValidator.validate,
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        return CustomButtonAuth(
          text: viewModel.isLoading ? "Logging in..." : "Login",
          onPressed: viewModel.isLoading
              ? null
              : () => _handleLogin(viewModel),
        );
      },
    );
  }

  Widget _buildSignUpLink(bool isDark) {
    return Row(
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
    );
  }

  void _handleLogin(LoginViewModel viewModel) {
    if (_formKey.currentState?.validate() ?? false) {
      viewModel.login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _navigateToMain() {
    Navigator.pushReplacementNamed(context, AppRouter.main);
  }
}