// lib/app/model/my_request_status.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:intl/intl.dart'; // (ต้องมี package intl)

// Enum สำหรับแยกว่าเป็นคำร้องประเภทไหน
enum RequestType { restaurantEdit, complaint }
// Enum สำหรับสถานะ
enum RequestStatus { pending, approved, rejected }

class MyRequestStatus {
  final int id; // ID จากตาราง (edits หรือ complaints)
  final RequestType type;
  final RequestStatus status;
  final String title; // ชื่อเรื่อง (เช่น "คำขอเพิ่มร้าน", "รายงานคอมเมนต์")
  final String details; // รายละเอียด (เช่น "New Restaurant" หรือ เหตุผลการ report)
  final String? rejectionReason; // เหตุผลการปฏิเสธ (จาก edits)
  final DateTime createdAt;
  // Fields เพิ่มเติมสำหรับหน้า Resubmit
  final Map<String, dynamic>? proposedData; 
  final String? editType; 

  MyRequestStatus({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.details,
    this.rejectionReason,
    required this.createdAt,
    this.proposedData, 
    this.editType,     
  });

  // Factory สำหรับแปลงข้อมูลจากตาราง restaurant_edits
  factory MyRequestStatus.fromRestaurantEdit(Map<String, dynamic> map) {
    final String editTypeStr = map['edit_type'] ?? 'unknown';
    final String statusStr = map['status'] ?? 'pending';
    final proposedDataMap = map['proposed_data'] as Map<String, dynamic>? ?? {};
    
    // (ใช้ชื่อร้านจาก 'res_name_from_data' ที่เรา select มาใน Controller)
    final String resName = map['res_name_from_data'] ?? proposedDataMap['res_name'] ?? 'N/A';

    String title = 'คำขอแก้ไขข้อมูล';
    if (editTypeStr == 'new_restaurant') {
      title = 'คำขอเพิ่มร้านใหม่: $resName';
    } else if (editTypeStr == 'update_location') {
      title = 'คำขอแก้ไขตำแหน่งร้าน: $resName';
    }

    return MyRequestStatus(
      id: map['id'],
      type: RequestType.restaurantEdit,
      status: parseStatus(statusStr), // <<< เรียก public parseStatus
      title: title,
      details: 'ประเภท: $editTypeStr',
      rejectionReason: map['rejection_reason'],
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      proposedData: proposedDataMap, // <<< เก็บ proposed_data
      editType: editTypeStr,         // <<< เก็บ editType
    );
  }

  // Factory สำหรับแปลงข้อมูลจากตาราง complaints
  factory MyRequestStatus.fromComplaint(Map<String, dynamic> map) {
    final String statusStr = map['status'] ?? 'pending';
    
    // (ดึงข้อมูลที่ JOIN มาใน Controller)
    final resData = map['restaurants'] as Map<String, dynamic>?;
    final commentData = map['comments'] as Map<String, dynamic>?;
    final String reason = map['reason'] ?? 'ไม่มีรายละเอียด';

    String title = 'รายงานปัญหา';
    String details = 'เหตุผล: $reason';

    if (commentData != null) {
      title = 'รายงานคอมเมนต์';
      String content = commentData['content'] ?? '';
      if (content.length > 50) {
        content = '${content.substring(0, 50)}...';
      }
      details = 'เนื้อหา: "$content"\nเหตุผล: $reason';
    } else if (resData != null) {
      title = 'รายงานร้านค้า: ${resData['res_name'] ?? 'N/A'}';
      details = 'เหตุผล: $reason';
    }

    return MyRequestStatus(
      id: map['id'],
      type: RequestType.complaint,
      status: parseStatus(statusStr), // <<< เรียก public parseStatus
      title: title,
      details: details, // <<< ใช้ details ที่อัปเดตแล้ว
      rejectionReason: null, 
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      proposedData: null, 
      editType: null,     
    );
  }


  // Helper แปลง string status เป็น Enum (เปลี่ยนเป็น public)
  static RequestStatus parseStatus(String status) {
    if (status == 'approved') return RequestStatus.approved;
    if (status == 'rejected') return RequestStatus.rejected;
    return RequestStatus.pending;
  }

  // --- Helpers สำหรับ UI ---
  IconData get icon {
    return type == RequestType.restaurantEdit ? Icons.edit_note_rounded : Icons.flag_rounded;
  }

  Color get statusColor {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green.shade700;
      case RequestStatus.rejected:
        return Colors.red.shade700;
      case RequestStatus.pending:
        return Colors.orange.shade800;
    }
  }
  
  String get statusText {
      String text = status.toString().split('.').last;
      return text.capitalizeFirst ?? text;
  }
  
  String get formattedDate {
      return DateFormat('dd/MM/yyyy HH:mm').format(createdAt.toLocal());
  }
}