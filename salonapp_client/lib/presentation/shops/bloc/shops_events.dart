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
