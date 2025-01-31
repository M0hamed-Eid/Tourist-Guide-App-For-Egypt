
import '../../models/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdated extends ProfileState {
  final UserProfile profile;

  ProfileUpdated(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}