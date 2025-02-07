import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/biometric/biometric_bloc.dart';
import '../../../core/bloc/biometric/biometric_event.dart';
import '../../../core/bloc/biometric/biometric_state.dart';


class BiometricAuthWrapper extends StatelessWidget {
  final Widget child;

  const BiometricAuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricBloc, BiometricState>(
      builder: (context, state) {
        if (state is BiometricInitial) {
          // Automatically trigger authentication check
          context.read<BiometricBloc>()
            ..add(CheckBiometricAvailability())
            ..add(AuthenticateUser()); // Automatically start authentication
          return _buildAuthenticationScreen(context);
        }

        if (state is BiometricLoading) {
          return _buildAuthenticationScreen(context);
        }

        if (state is BiometricUnavailable) {
          return _buildErrorScreen(
            'Biometric authentication is not available',
            context,
          );
        }

        if (state is BiometricAvailable || state is BiometricFailed) {
          // Automatically trigger authentication
          context.read<BiometricBloc>().add(AuthenticateUser());
          return _buildAuthenticationScreen(context);
        }

        if (state is BiometricAuthenticated) {
          return child;
        }

        return _buildErrorScreen('Something went wrong', context);
      },
    );
  }

  Widget _buildAuthenticationScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fingerprint,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 32),
            Text(
              'Please authenticate to\naccess your profile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 32),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.read<BiometricBloc>().add(AuthenticateUser());
              },
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}