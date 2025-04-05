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
        appointmentTime: data["appointmentTime"] ?? '',
        appointmentDate: data["appointmentDate"] ?? '',
        phone: data["phone"] ?? '',
        servicesType: data["servicesType"] ?? '',
        bookingCode: data["bookingCode"] ?? '',
      );
    } else {
      print('Document not found for id: ${document.id}');
      return AppointmentModel.defaultModel();
    }
  }
}
