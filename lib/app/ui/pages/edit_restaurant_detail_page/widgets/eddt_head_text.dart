import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EdDtHeadText extends StatelessWidget {
  // <<<--- [TASK 24.1 - เริ่มแก้ไข] ---
  final String title;
  const EdDtHeadText({super.key, required this.title});
  // <<<--- [TASK 24.1 - สิ้นสุดการแก้ไข] ---

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          // <<<--- [TASK 24.1 - เริ่มแก้ไข] ---
          title, // (ใช้ title ที่รับเข้ามา)
          // "แก้ไขข้อมูลร้าน",
          // <<<--- [TASK 24.1 - สิ้นสุดการแก้ไข] ---
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