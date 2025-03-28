part of 'location_bloc.dart';

sealed class LocationState {}

final class InitLocation extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSucces extends LocationState {
  final String message;

  LocationSucces({required this.message});
}

final class CordinatesLoaded extends LocationState {
  final String message;

  CordinatesLoaded({required this.message});
}

final class LocationFailure extends LocationState {
  final String error;

  LocationFailure({required this.error});
}

final class LocationOff extends LocationState {
  final String message;

  LocationOff({required this.message});
}

final class PermissionDenied extends LocationState {
  final String message;

  PermissionDenied({required this.message});
}

final class PermissionDeniedForever extends LocationState {
  final String message;

  PermissionDeniedForever({required this.message});
}

final class LocationFetchedState extends LocationState {
  LocationFetchedState(
      {this.latitude, this.longitude, this.address, this.address2});

  final double? latitude;
  final double? longitude;
  final String? address;
  final String? address2;
}
