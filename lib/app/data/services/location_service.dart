// lib/app/data/services/location_service.dart

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
// <<<--- FIX: เพิ่ม import FilterController
import '../../ui/global_widgets/filter_ctrl.dart';

class LocationService extends GetxService {
  final Rx<Position?> currentLocation = Rx<Position?>(null);
  final RxBool isLoadingLocation = false.obs;
  final RxString currentAddress =
      'กำลังค้นหาที่อยู่...'.obs; // <<<--- เพิ่มตัวแปรสำหรับเก็บที่อยู่

  Future<void> determinePosition() async {
    isLoadingLocation.value = true;
    currentAddress.value = 'กำลังดึงตำแหน่ง...'; // อัปเดตสถานะการโหลด
    bool serviceEnabled;
    LocationPermission permission;

    // 1. ตรวจสอบว่าเปิด GPS หรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'แจ้งเตือน',
        'กรุณาเปิด GPS/Location Service เพื่อใช้งานฟังก์ชันนี้',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      isLoadingLocation.value = false;
      currentAddress.value = 'ไม่สามารถดึงตำแหน่งได้';
      return;
    }

    // 2. ตรวจสอบและขอสิทธิ์
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'แจ้งเตือน',
          'ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง (Location Permission Denied)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        isLoadingLocation.value = false;
        currentAddress.value = 'ไม่ได้รับอนุญาต';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'แจ้งเตือน',
        'ไม่ได้รับอนุญาตให้เข้าถึงตำแหน่งอย่างถาวร กรุณาไปตั้งค่าในแอปพลิเคชัน',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      isLoadingLocation.value = false;
      currentAddress.value = 'ไม่ได้รับอนุญาตถาวร';
      return;
    }

    // 3. ดึงตำแหน่งปัจจุบันและแปลงเป็นที่อยู่
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation.value = position;

      // 3.1. ดำเนินการ Reverse Geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String displayAddress = 'ไม่พบรายละเอียดที่อยู่';

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // 3.2. สร้างที่อยู่ที่เป็นข้อความ
        displayAddress =
            '${place.name ?? ''}, '
                    '${place.street ?? ''} '
                    '${place.subLocality ?? place.locality ?? ''}, '
                    '${place.administrativeArea ?? ''} '
                    '${place.postalCode ?? ''}'
                .trim();

        // ลบเครื่องหมายวรรคตอนและช่องว่างที่ไม่จำเป็น
        displayAddress = displayAddress
            .replaceAll(RegExp(r', , '), ', ')
            .replaceAll(RegExp(r', $'), '')
            .trim();
      }

      currentAddress.value = displayAddress; // <<<--- บันทึกที่อยู่

      // 3.3. แสดง Snackbar ด้วยที่อยู่
      Get.snackbar(
        'อัปเดตตำแหน่งสำเร็จ',
        currentAddress.value, // <<<--- แสดงที่อยู่
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(milliseconds: 2000),
      );
    } catch (e) {
      currentAddress.value = 'เกิดข้อผิดพลาดในการดึงตำแหน่ง';
      Get.snackbar(
        'ข้อผิดพลาด',
        'ไม่สามารถดึงตำแหน่งได้: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // --- ฟังก์ชันใหม่: เคลียร์ตำแหน่ง ---
  void clearLocation() {
    currentLocation.value = null; // รีเซ็ต Position
    currentAddress.value = 'กำลังค้นหาที่อยู่...'; // รีเซ็ต Text
    
    // อัปเดต Filter ทันที เพื่อให้ร้านค้าถูกจัดเรียงตามชื่อแทนระยะทาง
    // <<<--- FIX: ต้อง Get.find<FilterController>() ที่นี่
    final FilterController filterController = Get.find<FilterController>(); 
    filterController.applyFilters();
    
    Get.snackbar(
      'ตำแหน่ง',
      'ยกเลิกการใช้ตำแหน่งปัจจุบันแล้ว',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }
}