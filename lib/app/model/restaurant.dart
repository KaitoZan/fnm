// lib/app/model/restaurant.dart (แก้ไข)

import 'package:get/get.dart';
import 'menu_item.dart';

class Restaurant {
  final String id;
  final String? imageUrl;
  final String? ownerId;
  final String restaurantName;
  final String description;
  final String detail; 
  final double rating;
  final RxBool isOpen;
  
  final String status; // <<< 1. [เพิ่ม] Field status (approved, pending, suspended)

  final bool hasDelivery; 
  final bool hasDineIn; 
  
  final String? openingHours;
  final String? phoneNumber;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<MenuItem> menuItems; 
  final List<String> promotion; 
  final List<String> galleryImages; 
  final String? type; 
  final RxBool isFavorite;
  double distanceInMeters;


  // Constructor
  Restaurant({
    required this.id,
    this.imageUrl,
    this.ownerId,
    required this.restaurantName,
    required this.description,
    required this.detail,
    required this.rating,
    required bool isOpen,
    required this.status, // <<< 2. [เพิ่ม] status
    required this.hasDelivery, 
    required this.hasDineIn, 

    this.openingHours,
    this.phoneNumber,
    this.location,
    this.latitude,
    this.longitude,
    required this.menuItems,
    required this.promotion,
    required this.galleryImages, 
    this.type, 
    required bool isFavorite,
    this.distanceInMeters = double.maxFinite,
  })  : this.isOpen = isOpen.obs,
        this.isFavorite = isFavorite.obs;

  // *** แก้ไข Factory fromSupabaseMap ***
  factory Restaurant.fromSupabaseMap(Map<String, dynamic> map, bool isCurrentlyFavorite) {

    final List<dynamic> menuData = map['menus'] as List<dynamic>? ?? [];
    final List<MenuItem> fullMenuItems = menuData
        .map((menuMap) => MenuItem.fromMap(menuMap as Map<String, dynamic>))
        .toList();

    double? lat = (map['latitude'] as num?)?.toDouble();
    double? lng = (map['longitude'] as num?)?.toDouble();
    bool currentIsOpen = map['is_open'] as bool? ?? false;
    String currentStatus = map['status'] as String? ?? 'pending'; // <<< 3. [แก้ไข] ดึง status

    List<String> promotionList = [];
    final dynamic promoData = map['promo_imgs_urls'];
    if (promoData is List) {
      promotionList = List<String>.from(promoData.whereType<String>());
    } else if (promoData is String && promoData.isNotEmpty) {
      promotionList = [promoData];
    }
    
    List<String> galleryList = [];
    final dynamic galleryData = map['gallery_imgs_urls'];
    if (galleryData is List) {
      galleryList = List<String>.from(galleryData.whereType<String>());
    } else if (galleryData is String && galleryData.isNotEmpty) {
      galleryList = [galleryData];
    }

    return Restaurant(
      id: map['id'] as String,
      imageUrl: map['res_img'] as String?,
      ownerId: map['owner_id'] as String?,
      restaurantName: map['res_name'] as String? ?? 'ไม่มีชื่อร้าน',
      description: map['description'] as String? ?? '',
      detail: map['detail'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      isOpen: currentIsOpen,
      status: currentStatus, // <<< 4. [เพิ่ม] status
      hasDelivery: map['has_delivery'] as bool? ?? false, 
      hasDineIn: map['has_dine_in'] as bool? ?? false,
      openingHours: map['opening_hours']?.toString(),
      phoneNumber: map['phone_no'] as String?,
      location: map['location'] as String?,
      latitude: lat,
      longitude: lng,
      menuItems: fullMenuItems, 
      promotion: promotionList,
      galleryImages: galleryList, 
      type: map['food_type'] as String?, 
      isFavorite: isCurrentlyFavorite,
    );
  }

  // *** แก้ไข copyWith ***
  Restaurant copyWith({
    String? id,
    String? imageUrl,
    String? ownerId,
    String? restaurantName,
    String? description,
    double? rating,
    bool? isOpen,
    String? status, // <<< 5. [เพิ่ม] status
    bool? hasDelivery, 
    bool? hasDineIn, 
    String? detail,
    String? openingHours,
    String? phoneNumber,
    String? location,
    double? latitude,
    double? longitude,
    List<MenuItem>? menuItems,
    List<String>? promotion,
    List<String>? galleryImages, 
    String? type, 
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
      status: status ?? this.status, // <<< 6. [เพิ่ม] status
      hasDelivery: hasDelivery ?? this.hasDelivery, 
      hasDineIn: hasDineIn ?? this.hasDineIn, 
      detail: detail ?? this.detail,
      openingHours: openingHours ?? this.openingHours,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      menuItems: menuItems ?? this.menuItems,
      promotion: promotion ?? this.promotion,
      galleryImages: galleryImages ?? this.galleryImages, 
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite.value,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
    );
  }
}