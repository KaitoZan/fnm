// lib/app/ui/pages/restaurant_detail_page/restaurant_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../../../model/menu_item.dart';
import '../login_page/login_controller.dart';

// (Comment Model - เหมือนเดิม)
class CommentModel {
  final int id; 
  final String userId;
  final String content;
  final int ratingScore;
  final DateTime createdAt;
  final String userName;
  final String? userAvatarUrl;

  CommentModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.ratingScore,
    required this.createdAt,
    required this.userName,
    this.userAvatarUrl,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    final profileData = map['user_profiles'] as Map<String, dynamic>?; 

    return CommentModel(
      id: map['id'] as int,
      userId: map['user_id'] as String? ?? '',
      content: map['content'] as String? ?? '',
      ratingScore: (map['rating_score'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      userName:
          profileData?['user_name'] as String? ?? 'ผู้ใช้',
      userAvatarUrl: profileData?['avatar_url'] as String?,
    );
  }
}


class RestaurantDetailController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  late final FilterController _filterController;
  final supabase = Supabase.instance.client;

  // Controllers รีวิว
  final TextEditingController commentController = TextEditingController();
  final RxDouble userRating = 0.0.obs;

  final String restaurantId;

  // State ร้านและรีวิว
  final Rx<Restaurant?> restaurant = Rx<Restaurant?>(null);
  final RxBool isDeleting = false.obs;
  final RxList<CommentModel> reviews = <CommentModel>[].obs; 
  final RxBool isLoadingReviews = false.obs;

  // Controller Report
  final TextEditingController reportReasonController = TextEditingController();

  // Constructor
  RestaurantDetailController({required this.restaurantId});

  @override
  void onInit() {
    super.onInit();
    _filterController = Get.find<FilterController>();
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

  // loadRestaurantDetails
  void loadRestaurantDetails() {
    final newRestaurantInstance = _filterController.allRestaurantsObservable
        .firstWhereOrNull(
          (res) => res.id == restaurantId,
        );

    restaurant.value = newRestaurantInstance; 

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

  // deleteRestaurant
  void deleteRestaurant() {
    if (restaurant.value == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบ: ไม่พบข้อมูลร้านค้า');
      return;
    }

    final String restaurantName =
        restaurant.value!.restaurantName;
    final String currentRestaurantId =
        restaurant.value!.id;

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
                Obx(() => ElevatedButton( // Wrap ElevatedButton in Obx to track isDeleting state
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isDeleting.value ? null : () async { // Disable button while deleting
                    isDeleting.value = true;
                    Get.back();
                    try {
                      await supabase
                          .from('restaurants')
                          .delete()
                          .eq('id', currentRestaurantId);

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
                  child: isDeleting.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text("ยืนยัน"),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // _loadReviews
  Future<void> _loadReviews() async {
    isLoadingReviews.value = true;
    try {
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
 		  ''')
          .eq('res_id', restaurantId)
          .order('created_at', ascending: false);

      reviews.assignAll(data.map((map) => CommentModel.fromMap(map)).toList());
    } catch (e) {
      print("Error loading reviews: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถโหลดรีวิวได้: ${e.toString()}');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  // submitReview
  void submitReview() async {
    if (loginController.isLoggedIn.value) {
      if (commentController.text.trim().isNotEmpty && userRating.value > 0) {
        final String currentUserId = loginController.userId.value;
        final String commentContent = commentController.text.trim();
        final int ratingScore = userRating.value.toInt();

        try {
          await supabase.from('comments').insert({
            'user_id': currentUserId,
            'res_id': restaurantId,
            'content': commentContent,
            'rating_score': ratingScore,
          });

          commentController.clear();
          userRating.value = 0.0;
          _loadReviews();
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

  // deleteComment
  void deleteComment(int commentId) async {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('ข้อผิดพลาด', 'กรุณาเข้าสู่ระบบ');
      return;
    }

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

  // launchMap
  Future<void> launchMap(double? lat, double? lng, String label) async {
    if (lat == null || lng == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่พบข้อมูลพิกัดสำหรับร้านนี้');
      return;
    }
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

  // showReportDialog (Comment)
  void showReportDialog(int commentId) {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเข้าสู่ระบบ...');
      return;
    }
    reportReasonController.clear();
    
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
      
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.75), 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.only(top: 0),
              child: Column(
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
                        controller: reportReasonController, 
                        maxLines: 2,
                        autofocus: true, 
                        decoration: const InputDecoration(
                          hintText: 'โปรดระบุเหตุผล...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      confirm: ElevatedButton(
        onPressed: () {
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
            finalReason, 
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

  // showReportRestaurantDialog (Restaurant)
  void showReportRestaurantDialog() {
    if (!loginController.isLoggedIn.value) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเข้าสู่ระบบ...');
      return;
    }
    reportReasonController.clear();
    
    String? selectedReason; 
    final String otherReasonKey = "อื่นๆ";
    final List<String> restaurantReportOptions = [
        "ข้อมูลร้านไม่ถูกต้อง (เช่น เบอร์, เวลาเปิด)", 
        "ร้านปิดถาวรแล้ว",
        "สแปม / โฆษณา",
        otherReasonKey
    ];

    Get.defaultDialog(
      title: 'แจ้งปัญหาร้านค้า', 
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.75), 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('โปรดเลือกเหตุผลในการแจ้งปัญหา:'),
                  ),
                  const SizedBox(height: 8),

                  // (RadioListTile map loop)
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
                  
                  // (TextField for "อื่นๆ")
                  if (selectedReason == otherReasonKey)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                      child: TextField(
                        controller: reportReasonController, 
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
              ),
            ),
          );
        },
      ),
      
      confirm: ElevatedButton(
        onPressed: () {
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
            finalReason, 
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

  // _submitReport
  Future<void> _submitReport(String reason, {int? commentId, String? resId}) async {
    final String currentUserId = loginController.userId.value;
    try {
      await supabase.from('complaints').insert({
        'reporter_id': currentUserId,
        'comment_id': commentId, 
        'res_id': resId, 
        'reason': reason, 
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
