import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordHeadText extends StatelessWidget {
  const ResetPasswordHeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Reset Password",
          style: GoogleFonts.charmonman(
            fontSize: 40,
            color: Colors.white,
           
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}