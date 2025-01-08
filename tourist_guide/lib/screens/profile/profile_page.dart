import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/theme/text_themes.dart';
import 'package:tourist_guide/core/utils/responsive_utils.dart';
import 'package:tourist_guide/screens/profile/widgets/edit_form.dart';
import 'package:tourist_guide/screens/profile/widgets/profile_info.dart';

import '../base_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy data until auth is implemented
  late String fullName;
  late String email;
  late String password;
  late String phone;
  late String hashedPassword;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final TextEditingController passwordController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    password = prefs.getString('password') ?? '';
    email = prefs.getString('email') ?? 'Error in auth';
    fullName = prefs.getString('fullName') ?? 'Error in auth';
    phone = prefs.getString('phone') ?? 'Error in auth';

    hashedPassword = sha256.convert(utf8.encode(password)).toString();

    fullNameController = TextEditingController(text: fullName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);

    setState(() {});
  }

  void _toggleEdit() {
    print('text: ${fullNameController.text}');
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _applyChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('fullName', fullNameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('password', passwordController.text);

    fullName = fullNameController.text;
    email = emailController.text;
    phone = phoneController.text;
    hashedPassword = sha256.convert(utf8.encode(passwordController.text)).toString();

    setState(() {
      isEditing = false; // Exit editing mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 3,
      appBar: AppBar(
        title: Text('app.navigation.profile'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileInfo(
              fullName: fullName,
              email: email,
              phone: phone,
              hashedPassword: hashedPassword,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isEditing
                  ? EditForm(
                      fullNameController: fullNameController,
                      emailController: emailController,
                      phoneController: phoneController,
                      passwordController: passwordController,
                      onApply: _applyChanges,
                    )
                  : const SizedBox.shrink(),
            ),
            if (!isEditing) // Show this button only when not editing
              const SizedBox(height: 16),
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                  onPressed: _toggleEdit,
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  child: Text(
                    'Edit Profile',
                    style: AppTextTheme.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
