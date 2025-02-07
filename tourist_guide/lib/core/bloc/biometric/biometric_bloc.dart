import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/biometric_auth_service.dart';
import 'biometric_event.dart';
import 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final BiometricAuthService _biometricService;

  BiometricBloc({
    required BiometricAuthService biometricService,
  })  : _biometricService = biometricService,
        super(BiometricInitial()) {
    on<CheckBiometricAvailability>(_handleCheckBiometric);
    on<AuthenticateUser>(_handleAuthenticate);
  }

  Future<void> _handleCheckBiometric(
      CheckBiometricAvailability event,
      Emitter<BiometricState> emit,
      ) async {
    emit(BiometricLoading());
    try {
      final isAvailable = await _biometricService.isBiometricAvailable();
      if (isAvailable) {
        final biometrics = await _biometricService.getAvailableBiometrics();
        emit(BiometricAvailable(biometrics));
      } else {
        emit(BiometricUnavailable());
      }
    } catch (e) {
      emit(BiometricFailed(e.toString()));
    }
  }

  Future<void> _handleAuthenticate(
      AuthenticateUser event,
      Emitter<BiometricState> emit,
      ) async {
    emit(BiometricLoading());
    try {
      final isAuthenticated = await _biometricService.authenticate();
      if (isAuthenticated) {
        emit(BiometricAuthenticated());
      } else {
        emit(BiometricFailed('Authentication failed'));
      }
    } catch (e) {
      emit(BiometricFailed(e.toString()));
    }
  }
}