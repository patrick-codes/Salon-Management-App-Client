part of 'single_shop_bloc.dart';

sealed class SingleShopsState {}

class ShopInitial extends SingleShopsState {}

class ShopsLoadingState extends SingleShopsState {}

class ShopsFetchFailureState extends SingleShopsState {
  final String errorMessage;

  ShopsFetchFailureState({required this.errorMessage});
}

class EmptyShopState extends SingleShopsState {
  final String message;

  EmptyShopState({required this.message});
}

class SingleShopsFetchedState extends SingleShopsState {
  ShopModel? shop;

  SingleShopsFetchedState({required this.shop});
}
