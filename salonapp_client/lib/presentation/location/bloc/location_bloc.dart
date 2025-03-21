import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'location_state.dart';
part 'location_events.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  String locationMessage = 'Current Location of user';
  bool serviceEnabled = false;
  late LocationPermission permission;
  Position? _currentUserLocation;
  String currentAddress = 'Loading current location....';
  String placeLoc = '';
  String? placeAdm;
  String currentStreet = '';
  double? distanceInMeters = 0.0;
  double? distanceInKm = 0.0;
  double? userLatitude;
  double? userLongitude;
  LatLng? coordinates;
  bool isLoading = false;

  LocationBloc() : super(InitLocation()) {
    on<LoadLocationEvent>(_loadLocation);
  }

  Future<Position> _getLocation(Emitter<LocationState> emit) async {
    try {
      emit(LocationLoading());
      debugPrint("Loading Location.....");
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        emit(LocationOff(message: 'Turn on location service'));
        // throw Exception("Location service is disabled....");
      } else if (serviceEnabled) {
        await Geolocator.getCurrentPosition();
        emit(CordinatesLoaded(message: currentAddress));
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(PermissionDenied(
              message: 'Location permission denied by device'));
          throw Exception("Location permission denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(PermissionDeniedForever(
            message:
                'Location permissions are permanently denied, we cannot request permission.'));
        throw Exception("Location permission permanently denied");
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      emit(LocationFailure(error: e.toString()));
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<void> _loadLocation(
      LoadLocationEvent event, Emitter<LocationState> emit) async {
    try {
      emit(LocationLoading());
      _currentUserLocation = await _getLocation(emit);
      await _addressFromCoordinates(emit);
      //emit(CordinatesLoaded(message: '$currentAddress'));
      emit(LocationFetchedState(
        latitude: userLatitude,
        longitude: userLongitude,
        address: currentAddress,
      ));
      debugPrint('Address: $currentAddress');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _addressFromCoordinates(Emitter<LocationState> emit) async {
    try {
      if (_currentUserLocation == null) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentUserLocation!.latitude, _currentUserLocation!.longitude);
      Placemark place = placemarks.first;

      currentAddress = '${place.locality} - ${place.administrativeArea}';
      userLatitude = _currentUserLocation!.latitude;
      userLongitude = _currentUserLocation!.longitude;
      placeLoc = place.street ?? '';
      placeAdm = place.country;

      debugPrint("Location Fetched: $userLatitude, $userLongitude");
      emit(LocationFetchedState(
        latitude: userLatitude,
        longitude: userLongitude,
        address: currentAddress,
      ));

      debugPrint('Location: $currentAddress');
      debugPrint('Latitude: $userLatitude');
      debugPrint('Longitude: $userLongitude');
    } catch (e) {
      debugPrint('Error fetching address: $e');
    }
  }

/*
  Future<void> _addressFromCoordinates(Emitter<LocationState> emit) async {
    try {
      if (_currentUserLocation == null) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentUserLocation!.latitude, _currentUserLocation!.longitude);
      Placemark place = placemarks.first;

      currentAddress = '${place.locality} - ${place.administrativeArea}';
      userLatitude = _currentUserLocation!.latitude;
      userLongitude = _currentUserLocation!.longitude;
      placeLoc = place.street ?? '';
      placeAdm = place.country;

      debugPrint('Location: $currentAddress');
      debugPrint('Latitude: $userLatitude');
      debugPrint('Longitude: $userLongitude');
    } catch (e) {
      debugPrint('Error fetching address: $e');
    }
  }
*/
}
