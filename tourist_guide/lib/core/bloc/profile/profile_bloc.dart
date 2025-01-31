// lib/core/bloc/profile/profile_bloc.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuthService authService;
  final FirestoreService firestoreService;

  ProfileBloc({
    required this.authService,
    required this.firestoreService,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_handleLoadProfile);
    on<UpdateProfile>(_handleUpdateProfile);
    on<UpdateAvatar>(_handleUpdateAvatar);
  }

  Future<void> _handleLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profile = await firestoreService.getUserProfile(user.uid);
      if (profile == null) {
        throw Exception('Profile not found');
      }

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _handleUpdateProfile(
      UpdateProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await firestoreService.updateUserProfile(
        user.uid,
        event.profile.toJson(),
      );

      emit(ProfileUpdated(event.profile));
      // Reload profile to get latest data
      add(LoadProfile());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _handleUpdateAvatar(
      UpdateAvatar event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final currentProfile = await firestoreService.getUserProfile(user.uid);
      if (currentProfile == null) {
        throw Exception('Profile not found');
      }

      final updatedProfile = currentProfile.copyWith(
        avatarUrl: event.avatarPath,
        updatedAt: DateTime.now(),
      );

      await firestoreService.updateUserProfile(
        user.uid,
        {'avatarUrl': event.avatarPath},
      );

      emit(ProfileUpdated(updatedProfile));
      // Reload profile to get latest data
      add(LoadProfile());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}