// lib/app/model/restaurant.dart (แก้ไขส่วน factory)

import 'package:get/get.dart';

class Restaurant {
  // ... (ประกาศ Fields เหมือนเดิม - type เป็น String?) ...
  final String id;
  final String? imageUrl;
  final String? ownerId;
  final String restaurantName;
  final String description;
  final double rating;
  final RxBool isOpen;
  final bool showMotorcycleIcon;
  final String? detail; // <<<--- ชื่อตัวแปรถูกต้องแล้ว
  final String? openingHours;
  final String? phoneNumber;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String> menuImages; // <<<--- ยังคงเป็น List<String> (เก็บ URL แรกของแต่ละเมนู)
  final List<String> promotion;
  final String? type; // <<<--- String? สำหรับ food_type (Text)
  final RxBool isFavorite;
  double distanceInMeters;


  // Constructor (เหมือนเดิม)
  Restaurant({
    required this.id,
    this.imageUrl,
    this.ownerId,
    required this.restaurantName,
    required this.description,
    required this.rating,
    required bool isOpen,
    required this.showMotorcycleIcon,
    this.detail,
    this.openingHours,
    this.phoneNumber,
    this.location,
    this.latitude,
    this.longitude,
    required this.menuImages, // <<<--- รับ List<String>
    required this.promotion,
    this.type, // <<<--- รับ String?
    required bool isFavorite,
    this.distanceInMeters = double.maxFinite,
  })  : this.isOpen = isOpen.obs,
        this.isFavorite = isFavorite.obs;

  // *** แก้ไข Factory fromSupabaseMap ตรงนี้ ***
  factory Restaurant.fromSupabaseMap(Map<String, dynamic> map, bool isCurrentlyFavorite) {

    // --- ส่วนประมวลผล menus ที่แก้ไขแล้ว ---
    final List<dynamic> menuData = map['menus'] as List<dynamic>? ?? [];
    final List<String> menuImageUrls = []; // สร้าง List ว่าง

    for (var menu in menuData) { // วนลูปแต่ละเมนู (Map)
      // อ่าน img_url (ซึ่งเป็น List หรือ null)
      final dynamic imgUrlData = menu['img_url'];

      if (imgUrlData is List && imgUrlData.isNotEmpty) {
        // ถ้า img_url เป็น List และไม่ว่าง
        final String? firstUrl = imgUrlData.first as String?; // เอา URL แรกมา
        if (firstUrl != null && firstUrl.isNotEmpty) {
          menuImageUrls.add(firstUrl); // เพิ่ม URL แรกลงใน List ผลลัพธ์
        }
      }
      // ถ้า imgUrlData ไม่ใช่ List หรือเป็น List ว่าง ก็ไม่ต้องทำอะไร (ข้ามไป)
    }
    // --- สิ้นสุดส่วนประมวลผล menus ---

    // (ดึง Lat/Lng, is_open - เหมือนเดิม)
    double? lat = (map['latitude'] as num?)?.toDouble();
    double? lng = (map['longitude'] as num?)?.toDouble();
    bool currentIsOpen = map['is_open'] as bool? ?? false;

    // (ส่วนจัดการ promo_imgs_urls - เหมือนเดิม)
    List<String> promotionList = [];
    final dynamic promoData = map['promo_imgs_urls'];
    if (promoData is List) {
      promotionList = List<String>.from(promoData.whereType<String>());
    } else if (promoData is String && promoData.isNotEmpty) {
      promotionList = [promoData];
    }

    // สร้าง Instance
    return Restaurant(
      id: map['id'] as String,
      imageUrl: map['res_img'] as String?,
      ownerId: map['owner_id'] as String?,
      restaurantName: map['res_name'] as String? ?? 'ไม่มีชื่อร้าน',
      description: map['description'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      isOpen: currentIsOpen,
      showMotorcycleIcon: map['has_delivery'] as bool? ?? false,
      // detail: map['description_inside'] as String?, // <<<--- แก้ไข
      detail: map['detail'] as String?, // <<<--- TASK 3
      openingHours: map['opening_hours']?.toString(),
      phoneNumber: map['phone_no'] as String?,
      location: map['location'] as String?,
      latitude: lat,
      longitude: lng,
      menuImages: menuImageUrls, // <<<--- ใช้ List<String> ที่ได้จากการประมวลผล
      promotion: promotionList,
      type: map['food_type'] as String?, // <<<--- อ่าน food_type เป็น String?
      isFavorite: isCurrentlyFavorite,
    );
  }

  // copyWith (เหมือนเดิม - ใช้ String? type)
  Restaurant copyWith({
    String? id,
    String? imageUrl,
    String? ownerId,
    String? restaurantName,
    String? description,
    double? rating,
    bool? isOpen,
    bool? showMotorcycleIcon,
    String? detail,
    String? openingHours,
    String? phoneNumber,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? menuImages,
    List<String>? promotion,
    String? type, // <<<--- String?
    bool? isFavorite,
    double? distanceInMeters,
  }) {
    return Restaurant(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      restaurantName: restaurantName ?? this.restaurantName,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen.value,
      showMotorcycleIcon: showMotorcycleIcon ?? this.showMotorcycleIcon,
      detail: detail ?? this.detail,
      openingHours: openingHours ?? this.openingHours,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      menuImages: menuImages ?? this.menuImages,
      promotion: promotion ?? this.promotion,
      type: type ?? this.type, // <<<--- ใช้ type
      isFavorite: isFavorite ?? this.isFavorite.value,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
    );
  }
}