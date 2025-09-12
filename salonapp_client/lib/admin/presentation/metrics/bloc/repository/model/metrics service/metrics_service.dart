import 'package:cloud_firestore/cloud_firestore.dart';

class MetricsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> fetchSalonMetrics(String ownerId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('ownerID', isEqualTo: ownerId)
          .get();

      int totalOrders = 0;
      double totalRevenue = 0.0;
      Set<String> uniqueCustomers = {};
      Set<String> uniqueServices = {};

      for (var doc in snapshot.docs) {
        totalOrders += 1;

        // Revenue
        final amount = doc['amount'];
        if (amount is int) {
          totalRevenue += amount.toDouble();
        } else if (amount is double) {
          totalRevenue += amount;
        }

        // Customers
        if (doc.data().containsKey('userId')) {
          uniqueCustomers.add(doc['userId']);
        }

        // Services
        if (doc.data().containsKey('servicesType')) {
          uniqueServices.add(doc['servicesType']);
        }
      }

      return {
        'totalOrders': totalOrders,
        'totalRevenue': totalRevenue,
        'totalCustomers': uniqueCustomers.length,
        'totalServices': uniqueServices.length,
      };
    } catch (e) {
      print("Error fetching metrics: $e");
      return {
        'totalOrders': 0,
        'totalRevenue': 0.0,
        'totalCustomers': 0,
        'totalServices': 0,
      };
    }
  }
}
