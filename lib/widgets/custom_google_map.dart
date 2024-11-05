import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_app/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      zoom: 12,
      target: LatLng(31.187, 29.928),
    );
    initMarker();

    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
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
        ).toSet();
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
            googleMapController.animateCamera(
              CameraUpdate.newLatLng(newLocation),
            );
          },
          child: const Text("Change location"),
        ),
      ],
    );
  }
}
