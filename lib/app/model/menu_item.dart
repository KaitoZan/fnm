// lib/app/model/menu_item.dart
// (ไฟล์นี้คือ Model สำหรับเก็บข้อมูลจากตาราง 'menus' [SCHEMA] 1 แถว)

class MenuItem {
  final int id; // id (bigint)
  final String name;
  final String description;
  final double price;
  final List<String> imgUrls; // img_url (ARRAY)

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imgUrls,
  });

  // Factory สำหรับแปลงข้อมูลจาก Supabase (ที่ JOIN มาใน 'menus')
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    List<String> urls = [];
    final dynamic imgUrlData = map['img_url']; // (นี่คือ ARRAY)
    if (imgUrlData is List) {
      urls = List<String>.from(imgUrlData.whereType<String>());
    } else if (imgUrlData is String && imgUrlData.isNotEmpty) {
      urls = [imgUrlData]; // (เผื่อกรณีข้อมูลเก่า)
    }

    return MenuItem(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] as String? ?? 'ไม่มีชื่อเมนู',
      description: map['description'] as String? ?? '', // (ใช้ description ที่อาจจะเป็น null)
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imgUrls: urls,
    );
  }
}