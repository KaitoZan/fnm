// lib/app/ui/pages/restaurant_detail_page/restaurant_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/filter_ctrl.dart';
import '../../../model/restaurant.dart';
import '../login_page/login_controller.dart';

class CommentModel {
  final int id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String userName;
  final String? userAvatarUrl;

  CommentModel({
    required this.id,
    required this.userId,
    required this.content,
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
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
      userName: profileData?['user_name'] as String? ?? 'ผู้ใช้',
      userAvatarUrl: profileData?['avatar_url'] as String?,
    );
  }
}

class RestaurantDetailController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  late final FilterController _filterController;
  final supabase = Supabase.instance.client;

  final String restaurantId;

  // --- State ---
  final Rx<Restaurant?> restaurant = Rx<Restaurant?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoadingComments = false.obs;
  final RxBool isDeleting = false.obs;

  // --- Rating State ---
  final RxDouble myRating = 0.0.obs;
  final RxBool isRatingLoading = false.obs;

  // --- Input Controllers ---
  final TextEditingController commentController = TextEditingController();
  final TextEditingController reportReasonController = TextEditingController();

  RestaurantDetailController({required this.restaurantId});

  @override
  void onInit() {
    super.onInit();
    _filterController = Get.find<FilterController>();
    loadRestaurantDetails();
    loadComments();
    loadMyRating();
  }

  @override
  void onClose() {
    commentController.dispose();
    reportReasonController.dispose();
    super.onClose();
  }

  void restore() {
    loadRestaurantDetails();
    loadComments();
    loadMyRating();
  }

  void loadRestaurantDetails() {
    final newRestaurantInstance = _filterController.allRestaurantsObservable
        .firstWhereOrNull((res) => res.id == restaurantId);
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

  // --- ส่วนจัดการ Rating (ใช้ตาราง user_ratings_res) ---
  
  Future<void> loadMyRating() async {
    if (!loginController.isLoggedIn.value) {
      myRating.value = 0.0;
      return;
    }
    try {
      // [แก้ไข] ใช้ตาราง user_ratings_res
      final data = await supabase
          .from('user_ratings_res') 
          .select('rating')
          .eq('user_id', loginController.userId.value)
          .eq('res_id', restaurantId)
          .maybeSingle();

      if (data != null) {
        myRating.value = (data['rating'] as num).toDouble();
      } else {
        myRating.value = 0.0;
      }
    } catch (e) {
      print("Error loading my rating: $e");
    }
  }

  Future<void> submitRating(double rating) async {
    if (!loginController.isLoggedIn.value) {
      Get.toNamed(AppRoutes.LOGIN);
      return;
    }

    if (rating < 1) return;

    isRatingLoading.value = true;
    try {
      // [แก้ไข] ใช้ตาราง user_ratings_res
      await supabase.from('user_ratings_res').upsert({
        'user_id': loginController.userId.value,
        'res_id': restaurantId,
        'rating': rating.toInt(),
      }, onConflict: 'user_id, res_id');

      myRating.value = rating;
      
      final updatedRes = await supabase.from('restaurants').select().eq('id', restaurantId).single();
      if (restaurant.value != null && updatedRes != null) {
         restaurant.value = restaurant.value!.copyWith(
           rating: (updatedRes['rating'] as num?)?.toDouble() ?? restaurant.value!.rating
         );
      }

      Get.snackbar('สำเร็จ', 'บันทึกคะแนนของคุณแล้ว',
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.green.withOpacity(0.8), colorText: Colors.white, duration: const Duration(milliseconds: 800));

    } catch (e) {
      print("Error submitting rating: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถบันทึกคะแนนได้');
    } finally {
      isRatingLoading.value = false;
    }
  }

  // --- ส่วนจัดการ Comments (ยังใช้ตาราง comments เหมือนเดิม) ---

  Future<void> loadComments() async {
    isLoadingComments.value = true;
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('comments')
          .select('''
            id, 
            user_id, 
            content, 
            created_at, 
            user_profiles(user_name, avatar_url)
          ''')
          .eq('res_id', restaurantId)
          .order('created_at', ascending: false);

      comments.assignAll(data.map((map) => CommentModel.fromMap(map)).toList());
    } catch (e) {
      print("Error loading comments: $e");
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถโหลดข้อความได้: ${e.toString()}');
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> submitComment() async {
    if (!loginController.isLoggedIn.value) {
        Get.defaultDialog(
        title: 'แจ้งเตือน',
        middleText: 'กรุณาเข้าสู่ระบบก่อนทำการคอมเมนต์',
        textConfirm: 'ตกลง',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          Get.offAllNamed(AppRoutes.LOGIN);
        },
        textCancel: 'ยกเลิก',
        onCancel: () {},
      );
       return;
    }
    
    final text = commentController.text.trim();
    if (text.isEmpty) {
        Get.snackbar(
          'ข้อผิดพลาด',
          'โปรดเขียนข้อความก่อนส่ง',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black.withOpacity(0.1),
          colorText: Colors.black,
          duration: const Duration(milliseconds: 900),
        );
        return;
    }

    try {
      await supabase.from('comments').insert({
        'user_id': loginController.userId.value,
        'res_id': restaurantId,
        'content': text,
      });

      commentController.clear();
      await loadComments(); 
      
    } catch (e) {
      print("Error submitting comment: $e");
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถส่งข้อความได้: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void deleteComment(int id) async {
    if (!loginController.isLoggedIn.value) return;

     Get.defaultDialog(
      title: "ยืนยันการลบ",
      middleText: "คุณต้องการลบข้อความนี้ใช่ไหม?",
      textConfirm: "ลบ",
      textCancel: "ยกเลิก",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        try {
          await supabase.from('comments').delete().eq('id', id);
          
          Get.snackbar(
            'สำเร็จ',
            'ลบข้อความเรียบร้อยแล้ว',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.1),
            colorText: Colors.black,
            duration: const Duration(milliseconds: 900),
          );

          loadComments();
        } catch (e) {
            print("Error deleting comment: $e");
          Get.snackbar('ข้อผิดพลาด', 'ลบไม่สำเร็จ: ${e.toString()}');
        }
      }
    );
  }

  // --- Other Functions ---
  
  void deleteRestaurant() {
    if (restaurant.value == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบ: ไม่พบข้อมูลร้านค้า');
      return;
    }

    final String restaurantName = restaurant.value!.restaurantName;
    final String currentRestaurantId = restaurant.value!.id;

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
                Obx(() => ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isDeleting.value ? null : () async { 
                    isDeleting.value = true;
                    Get.back();
                    try {
                      await supabase
                          .from('restaurants')
                          .delete()
                          .eq('id', currentRestaurantId);

                      _filterController.removeRestaurantFromList(restaurantId);

                      Get.back();
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
  
  Future<void> launchMap(double? lat, double? lng, String label) async {
    if (lat == null || lng == null) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่พบข้อมูลพิกัดสำหรับร้านนี้');
      return;
    }
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
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
          
          Get.back(); 
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
          
          Get.back(); 
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
}