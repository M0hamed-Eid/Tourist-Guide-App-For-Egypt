
import 'dart:io';

import '../../models/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;
  UpdateProfile(this.profile);
}

class UpdateAvatar extends ProfileEvent {
  final String avatarPath;

  UpdateAvatar(this.avatarPath);
}

class UpdateProfilePhoto extends ProfileEvent {
  final File image;
  UpdateProfilePhoto(this.image);
}

class RemoveProfilePhoto extends ProfileEvent {}