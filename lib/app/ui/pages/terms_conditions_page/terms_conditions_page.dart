import 'package:flutter/material.dart';



import 'package:food_near_me_app/app/ui/pages/terms_conditions_page/terms_conditions_controller.dart';
import 'package:get/get.dart';

import '../../global_widgets/back3_bt.dart';

class TermsConditionsPage extends GetView<TermsConditionsController> {
  TermsConditionsPage({super.key});


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Back3Bt(),
        title: const Text('เงื่อนไขและข้อตกลง'),
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
                'เงื่อนไขและข้อตกลงการใช้งานแอปพลิเคชัน "ร้านอาหารใกล้ฉัน"',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'โปรดอ่านเงื่อนไขและข้อตกลงเหล่านี้อย่างละเอียดก่อนการใช้งานแอปพลิเคชัน "ร้านอาหารใกล้ฉัน" การเข้าถึงและใช้งานแอปพลิเคชันนี้ถือว่าคุณยอมรับและผูกพันตามเงื่อนไขทั้งหมดที่ระบุไว้ด้านล่างนี้ หากคุณไม่เห็นด้วยกับเงื่อนไขใดๆ โปรดอย่าใช้งานแอปพลิเคชันนี้',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '1. การยอมรับเงื่อนไข',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'การใช้งานแอปพลิเคชันนี้แสดงว่าคุณตกลงที่จะปฏิบัติตามเงื่อนไขและข้อตกลงทั้งหมดที่ระบุไว้ที่นี่ เราขอสงวนสิทธิ์ในการเปลี่ยนแปลง แก้ไข หรือเพิ่มเติมเงื่อนไขเหล่านี้ได้ทุกเมื่อ โดยไม่ต้องแจ้งให้ทราบล่วงหน้า การที่คุณยังคงใช้งานแอปพลิเคชันต่อไปหลังจากการเปลี่ยนแปลงใดๆ ถือว่าคุณยอมรับการเปลี่ยนแปลงนั้น',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '2. การใช้งานบริการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'แอปพลิเคชัน "ร้านอาหารใกล้ฉัน" มีวัตถุประสงค์เพื่อช่วยผู้ใช้งานค้นหาร้านอาหารที่อยู่ใกล้เคียงและดูข้อมูลร้านอาหาร เราไม่อนุญาตให้ใช้งานแอปพลิเคชันนี้เพื่อวัตถุประสงค์ที่ผิดกฎหมาย หรือละเมิดสิทธิ์ของผู้อื่น',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '3. บัญชีผู้ใช้งาน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'คุณต้องรับผิดชอบในการรักษาความลับของข้อมูลบัญชีผู้ใช้งานและรหัสผ่านของคุณ คุณต้องรับผิดชอบต่อกิจกรรมทั้งหมดที่เกิดขึ้นภายใต้บัญชีของคุณ และยินยอมที่จะแจ้งให้เราทราบทันทีหากมีการใช้งานบัญชีของคุณโดยไม่ได้รับอนุญาต',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '4. ข้อมูลและเนื้อหา',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'ข้อมูลทั้งหมดในแอปพลิเคชัน (รวมถึงแต่ไม่จำกัดเพียงข้อมูลร้านอาหาร รูปภาพ และบทวิจารณ์) มีวัตถุประสงค์เพื่อเป็นข้อมูลเท่านั้น เราไม่รับประกันความถูกต้องหรือครบถ้วนของข้อมูลดังกล่าว เนื้อหาที่ผู้ใช้งานสร้างขึ้น เช่น บทวิจารณ์ร้านอาหาร ถือเป็นความรับผิดชอบของผู้ใช้งานแต่เพียงผู้เดียว และต้องไม่ละเมิดสิทธิ์ของบุคคลที่สาม หรือมีเนื้อหาที่ไม่เหมาะสม',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '5. การจำกัดความรับผิด',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'แอปพลิเคชัน "ร้านอาหารใกล้ฉัน" ให้บริการตาม "สภาพที่เป็นอยู่" และ "ตามที่มี" เราไม่รับประกันว่าการทำงานของแอปพลิเคชันจะไม่มีข้อผิดพลาด หรือจะสามารถใช้งานได้อย่างต่อเนื่อง เราจะไม่รับผิดชอบต่อความเสียหายใดๆ ที่เกิดจากการใช้งานหรือไม่สามารถใช้งานแอปพลิเคชันนี้ได้',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '6. การเปลี่ยนแปลงบริการ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'เราขอสงวนสิทธิ์ในการเปลี่ยนแปลง ระงับ หรือยกเลิกบริการใดๆ หรือคุณสมบัติของแอปพลิเคชันได้ทุกเมื่อ โดยไม่ต้องแจ้งให้ทราบล่วงหน้า',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '7. การยุติการใช้งาน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'เราอาจยุติหรือระงับการเข้าถึงแอปพลิเคชันของคุณได้ทันที โดยไม่ต้องแจ้งให้ทราบล่วงหน้า หากคุณละเมิดเงื่อนไขและข้อตกลงเหล่านี้',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),

              Text(
                '8. กฎหมายที่บังคับใช้',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                'เงื่อนไขและข้อตกลงเหล่านี้จะอยู่ภายใต้บังคับของกฎหมายแห่งประเทศไทย',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'อัปเดตล่าสุด: 24 มิถุนายน 2567',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
