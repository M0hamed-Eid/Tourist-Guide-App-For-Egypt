import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/local_storage_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuthService authService;
  final FirestoreService firestoreService;
  final LocalStorageService localStorageService;

  ProfileBloc({
    required this.authService,
    required this.firestoreService,
    required this.localStorageService,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_handleLoadProfile);
    on<UpdateProfile>(_handleUpdateProfile);
    on<UpdateProfilePhoto>(_handleUpdateProfilePhoto);
    on<RemoveProfilePhoto>(_handleRemoveProfilePhoto);
  }

  Future<void> _handleUpdateProfilePhoto(
      UpdateProfilePhoto event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(ProfileLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Save image locally
      final imagePath = await localStorageService.saveImage(event.image, user.uid);

      // Update profile with new image path
      final updatedProfile = currentState.user?.copyWith(
        avatarUrl: imagePath,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await firestoreService.updateUserProfile(
        user.uid,
        {'avatarUrl': imagePath},
      );

      emit(ProfileLoaded(updatedProfile!));
    } catch (e) {
      emit(ProfileError(e.toString()));
      emit(currentState);
    }
  }

  Future<void> _handleRemoveProfilePhoto(
      RemoveProfilePhoto event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(ProfileLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Delete local image if exists
      if (currentState.user?.avatarUrl != null) {
        await localStorageService.deleteImage(currentState.user!.avatarUrl!);
      }

      // Update profile
      final updatedProfile = currentState.user?.copyWith(
        avatarUrl: null,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await firestoreService.updateUserProfile(
        user.uid,
        {'avatarUrl': null},
      );

      emit(ProfileLoaded(updatedProfile!));
    } catch (e) {
      emit(ProfileError(e.toString()));
      emit(currentState);
    }
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