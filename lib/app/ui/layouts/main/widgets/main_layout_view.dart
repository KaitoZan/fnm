import 'package:flutter/material.dart';

class MainLayoutView extends StatelessWidget {
  final Widget child;

  const MainLayoutView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(child: child);
  }
}
