part of 'owner_location_bloc.dart';

sealed class OwnerLocationState {}

final class OwnerInitLocation extends OwnerLocationState {}

final class OwnerLocationLoading extends OwnerLocationState {}

final class OwnerLocationSucces extends OwnerLocationState {
  final String message;

  OwnerLocationSucces({required this.message});
}

final class OwnerCordinatesLoaded extends OwnerLocationState {
  final String message;

  OwnerCordinatesLoaded({required this.message});
}

final class OwnerLocationFailure extends OwnerLocationState {
  final String error;

  OwnerLocationFailure({required this.error});
}

final class OwnerLocationOff extends OwnerLocationState {
  final String message;

  OwnerLocationOff({required this.message});
}

final class OwnerPermissionDenied extends OwnerLocationState {
  final String message;

  OwnerPermissionDenied({required this.message});
}

final class OwnerPermissionDeniedForever extends OwnerLocationState {
  final String message;

  OwnerPermissionDeniedForever({required this.message});
}

final class OwnerLocationFetchedState extends OwnerLocationState {
  OwnerLocationFetchedState(
      {this.latitude, this.longitude, this.address, this.address2});

  final double? latitude;
  final double? longitude;
  final String? address;
  final String? address2;
}
