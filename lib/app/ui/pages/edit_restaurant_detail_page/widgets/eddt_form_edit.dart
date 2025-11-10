// lib/app/ui/pages/edit_restaurant_detail_page/widgets/eddt_form_edit.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/widgets/detail_menu_ctrl.dart';

// (Import Controller ที่เกี่ยวข้อง - ไม่จำเป็นต้องใช้แล้ว)
// import '../edit_restaurant_detail_controller.dart'; 

// Import BannerType จากแหล่งกำเนิด
import '../edit_restaurant_detail_controller.dart' show BannerType;


class EddtFormEdit extends StatelessWidget {
  final String restaurantId;
  // --- 1. เพิ่ม Field นี้เพื่อรับ Controller ---
  final dynamic controller; 

  const EddtFormEdit({
    super.key, 
    required this.restaurantId,
    required this.controller, // <<<--- 2. เพิ่มใน Constructor
  });

  @override
  Widget build(BuildContext context) {
    // 3. ลบ Get.find() บรรทัดนี้ทิ้ง
    // final RestaurantEditDetailController controller =
    //     Get.find<RestaurantEditDetailController>(tag: restaurantId); 
    
    // (โค้ดส่วนที่เหลือใน Column ... เหมือนเดิมทุกประการ)
    return Column(
      children: [
        _buildCoverImagePicker(
           label: 'รูปหน้าปก',
           controller: controller,
        ),
        _buildTextFieldWithLabel(
          'ชื่อร้าน',
          controller.restaurantNameController,
        ),
        _buildTextFieldWithLabel(
          'คำอธิบาย (หน้าแรก)',
          controller.descriptionController,
          maxLines: 5,
        ),
        _buildTextFieldWithLabel(
          'รายละเอียดร้าน (ข้อมูลภายใน)',
          controller.detailController,
          maxLines: 5,
        ),
         _buildTextFieldWithLabel(
           'Latitude',
           controller.latitudeController,
           keyboardType: TextInputType.numberWithOptions(decimal: true),
         ),
         _buildTextFieldWithLabel(
           'Longitude',
           controller.longitudeController,
           keyboardType: TextInputType.numberWithOptions(decimal: true),
         ),
        _buildTextFieldWithLabel(
          'เวลาเปิด-ปิด',
          controller.openingHoursController,
        ),
        _buildTextFieldWithLabel(
          'เบอร์โทรศัพท์',
          controller.phoneNumberController,
        ),
        _buildTextFieldWithLabel(
          'ที่ตั้ง (ข้อความ)',
          controller.locationController,
          maxLines: 3,
        ),
        _buildImagePicker(
          label: 'รูปเมนู',
          imageList: controller.menuImageUrlsOrPaths,
          onAdd: () => controller.addMenuImages(),
          onRemove: (index) => controller.removeMenuImage(index),
        ),
        Text(
          'จัดการโปรโมชั่น',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: RadioListTile<BannerType>(
                  title: const Text('รูปภาพ'),
                  value: BannerType.image,
                  groupValue: controller.selectedBannerType.value, 
                  onChanged: (value) =>
                      controller.setBannerType(value!),
                ),
              ),
              Expanded(
                child: RadioListTile<BannerType>(
                  title: const Text('ข้อความ'),
                  value: BannerType.text,
                  groupValue: controller.selectedBannerType.value, 
                  onChanged: (value) =>
                      controller.setBannerType(value!),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.selectedBannerType.value == 
              BannerType.image) {
            return _buildImagePicker(
              label: 'รูปโปรโมชั่น',
              imageList: controller.bannerImageUrlsOrPaths, 
              onAdd: () => controller.addPromotion(),
              onRemove: (index) =>
                  controller.removeBannerImage(index),
            );
          } else {
            return _buildBannerTextEditor(
              label: 'ข้อความโปรโมชั่น',
              controller: controller, 
            );
          }
        }),
        const Divider(height: 30, thickness: 1),
        _buildTextFieldWithLabel(
          'ประเภทอาหาร (ข้อความเดียว)',
          controller.typeController, 
        ),
      ],
    );
  }
}

