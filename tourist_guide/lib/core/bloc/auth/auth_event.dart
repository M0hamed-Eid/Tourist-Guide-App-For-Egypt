abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}
class LogoutRequested extends AuthEvent {}
