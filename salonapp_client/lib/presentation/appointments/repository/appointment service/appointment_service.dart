import 'package:cloud_firestore/cloud_firestore.dart';
import '../data model/appointment_model.dart';

class SalonServiceHelper {
  int? totalService;
  int? totalService2;
  List<AppointmentModel> shopList = [];

  final _db = FirebaseFirestore.instance;

  Future<void> createAppointment(AppointmentModel shop) async {
    try {
      await _db.collection("appointment").add(shop.toJson());
      print("appointment created sucessfully");
    } catch (error) {
      print(error);
    }
  }

  Future<List<AppointmentModel>?> fetchAllappointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("appointment").get();
      final appointment = querySnapshot.docs
          .map((doc) => AppointmentModel.fromSnapshot(doc))
          .toList();
      print("Fetched ${appointment.length} appointment successfully");
      totalService = appointment.length;
      return appointment;
    } catch (error) {
      print("Error fetching appointment: $error");
      return [];
    }
  }

  Future<AppointmentModel?> fetchSingleAppointment(String? id) async {
    try {
      if (id == null) return null;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _db.collection("appointment").doc(id).get();
      if (documentSnapshot.exists) {
        final appointment = AppointmentModel.fromSnapshot(documentSnapshot);
        print("Fetched salonshop with id: $id successfully");
        return appointment;
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
