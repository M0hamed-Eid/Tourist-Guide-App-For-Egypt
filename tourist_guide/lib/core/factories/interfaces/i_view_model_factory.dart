import '../../../screens/auth/login/login_view_model.dart';
import '../../../screens/auth/signup/signup_view_model.dart';

abstract class IViewModelFactory {
  LoginViewModel createLoginViewModel();
  SignUpViewModel createSignUpViewModel();
}