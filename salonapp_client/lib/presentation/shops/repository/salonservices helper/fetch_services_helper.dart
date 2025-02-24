import 'package:cloud_firestore/cloud_firestore.dart';

import '../data rmodel/service_model.dart';

class SalonServiceHelper {
  int? totalService;
  int? totalService2;

  final _db = FirebaseFirestore.instance;

  Future<void> createService(ShopModel shop) async {
    try {
      await _db.collection("salonshops").add(shop.toJson());
      print("salonshops created sucessfully");
    } catch (error) {
      print(error);
    }
  }

  Future<List<ShopModel>?> fetchAllSalonShops() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("salonshops").get();
      final salonShops =
          querySnapshot.docs.map((doc) => ShopModel.fromSnapshot(doc)).toList();
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
}
