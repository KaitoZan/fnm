import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusTag extends StatelessWidget {
  final bool isOpen;
  // <<<--- 1. [แก้ไข] เปลี่ยนชื่อ Field
  // final bool showMotorcycleIcon;
  final bool hasDelivery;
  // <<<--- 2. [เพิ่ม] Field ใหม่
  final bool hasDineIn;

  final double fontSize;
  final bool showOpenStatus;
  final double iconSize;
  
  const StatusTag({
    super.key,
    required this.isOpen,
    // this.showMotorcycleIcon = false, // <<< 3. [แก้ไข]
    this.hasDelivery = false, // <<< [แก้ไข]
    this.hasDineIn = false, // <<< [เพิ่ม]
    this.fontSize = 12,
    this.iconSize = 24,
    this.showOpenStatus = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        // <<<--- 4. [เพิ่ม] ไอคอนทานที่ร้าน
        if (hasDineIn)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant, // <<< ไอคอนทานที่ร้าน
                  size: iconSize,
                  color: Colors.blue.shade700, // <<< สีฟ้า
                ),
              ],
            ),
          ),

        // <<<--- 5. [แก้ไข] ไอคอน Delivery
        if (hasDelivery) // <<< [แก้ไข]
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: iconSize,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        
        // (ส่วนแสดง "เปิดอยู่/ปิดอยู่" ... เหมือนเดิม)
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