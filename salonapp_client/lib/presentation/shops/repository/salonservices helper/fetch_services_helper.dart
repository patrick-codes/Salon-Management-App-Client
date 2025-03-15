import 'package:cloud_firestore/cloud_firestore.dart';
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

/*
  Future<List<ShopModel>?> fetchAllSalonShops(
      double userLatitude, double userLongitude) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("salonshops").get();
      final salonShops =
          querySnapshot.docs.map((doc) => ShopModel.fromSnapshot(doc)).toList();
      print("Fetched ${salonShops.length} salonShops successfully");

      // Check if the station is nearby based on user's coordinates
      if (isStationNearby(shop, userLongitude, userLatitude)) {
        shopList.add(station);
      }
      totalService = salonShops.length;
      return salonShops;
    } catch (error) {
      print("Error fetching salonShops: $error");
      return [];
    }
  }
*/
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

      print("Nearby shops: ${nearbyShops.length}");

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
    final Geodesy geodesy = Geodesy();

    LatLng userLatLng = LatLng(userLatitude!, userLongitude!);
    LatLng stationLatLng =
        LatLng(shop.cordinates[0] as double, shop.cordinates[1] as double);

    num distanceNum =
        geodesy.distanceBetweenTwoGeoPoints(userLatLng, stationLatLng);

    // Convert distance from meters to kilometers
    double distanceInKm = (distanceNum as double) / 1000.0;
    shop.distanceToUser = distanceInKm;

    const double maxDistance = 6.0; //6 Maximum distance in kilometers

    print('Distance $distanceInKm km');

    return distanceInKm <= maxDistance;
  }
}
