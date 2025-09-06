part of 'owner_location_bloc.dart';

sealed class OwnerLocationEvent {}

class CheckOwnerLocationServices extends OwnerLocationEvent {}

class RequestOwnerLocationPermission extends OwnerLocationEvent {}

class LoadOwnerLocationEvent extends OwnerLocationEvent {}
