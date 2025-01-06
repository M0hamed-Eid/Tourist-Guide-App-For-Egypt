import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../base_page.dart';

class GovernmentsPage extends StatelessWidget {
  const GovernmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 1,
      appBar: AppBar(
        title: Text('app.navigation.governments'.tr()),
      ),
      body: Center(
        child: Text('Governments Page'),
      ),
    );
  }
}