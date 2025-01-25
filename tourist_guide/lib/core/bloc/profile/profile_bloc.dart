import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_handleLoadProfile);
    on<UpdateProfile>(_handleUpdateProfile);
    on<UpdateAvatar>(_handleUpdateAvatar);
  }

  Future<void> _handleLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final password = prefs.getString('password') ?? '';

      final profile = UserProfile(
        id: prefs.getString('userId') ?? '',
        name: prefs.getString('fullName') ?? '',
        email: prefs.getString('email') ?? '',
        phone: prefs.getString('phone') ?? '',
        avatarUrl: prefs.getString('avatarUrl'),
        hashedPassword: sha256.convert(utf8.encode(password)).toString(),
      );

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _handleUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', event.profile.name);
      await prefs.setString('email', event.profile.email);
      await prefs.setString('phone', event.profile.phone);
          if (event.profile.avatarUrl != null) {
        await prefs.setString('avatarUrl', event.profile.avatarUrl!);
      }

      emit(ProfileUpdated(event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _handleUpdateAvatar(UpdateAvatar event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarUrl', event.avatarPath);

      final currentProfile = await _getCurrentProfile();
      final updatedProfile = currentProfile.copyWith(avatarUrl: event.avatarPath);

      emit(ProfileUpdated(updatedProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<UserProfile> _getCurrentProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString('password') ?? '';

    return UserProfile(
      id: prefs.getString('userId') ?? '',
      name: prefs.getString('fullName') ?? '',
      email: prefs.getString('email') ?? '',
      phone: prefs.getString('phone') ?? '',
      avatarUrl: prefs.getString('avatarUrl'),
      hashedPassword: sha256.convert(utf8.encode(password)).toString(),
    );
  }
}