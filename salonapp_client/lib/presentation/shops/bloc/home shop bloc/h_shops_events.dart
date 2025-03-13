part of 'h_shops_bloc.dart';

sealed class HomeShopsEvent {}

class CreateShopEvent extends HomeShopsEvent {
  String? shopId;
  final String shopOwnerId;
  final String shopName;
  final String category;
  final String openingDays;
  final String operningTimes;
  final String location;
  final String phone;
  final String whatsapp;
  final String services;
  final String profileImg;
  final String dateJoined;
  final List<String> workImgs = [];

  CreateShopEvent(
      {this.shopId,
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
      required this.dateJoined});
}

class DeleteShopEvent extends HomeShopsEvent {
  final String message;
  DeleteShopEvent({
    required this.message,
  });
}

class ViewHomeShopsEvent extends HomeShopsEvent {}

class ViewSingleShopEvent extends HomeShopsEvent {
  final String? id;

  ViewSingleShopEvent(this.id);
}

class SearchShopEvent extends HomeShopsEvent {
  final String query;

  SearchShopEvent({required this.query});
}
