import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/bloc/auth/auth_bloc.dart';
import '../../core/bloc/auth/auth_event.dart';
import '../../core/bloc/biometric/biometric_bloc.dart';
import '../../core/bloc/language/language_bloc.dart';
import '../../core/bloc/language/language_event.dart';
import '../../core/bloc/profile/profile_bloc.dart';
import '../../core/bloc/profile/profile_event.dart';
import '../../core/bloc/profile/profile_state.dart';
import '../../core/bloc/theme/theme_bloc.dart';
import '../../core/routes/app_router.dart';
import '../../core/services/biometric_auth_service.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/biometric_auth_wrapper.dart';
import 'widgets/profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _imagePicker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('profile.take_photo'.tr()),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _imagePicker.pickImage(source: ImageSource.camera),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('profile.choose_gallery'.tr()),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _imagePicker.pickImage(source: ImageSource.gallery),
                  );
                },
              ),
              if (context.select((ProfileBloc bloc) =>
                  bloc.state is ProfileLoaded &&
                  (bloc.state as ProfileLoaded).user?.avatarUrl != null))
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text('profile.remove_photo'.tr(),
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Clear the local image file
                    setState(() {
                      _imageFile = null;
                    });

                    // Dispatch the remove photo event
                    context.read<ProfileBloc>().add(RemoveProfilePhoto());
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      context.read<ProfileBloc>().add(UpdateProfilePhoto(_imageFile!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return BlocProvider(
      create: (context) => BiometricBloc(
        biometricService: BiometricAuthService(),
      ),
      child: BiometricAuthWrapper(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    ProfileAvatar(
                      imageUrl: user!.avatarUrl,
                      imageFile: _imageFile,
                      onTap: _pickImage,
                      isLoading: state is ProfileUpdating,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary(isDark),
                          ),
                    ),
                    ...[
                      const SizedBox(height: 8),
                      Text(
                        user.phone,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary(isDark),
                            ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    _buildProfileSection(
                      title: 'profile.account_settings'.tr(),
                      items: [
                        _buildListTile(
                          icon: Icons.edit,
                          title: 'profile.edit_profile'.tr(),
                          onTap: () {
                            // Navigate to edit profile
                          },
                        ),
                        _buildListTile(
                          icon: Icons.lock_outline,
                          title: 'profile.change_password'.tr(),
                          onTap: () {
                            // Navigate to change password
                          },
                        ),
                        _buildListTile(
                          icon: Icons.language,
                          title: 'profile.language'.tr(),
                          trailing: Text(
                            context.locale.languageCode == 'en' ? 'English' : 'العربية',
                            style: TextStyle(
                              color: AppColors.primary(isDark),
                            ),
                          ),
                          onTap: () async {
                            final newLocale = await showDialog<({String languageCode, String countryCode})>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('profile.select_language'.tr()),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: const Text('English'),
                                        trailing: context.locale.languageCode == 'en'
                                            ? Icon(Icons.check, color: AppColors.primary(isDark))
                                            : null,
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                            (languageCode: 'en', countryCode: 'US'),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: const Text('العربية'),
                                        trailing: context.locale.languageCode == 'ar'
                                            ? Icon(Icons.check, color: AppColors.primary(isDark))
                                            : null,
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                            (languageCode: 'ar', countryCode: 'EG'),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            if (newLocale != null && context.mounted) {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              // Change language in bloc
                              context.read<LanguageBloc>().add(
                                ChangeLanguage(
                                  languageCode: newLocale.languageCode,
                                  countryCode: newLocale.countryCode,
                                ),
                              );

                              // Change locale
                              context.setLocale(Locale(newLocale.languageCode, newLocale.countryCode));

                              // Wait for translations to load
                              await Future.delayed(const Duration(milliseconds: 300));

                              // Hide loading indicator
                              if (context.mounted) {
                                Navigator.pop(context);
                                // Reload profile
                                context.read<ProfileBloc>().add(LoadProfile());
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProfileSection(
                      title: 'profile.app_settings'.tr(),
                      items: [
                        _buildListTile(
                          icon: Icons.notifications_outlined,
                          title: 'profile.notifications'.tr(),
                          onTap: () {
                            // Navigate to notifications settings
                          },
                        ),
                        _buildListTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'profile.privacy_policy'.tr(),
                          onTap: () {
                            // Show privacy policy
                          },
                        ),
                        _buildListTile(
                          icon: Icons.help_outline,
                          title: 'profile.help_support'.tr(),
                          onTap: () {
                            // Show help & support
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                          // Navigate to login page
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.login,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('profile.logout'.tr(), style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
        // Your existing profile content
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
