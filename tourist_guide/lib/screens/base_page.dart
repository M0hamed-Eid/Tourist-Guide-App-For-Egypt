import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int currentIndex;

  const BasePage({
    super.key,
    required this.body,
    this.appBar,
    required this.currentIndex,
  });

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends State<BasePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}