import 'package:flutter/material.dart';
import 'package:food_near_me_app/app/ui/pages/contact_us_page/contact_us_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';

class ContactUsPage extends GetView<ContactUsController> {
  ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Back3Bt(),
        title: const Text('ติดต่อเรา'),
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
        color: Colors.white,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'ติดต่อแอปพลิเคชัน "ร้านอาหารใกล้ฉัน"',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'เรายินดีรับฟังทุกความคิดเห็น คำถาม หรือข้อเสนอแนะจากคุณ เพื่อนำไปปรับปรุงและพัฒนาบริการของแอปพลิเคชัน "ร้านอาหารใกล้ฉัน" ให้ดียิ่งขึ้น คุณสามารถติดต่อเราได้ตามช่องทางด้านล่างนี้:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                'ข้อมูลการติดต่อ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- **อีเมล:** support@foodnearmeapp.com',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **โทรศัพท์:** +66 (0) 123 4567 (เวลาทำการ: จันทร์-ศุกร์, 09:00 - 17:00 น.)',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **ที่อยู่:** เลขที่ 123 อาคารแอปพลิเคชัน แขวง/เขต บางกอกน้อย กรุงเทพมหานคร 10700',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                'ช่องทางโซเชียลมีเดีย',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ติดตามข่าวสารและโปรโมชั่นพิเศษจากเราได้ที่:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **Facebook:** facebook.com/FoodNearMeApp',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **Instagram:** instagram.com/FoodNearMeApp',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- **X (Twitter):** twitter.com/FoodNearMeApp',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                'แบบฟอร์มติดต่อ (สำหรับข้อเสนอแนะ)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'หากคุณต้องการส่งข้อเสนอแนะโดยตรงผ่านแอปพลิเคชัน โปรดกรอกข้อมูลในแบบฟอร์มด้านล่างนี้ (คุณสมบัตินี้จะถูกพัฒนาในอนาคต):',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),

              SizedBox(height: 24),
              Text(
                'เราจะตอบกลับข้อความของคุณโดยเร็วที่สุดเท่าที่จะทำได้',
                style: TextStyle(
                  fontSize: 16,
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
