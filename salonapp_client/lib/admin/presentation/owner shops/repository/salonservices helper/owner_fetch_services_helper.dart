import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/image uploader/image_uploader.dart';
import '../data rmodel/h_shop_service_model.dart';
import '../data rmodel/service_model.dart';
import 'package:geodesy/geodesy.dart';

class OwnerSalonServiceHelper {
  int? totalService;
  int? totalService2;
  List<OwnerShopModel> shopList = [];

  final _db = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> uploadImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null; // nothing to upload
    }

    // Already a Cloudinary URL
    if (imagePath.startsWith("http")) {
      return imagePath;
    }

    // Local file → upload
    File file = File(imagePath);
    if (!file.existsSync()) {
      print(" File does not exist at path: $imagePath");
      return null;
    }

    final uploadedUrl = await CloudinaryHelper2.uploadImage(file);
    return uploadedUrl;
  }

  Future<void> createService(OwnerShopModel shop) async {
    try {
      // Handle profile image safely
      final profileImgUrl = await uploadImage(shop.profileImg);

      // Handle work images safely
      List<String> workImgUrls = [];
      if (shop.workImgs != null) {
        for (var img in shop.workImgs!) {
          final uploadedUrl = await uploadImage(img);
          if (uploadedUrl != null) {
            workImgUrls.add(uploadedUrl);
          }
        }
      }

      // Save only valid URLs
      final shopData = shop.toJson();
      shopData["profileImg"] = profileImgUrl ?? '';
      shopData["workImgs"] = workImgUrls;

      await _db.collection("salonshops").add(shopData);

      print(" Shop created successfully");
    } catch (e) {
      print("Failed to create shop: $e");
    }
  }

  Future<List<OwnerShopModel>> fetchAllSalonShops(
      double? userLatitude, double? userLongitude) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("salonshops").get();

      final List<OwnerShopModel> salonShops = [];

      for (var doc in querySnapshot.docs) {
        try {
          salonShops.add(OwnerShopModel.fromSnapshot(doc));
        } catch (e) {
          print("Skipping shop ${doc.id} due to parse error: $e");
        }
      }

      print("Fetched ${salonShops.length} valid salonShops successfully");

      // Filter nearby shops
      List<OwnerShopModel> nearbyShops = [];
      for (var shop in salonShops) {
        if (isShopNearby(shop, userLatitude, userLongitude)) {
          nearbyShops.add(shop);
        }
      }

      print("Nearby shops: ${nearbyShops.length}");
      return nearbyShops;
    } catch (error) {
      print("Error fetching salonShops: $error");
      return [];
    }
  }

  Future<List<OwnerShopModel>> fetchShopOwner(String name) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection("salonshops")
          .where("Category", isEqualTo: name)
          .get();
      final salonshops = querySnapshot.docs
          .map((doc) => OwnerShopModel.fromSnapshot(doc))
          .toList();
      print("Fetched ${salonshops.length} $name successfully");
      totalService2 = salonshops.length;
      return salonshops;
    } catch (error) {
      print("Error fetching $name: $error");
      return [];
    }
  }

  Future<OwnerShopModel?> fetchOwnerSalonShop(String ownerId) async {
    try {
      final querySnapshot = await _db
          .collection("salonshops")
          .where("ownerID", isEqualTo: ownerId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final salonShop = OwnerShopModel.fromSnapshot(querySnapshot.docs.first);
        print("Fetched salonshop for ownerId: $ownerId successfully");
        return salonShop;
      } else {
        print("No salonshop found for ownerId: $ownerId");
        return null;
      }
    } catch (error) {
      print("Error fetching salonshop by ownerId: $error");
      return null;
    }
  }

  Future<HomeShopModel?> fetchSingleHomeSalonshops(String? id) async {
    try {
      if (id == null) return null;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _db.collection("salonshops").doc(id).get();
      if (documentSnapshot.exists) {
        final salonshops = HomeShopModel.fromSnapshot(documentSnapshot);
        print("Fetched salonshop with id: $id successfully");
        return salonshops;
      } else {
        print("No salonshop found with id: $id");
        return null;
      }
    } catch (error) {
      print("Error fetching salonshop by id: $error");
      return null;
    }
  }

  static bool isShopNearby(
      OwnerShopModel shop, double? userLatitude, double? userLongitude) {
    if (shop.cordinates.length < 2) {
      debugPrint("Error: Shop coordinates are missing or incomplete.");
      return false;
    }

    try {
      final Geodesy geodesy = Geodesy();

      double? shopLatitude = shop.cordinates[0] is double
          ? shop.cordinates[0]
          : double.parse(shop.cordinates[0].toString());

      double? shopLongitude = shop.cordinates[1] is double
          ? shop.cordinates[1]
          : double.parse(shop.cordinates[1].toString());

      LatLng userLatLng = LatLng(userLatitude!, userLongitude!);
      LatLng shopLatLng = LatLng(shopLatitude!, shopLongitude!);

      num distanceNum =
          geodesy.distanceBetweenTwoGeoPoints(userLatLng, shopLatLng);

      double distanceInKm = (distanceNum as double) / 1000.0;
      shop.distanceToUser = distanceInKm;

      const double maxDistance = 10.0;
      debugPrint('Distance to ${shop.shopName}: $distanceInKm km');

      return distanceInKm <= maxDistance;
    } catch (e) {
      debugPrint("Error calculating distance: $e");
      return false;
    }
  }
}
