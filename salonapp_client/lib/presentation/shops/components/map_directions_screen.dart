import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:salonapp_client/helpers/colors/color_constants.dart';
import '../../location/bloc/location_bloc.dart';
import 'dart:convert';

class MapDirectionScreen extends StatefulWidget {
  const MapDirectionScreen({super.key});

  @override
  State<MapDirectionScreen> createState() => _MapDirectionScreenState();
}

class _MapDirectionScreenState extends State<MapDirectionScreen> {
  MapLibreMapController? mapController;

  bool canInteractWithMap = false;

  Future<void> _addPolyline() async {
    if (mapController == null) return;

    Map<String, dynamic> geoJson = jsonDecode('''
  {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [-122.4194, 37.7749], // Start (Longitude, Latitude)
            [-122.4294, 37.7849]  // End (Longitude, Latitude)
          ]
        },
        "properties": {}
      }
    ]
  }
  ''');

    await mapController!.addGeoJsonSource("polyline-source", geoJson);

    await mapController!.addLineLayer(
      "polyline-source",
      "polyline-layer",
      LineLayerProperties(
        lineColor: "#FF0000",
        lineWidth: 5.0,
        lineOpacity: 0.8,
      ),
    );
  }

  void moveCameraToUserLocation(BuildContext context) async {
    if (mapController == null) return;

    final locationBloc = context.read<LocationBloc>();

    if (locationBloc.userLatitude != null &&
        locationBloc.userLongitude != null) {
      LatLng userLatLng = LatLng(
        locationBloc.userLatitude!,
        locationBloc.userLongitude!,
      );

      await Future.delayed(Duration(milliseconds: 300));

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLatLng, zoom: 12),
        ),
      );
    }
  }

  LatLng userLocation = LatLng(0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
      if (state is CordinatesLoaded) {
        final locationBloc = context.read<LocationBloc>();
        userLocation = LatLng(
          locationBloc.userLatitude ?? 0.0,
          locationBloc.userLongitude ?? 0.0,
        );
        moveCameraToUserLocation(context);
      } else if (state is LocationLoading) {
        Center(child: CircularProgressIndicator());
      } else {
        const Center(child: Text("Failed to load location"));
      }
    }, builder: (BuildContext context, state) {
      return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => moveCameraToUserLocation(context),
          mini: true,
          child: const Icon(Icons.restore, color: primaryColor),
        ),
        body: MapLibreMap(
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.tracking,
          myLocationRenderMode: MyLocationRenderMode.normal,
          styleString:
              // "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json",
              "https://basemaps.cartocdn.com/gl/voyager-gl-style/style.json",
          onMapCreated: (controller) async {
            mapController = controller;
            await Future.delayed(Duration(seconds: 1));
            moveCameraToUserLocation(context);
            await _addPolyline();
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: userLocation, zoom: 12),
              ),
            );
          },
          initialCameraPosition: CameraPosition(
            target: userLocation,
          ),
          onStyleLoadedCallback: () {
            _addPolyline();
          },
        ),
      );
    });
  }
}
