import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  late String? appointmentId;
  late String? userId;
  late String? shopName;
  late String? category;
  late String? appointmentTime;
  late String? appointmentDate;
  late String? phone;
  late String? servicesType;

  AppointmentModel({
    this.appointmentId,
    this.userId,
    required this.shopName,
    required this.category,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.phone,
    required this.servicesType,
  });

  Map<String, dynamic> toJson() {
    return {
      "appointmentId": appointmentId,
      "ownerID": userId,
      "shopName": shopName,
      "category": category,
      "appointmentTime": appointmentTime,
      "appointmentDate": appointmentDate,
      "phone": phone,
      "servicesType": servicesType,
    };
  }

  AppointmentModel.defaultModel() {
    appointmentId = null;
    userId = "ownerID";
    shopName = "shopName";
    category = "category";
    appointmentTime = "appointmentTime";
    appointmentDate = "appointmentDate";
    phone = "phone";
    servicesType = "servicesType";
  }

  factory AppointmentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return AppointmentModel(
        appointmentId: document.id,
        userId: data["userId"] ?? '',
        shopName: data["shopName"] ?? '',
        category: data["category"] ?? '',
        appointmentTime: data["appointmentTime"] ?? '',
        appointmentDate: data["appointmentDate"] ?? '',
        phone: data["phone"] ?? '',
        servicesType: data["servicesType"] ?? '',
      );
    } else {
      print('Document not found for id: ${document.id}');
      return AppointmentModel.defaultModel();
    }
  }
}
