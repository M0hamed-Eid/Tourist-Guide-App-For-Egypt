

import '../../models/user_profile.dart';

abstract class ProfileState {
  final UserProfile? user;

  const ProfileState({this.user});
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(user: null);
}

class ProfileLoading extends ProfileState {
  const ProfileLoading({super.user});
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(UserProfile user) : super(user: user);
}

class ProfileUpdating extends ProfileState {
  final UserProfile currentUser;
  ProfileUpdating({required this.currentUser});
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated(UserProfile user) : super(user: user);
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message, {super.user});
}