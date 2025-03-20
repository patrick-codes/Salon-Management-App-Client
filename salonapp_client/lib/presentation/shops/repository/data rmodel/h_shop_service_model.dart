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
        // ratings: data["Ratings"] is int
        //     ? data["Ratings"]
        //     : int.tryParse(data["Ratings"].toString()) ?? 0,
      );
    } else {
      print('Document not found for id: ${document.id}');
      return HomeShopModel.defaultModel();
    }
  }
}
