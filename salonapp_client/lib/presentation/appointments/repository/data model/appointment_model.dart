// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';

class AppointmentModel {
  late String? id;
  late double? amount;
  late String? userId;
  late String? shopName;
  late String? category;
  late TimeOfDay? appointmentTime;
  late DateTime? appointmentDate;
  late String? phone;
  late String? servicesType;
  late String? bookingCode;
  late String? imgUrl;

  AppointmentModel({
    this.id,
    this.amount,
    this.userId,
    this.shopName,
    this.category,
    this.appointmentTime,
    this.appointmentDate,
    this.phone,
    this.servicesType,
    this.bookingCode,
    this.imgUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "ownerID": userId,
      "shopName": shopName,
      "category": category,
      "appointmentTime": appointmentTime,
      "appointmentDate": appointmentDate,
      "phone": phone,
      "servicesType": servicesType,
      "bookingCode": bookingCode,
      "imgUrl": imgUrl,
    };
  }

  AppointmentModel.defaultModel() {
    id = null;
    amount = 0.0;
    userId = "ownerID";
    shopName = "shopName";
    category = "category";
    appointmentTime =
        Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
    appointmentDate = DateTime.now();
    phone = "phone";
    servicesType = "servicesType";
    bookingCode = "bookingCode";
    imgUrl = "imgUrl";
  }

  factory AppointmentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return AppointmentModel(
        id: document.id,
        amount: data["amount"] ?? 0.0,
        userId: data["userId"] ?? '',
        shopName: data["shopName"] ?? '',
        category: data["category"] ?? '',
        appointmentTime: parseTimeOfDay(data["appointmentTime"]),
        appointmentDate: (data["appointmentDate"] as Timestamp?)?.toDate(),
        phone: data["phone"] ?? '',
        servicesType: data["servicesType"] ?? '',
        bookingCode: data["bookingCode"] ?? '',
        imgUrl: data["imgUrl"] ?? '',
      );
    } else {
      print('Document not found for id: ${document.id}');
      return AppointmentModel.defaultModel();
    }
  }
}

TimeOfDay? parseTimeOfDay(dynamic value) {
  if (value == null || value is! String) return null;
  final parts = value.split(":");
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return TimeOfDay(hour: hour, minute: minute);
}
