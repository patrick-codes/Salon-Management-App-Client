// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'owner_shops_bloc.dart';

sealed class OwnerShopsEvent {}

class OwnerCreateShopEvent extends OwnerShopsEvent {
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

  OwnerCreateShopEvent({
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

class OwnerPickProfileImageEvent extends OwnerShopsEvent {}

class OwnerPickShopImageEvent extends OwnerShopsEvent {}

class OwnerDeleteShopEvent extends OwnerShopsEvent {
  final String message;
  OwnerDeleteShopEvent({
    required this.message,
  });
}

class ViewOwnerShopsEvent extends OwnerShopsEvent {}

class OwnerSearchShopEvent extends OwnerShopsEvent {
  final String query;

  OwnerSearchShopEvent({required this.query});
}

class FetchOwnerShopEvent extends OwnerShopsEvent {
  final String ownerId;
  FetchOwnerShopEvent({required this.ownerId});
}
