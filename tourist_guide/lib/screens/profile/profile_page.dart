import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/screens/profile/widgets/profile_info.dart';

import '../base_page.dart';

class ProfilePage extends StatelessWidget {
  // Dummy data until auth is implemented

  late final String fullName;
  late final String email;
  late final String password;
  late final String phone;
  late final String hashedPassword;

  ProfilePage({super.key}) {
    _init();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    password = prefs.getString('password') ?? '';
    email = prefs.getString('email') ?? 'Error in auth';
    fullName = prefs.getString('fullName') ?? 'Error in auth';
    phone = prefs.getString('phone') ?? 'Error in auth';

    hashedPassword = sha256.convert(utf8.encode(password)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 3,
      appBar: AppBar(
        title: Text('app.navigation.profile'.tr()),
      ),
      body: Column(
        children: [
          ProfileInfo(
              fullName: fullName, email: email,phone: phone, hashedPassword: hashedPassword)
        ],
      ),
    );
  }
}
