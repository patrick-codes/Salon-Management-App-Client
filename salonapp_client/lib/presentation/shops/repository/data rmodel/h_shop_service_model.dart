import 'package:cloud_firestore/cloud_firestore.dart';

class HomeShopModel {
  late String? shopId;
  late String? shopOwnerId;
  late String? shopName;
  late String? category;

  //late int? ratings;
  late String? openingDays;
  late String? operningTimes;
  late String? location;
  late String? phone;
  late String? whatsapp;
  late String? services;
  late String? profileImg;
  late String? dateJoined;
  late List<String>? workImgs;
  late bool? isOpened;
  late double distanceToUser;
  late List<double?> cordinates;

  HomeShopModel({
    this.shopId,
    this.shopOwnerId,
    required this.shopName,
    required this.category,
    required this.openingDays,
    required this.operningTimes,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.services,
    required this.profileImg,
    required this.dateJoined,
    required this.workImgs,
    this.isOpened,
    required this.distanceToUser,
    required this.cordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      "shopId": shopId,
      "ownerID": shopOwnerId,
      "shopName": shopName,
      "category": category,
      "openingDays": openingDays,
      "operningTimes": operningTimes,
      "location": location,
      "phone": phone,
      "whatsapp": whatsapp,
      "services": services,
      "profileImg": profileImg,
      "dateJoined": dateJoined,
      "workImgs": workImgs,
      "isOpened": isOpened,
      "distanceToUser": distanceToUser,
      "cordinates": List<dynamic>.from(cordinates.map((x) => x)),
    };
  }

  HomeShopModel.defaultModel() {
    /// shopId = null;
    shopOwnerId = "ownerID";
    shopName = "shopName";
    category = "category";
    openingDays = "openingDays";
    operningTimes = "operningTimes";
    location = "location";
    phone = "phone";
    whatsapp = "whatsapp";
    services = "services";
    profileImg = "profileImg";
    dateJoined = "dateJoined";
    workImgs = [];
    isOpened = true;
    cordinates = [];
  }

  factory HomeShopModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return HomeShopModel(
        shopId: document.id,
        shopOwnerId: data["shopOwnerId"] ?? '',
        shopName: data["shopName"] ?? '',
        category: data["category"] ?? '',
        openingDays: data["openingDays"] ?? '',
        operningTimes: data["operningTimes"] ?? '',
        location: data["location"] ?? '',
        phone: data["phone"] ?? '',
        whatsapp: data["whatsapp"] ?? '',
        services: data["services"] ?? '',
        profileImg: data["profileImg"] ?? '',
        dateJoined: data["dateJoined"] ?? '',
        workImgs:
            data["workImgs"] != null ? List<String>.from(data["workImgs"]) : [],
        isOpened: data["isOpened"] ?? false,
        cordinates: data["cordinates"] != null
            ? List<double>.from(data["cordinates"].map((x) => x.toDouble()))
            : [],
        distanceToUser: data["distanceToUser"] ?? 0,
      );
    } else {
      print('Document not found for id: ${document.id}');
      return HomeShopModel.defaultModel();
    }
  }
}
