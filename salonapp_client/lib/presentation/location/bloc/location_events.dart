part of 'location_bloc.dart';

sealed class LocationEvent {}

final class GetLocationEvent extends LocationEvent {}

final class LoadLocationEvent extends LocationEvent {}

final class GetCordinatesAddressEvent extends LocationEvent {}
