import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data rmodel/h_shop_service_model.dart';
import '../data rmodel/service_model.dart';
import 'package:geodesy/geodesy.dart';

class SalonServiceHelper {
  int? totalService;
  int? totalService2;
  List<ShopModel> shopList = [];

  final _db = FirebaseFirestore.instance;

  Future<void> createService(ShopModel shop) async {
    try {
      await _db.collection("salonshops").add(shop.toJson());
      print("salonshops created sucessfully");
    } catch (error) {
      print(error);
    }
  }

  Future<List<ShopModel>> fetchAllSalonShops(
      double? userLatitude, double? userLongitude) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("salonshops").get();
      final List<ShopModel> salonShops =
          querySnapshot.docs.map((doc) => ShopModel.fromSnapshot(doc)).toList();

      print("Fetched ${salonShops.length} salonShops successfully");

      List<ShopModel> nearbyShops = [];
      for (var shop in salonShops) {
        if (isShopNearby(shop, userLatitude, userLongitude)) {
          nearbyShops.add(shop);
        }
      }

      print("   Nearby shops: ${nearbyShops.length}");

      return nearbyShops;
    } catch (error) {
      print("Error fetching salonShops: $error");
      return [];
    }
  }

  Future<List<HomeShopModel>?> fetchHomeSalonShops() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("salonshops").get();
      final salonShops = querySnapshot.docs
          .map((doc) => HomeShopModel.fromSnapshot(doc))
          .toList();
      print("Fetched ${salonShops.length} salonShops successfully");
      totalService = salonShops.length;
      return salonShops;
    } catch (error) {
      print("Error fetching salonShops: $error");
      return [];
    }
  }

  Future<List<ShopModel>> fetchShopOwner(String name) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection("salonshops")
          .where("Category", isEqualTo: name)
          .get();
      final salonshops =
          querySnapshot.docs.map((doc) => ShopModel.fromSnapshot(doc)).toList();
      print("Fetched ${salonshops.length} $name successfully");
      totalService2 = salonshops.length;
      return salonshops;
    } catch (error) {
      print("Error fetching $name: $error");
      return [];
    }
  }

  Future<ShopModel?> fetchSinglesalonshops(String? id) async {
    try {
      if (id == null) return null;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _db.collection("salonshops").doc(id).get();
      if (documentSnapshot.exists) {
        final salonshops = ShopModel.fromSnapshot(documentSnapshot);
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
      ShopModel shop, double? userLatitude, double? userLongitude) {
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

  Future<List<HomeShopModel>> fetchFilteredSalonShops({
    String? query,
    String? category,
    String? location,
    String? service,
    double? userLatitude,
    double? userLongitude,
  }) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _db.collection("salonshops");

      // Apply Firestore filters
      if (category != null && category.isNotEmpty) {
        firestoreQuery = firestoreQuery.where("category", isEqualTo: category);
      }

      if (location != null && location.isNotEmpty) {
        firestoreQuery = firestoreQuery.where("location", isEqualTo: location);
      }

      // 🔑 If "services" is a list field → use arrayContains
      if (service != null && service.isNotEmpty) {
        firestoreQuery =
            firestoreQuery.where("services", arrayContains: service);
      }

      final snapshot = await firestoreQuery.get();
      List<HomeShopModel> shops =
          snapshot.docs.map((doc) => HomeShopModel.fromSnapshot(doc)).toList();

      // Text search (shopName)
      if (query != null && query.isNotEmpty) {
        shops = shops
            .where((shop) =>
                shop.shopName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Nearby filter
      if (userLatitude != null && userLongitude != null) {
        shops = shops
            .where((shop) => isShopNearby(
                  ShopModel.fromSnapshot(
                      snapshot.docs.firstWhere((d) => d.id == shop.shopId)),
                  userLatitude,
                  userLongitude,
                ))
            .toList();
      }

      print("Fetched ${shops.length} shops with filters applied");
      return shops;
    } catch (e) {
      print("Error in fetchFilteredSalonShops: $e");
      return [];
    }
  }
}
