import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/interfaces/auth_repository.dart';
import '../../repositories/interfaces/user_repository.dart';
import '../../services/local_storage_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final LocalStorageService _localStorageService;

  ProfileBloc({
    required IAuthRepository authRepository,
    required IUserRepository userRepository,
    required LocalStorageService localStorageService,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _localStorageService = localStorageService,
        super(ProfileInitial()) {
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

    try {
      // Emit updating state while maintaining current user data
      emit(ProfileUpdating(currentUser: currentState.user!));

      final user = _authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Delete old image if exists
      if (currentState.user?.avatarUrl != null) {
        await _localStorageService.deleteImage(currentState.user!.avatarUrl!);
      }

      // Save new image locally
      final imagePath = await _localStorageService.saveImage(event.image, user.uid);

      // Update profile with new image path
      final updatedProfile = currentState.user?.copyWith(
        avatarUrl: imagePath,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _userRepository.updateUserProfile(
        user.uid,
        {'avatarUrl': imagePath},
      );

      emit(ProfileLoaded(updatedProfile!));
    } catch (e) {
      emit(ProfileError(e.toString()));
      // Revert to previous state on error
      emit(currentState);
    }
  }

  Future<void> _handleRemoveProfilePhoto(
      RemoveProfilePhoto event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    try {
      // Emit updating state while maintaining current user data
      emit(ProfileUpdating(currentUser: currentState.user!));

      final user = _authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Delete local image if exists
      if (currentState.user?.avatarUrl != null) {
        await _localStorageService.deleteImage(currentState.user!.avatarUrl!);
      }

      // Update profile
      final updatedProfile = currentState.user?.copyWith(
        avatarUrl: null,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _userRepository.updateUserProfile(
        user.uid,
        {'avatarUrl': null},
      );

      emit(ProfileLoaded(updatedProfile!));
    } catch (e) {
      emit(ProfileError(e.toString()));
      // Revert to previous state on error
      emit(currentState);
    }
  }

  Future<void> _handleLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profile = await _userRepository.getUserProfile(user.uid);
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
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    try {
      emit(ProfileUpdating(currentUser: currentState.user!));

      final user = _authRepository.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _userRepository.updateUserProfile(
        user.uid,
        event.profile.toJson(),
      );

      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
      emit(currentState);
    }
  }
}