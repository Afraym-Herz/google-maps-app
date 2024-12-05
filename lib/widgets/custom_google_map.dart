import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_app/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? googleMapController;
  late Location location;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Circle> circles = {};
  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      zoom: 12,
      target: LatLng(31.187, 29.928),
    );
    checkAndRequestLocationServices();
    checkAndRequestLocationPermission();
    initMarker();
    initPloyLines();
    initPolygon();
    initCircle();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController!.dispose();
    super.dispose();
  }

  Future<String> nightMapStyle() async {
    String nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString("assets/google_map_styles/google_map_night_style.json");
    return nightMapStyle;
  }

  void initMarker() async {
    var customMarkerImage = BitmapDescriptor.bytes(
      await getImageFromRawData("assets/images/unnamed.png", 100),
    );
    var myMarkers = places
        .map(
          (place) => Marker(
            icon: customMarkerImage,
            position: place.latLng,
            markerId: MarkerId(
              place.id.toString(),
            ),
          ),
        )
        .toSet();
    markers.addAll(myMarkers);
  }

  Future<Uint8List> getImageFromRawData(String image, int width) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width,
    );
    var imageFrame = await imageCodec.getNextFrame();
    var imageByteData =
        await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          style: nightMapStyle().toString(),
          initialCameraPosition: initialCameraPosition,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(31.080, 29.7634),
              northeast: const LatLng(31.308, 30.169),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            LatLng newLocation = const LatLng(30.6733, 30.19070);
            googleMapController!.animateCamera(
              CameraUpdate.newLatLng(newLocation),
            );
          },
          child: const Text("Change location"),
        ),
      ],
    );
  }

  void initPloyLines() {
    Polyline polyline = const Polyline(
        color: Colors.red,
        zIndex: 1,
        width: 5,
        geodesic: true,
        endCap: Cap.roundCap,
        polylineId: PolylineId("1"),
        points: [
          LatLng(31.146667, 29.881753),
          LatLng(31.183682, 29.905957),
          LatLng(31.178982, 29.942006),
          LatLng(31.209379, 29.937199),
        ]);

    Polyline polyline2 = const Polyline(
        color: Colors.black,
        zIndex: 2,
        width: 5,
        geodesic: true,
        endCap: Cap.roundCap,
        polylineId: PolylineId("1"),
        points: [
          LatLng(31.14725, 29.94698),
          LatLng(31.20482, 29.90509),
        ]);

    polyLines.add(polyline);
    polyLines.add(polyline2);
  }

  void initPolygon() {
    Polygon polygon = const Polygon(polygonId: PolygonId('1'), holes: [
      [
        LatLng(32.9027, 31.4329),
        LatLng(28.7532, 26.9504),
        LatLng(29.6738, 34.2454),
      ]
    ], points: [
      LatLng(31.5, 25.0),
      LatLng(31.5, 28),
      LatLng(31.2, 30.0),
      LatLng(31.0, 32.0),
      LatLng(31.0, 34),
    ]);
  }

  void initCircle() {
    Circle kosharyAbu = const Circle(
        radius: 10000,
        circleId: CircleId("1"),
        center: LatLng(30.018987399497977, 31.424207246099208));
  }

  Future<void> checkAndRequestLocationServices() async {
    var isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();

      if (!isServiceEnable) {
        // TODO : show error bar
      }
    }
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      if (permissionStatus != PermissionStatus.granted) {
        // TODO: show error bar
        return false;
      }
    }
    if (permissionStatus == PermissionStatus.deniedForever){
      return false ;
    }
    return true;
  }

  void getLocationData() {
    location.onLocationChanged.listen((locationData) {
      var cameraPosition = CameraPosition(target: LatLng(locationData.latitude!, locationData.longitude!));
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void updateMyLocation() async {
    await checkAndRequestLocationServices();
    var hasPermission = await checkAndRequestLocationPermission();
    if (hasPermission) {
      getLocationData();
    } else {}
  }
}
