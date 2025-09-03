import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';
part 'location_events.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(InitLocation()) {
    on<LoadLocationEvent>(_loadLocation);
  }

  Position? _currentUserLocation;
  String currentAddress = 'Loading current location...';
  String? placeLoc;
  String? placeAdm;
  double? userLatitude;
  double? userLongitude;
  bool wentToSettings = false;
  String? lastKnownAddress;

  Future<Position> _getLocation(Emitter<LocationState> emit) async {
    try {
      emit(LocationLoading());
      debugPrint("Checking location service and permissions...");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Prompt user to enable GPS
        emit(LocationOff(message: 'Turn on location service'));
        wentToSettings = true;

        await Geolocator.openLocationSettings();

        // Give system time to actually turn on GPS before checking again
        await Future.delayed(Duration(seconds: 2));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          // Do not emit failure here if we just came from settings — let lifecycle handle retry
          throw Exception("Location services are still disabled");
        }
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(PermissionDenied(message: 'Location permission denied'));
          throw Exception("Location permission denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(PermissionDeniedForever(
            message: 'Location permissions are permanently denied.'));
        await Geolocator.openAppSettings();
        throw Exception("Location permission permanently denied");
      }

      // Use last known location immediately if available
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

// Resolve address from coordinates
      final address = await _addressFromCoordinates(
          emit); // Make sure this returns the address

      if (address != null) {
        lastKnownAddress = address;
      }

// Emit the fetched state
      emit(LocationFetchedState(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ));

      return position;
    } catch (e) {
      // Only emit failure if we aren't in the "just returned from settings" case
      if (!wentToSettings) {
        emit(LocationFailure(error: e.toString()));
      }
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<void> _loadLocation(
      LoadLocationEvent event, Emitter<LocationState> emit) async {
    try {
      Position position = await _getLocation(emit);
      _currentUserLocation = position;
      await _addressFromCoordinates(emit);

      emit(LocationFetchedState(
        latitude: userLatitude,
        longitude: userLongitude,
        address: currentAddress,
        address2: placeLoc,
      ));
    } catch (e) {
      debugPrint("LoadLocation error: $e");
    }
  }

  Future<String?> _addressFromCoordinates(Emitter<LocationState> emit) async {
    try {
      if (_currentUserLocation == null) return null;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
      );

      Placemark place = placemarks.first;
      currentAddress = '${place.locality}, ${place.subAdministrativeArea}';
      userLatitude = _currentUserLocation!.latitude;
      userLongitude = _currentUserLocation!.longitude;
      placeLoc = place.locality;
      placeAdm = place.country;

      debugPrint("Address resolved: $currentAddress");

      emit(LocationFetchedState(
        latitude: userLatitude,
        longitude: userLongitude,
        address: currentAddress,
      ));
    } catch (e) {
      debugPrint('Error fetching address: $e');
    }
    return null;
  }
}
