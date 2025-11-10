import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';
import 'aboutapp_controller.dart';

class AboutAppPage extends GetView<AboutappController> {
 AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Back3Bt(),
        title: const Text('เกี่ยวกับ ร้านอาหารใกล้ฉัน'),
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
                'เกี่ยวกับแอปพลิเคชัน "ร้านอาหารใกล้ฉัน"',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'แอปพลิเคชัน "ร้านอาหารใกล้ฉัน" ถูกพัฒนาขึ้นมาเพื่อเป็นเพื่อนคู่ใจของคุณในการค้นหาร้านอาหารอร่อยๆ ที่อยู่ใกล้ตัวคุณ ไม่ว่าคุณจะอยู่ที่ไหน เราก็พร้อมช่วยคุณค้นพบร้านโปรดใหม่ๆ หรือกลับไปเยือนร้านประจำที่คุณชื่นชอบได้อย่างง่ายดาย',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'วิสัยทัศน์ของเรา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'เรามุ่งมั่นที่จะเป็นแพลตฟอร์มค้นหาร้านอาหารอันดับหนึ่งที่ตอบโจทย์ทุกความต้องการของผู้ใช้งาน ด้วยข้อมูลที่ครบถ้วน แม่นยำ และฟังก์ชันการใช้งานที่ง่ายดาย เพื่อให้ทุกคนได้สัมผัสประสบการณ์การกินที่ยอดเยี่ยมที่สุด',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'คุณสมบัติเด่น',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '- ค้นหาร้านอาหารใกล้เคียง: ใช้ตำแหน่งปัจจุบันของคุณเพื่อค้นหาร้านอาหารที่อยู่รอบตัวคุณ',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- ตัวกรองที่หลากหลาย: กรองร้านอาหารตามประเภทอาหาร จังหวัด อำเภอ หรือแม้กระทั่งตามความนิยมและรีวิว',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- ข้อมูลร้านอาหารครบครัน: ดูรายละเอียดร้านค้า เช่น ที่อยู่ เบอร์โทรศัพท์ เวลาเปิด-ปิด และรีวิวจากผู้ใช้งานจริง',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                '- ใช้งานง่าย: ออกแบบมาให้ใช้งานง่ายและสะดวกสบายสำหรับทุกคน',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'ทีมงานของเรา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'แอปพลิเคชัน "ร้านอาหารใกล้ฉัน" พัฒนาโดยทีมงานผู้เชี่ยวชาญด้านเทคโนโลยีและผู้หลงใหลในการกิน ที่ตั้งใจสร้างสรรค์สิ่งที่ดีที่สุดเพื่อตอบสนองความต้องการของผู้ใช้งานทุกท่าน',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'ติดต่อเรา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'หากคุณมีข้อเสนอแนะ คำถาม หรือต้องการความช่วยเหลือ โปรดอย่าลังเลที่จะติดต่อเราผ่านช่องทาง "ติดต่อเรา" ในหน้าตั้งค่า เรายินดีรับฟังทุกความคิดเห็นเพื่อนำไปปรับปรุงบริการของเราให้ดียิ่งขึ้น',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'ขอบคุณที่เลือกใช้แอปพลิเคชัน "ร้านอาหารใกล้ฉัน"!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'เวอร์ชั่น: 0.0.11',
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
