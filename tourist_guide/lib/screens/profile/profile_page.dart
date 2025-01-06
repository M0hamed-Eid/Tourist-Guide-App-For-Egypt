import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../base_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 3,
      appBar: AppBar(
        title: Text('app.navigation.profile'.tr()),
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}