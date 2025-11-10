// lib/app/ui/pages/home_page/widgets/home_location_FilterBar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/filter_ctrl.dart';
import 'home_localist.dart';

class HomeLocationFilterbar extends StatelessWidget {
  const HomeLocationFilterbar({super.key});

  @override
  Widget build(BuildContext context) {
    // final FilterController filterController = Get.find<FilterController>();
    final FilterController filterController = Get.find<FilterController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // <<< แสดงที่อยู่ปัจจุบัน และ ปุ่มยกเลิก (คงเดิม) >>>
          Obx(
            () {
              final isLocationSet = filterController.locationService.currentLocation.value != null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                child: Row(
                  children: [
                    // --- FIX: Wrap Text with Expanded ---
                    Expanded(
                      child: Text(
                        // แสดงสถานะ Loading หรือ ที่อยู่จริง
                        'ที่อยู๋: ${filterController.currentAddress}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2, // จำกัดให้แสดงสูงสุด 2 บรรทัด
                        overflow: TextOverflow.ellipsis, // ตัดข้อความถ้าล้น
                      ),
                    ),
                    // --- ปุ่มยกเลิกตำแหน่ง ---
                    if (isLocationSet)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // เรียกฟังก์ชัน clearLocation ใน LocationService
                            filterController.locationService.clearLocation(); 
                          },
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.red[400],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
          ),
          
          // --- [แก้ไข] ---
          
          // --- แถวที่ 1: จังหวัด, เขต ---
          Row(
            children: [
              // ใช้ Expanded เพื่อให้ Dropdown ยืด/หด ได้
              Expanded(
                flex: 4, 
                child: Obx(() => _buildProvinceDropdown(filterController)),
              ),
              const SizedBox(width: 8),
              // ใช้ Expanded เพื่อให้ Dropdown ยืด/หด ได้
              Expanded(
                flex: 5, 
                child: Obx(() => _buildDistrictDropdown(filterController)),
              ),
            ],
          ),

          const SizedBox(height: 8), // ระยะห่างระหว่างแถว

          // --- แถวที่ 2: ประเภท, สถานะ, GPS ---
          Row(
            children: [
              // Flexible สำหรับประเภทอาหาร
              Flexible(
                // --- [แก้ไข] ลด flex ลง ---
                flex: 3, 
                fit: FlexFit.tight, // <<<--- เปลี่ยนเป็น tight
                child: Obx(() => _buildCategoryDropdown(filterController)),
              ),
              const SizedBox(width: 8),
              // SizedBox ขนาดคงที่สำหรับสถานะ
              Flexible( // <<<--- เปลี่ยนเป็น Flexible
                // --- [แก้ไข] เพิ่ม flex ---
                flex: 2, 
                fit: FlexFit.tight, // <<<--- เปลี่ยนเป็น tight
                child: Obx(() => _buildOpenStatusDropdown(filterController)),
              ),
              const SizedBox(width: 8),
              _buildLocationButton(filterController), // <<<--- ย้ายปุ่ม GPS มาไว้ที่นี่
            ],
          ),
          // --- [สิ้นสุดการแก้ไข] ---
        ],
      ),
    );
  }

  Widget _buildProvinceDropdown(FilterController filterController) {
    // --- [เพิ่ม] ตรวจสอบว่าใช้ตำแหน่งหรือไม่ ---
    final bool isLocationActive = filterController.locationService.currentLocation.value != null;
    
    return _buildContainer(
      // --- [ลบ] SizedBox(width: 130) ที่ครอบอยู่ออก ---
      DropdownButton<String>(
        isExpanded: true,
        value: filterController.selectedProvince.value.isEmpty
            ? null
            : filterController.selectedProvince.value,
        hint: Text(
          isLocationActive ? '(ใช้ตำแหน่ง)' : 'เลือกจังหวัด',
          style: TextStyle(color: isLocationActive ? Colors.white54 : Colors.white),
          // --- [แก้ไข] เพิ่ม maxLines และ overflow ---
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // --- [สิ้นสุดการแก้ไข] ---
        ),
        dropdownColor: Colors.purple[200],
        iconEnabledColor: isLocationActive ? Colors.white54 : Colors.white,
        menuMaxHeight: 400,
        menuWidth: 200,
        style: const TextStyle(color: Colors.white),
        items: [
          const DropdownMenuItem<String>(
            value: '',
            child: Text('ทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
          ...Localist.provinces.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        ],
        onChanged: isLocationActive ? null : (newValue) {
          filterController.setSelectedProvince(newValue ?? '');
        },
      ),
      isDisabled: isLocationActive,
    );
  }

  Widget _buildDistrictDropdown(FilterController filterController) {
    final bool isLocationActive = filterController.locationService.currentLocation.value != null;
    
    final List<String> districts =
        Localist.districtsByProvince[filterController.selectedProvince.value] ??
        [];
    return _buildContainer(
      // --- [ลบ] SizedBox(width: 143) ที่ครอบอยู่ออก ---
      DropdownButton<String>(
        isExpanded: true,
        value: filterController.selectedDistrict.value.isEmpty
            ? null
            : filterController.selectedDistrict.value,
        hint: Text(
          isLocationActive ? '(ใช้ตำแหน่ง)' : 'เลือกเขต/อำเภอ',
          style: TextStyle(color: isLocationActive ? Colors.white54 : Colors.white),
          // --- [แก้ไข] เพิ่ม maxLines และ overflow ---
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // --- [สิ้นสุดการแก้ไข] ---
        ),
        dropdownColor: Colors.purple[200],
        iconEnabledColor: isLocationActive ? Colors.white54 : Colors.white,
        menuMaxHeight: 400,
        menuWidth: 200,
        style: const TextStyle(color: Colors.white),
        items: [
          const DropdownMenuItem<String>(
            value: '',
            child: Text('ทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
          ...districts.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        ],
        onChanged: isLocationActive ? null : (newValue) {
          filterController.setSelectedDistrict(newValue ?? '');
        },
      ),
      isDisabled: isLocationActive,
    );
  }

  Widget _buildCategoryDropdown(FilterController filterController) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[300]!, Colors.blue[300]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: filterController.selectedCategory.value.isEmpty
            ? null
            : filterController.selectedCategory.value,
        hint: const Text(
          // --- [แก้ไข] เปลี่ยนชื่อ Hint ให้สั้นลง ---
          'ประเภทอาหาร',
          style: TextStyle(color: Colors.white),
          // --- [แก้ไข] เพิ่ม maxLines และ overflow ---
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // --- [สิ้นสุดการแก้ไข] ---
        ),
        dropdownColor: Colors.purple[200],
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        menuMaxHeight: 400,
        menuWidth: 200,
        items: [
          const DropdownMenuItem<String>(
            value: '',
            child: Text('ทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
          ...Localist.foodTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        ],
        onChanged: (newValue) {
          filterController.setSelectedCategory(newValue ?? '');
        },
      ),
    );
  }

  Widget _buildOpenStatusDropdown(FilterController filterController) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[300]!, Colors.blue[300]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: filterController.openStatusFilter.value,
        hint: const Text('สถานะร้าน', style: TextStyle(color: Colors.white)),
        dropdownColor: Colors.purple[200],
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        menuMaxHeight: 200,
        menuWidth: 150,
        items: const [
          DropdownMenuItem<String>(
            value: 'all',
            child: Text('ทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem<String>(
            value: 'open',
            child: Text('เปิด', style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem<String>(
            value: 'closed',
            child: Text('ปิด', style: TextStyle(color: Colors.white)),
          ),
        ],
        onChanged: (newValue) {
          filterController.openStatusFilter.value = newValue ?? 'all';
        },
      ),
    );
  }

  Widget _buildLocationButton(FilterController filterController) {
    // <<<--- (คงเดิม)
    const double iconSize = 20.0;
    const double buttonPadding = 8.0;

    return Obx(
      () => Container(
        height: iconSize + buttonPadding * 2,
        width: iconSize + buttonPadding * 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[300]!, Colors.blue[300]!],
          ),
          borderRadius: BorderRadius.circular(
            (iconSize + buttonPadding * 2) / 2,
          ),
        ),
        child:
            filterController
                .isLoadingLocation
                .value // <<<--- แสดงสถานะ Loading
            ? const Center(
                child: SizedBox(
                  width: iconSize + 5,
                  height: iconSize + 5,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                ),
              )
            : IconButton(
                iconSize: iconSize,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                onPressed: () {
                  filterController
                      .fetchCurrentLocation(); // <<<--- เรียกใช้ฟังก์ชันดึงตำแหน่ง
                },
                icon: const Icon(Icons.my_location, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildContainer(Widget child, {bool isDisabled = false}) {
     // <<<--- (คงเดิม)
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // --- [แก้ไข] ถ้า Disable ให้เป็นสีเทา ---
          colors: isDisabled
              ? [Colors.grey.shade400, Colors.grey.shade500]
              : [Colors.pink[300]!, Colors.blue[300]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}