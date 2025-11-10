import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'logo.dart';

class Backgoundlogin extends StatelessWidget {
  const Backgoundlogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.pink[300]!, Colors.blue[300]!]),
        image: DecorationImage(
          image: AssetImage('./assets/imgs/town2.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            
            Colors.black.withValues(alpha: 8 * 54),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Container(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Logo(width: 300)],
            ),
          ),
        ),
      ),
    );
  }
}
