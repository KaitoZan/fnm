import 'package:flutter/material.dart';
import 'logo.dart';

class Backgoundsplash extends StatelessWidget {
  const Backgoundsplash({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       
        image: DecorationImage(
          image: AssetImage('./assets/imgs/town2.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 8 * 50),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 8 * 1),
              Logo(width: 350),
            ],
          ),
        ),
       
      ),
    );
  }
}
