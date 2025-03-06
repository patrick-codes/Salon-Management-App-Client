part of 'shops_bloc.dart';

sealed class ShopsState {}

class ShopInitial extends ShopsState {}

class ShopsLoadingState extends ShopsState {}

class ShopsFetchedState extends ShopsState {
  List<ShopModel>? shop;

  ShopsFetchedState({required this.shop});
}

class SingleShopsFetchedState extends ShopsState {
  ShopModel? shop;

  SingleShopsFetchedState({required this.shop});
}

class ShopsFetchFailureState extends ShopsState {
  final String errorMessage;

  ShopsFetchFailureState({required this.errorMessage});
}

class ShopCreatedSuccesState extends ShopsState {
  final String message;

  ShopCreatedSuccesState({
    required this.message,
  });
}

class ShopCreateFailureState extends ShopsState {
  final String error;

  ShopCreateFailureState({required this.error});
}

class ShopDeletedSuccesState extends ShopsState {
  final String message;

  ShopDeletedSuccesState({
    required this.message,
  });
}

class ShopDeletedFailureState extends ShopsState {
  final String message;

  ShopDeletedFailureState({required this.message});
}

class SeachSuccesState extends ShopsState {
  final String message;

  SeachSuccesState({required this.message});
}

class SeachFailureState extends ShopsState {
  final String error;

  SeachFailureState({required this.error});
}

class EmptyShopState extends ShopsState {
  final String message;

  EmptyShopState({required this.message});
}
