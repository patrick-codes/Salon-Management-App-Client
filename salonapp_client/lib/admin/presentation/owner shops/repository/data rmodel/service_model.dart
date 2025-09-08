// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerShopModel {
  late String? shopId;
  late String? shopOwnerId;
  late String? shopName;
  late String? category;
  late List<double?> cordinates;
  late String? openingDays;
  late String? operningTimes;
  late String? location;
  late String? phone;
  late String? whatsapp;
  late List<OwnerService>? services; // <-- FIXED
  late String? profileImg;
  late String? dateJoined;
  late List<String>? workImgs;
  late double distanceToUser;
  late bool isOpen;

  OwnerShopModel({
    this.shopId,
    this.shopOwnerId,
    required this.shopName,
    required this.category,
    required this.cordinates,
    required this.openingDays,
    required this.operningTimes,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.services,
    required this.profileImg,
    required this.dateJoined,
    required this.workImgs,
    required this.distanceToUser,
    required this.isOpen,
  });

  Map<String, dynamic> toJson() {
    return {
      "shopId": shopId,
      "ownerID": shopOwnerId,
      "shopName": shopName,
      "category": category,
      "cordinates": cordinates,
      "openingDays": openingDays,
      "operningTimes": operningTimes,
      "location": location,
      "phone": phone,
      "whatsapp": whatsapp,
      "service": services?.map((s) => s.toJson()).toList(),
      "profileImg": profileImg,
      "dateJoined": dateJoined,
      "workImgs": workImgs,
      "distanceToUser": distanceToUser,
      "isOpened": isOpen,
    };
  }

  factory OwnerShopModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return OwnerShopModel(
        shopId: document.id,
        shopOwnerId: data["ownerID"] ?? '',
        shopName: data["shopName"] ?? '',
        category: data["category"] ?? '',
        cordinates: data["cordinates"] != null
            ? List<double>.from(
                data["cordinates"].map((e) => (e as num).toDouble()))
            : [0.0, 0.0],
        openingDays: data["openingDays"] ?? '',
        operningTimes: data["operningTimes"] ?? '',
        location: data["location"] ?? '',
        phone: data["phone"] ?? '',
        whatsapp: data["whatsapp"] ?? '',
        services: data["service"] != null
            ? (data["service"] as List)
                .map((s) => OwnerService.fromJson(Map<String, dynamic>.from(s)))
                .toList()
            : [],
        profileImg: data["profileImg"] ?? '',
        dateJoined: data["dateJoined"] ?? '',
        workImgs:
            data["workImgs"] != null ? List<String>.from(data["workImgs"]) : [],
        distanceToUser:
            (data["distanceToUser"] ?? 0).toDouble(), // ensure double
        isOpen: data['isOpened'] ?? false,
      );
    } else {
      print('Document not found for id: ${document.id}');
      return OwnerShopModel.defaultModel();
    }
  }

  OwnerShopModel.defaultModel() {
    shopId = null;
    shopOwnerId = "ownerID";
    shopName = "shopName";
    category = "category";
    cordinates = [0.0, 0.0];
    openingDays = "openingDays";
    operningTimes = "operningTimes";
    location = "location";
    phone = "phone";
    whatsapp = "whatsapp";
    services = [];
    profileImg = "profileImg";
    dateJoined = "dateJoined";
    workImgs = [];
    distanceToUser = 0.0;
    isOpen = false;
  }
}

class OwnerService {
  final String name;
  final double price;

  OwnerService({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
    };
  }

  factory OwnerService.fromJson(Map<String, dynamic> json) {
    return OwnerService(
      name: json["name"] ?? '',
      price: (json["price"] ?? 0).toDouble(),
    );
  }
}
