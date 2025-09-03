part of 'single_shop_bloc.dart';

sealed class SingleShopsEvent {}

class ViewSingleShopEvent extends SingleShopsEvent {
  final String? id;

  ViewSingleShopEvent(this.id);
}
