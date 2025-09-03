// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel {
  String? id;
  late String? fullname;
  late String? email;
  late String? phone;
  late String? password;
  late String? profilePhoto;
  late DateTime? createdAt;
  UserModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePhoto,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePhoto': profilePhoto,
      'createdAt': FieldValue.serverTimestamp(),
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
    createdAt = DateTime.now();
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      fullname: map['fullname'],
      profilePhoto: map['photoUrl'],
      phone: map['phone'],
      password: map['password'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data()!;
      return UserModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        fullname: data['fullname'],
        email: data['email'],
        phone: data['phone'],
        password: data['password'],
        profilePhoto: data['profilePhoto'],
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      );
    } else {
      print('Document not found for id: ${document.id}');
      return UserModel.defaultModel();
    }
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception('User data is null');

    return UserModel(
      id: data['id'] ?? snapshot.id,
      fullname: data['fullname'] ?? 'Unknown',
      email: data['email'] ?? '',
      phone: data['phone'],
      password: data['password'],
      profilePhoto: data['profilePhoto'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      phone: null,
      fullname: 'Guest',
      password: '',
      profilePhoto: '',
    );
  }

  static Future<UserModel> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return UserModel.empty();
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      final createdAt = (data?['createdAt'] as Timestamp?)?.toDate();

      debugPrint("Member since: ${DateFormat.yMMMMd().format(createdAt!)}");

      if (doc.exists) {
        return UserModel.fromFirestore(doc, null);
      }
      return UserModel.empty();
    } catch (e) {
      print('Error fetching user: $e');
      return UserModel.empty();
    }
  }
}
