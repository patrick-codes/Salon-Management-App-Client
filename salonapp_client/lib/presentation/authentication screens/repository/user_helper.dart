import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data model/user_model.dart';

class UserHelper {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final firebaseUser = FirebaseAuth.instance.currentUser;

  Future<void> createUserDb(UserModel user) async {
    try {
      final userId = firebaseUser!.uid;
      await _db.collection("users").doc(userId).set(user.toJson());
      print("Account created successfully");
    } catch (error) {
      print("Error creating user in Firestore: $error");
    }
  }

  Future<UserModel?> getUserDetails(String email) async {
    try {
      final snapshot =
          await _db.collection("users").where("email", isEqualTo: email).get();
      print(snapshot);
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching user details: $error');
      rethrow;
    }
  }

  Future<UserModel?> getUserDetails2(String id) async {
    try {
      final snapshot =
          await _db.collection("users").where("id", isEqualTo: id).get();
      print(snapshot);
      print("ID from Post Page $id");
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching user details: $error');
      rethrow;
    }
  }

  Future<List<UserModel>> fetchUser(String? name) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("users").where("id", isEqualTo: name).get();
      final serviceman =
          querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
      print("Fetched ${serviceman.length} $name successfully");
      //totalService2 = serviceman.length;
      return serviceman;
    } catch (error) {
      print("Error fetching $name: $error");
      return [];
    }
  }

  // Get the current user's ID
  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }
}
