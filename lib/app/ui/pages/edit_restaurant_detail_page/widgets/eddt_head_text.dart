import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EdDtHeadText extends StatelessWidget {
  const EdDtHeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "แก้ไขข้อมูลร้าน",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
