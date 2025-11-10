// lib.zip/app/ui/pages/restaurant_detail_page/restaurant_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// <<<--- [TASK 18 - เพิ่ม] Import (สำหรับ CachedNetworkImage)
import 'package:cached_network_image/cached_network_image.dart';


import '../../../routes/app_routes.dart';
import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart'; // <<<--- Import Model ที่แก้ไขแล้ว
import '../../../model/menu_item.dart'; // <<<--- [TASK 18 - เพิ่ม] Import (สำหรับ CommentModel)
import '../login_page/login_controller.dart';

class RestaurantDetailController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  late final FilterController _filterController;
  final supabase = Supabase.instance.client;

  // Controllers รีวิว
  final TextEditingController commentController = TextEditingController();
  final RxDouble userRating = 0.0.obs;

  // --- 1. restaurantId เป็น String (uuid) ---
  final String restaurantId;

  // State ร้านและรีวิว
  final Rx<Restaurant?> restaurant = Rx<Restaurant?>(null);
  final RxBool isDeleting = false.obs;
  final RxList<CommentModel> reviews =
      <CommentModel>[].obs; // <<<--- ใช้ Model ที่แก้ไขแล้ว
  final RxBool isLoadingReviews = false.obs;

  // Controller Report
  final TextEditingController reportReasonController = TextEditingController();

  // Constructor
  RestaurantDetailController({required this.restaurantId});

  @override
  void onInit() {
    super.onInit();
    _filterController = Get.find<FilterController>();
    // --- 2. ไม่ต้องแปลง ID ---

    loadRestaurantDetails();
    _loadReviews();
  }

  @override
  void onClose() {
    commentController.dispose();
    reportReasonController.dispose();
    super.onClose();
  }

  // โหลด/รีเฟรชข้อมูล
  void restore() {
    loadRestaurantDetails();
    _loadReviews();
  }

  // --- 3. loadRestaurantDetails (ใช้ ID String) ---
  void loadRestaurantDetails() {
    // ใช้ ID (String uuid) ในการหา
    final newRestaurantInstance = _filterController.allRestaurantsObservable
        .firstWhereOrNull(
          (res) => res.id == restaurantId,
        ); // <<<--- ID (String)

    restaurant.value = newRestaurantInstance; // อัปเดต State

    // จัดการกรณีไม่เจอร้าน
    if (restaurant.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute.startsWith(AppRoutes.RESTAURANTDETAIL)) {
          Get.snackbar(
            'ข้อผิดพลาด',
            'ไม่พบข้อมูลร้านค้า อาจถูกลบไปแล้ว',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.1),
            colorText: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Get.offNamed(AppRoutes.NAVBAR);
        }
      });
    }
  }

  // อัปเดตคะแนนรีวิวชั่วคราว
  void onRatingChanged(double newRating) {
    userRating.value = newRating;
  }

  // --- 4. deleteRestaurant (ใช้ restaurantName และ ID String) ---
  void deleteRestaurant() {
    if (restaurant.value == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบ: ไม่พบข้อมูลร้านค้า');
      return;
    }

    final String restaurantName =
        restaurant.value!.restaurantName; // <<<--- restaurantName
    final String currentRestaurantId =
        restaurant.value!.id; // <<<--- ID (String)

    Get.defaultDialog(
      title: "ยืนยันการลบ",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "คุณแน่ใจหรือไม่ว่าต้องการลบร้าน\n'$restaurantName'?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    isDeleting.value = true;
                    Get.back();
                    try {
                      // --- ใช้ ID (String uuid) ในการลบ ---
                      await supabase
                          .from('restaurants')
                          .delete()
                          .eq('id', currentRestaurantId); // <<<--- ID (String)

                      // ลบออกจาก FilterController (ส่ง String ID)
                      _filterController.removeRestaurantFromList(restaurantId);

                      Get.back(); // กลับไปหน้าก่อนหน้า (Home/MyShop)
                      Get.snackbar(
                        'สำเร็จ',
                        'ลบร้านค้า "$restaurantName" เรียบร้อยแล้ว',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.black.withOpacity(0.1),
                        colorText: Colors.black,
                        duration: const Duration(milliseconds: 900),
                      );
                    } catch (e) {
                      print("Error deleting restaurant: $e");
                      Get.snackbar(
                        'ข้อผิดพลาด',
                        'ไม่สามารถลบร้านค้าได้: ${e.toString()}',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    } finally {
                      isDeleting.value = false;
                    }
                  },
                  child: const Text("ยืนยัน"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. _loadReviews (เพิ่ม 'user_id' เข้า Select) ---
  Future<void> _loadReviews() async {
    isLoadingReviews.value = true;
    try {
      // --- เพิ่ม 'user_id' ---
      final List<Map<String, dynamic>> data = await supabase
          .from('comments')
          .select('''
 			id,
 			user_id, 
 			content,
 			rating_score,
 			created_at,
 			user_profiles (
 			  user_name,
 			  avatar_url
 			)
 		  ''') // <<<--- เพิ่ม user_id
          .eq('res_id', restaurantId) // <<<--- res_id (String)
          .order('created_at', ascending: false);

      // Map เป็น CommentModel (ใช้ Model ที่แก้ไขแล้ว)
      reviews.assignAll(data.map((map) => CommentModel.fromMap(map)).toList());
    } catch (e) {
      print("Error loading reviews: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถโหลดรีวิวได้: ${e.toString()}');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  // --- 6. submitReview (ใช้ 'res_id') ---
  void submitReview() async {
    if (loginController.isLoggedIn.value) {
      if (commentController.text.trim().isNotEmpty && userRating.value > 0) {
        final String currentUserId = loginController.userId.value;
        final String commentContent = commentController.text.trim();
        final int ratingScore = userRating.value.toInt();

        try {
          // --- ใช้ 'res_id' (String) ---
          await supabase.from('comments').insert({
            'user_id': currentUserId,
            'res_id': restaurantId, // <<<--- res_id (String)
            'content': commentContent,
            'rating_score': ratingScore,
          });

          commentController.clear();
          userRating.value = 0.0;
          _loadReviews(); // โหลดรีวิวใหม่
          Get.snackbar(
            'ส่งรีวิวแล้ว',
            'รีวิวของคุณถูกส่งเรียบร้อยแล้วค่ะ!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.1),
            colorText: Colors.black,
            duration: const Duration(milliseconds: 900),
          );
        } catch (e) {
          print("Error submitting review: $e");
          Get.snackbar(
            'ข้อผิดพลาด',
            'ไม่สามารถส่งรีวิวได้: ${e.toString()}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          'โปรดให้คะแนนและเขียนคอมเมนต์ให้ครบถ้วนก่อนส่ง',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.1),
          colorText: Colors.black,
          duration: const Duration(milliseconds: 900),
        );
      }
    } else {
      Get.defaultDialog(
        title: 'แจ้งเตือน',
        middleText: 'กรุณาเข้าสู่ระบบก่อนทำการรีวิว',
        textConfirm: 'ตกลง',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          Get.offAllNamed(AppRoutes.LOGIN);
        },
        textCancel: 'ยกเลิก',
        onCancel: () {},
      );
    }
  }

  // --- (ฟังก์ชันลบคอมเมนต์ (TASK 2) ... เหมือนเดิม) ---
  void deleteComment(int commentId) async {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('ข้อผิดพลาด', 'กรุณาเข้าสู่ระบบ');
      return;
    }

    // (Policy RLS จะตรวจสอบเองว่าเป็นเจ้าของหรือไม่)

    Get.defaultDialog(
      title: "ยืนยันการลบ",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบคอมเมนต์นี้?"),
      textCancel: "ยกเลิก",
      textConfirm: "ลบ",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // ปิด Dialog
        try {
          // RLS Policy ("Allow owner or admin delete on comments") จะทำงาน
          await supabase
              .from('comments')
              .delete()
              .eq('id', commentId);
          
          _loadReviews(); // โหลดรีวิวใหม่
          
          Get.snackbar(
            'สำเร็จ',
            'ลบคอมเมนต์เรียบร้อยแล้ว',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.1),
            colorText: Colors.black,
            duration: const Duration(milliseconds: 900),
          );

        } catch (e) {
          print("Error deleting comment: $e");
          Get.snackbar(
            'ข้อผิดพลาด',
            'ไม่สามารถลบคอมเมนต์ได้: ${e.toString()}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      },
    );
  }


  // เปิดแผนที่
  Future<void> launchMap(double? lat, double? lng, String label) async {
    if (lat == null || lng == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่พบข้อมูลพิกัดสำหรับร้านนี้');
      return;
    }
    // (Note: This URL seems incorrect, but keeping it as per original code)
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final Uri url = Uri.parse(googleMapsUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'ไม่สามารถเปิด URL แผนที่ได้: $url';
      }
    } catch (e) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถเปิดแอปแผนที่ได้: ${e.toString()}');
    }
  }

  // <<<--- [TASK 18 - เริ่มแก้ไข] ---
  
  // --- 7. (แก้ไข) showReportDialog (สำหรับ Comment) ---
  void showReportDialog(int commentId) {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเข้าสู่ระบบ...');
      return;
    }
    reportReasonController.clear();
    
    // (ตัวแปรสำหรับจัดการ State ภายใน Dialog)
    String? selectedReason; 
    final String otherReasonKey = "อื่นๆ";
    final List<String> commentReportOptions = [
        "ข้อความหยาบคาย", 
        "สแปม / โฆษณา", 
        otherReasonKey
    ];

    Get.defaultDialog(
      title: 'แจ้งปัญหาคอมเมนต์',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      
      // --- ใช้ StatefulBuilder เพื่อจัดการ State ของ Radio และ TextField ---
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('โปรดเลือกเหตุผลในการแจ้งปัญหา:'),
              ),
              const SizedBox(height: 8),
              
              // (สร้าง RadioListTile จาก List)
              ...commentReportOptions.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                  dense: true,
                );
              }).toList(),
              
              // (แสดง TextField ถ้าเลือก "อื่นๆ")
              if (selectedReason == otherReasonKey)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: TextField(
                    controller: reportReasonController, // ใช้ Controller ของคลาสหลัก
                    maxLines: 2,
                    autofocus: true, // Focus ทันทีที่แสดง
                    decoration: const InputDecoration(
                      hintText: 'โปรดระบุเหตุผล...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // (ตรวจสอบ State ตอนกดยืนยัน)
          if (selectedReason == null) {
            Get.snackbar('ข้อผิดพลาด', 'กรุณาเลือกเหตุผล...');
            return;
          }
          
          String finalReason;
          if (selectedReason == otherReasonKey) {
            if (reportReasonController.text.trim().isEmpty) {
              Get.snackbar('ข้อผิดพลาด', 'กรุณาระบุเหตุผลในช่อง "อื่นๆ"...');
              return;
            }
            // (รวมเหตุผล)
            finalReason = "$otherReasonKey: ${reportReasonController.text.trim()}";
          } else {
            finalReason = selectedReason!;
          }
          
          Get.back(); // ปิด Dialog
          _submitReport(
            finalReason, // <<< ส่งเหตุผลที่สร้างใหม่
            commentId: commentId,
          );
        },
        child: const Text('ส่งเรื่อง'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('ยกเลิก'),
      ),
    );
  }

  // --- 8. (แก้ไข) showReportRestaurantDialog (สำหรับ Restaurant) ---
  void showReportRestaurantDialog() {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเข้าสู่ระบบ...');
      return;
    }
    reportReasonController.clear();
    
    // (ตัวแปรสำหรับจัดการ State ภายใน Dialog)
    String? selectedReason; 
    final String otherReasonKey = "อื่นๆ";
    // (ใช้เหตุผลคนละชุดกับ Comment)
    final List<String> restaurantReportOptions = [
        "ข้อมูลร้านไม่ถูกต้อง (เช่น เบอร์, เวลาเปิด)", 
        "ร้านปิดถาวรแล้ว",
        "สแปม / โฆษณา",
        otherReasonKey
    ];

    Get.defaultDialog(
      title: 'แจ้งปัญหาร้านค้า', // <<< แก้ไข Title
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      
      // --- ใช้ StatefulBuilder ---
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('โปรดเลือกเหตุผลในการแจ้งปัญหา:'),
              ),
              const SizedBox(height: 8),

              // (สร้าง RadioListTile จาก List)
              ...restaurantReportOptions.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                  dense: true,
                );
              }).toList(),
              
              // (แสดง TextField ถ้าเลือก "อื่นๆ")
              if (selectedReason == otherReasonKey)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: TextField(
                    controller: reportReasonController, // ใช้ Controller ของคลาสหลัก
                    maxLines: 2,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'โปรดระบุปัญหาที่พบ...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // (ตรวจสอบ State ตอนกดยืนยัน)
          if (selectedReason == null) {
            Get.snackbar('ข้อผิดพลาด', 'กรุณาเลือกเหตุผล...');
            return;
          }
          
          String finalReason;
          if (selectedReason == otherReasonKey) {
            if (reportReasonController.text.trim().isEmpty) {
              Get.snackbar('ข้อผิดพลาด', 'กรุณาระบุเหตุผลในช่อง "อื่นๆ"...');
              return;
            }
            finalReason = "$otherReasonKey: ${reportReasonController.text.trim()}";
          } else {
            finalReason = selectedReason!;
          }
          
          Get.back(); // ปิด Dialog
          _submitReport(
            finalReason, // <<< ส่งเหตุผลที่สร้างใหม่
            resId: restaurantId,
          );
        },
        child: const Text('ส่งเรื่อง'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('ยกเลิก'),
      ),
    );
  }
  // <<<--- [TASK 18 - สิ้นสุดการแก้ไข] ---


  // --- 9. _submitReport (ไม่ต้องแก้ไข) ---
  Future<void> _submitReport(String reason, {int? commentId, String? resId}) async {
    final String currentUserId = loginController.userId.value;
    try {
      await supabase.from('complaints').insert({
        'reporter_id': currentUserId,
        'comment_id': commentId, // <<<--- อาจเป็น null
        'res_id': resId, // <<<--- อาจเป็น null (แต่ใน Logic นี้คือ restaurantId)
        'reason': reason, // <<<--- รับ "เหตุผล" ที่สร้างใหม่
        'status': 'pending',
      });
      Get.snackbar(
        'ส่งเรื่องสำเร็จ',
        'การแจ้งปัญหาของคุณถูกส่งเรียบร้อยแล้ว...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error submitting report: $e");
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถส่งเรื่องแจ้งปัญหาได้: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

} // End of Controller

// --- 9. Comment Model (เพิ่ม 'userId') ---
class CommentModel {
  final int id; // bigint
  final String userId; // <<<--- [เพิ่ม]
  final String content;
  final int ratingScore; // smallint (int2)
  final DateTime createdAt;
  final String userName; // user_profiles.user_name
  final String? userAvatarUrl; // user_profiles.avatar_url

  CommentModel({
    required this.id,
    required this.userId, // <<<--- [เพิ่ม]
    required this.content,
    required this.ratingScore,
    required this.createdAt,
    required this.userName,
    this.userAvatarUrl,
  });

  // Factory (ใช้ 'user_profiles', 'user_name', 'avatar_url', และ 'user_id')
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    // ดึงข้อมูลจากตาราง Join 'user_profiles'
    final profileData =
        map['user_profiles'] as Map<String, dynamic>?; // <<<--- user_profiles

    return CommentModel(
      id: map['id'] as int,
      userId: map['user_id'] as String? ?? '', // <<<--- [เพิ่ม]
      content: map['content'] as String? ?? '',
      ratingScore: (map['rating_score'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      // ใช้ชื่อคอลัมน์จาก user_profiles
      userName:
          profileData?['user_name'] as String? ?? 'ผู้ใช้', // <<<--- user_name
      userAvatarUrl: profileData?['avatar_url'] as String?, // <<<--- avatar_url
    );
  }
}