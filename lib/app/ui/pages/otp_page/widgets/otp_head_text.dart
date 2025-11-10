import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpHeadText extends StatelessWidget {
  const OtpHeadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Enter OTP",
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