// --- (Helper Widgets: _build... ทั้งหมดด้านล่าง ไม่ต้องแก้ไข) ---
// (เพราะมันใช้ 'dynamic controller' อยู่แล้ว)
// ...
Widget _buildCoverImagePicker({
   required String label,
   required dynamic controller, 
}) {
   return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
           final imageUrlOrPath = controller.coverImageUrlOrPath.value;
           Widget imagePreview;
           bool hasImage = imageUrlOrPath.isNotEmpty;
           if (!hasImage) {
              imagePreview = Container(
                 height: 150,
                 decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade400),
                 ),
                 child: const Center(child: Icon(Icons.image_not_supported, color: Color.fromRGBO(158, 158, 158, 1), size: 40)),
              );
           } else if (imageUrlOrPath.startsWith('http')) {
              imagePreview = DetailMenuCtrl(imageUrl: imageUrlOrPath, fit: BoxFit.cover);
           } else if (File(imageUrlOrPath).existsSync()) {
              imagePreview = Image.file(File(imageUrlOrPath), fit: BoxFit.cover);
           } else {
               imagePreview = Container(
                 height: 150,
                 color: Colors.grey[200],
                 child: const Center(child: Icon(Icons.error_outline, color: Colors.red)),
              );
           }
           return GestureDetector(
             onTap: () => controller.pickCoverImage(),
             child: Stack(
                alignment: Alignment.center,
                children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: imagePreview
                        ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                    if (hasImage)
                        Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                                onTap: () => controller.removeCoverImage(),
                                child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                            ),
                        ),
                ],
             ),
           );
        }),
      ],
    ),
   );
}


Widget _buildTextFieldWithLabel(
  String label,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: 'กรอก $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
        ),
      ],
    ),
  );
}


Widget _buildImagePicker({
  required String label,
  required RxList<String> imageList,
  required VoidCallback onAdd,
  required Function(int) onRemove,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
           padding: const EdgeInsets.all(8.0),
           decoration: BoxDecoration(
             color: Colors.grey[100],
             borderRadius: BorderRadius.circular(8.0),
           ),
           height: 120,
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  if (imageList.isEmpty) {
                    return const Center(
                          child: Text( 'ยังไม่มีรูปภาพ', style: TextStyle(color: Colors.grey) ),
                        );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      final imageUrlOrPath = imageList[index];
                      Widget imageWidget;
                      if (imageUrlOrPath.startsWith('http')) {
                        imageWidget = DetailMenuCtrl(imageUrl: imageUrlOrPath, fit: BoxFit.cover);
                      } else if (File(imageUrlOrPath).existsSync()) {
                        imageWidget = Image.file(File(imageUrlOrPath), fit: BoxFit.cover);
                      } else {
                         imageWidget = Container(color: Colors.grey[200], child: const Icon(Icons.broken_image));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox( width: 100, height: 100, child: imageWidget ),
                            ),
                            InkWell(
                                onTap: () => onRemove(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration( color: Colors.red, shape: BoxShape.circle ),
                                  child: const Icon( Icons.close, color: Colors.white, size: 14 ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onAdd,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all( color: Colors.grey.shade400, style: BorderStyle.solid ),
                  ),
                  child: const Icon( Icons.add_a_photo_outlined, color: Color.fromRGBO(158, 158, 158, 1), size: 40 ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildBannerTextEditor({
  required String label,
  required dynamic controller, 
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => controller.addBannerField(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Obx(() {
            if (controller.bannerTextControllers.isEmpty) {
              return const SizedBox(
                height: 50,
                child: Center(
                  child: Text( 'กด "+" เพื่อเพิ่มข้อความโปรโมชั่น', style: TextStyle(color: Colors.grey) ),
                ),
              );
            }
            return Column(
              children: controller.bannerTextControllers.map<Widget>((textController) { 
                final index = controller.bannerTextControllers.indexOf( textController );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: 'โปรโมชั่นที่ ${index + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric( horizontal: 16.0, vertical: 12.0 ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon( Icons.remove_circle, color: Colors.red ),
                        onPressed: () => controller.removeBannerField(index),
                      ),
                    ],
                  ),
                );
              }).toList(), 
            );
          }),
        ),
      ],
    ),
  );
}