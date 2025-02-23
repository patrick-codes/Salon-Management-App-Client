// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  late String? fullname;
  late String? email;
  late String? phone;
  late String? password;
  late String? profilePhoto;
  UserModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePhoto': profilePhoto,
    };
  }

  UserModel.defaultModel() {
    // Set default values for the fields
    id = null;
    fullname = 'Default fullname';
    email = 'default@example.com';
    phone = '233################';
    password = 'Default Password';
    profilePhoto = 'profilePhoto';
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      fullname: map['fullname'],
      profilePhoto: map['photoUrl'],
      phone: map['phone'],
      password: map['password'],
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return UserModel(
        id: data['id'],
        fullname: data['fullname'],
        email: data['email'],
        phone: data['phone'],
        password: data['password'],
        profilePhoto: data['profilePhoto'],
      );
    } else {
      print('Document not found for id: ${document.id}');
      return UserModel.defaultModel();
    }
  }
}
