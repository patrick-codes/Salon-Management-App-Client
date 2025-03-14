part of 'h_shops_bloc.dart';

sealed class HomeShopsState {}

class HomeShopInitial extends HomeShopsState {}

class ShopsLoadingState extends HomeShopsState {}

class ShopsFetchedState extends HomeShopsState {
  List<HomeShopModel>? shop;

  ShopsFetchedState({required this.shop});
}

class SingleShopsFetchedState extends HomeShopsState {
  HomeShopModel? shop;

  SingleShopsFetchedState({required this.shop});
}

class ShopsFetchFailureState extends HomeShopsState {
  final String errorMessage;

  ShopsFetchFailureState({required this.errorMessage});
}

class ShopCreatedSuccesState extends HomeShopsState {
  final String message;

  ShopCreatedSuccesState({
    required this.message,
  });
}

class ShopCreateFailureState extends HomeShopsState {
  final String error;

  ShopCreateFailureState({required this.error});
}

class ShopDeletedSuccesState extends HomeShopsState {
  final String message;

  ShopDeletedSuccesState({
    required this.message,
  });
}

class ShopDeletedFailureState extends HomeShopsState {
  final String message;

  ShopDeletedFailureState({required this.message});
}

class SeachSuccesState extends HomeShopsState {
  final String message;

  SeachSuccesState({required this.message});
}

class SeachFailureState extends HomeShopsState {
  final String error;

  SeachFailureState({required this.error});
}

class EmptyShopState extends HomeShopsState {
  final String message;

  EmptyShopState({required this.message});
}
