import 'package:local_auth/local_auth.dart';

abstract class BiometricState {}

class BiometricInitial extends BiometricState {}

class BiometricLoading extends BiometricState {}

class BiometricAvailable extends BiometricState {
  final List<BiometricType> availableBiometrics;

  BiometricAvailable(this.availableBiometrics);
}

class BiometricUnavailable extends BiometricState {}

class BiometricAuthenticated extends BiometricState {}

class BiometricFailed extends BiometricState {
  final String message;

  BiometricFailed(this.message);
}