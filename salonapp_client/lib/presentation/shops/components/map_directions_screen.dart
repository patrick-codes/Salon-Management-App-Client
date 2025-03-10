import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
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
  bool showPopup = false;
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
      },
      builder: (BuildContext context, state) {
        return Stack(
          children: [
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerTop,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  setState(() {
                    showPopup = !showPopup;
                  });
                },
                //() => moveCameraToUserLocation(context),
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
            ),
            if (showPopup)
              Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPopup = false;
                        });
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(17),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              horizontalTitleGap: 5,
                              minLeadingWidth: 1,
                              minVerticalPadding: 2,
                              dense: true,
                              isThreeLine: true,
                              leading: CircleAvatar(
                                backgroundColor: Colors.red[50],
                                radius: 20,
                                child: const Icon(Icons.dangerous_outlined),
                              ),
                              title: Text(
                                "Toronto Haircut",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "Weija, Accra",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: Colors.black45,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "GHC 30.00",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 3,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pick Up Location",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                  color: Colors.black45,
                                                  fontSize: 11,
                                                ),
                                          ),
                                          Text(
                                            "Osu",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      const SizedBox(
                                        height: 60,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "---- ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Icon(
                                                  MingCute.truck_line,
                                                  size: 18,
                                                ),
                                                Text(
                                                  " ----",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Drop Off Location",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: Colors.black45,
                                              fontSize: 11,
                                            ),
                                      ),
                                      Text(
                                        "Adabraka",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rider Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontSize: 13,
                                      ),
                                ),
                                Text(
                                  "Patrick Boateng",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vehicle Type",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontSize: 13,
                                      ),
                                ),
                                Text(
                                  "Motorbike - Yamaha FZ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vehicle Number",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black45,
                                        fontSize: 13,
                                      ),
                                ),
                                Text(
                                  "GT-2440-25",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.4),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Vehicle Breakdown",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.done,
                                          size: 15,
                                          weight: 8,
                                          grade: 8,
                                          opticalSize: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Decline",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.red,
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showPopup = !showPopup;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Accept",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
