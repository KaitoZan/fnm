import 'package:flutter/material.dart';

import 'back3_bt.dart';


class AppbarB extends StatelessWidget implements PreferredSizeWidget {
  const AppbarB({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink[200],
          title: Align(
            alignment: Alignment.centerLeft,
            child: Back3Bt(),
          ),
          toolbarHeight: 8 * 10,
          automaticallyImplyLeading: false,
          actions: [
            Image.asset(
              "assets/imgs/logoHome.png",
              height: 8 * 10,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[200]!, Colors.blue[200]!],
                begin: Alignment.centerLeft,
                transform: GradientRotation(3.0),
                end: Alignment.centerRight,
              ),
            ),
          ),
        
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(8 * 12);
}