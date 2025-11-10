import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusTag extends StatelessWidget {
  final bool isOpen;
  final bool showMotorcycleIcon;
  final double fontSize;
  final bool showOpenStatus;
  final double iconSize;
  const StatusTag({
    super.key,
    required this.isOpen,
    this.showMotorcycleIcon = false,
    this.fontSize = 12,
    this.iconSize = 24,
    this.showOpenStatus = true,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMotorcycleIcon)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: iconSize,
                  color: Colors.green,
                ),
                // Text(
                //   'มีบริการส่งอาหาร',
                //   style: GoogleFonts.kanit(
                //     color: Colors.green,
                   
                //     fontSize: fontSize,
                //   ))
              ],
            ),
          ),
        if (showOpenStatus)
          Container(
            width: 8 * 9,
            height: 8 * 3,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isOpen
                  ?  Colors.pink.shade200
                  :  Colors.blue.shade200,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: isOpen
                    ? Colors.pink.shade300
                    : Colors.blue.shade300,
              ),
            ),
            child: Text(
              isOpen ? 'เปิดอยู่' : 'ปิดอยู่',
              style: GoogleFonts.kanit(
                color: isOpen
                    ? Colors.white
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
      ],
    );
  }
}
