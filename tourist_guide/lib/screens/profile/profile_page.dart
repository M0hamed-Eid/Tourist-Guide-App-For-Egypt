import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing
import 'package:tourist_guide/screens/profile/widgets/profile_info.dart';

import '../base_page.dart';

class ProfilePage extends StatelessWidget {
  // Dummy data until auth is implemented

  final String fullName = 'Ziad Assem';
  final String email = 'ziad.assem2001@gmail.com';
  final String password = 'password';

  late final String hashedPassword;

  ProfilePage({super.key}) {
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
              fullName: fullName, email: email, hashedPassword: hashedPassword)
        ],
      ),
    );
  }
}
