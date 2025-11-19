// lib.zip/app/model/notification_model.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      title: map['title'] as String? ?? 'การแจ้งเตือน',
      message: map['message'] as String? ?? 'ไม่มีข้อความ',
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy HH:mm').format(createdAt.toLocal());
  }
}