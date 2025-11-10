import 'package:flutter/material.dart';




import 'package:food_near_me_app/app/ui/pages/privacypolicy_page/privacypolicy_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';

class PrivacypolicyPage extends GetView<PrivacypolicyController> {
  PrivacypolicyPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Back3Bt(),
        title: const Text('นโยบายความเป็นส่วนตัว'),
        backgroundColor: Colors.blue[200],
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        toolbarHeight: 8 * 9,
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'นโยบายความเป็นส่วนตัวของแอปพลิเคชัน "ร้านอาหารใกล้ฉัน"',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'แอปพลิเคชัน "ร้านอาหารใกล้ฉัน" ให้ความสำคัญอย่างยิ่งกับความเป็นส่วนตัวของผู้ใช้งาน เราจึงได้จัดทำนโยบายความเป็นส่วนตัวนี้ขึ้น เพื่ออธิบายแนวทางปฏิบัติเกี่ยวกับการเก็บรวบรวม การใช้งาน การเปิดเผย และการคุ้มครองข้อมูลส่วนบุคคลของคุณ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '1. ข้อมูลที่เราเก็บรวบรวม',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- **ข้อมูลส่วนบุคคลที่ระบุตัวตนได้โดยตรง:** เช่น ชื่อผู้ใช้งาน, อีเมล (เมื่อคุณลงทะเบียนหรือเข้าสู่ระบบ)',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **ข้อมูลตำแหน่งทางภูมิศาสตร์:** เราอาจขออนุญาตเข้าถึงข้อมูลตำแหน่งปัจจุบันของคุณเพื่อแสดงร้านอาหารที่อยู่ใกล้เคียง ข้อมูลนี้จะถูกใช้งานเพื่อวัตถุประสงค์ในการให้บริการค้นหาร้านอาหารเท่านั้น และจะไม่ถูกเก็บรวบรวมอย่างถาวรโดยไม่ได้รับความยินยอมจากคุณ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **ข้อมูลการใช้งาน:** เช่น ประเภทของอุปกรณ์, ระบบปฏิบัติการ, เวลาที่เข้าใช้งาน, ฟังก์ชันที่ใช้งานบ่อย, และข้อมูลอื่นๆ ที่เกี่ยวข้องกับการใช้งานแอปพลิเคชัน เพื่อวัตถุประสงค์ในการปรับปรุงบริการและแก้ไขข้อบกพร่อง',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '2. การใช้ข้อมูลของคุณ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'เราใช้ข้อมูลที่เก็บรวบรวมเพื่อวัตถุประสงค์ดังต่อไปนี้:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อให้บริการและฟังก์ชันการทำงานของแอปพลิเคชัน',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อปรับปรุงและพัฒนาบริการของเราให้ดียิ่งขึ้น',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อตอบคำถามและให้การสนับสนุนแก่ผู้ใช้งาน',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อวิเคราะห์แนวโน้มการใช้งานและพฤติกรรมของผู้ใช้ (ในรูปแบบที่ไม่สามารถระบุตัวตนได้)',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '3. การเปิดเผยข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'เราจะไม่เปิดเผยข้อมูลส่วนบุคคลของคุณแก่บุคคลที่สาม เว้นแต่ในกรณีดังต่อไปนี้:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- ได้รับความยินยอมจากคุณ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อปฏิบัติตามกฎหมาย คำสั่งศาล หรือหน่วยงานรัฐที่มีอำนาจ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- เพื่อปกป้องสิทธิ์ ทรัพย์สิน หรือความปลอดภัยของแอปพลิเคชัน ผู้ใช้งาน หรือสาธารณะ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '4. การรักษาความปลอดภัยของข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'เราใช้มาตรการรักษาความปลอดภัยที่เหมาะสมเพื่อป้องกันการเข้าถึง การเปลี่ยนแปลง การเปิดเผย หรือการทำลายข้อมูลส่วนบุคคลของคุณโดยไม่ได้รับอนุญาต',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '5. การเปลี่ยนแปลงนโยบายความเป็นส่วนตัว',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'เราอาจปรับปรุงนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว การเปลี่ยนแปลงใดๆ จะมีผลบังคับใช้ทันทีเมื่อเราเผยแพร่นโยบายที่ปรับปรุงใหม่ในแอปพลิเคชัน เราขอแนะนำให้คุณตรวจสอบนโยบายนี้เป็นประจำ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '6. การติดต่อเรา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'หากคุณมีคำถามหรือข้อสงสัยเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ โปรดติดต่อเราผ่านช่องทางที่ระบุในส่วน "ติดต่อเรา" ของแอปพลิเคชัน',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'อัปเดตล่าสุด: 24 มิถุนายน 2567',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
