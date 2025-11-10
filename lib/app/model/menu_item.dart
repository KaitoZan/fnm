// lib/app/model/menu_item.dart
// (ไฟล์นี้คือ Model สำหรับเก็บข้อมูลจากตาราง 'menus' [SCHEMA] 1 แถว)

class MenuItem {
  final int id; // id (bigint)
  final String name;
  final double price;
  // final List<String> imgUrls; // <<<--- 1. ลบ/แก้ไข บรรทัดนี้

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    // required this.imgUrls, // <<<--- 2. ลบ/แก้ไข บรรทัดนี้
  });

  // Factory สำหรับแปลงข้อมูลจาก Supabase (ที่ JOIN มาใน 'menus')
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    // (ลบ Logic การประมวลผล imgUrlData ทั้งหมด)
    // List<String> urls = [];
    // final dynamic imgUrlData = map['img_url']; // (นี่คือ ARRAY)
    // if (imgUrlData is List) {
    //   urls = List<String>.from(imgUrlData.whereType<String>());
    // } else if (imgUrlData is String && imgUrlData.isNotEmpty) {
    //   urls = [imgUrlData]; 
    // }

    return MenuItem(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] as String? ?? 'ไม่มีชื่อเมนู',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      // imgUrls: urls, // <<<--- 3. ลบ/แก้ไข บรรทัดนี้
    );
  }
}