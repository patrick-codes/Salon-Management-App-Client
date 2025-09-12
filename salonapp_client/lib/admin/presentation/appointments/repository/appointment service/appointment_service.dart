import 'package:cloud_firestore/cloud_firestore.dart';
import '../data model/owner_appointment_model.dart';

class OwnerAppointmentServiceHelper {
  int? totalService;
  int? totalService2;
  List<OwnerAppointmentModel> appointmentList = [];

  final _db = FirebaseFirestore.instance;

  Future<void> createAppointment(OwnerAppointmentModel? appointment) async {
    try {
      await _db.collection("appointments").add(appointment!.toJson());
      print("appointment created sucessfully");
    } catch (error) {
      print(error);
    }
  }

  Future<List<OwnerAppointmentModel>?> fetchAllappointments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("appointments").get();
      final appointment = querySnapshot.docs
          .map((doc) => OwnerAppointmentModel.fromSnapshot(doc))
          .toList();
      print("Fetched ${appointment.length} appointment successfully");
      totalService = appointment.length;
      return appointment;
    } catch (error) {
      print("Error fetching appointment: $error");
      return [];
    }
  }

  Future<OwnerAppointmentModel?> fetchSingleAppointment(String? id) async {
    try {
      if (id == null) return null;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _db.collection("appointments").doc(id).get();
      if (documentSnapshot.exists) {
        final appointment =
            OwnerAppointmentModel.fromSnapshot(documentSnapshot);
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

  Future<List<OwnerAppointmentModel?>> myAppointments(String? userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection("appointments")
          .where("ownerID", isEqualTo: userId)
          .get();

      final appointment = querySnapshot.docs
          .map((doc) => OwnerAppointmentModel.fromSnapshot(doc))
          .toList();
      print("Fetched appointments for id: $userId successfully");
      return appointment;
    } catch (error) {
      print("Error fetching salonshop by id: $error");
      return [];
    }
  }

  Future<OwnerAppointmentModel?> deleteSingleAppointment(String? id) async {
    try {
      if (id == null) return null;

      final docRef = _db.collection("appointments").doc(id);
      final documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        final appointment =
            OwnerAppointmentModel.fromSnapshot(documentSnapshot);
        await docRef.delete();
        /////////
        print("Deleted appointment with id: $id successfully");
        return appointment;
      } else {
        print("No appointment found with id: $id");
        return null;
      }
    } catch (error) {
      print("Error deleting appointment by id: $error");
      return null;
    }
  }
}
