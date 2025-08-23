// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'shops_bloc.dart';

sealed class ShopsEvent {}

class CreateShopEvent extends ShopsEvent {
  String? shopId;
  final String shopOwnerId;
  final String shopName;
  final String category;
  final String openingDays;
  final String operningTimes;
  final String location;
  final String phone;
  final String whatsapp;
  final List<Service>? services;
  String? profileImg; // will be filled after upload
  final String dateJoined;
  List<String> workImgs = []; // will be filled after upload
  double distanceToUser = 0.0;
  List<double?> cordinates = []; // will be filled in Bloc
  bool isOpen;

  // NEW: raw files (optional)
  final File? profileImgFile;
  final List<File>? workImgFiles;

  CreateShopEvent({
    this.shopId,
    required this.shopOwnerId,
    required this.shopName,
    required this.category,
    required this.openingDays,
    required this.operningTimes,
    required this.location,
    required this.phone,
    required this.whatsapp,
    required this.services,
    required this.profileImg,
    required this.dateJoined,
    required this.isOpen,
    this.profileImgFile,
    this.workImgFiles,
  });
}

class PickProfileImageEvent extends ShopsEvent {}

class PickShopImageEvent extends ShopsEvent {}

class DeleteShopEvent extends ShopsEvent {
  final String message;
  DeleteShopEvent({
    required this.message,
  });
}

class ViewShopsEvent extends ShopsEvent {}

class ViewSingleShopEvent extends ShopsEvent {
  final String? id;

  ViewSingleShopEvent(this.id);
}

class SearchShopEvent extends ShopsEvent {
  final String query;

  SearchShopEvent({required this.query});
}
